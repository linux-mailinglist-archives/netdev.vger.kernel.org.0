Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A16C8956D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 04:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfHLCo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 22:44:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54702 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbfHLCo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 22:44:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DBAC63090FCF;
        Mon, 12 Aug 2019 02:44:56 +0000 (UTC)
Received: from [10.72.12.78] (ovpn-12-78.pek2.redhat.com [10.72.12.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0273610016E8;
        Mon, 12 Aug 2019 02:44:51 +0000 (UTC)
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jgg@ziepe.ca
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
Date:   Mon, 12 Aug 2019 10:44:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190810134948-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 12 Aug 2019 02:44:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/11 上午1:52, Michael S. Tsirkin wrote:
> On Fri, Aug 09, 2019 at 01:48:42AM -0400, Jason Wang wrote:
>> Hi all:
>>
>> This series try to fix several issues introduced by meta data
>> accelreation series. Please review.
>>
>> Changes from V4:
>> - switch to use spinlock synchronize MMU notifier with accessors
>>
>> Changes from V3:
>> - remove the unnecessary patch
>>
>> Changes from V2:
>> - use seqlck helper to synchronize MMU notifier with vhost worker
>>
>> Changes from V1:
>> - try not use RCU to syncrhonize MMU notifier with vhost worker
>> - set dirty pages after no readers
>> - return -EAGAIN only when we find the range is overlapped with
>>    metadata
>>
>> Jason Wang (9):
>>    vhost: don't set uaddr for invalid address
>>    vhost: validate MMU notifier registration
>>    vhost: fix vhost map leak
>>    vhost: reset invalidate_count in vhost_set_vring_num_addr()
>>    vhost: mark dirty pages during map uninit
>>    vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
>>    vhost: do not use RCU to synchronize MMU notifier with worker
>>    vhost: correctly set dirty pages in MMU notifiers callback
>>    vhost: do not return -EAGAIN for non blocking invalidation too early
>>
>>   drivers/vhost/vhost.c | 202 +++++++++++++++++++++++++-----------------
>>   drivers/vhost/vhost.h |   6 +-
>>   2 files changed, 122 insertions(+), 86 deletions(-)
> This generally looks more solid.
>
> But this amounts to a significant overhaul of the code.
>
> At this point how about we revert 7f466032dc9e5a61217f22ea34b2df932786bbfc
> for this release, and then re-apply a corrected version
> for the next one?


If possible, consider we've actually disabled the feature. How about 
just queued those patches for next release?

Thanks


>
>> -- 
>> 2.18.1
