Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B0A18A1E
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 14:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfEIMzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 08:55:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34502 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfEIMzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 08:55:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EE8E1306D332;
        Thu,  9 May 2019 12:55:36 +0000 (UTC)
Received: from [10.72.12.183] (ovpn-12-183.pek2.redhat.com [10.72.12.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B16715C226;
        Thu,  9 May 2019 12:55:30 +0000 (UTC)
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
 <a1ef0c0d-d67c-8888-91e6-2819e8c45489@redhat.com>
 <CAM_iQpVGdduQGdkBn2a+8=VTuZcoTxBdve6+uDHACcDrdtL=Og@mail.gmail.com>
 <e2c79625-7541-cf58-5729-a5519f36b248@redhat.com>
 <CAM_iQpV+FMvXQDO8o9=x90ybT87OWrSthaxt6soJ_Mhug=vSzA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <79cefeef-f7b9-e97f-2e81-cdb2c73b5767@redhat.com>
Date:   Thu, 9 May 2019 20:55:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV+FMvXQDO8o9=x90ybT87OWrSthaxt6soJ_Mhug=vSzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 09 May 2019 12:55:37 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/9 下午1:34, Cong Wang wrote:
> On Tue, May 7, 2019 at 7:54 PM Jason Wang <jasowang@redhat.com> wrote:
>> This is only true if you can make sure tfile[tun->numqueues] is not
>> freed. Either my patch or SOCK_RCU_FREE can solve this, but for
>> SOCK_RCU_FREE we need do extra careful audit to make sure it doesn't
>> break someting. So synchronize through pointers in tfiles[] which is
>> already protected by RCU is much more easier. It can make sure no
>> dereference from xmit path after synchornize_net(). And this matches the
>> assumptions of the codes after synchronize_net().
>>
> It is hard to tell which sock_put() matches with this synchronize_net()
> given the call path is complicated.
>
> With SOCK_RCU_FREE, no such a problem, all sock_put() will be safe.
> So to me SOCK_RCU_FREE is much easier to understand and audit.


The problem is not tfile itself but the data structure associated. As I 
mentioned earlier, the xdp_rxq_info_unreg() looks racy if tun_net_xmit() 
can read stale value of numqueues. It's just one example, we may meet 
similar issues in the future when adding more features.

Thanks


>
> Thanks.
