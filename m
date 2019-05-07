Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E040215D41
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 08:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfEGGTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 02:19:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726253AbfEGGTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 02:19:30 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA4D530832C3;
        Tue,  7 May 2019 06:19:29 +0000 (UTC)
Received: from [10.72.12.47] (ovpn-12-47.pek2.redhat.com [10.72.12.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 598B260BEC;
        Tue,  7 May 2019 06:19:25 +0000 (UTC)
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
 <CAM_iQpURdiJv9GqkEyk=MPokacvtJVfHUpBb3=6EWA0e1yiTZQ@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a1ef0c0d-d67c-8888-91e6-2819e8c45489@redhat.com>
Date:   Tue, 7 May 2019 14:19:20 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpURdiJv9GqkEyk=MPokacvtJVfHUpBb3=6EWA0e1yiTZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Tue, 07 May 2019 06:19:29 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/7 下午12:54, Cong Wang wrote:
> On Mon, May 6, 2019 at 9:03 PM Jason Wang <jasowang@redhat.com> wrote:
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index e9ca1c0..32a0b23 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>>                                     tun->tfiles[tun->numqueues - 1]);
>>                  ntfile = rtnl_dereference(tun->tfiles[index]);
>>                  ntfile->queue_index = index;
>> +               rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
>> +                                  NULL);
>>
> How does this work? Existing readers could still read this
> tun->tfiles[tun->numqueues - 1] before you NULL it. And,
> _if_ the following sock_put() is the one frees it, you still miss
> a RCU grace period.
>
>                  if (clean) {
>                          RCU_INIT_POINTER(tfile->tun, NULL);
>                          sock_put(&tfile->sk);
>
>
> Thanks.


My understanding is the socket will never be freed for this sock_put(). 
We just drop an extra reference count we held when the socket was 
attached to the netdevice (there's a sock_hold() in tun_attach()). The 
real free should happen at another sock_put() in the end of this function.

Thanks

