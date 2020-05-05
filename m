Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0AF1C63E9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 00:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbgEEWbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 18:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbgEEWbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 18:31:00 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F506C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 15:31:00 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jW65V-00068r-EU; Wed, 06 May 2020 00:30:54 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id F37011001F5; Wed,  6 May 2020 00:30:52 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [BUG] Inconsistent lock state in virtnet poll
In-Reply-To: <20200505120352-mutt-send-email-mst@kernel.org>
References: <87lfm6oa7b.fsf@nanos.tec.linutronix.de> <20200505120352-mutt-send-email-mst@kernel.org>
Date:   Wed, 06 May 2020 00:30:52 +0200
Message-ID: <87v9lanher.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, May 05, 2020 at 02:08:56PM +0200, Thomas Gleixner wrote:
>> 
>> The following lockdep splat happens reproducibly on 5.7-rc4
>
>> ================================
>> WARNING: inconsistent lock state
>> 5.7.0-rc4+ #79 Not tainted
>> --------------------------------
>> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
>> ip/356 [HC0[0]:SC1[1]:HE1:SE0] takes:
>> f3ee4cd8 (&syncp->seq#2){+.?.}-{0:0}, at: net_rx_action+0xfb/0x390
>> {SOFTIRQ-ON-W} state was registered at:
>>   lock_acquire+0x82/0x300
>>   try_fill_recv+0x39f/0x590
>
> Weird. Where does try_fill_recv acquire any locks?

  u64_stats_update_begin(&rq->stats.syncp);

That's a 32bit kernel which uses a seqcount for this. sequence counts
are "lock" constructs where you need to make sure that writers are
serialized.

Actually the problem at hand is that try_fill_recv() is called from
fully preemptible context initialy and then from softirq context.

Obviously that's for the open() path a non issue, but lockdep does not
know about that. OTOH, there is other code which calls that from
non-softirq context.

The hack below made it shut up. It's obvioulsy not ideal, but at least
it let me look at the actual problem I was chasing down :)

Thanks,

        tglx

8<-----------
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1243,9 +1243,11 @@ static bool try_fill_recv(struct virtnet
 			break;
 	} while (rq->vq->num_free);
 	if (virtqueue_kick_prepare(rq->vq) && virtqueue_notify(rq->vq)) {
+		local_bh_disable();
 		u64_stats_update_begin(&rq->stats.syncp);
 		rq->stats.kicks++;
 		u64_stats_update_end(&rq->stats.syncp);
+		local_bh_enable();
 	}
 
 	return !oom;
