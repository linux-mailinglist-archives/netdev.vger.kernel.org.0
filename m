Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13F2818402
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 05:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEIDQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 23:16:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58548 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfEIDQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 23:16:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4A7081F0C;
        Thu,  9 May 2019 03:16:19 +0000 (UTC)
Received: from [10.72.12.183] (ovpn-12-183.pek2.redhat.com [10.72.12.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6C5F608E4;
        Thu,  9 May 2019 03:16:14 +0000 (UTC)
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, mst@redhat.com, yuehaibing@huawei.com,
        xiyou.wangcong@gmail.com, weiyongjun1@huawei.com,
        eric.dumazet@gmail.com
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
 <20190508.103613.1782548019381525988.davem@davemloft.net>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7f45aef5-c55b-875f-3458-c34a9b90b564@redhat.com>
Date:   Thu, 9 May 2019 11:16:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508.103613.1782548019381525988.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 09 May 2019 03:16:20 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/9 上午1:36, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Tue,  7 May 2019 00:03:36 -0400
>
>> @@ -1313,6 +1315,10 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>>   
>>   	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
>>   					    numqueues]);
>> +	if (!tfile) {
>> +		rcu_read_unlock();
>> +		return -ENXIO; /* Caller will free/return all frames */
>> +	}
>>   
>>   	spin_lock(&tfile->tx_ring.producer_lock);
>>   	for (i = 0; i < n; i++) {
> The only way we can see a NULL here is if a detach happened in parallel,
> and if that happens we should retry the tfile[] indexing after resampling
> numqueues rather than dropping the packet.


Ok, will fix this in V3.

Thanks

