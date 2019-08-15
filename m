Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D538E327
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 05:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbfHOD0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 23:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34900 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbfHOD0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 23:26:55 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C6A76300894D;
        Thu, 15 Aug 2019 03:26:54 +0000 (UTC)
Received: from [10.72.12.184] (ovpn-12-184.pek2.redhat.com [10.72.12.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF74A27C2C;
        Thu, 15 Aug 2019 03:26:49 +0000 (UTC)
Subject: Re: [PATCH V5 0/9] Fixes for vhost metadata acceleration
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20190809054851.20118-1-jasowang@redhat.com>
 <20190810134948-mutt-send-email-mst@kernel.org>
 <360a3b91-1ac5-84c0-d34b-a4243fa748c4@redhat.com>
 <20190812054429-mutt-send-email-mst@kernel.org>
 <20190812130252.GE24457@ziepe.ca>
 <9a9641fe-b48f-f32a-eecc-af9c2f4fbe0e@redhat.com>
 <20190813115707.GC29508@ziepe.ca>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <74838e61-3a5e-0f51-2092-f4a16d144b45@redhat.com>
Date:   Thu, 15 Aug 2019 11:26:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190813115707.GC29508@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 15 Aug 2019 03:26:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/8/13 下午7:57, Jason Gunthorpe wrote:
> On Tue, Aug 13, 2019 at 04:31:07PM +0800, Jason Wang wrote:
>
>> What kind of issues do you see? Spinlock is to synchronize GUP with MMU
>> notifier in this series.
> A GUP that can't sleep can't pagefault which makes it a really weird
> pattern


My understanding is __get_user_pages_fast() assumes caller can fail or 
have fallback. And we have graceful fallback to copy_{to|from}_user().


>
>> Btw, back to the original question. May I know why synchronize_rcu() is not
>> suitable? Consider:
> We already went over this. You'd need to determine it doesn't somehow
> deadlock the mm on reclaim paths. Maybe it is OK, the rcq_gq_wq is
> marked WQ_MEM_RECLAIM at least..


Yes, will take a look at this.


>
> I also think Michael was concerned about the latency spikes a long RCU
> delay would cause.


I don't think it's a real problem consider MMU notifier could be 
preempted or blocked.

Thanks


>
> Jason
