Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1880053DF96
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 04:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349026AbiFFCDd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 22:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240339AbiFFCDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 22:03:33 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F1BA2B1A5;
        Sun,  5 Jun 2022 19:03:30 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LGcG84jmTzKmKy;
        Mon,  6 Jun 2022 10:03:12 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 6 Jun 2022 10:03:28 +0800
Subject: Re: [PATCH net-next v4] ipv6: Fix signed integer overflow in
 __ip6_append_data
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <edumazet@google.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20220601084803.1833344-1-wangyufen@huawei.com>
 <4c9e3cf5122f4c2f8a2473c493891362e0a13b4a.camel@redhat.com>
 <20220602090228.1e493e47@kernel.org>
 <34c12525e133402e9d49601974b3deb390991e74.camel@redhat.com>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <9b09cb01-07ee-6b33-5351-74a40edbda3d@huawei.com>
Date:   Mon, 6 Jun 2022 10:03:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <34c12525e133402e9d49601974b3deb390991e74.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/6/3 16:58, Paolo Abeni 写道:
> On Thu, 2022-06-02 at 09:02 -0700, Jakub Kicinski wrote:
>> On Thu, 02 Jun 2022 12:38:10 +0200 Paolo Abeni wrote:
>>> I'm sorry for the multiple incremental feedback on this patch. It's
>>> somewhat tricky.
>>>
>>> AFAICS Jakub mentioned only udpv6_sendmsg(). In l2tp_ip6_sendmsg() we
>>> can have an overflow:
>>>
>>>          int transhdrlen = 4; /* zero session-id */
>>>          int ulen = len + transhdrlen;
>>>
>>> when len >= INT_MAX - 4. That will be harmless, but I guess it could
>>> still trigger a noisy UBSAN splat.
>> Good point, I wonder if that's a separate issue. Should we
>> follow what UDP does and subtract the transhdr from the max?
>> My gut feeling is that stricter checks are cleaner than just
>> bumping variable sizes.
>>
>> diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
>> index c6ff8bf9b55f..9dbd801ddb98 100644
>> --- a/net/l2tp/l2tp_ip6.c
>> +++ b/net/l2tp/l2tp_ip6.c
>> @@ -504,14 +504,15 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>>          struct ipcm6_cookie ipc6;
>>          int addr_len = msg->msg_namelen;
>>          int transhdrlen = 4; /* zero session-id */
>> -       int ulen = len + transhdrlen;
>> +       int ulen;
>>          int err;
>>   
>>          /* Rough check on arithmetic overflow,
>>           * better check is made in ip6_append_data().
>>           */
>> -       if (len > INT_MAX)
>> +       if (len > INT_MAX - transhdrlen)
>>                  return -EMSGSIZE;
>> +       ulen = len + transhdrlen;
>>   
>>          /* Mirror BSD error message compatibility */
>>          if (msg->msg_flags & MSG_OOB)
>>
> LGTM. Imho this can even land in a separated patch (whatever is easier)

Thanks for all the feedback.
So, Jakub will send a new patch to fix the l2tp_ip6_sendmsg issue?

Thanks.

