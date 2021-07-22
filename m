Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CF93D23DE
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 14:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhGVMMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:12:54 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:12286 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbhGVMMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:12:53 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GVshJ0KWzz7tCv;
        Thu, 22 Jul 2021 20:48:48 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 22 Jul 2021 20:53:24 +0800
Subject: Re: [PATCH net v2] can: raw: fix raw_rcv panic for sock UAF
To:     Oliver Hartkopp <socketcan@hartkopp.net>
CC:     <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210722070819.1048263-1-william.xuanziyang@huawei.com>
 <d684ef4d-d6c1-56b0-dc9e-b330fb92ba87@hartkopp.net>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <dfb8e04b-257d-6de5-280b-e0326b4d0dbe@huawei.com>
Date:   Thu, 22 Jul 2021 20:53:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d684ef4d-d6c1-56b0-dc9e-b330fb92ba87@hartkopp.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> diff --git a/net/can/raw.c b/net/can/raw.c
>> index ed4fcb7ab0c3..cd5a49380116 100644
>> --- a/net/can/raw.c
>> +++ b/net/can/raw.c
>> @@ -546,10 +546,18 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
>>                   return -EFAULT;
>>           }
>>   +        rtnl_lock();
>>           lock_sock(sk);
>>   -        if (ro->bound && ro->ifindex)
>> +        if (ro->bound && ro->ifindex) {
>>               dev = dev_get_by_index(sock_net(sk), ro->ifindex);
>> +            if (!dev) {
> 
> 
>> +                if (count > 1)
>> +                    kfree(filter);
> 
> This was NOT suggested!
> 
> I've been talking about removing the other kfree() "improvement" you suggested.
> 
> The kfree() should only be done when ro->bound and ro->ifindex are cleared.
> 
> So when you remove these two lines it should be ok.
> 
> Please try to increase the context in the diff.
> 
> Thanks,
> Oliver

Sorry, I am a little confused.

The following codes are the latest raw_setsockopt function realization(ignore some non-key parts)
with my patch. Now we assume the condition that count more than 1, ro->bound and ro->ifindex
are not zero, dev_get_by_index() will return NULL. We analyze the code logic.

static int raw_setsockopt(struct socket *sock, int level, int optname,
                          sockptr_t optval, unsigned int optlen)
{
        ......
	struct can_filter *filter = NULL;
	......

        switch (optname) {
        case CAN_RAW_FILTER:
                ......

                if (count > 1) {
                        /* filter does not fit into dfilter => alloc space */
                        filter = memdup_sockptr(optval, optlen); // filter point to a heap memory
                        if (IS_ERR(filter))
                                return PTR_ERR(filter);
                } else if (count == 1) {
                        ......
                }

                rtnl_lock();
                lock_sock(sk);

                if (ro->bound && ro->ifindex) {
                        dev = dev_get_by_index(sock_net(sk), ro->ifindex);

			/*
			 * dev == NULL is exception. The function will exit abnormally.
			 * Memory pointed by filer does not forward to anyone for maintenance.
			 * If we do not kfree(filter) here, memory will be leaked after function exit.
			 */
                        if (!dev) {
                                if (count > 1)
                                        kfree(filter);
                                err = -ENODEV;
                                goto out_fil;
                        }
                }

                if (ro->bound) {
                        /* (try to) register the new filters */
                        if (count == 1)
                                err = raw_enable_filters(sock_net(sk), dev, sk,
                                                         &sfilter, 1);
                        else
                                err = raw_enable_filters(sock_net(sk), dev, sk,
                                                         filter, count);
                        if (err) {
                                if (count > 1)
                                        kfree(filter);
                               goto out_fil;
                        }

                        /* remove old filter registrations */
                        raw_disable_filters(sock_net(sk), dev, sk, ro->filter,
                                            ro->count);
                }

                /* remove old filter space */
                if (ro->count > 1)
                        kfree(ro->filter);

                /* link new filters to the socket */
                if (count == 1) {
                        /* copy filter data for single filter */
                        ro->dfilter = sfilter;
                        filter = &ro->dfilter;
                }
                ro->filter = filter;
                ro->count  = count;

 out_fil:
                if (dev)
                        dev_put(dev);

                release_sock(sk);
                rtnl_unlock();

                break;
	......

	return err;
}

So I think my modification is right. Thank you.




