Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 761DC91DD6
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfHSH3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:29:20 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39894 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726261AbfHSH3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 03:29:19 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6E6CD99178D47E0CBA6F;
        Mon, 19 Aug 2019 15:29:12 +0800 (CST)
Received: from [127.0.0.1] (10.133.205.80) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Mon, 19 Aug 2019
 15:29:06 +0800
Subject: Re: [PATCH v2] tun: fix use-after-free when register netdev failed
To:     Jason Wang <jasowang@redhat.com>, <netdev@vger.kernel.org>
References: <1565953224-104941-1-git-send-email-yangyingliang@huawei.com>
 <1b8175f3-7781-923b-5a24-d473f6efd33d@redhat.com>
CC:     <eric.dumazet@gmail.com>, <xiyou.wangcong@gmail.com>,
        <davem@davemloft.net>, <weiyongjun1@huawei.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <5D5A4FC0.5050606@huawei.com>
Date:   Mon, 19 Aug 2019 15:29:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1b8175f3-7781-923b-5a24-d473f6efd33d@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.205.80]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/19 11:17, Jason Wang wrote:
> On 2019/8/16 下午7:00, Yang Yingliang wrote:
[...]
>>   
>>   		INIT_LIST_HEAD(&tun->disabled);
>> -		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
>> -				 ifr->ifr_flags & IFF_NAPI_FRAGS);
>> -		if (err < 0)
>> -			goto err_free_flow;
>> +
>> +		tun_set_real_num_queues(tun, tun->numqueues + 1);
>
> This looks tricky, why not simply call netif_set_real_num_tx/rx_queues()
> here?
OK, I will do some test, then send a v3 patch.


Thanks,
Yang

>
> Thanks
>
>
>>   
>>   		err = register_netdevice(tun->dev);
>>   		if (err < 0)
>> -			goto err_detach;
>> +			/* register_netdevice() already called tun_free_netdev() */
>> +			goto err_free_dev;
>> +
>> +		err = tun_attach(tun, file, false, ifr->ifr_flags & IFF_NAPI,
>> +				 ifr->ifr_flags & IFF_NAPI_FRAGS);
>> +		if (err < 0)
>> +			goto err_unregister;
>>   	}
>>   
>>   	netif_carrier_on(tun->dev);
>> @@ -2851,14 +2857,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>>   	strcpy(ifr->ifr_name, tun->dev->name);
>>   	return 0;
>>   
>> -err_detach:
>> -	tun_detach_all(dev);
>> -	/* register_netdevice() already called tun_free_netdev() */
>> -	goto err_free_dev;
>> +err_unregister:
>> +	unregister_netdevice(dev);
>> +	return err;
>>   
>> -err_free_flow:
>> -	tun_flow_uninit(tun);
>> -	security_tun_dev_free_security(tun->security);
>>   err_free_stat:
>>   	free_percpu(tun->pcpu_stats);
>>   err_free_dev:
>> @@ -2979,6 +2981,8 @@ static int tun_set_queue(struct file *file, struct ifreq *ifr)
>>   			goto unlock;
>>   		ret = tun_attach(tun, file, false, tun->flags & IFF_NAPI,
>>   				 tun->flags & IFF_NAPI_FRAGS);
>> +		if (!ret)
>> +			tun_set_real_num_queues(tun, tun->numqueues);
>>   	} else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
>>   		tun = rtnl_dereference(tfile->tun);
>>   		if (!tun || !(tun->flags & IFF_MULTI_QUEUE) || tfile->detached)
> .
>


