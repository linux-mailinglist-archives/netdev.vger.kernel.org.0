Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3313597B
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 13:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgAIMvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 07:51:11 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47005 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725308AbgAIMvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 07:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578574269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fac4VqTnxrQkaCEJdCtkFmsn4oN/rNYvc/9xIScQoz4=;
        b=FXF5En7Vj/GE2ecCTuklH4dzCfk8qdxJGNnUZJgSeBbtf+q58KbnGFx8u7GxfRTjraIiKz
        p6ka/vjrLZ1hH512yC81t5Fq+rZdXWNgj64c2PPGk7mxZEO2SYTBX3F8jILfCAppsGMPVN
        jjiV/u20YhsfnzUJ8xW1u6H+FSRHMVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-_kaj9ArDOx-Z2_T2gQsS5Q-1; Thu, 09 Jan 2020 07:51:06 -0500
X-MC-Unique: _kaj9ArDOx-Z2_T2gQsS5Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AC421856A8F;
        Thu,  9 Jan 2020 12:51:05 +0000 (UTC)
Received: from ovpn-117-103.ams2.redhat.com (ovpn-117-103.ams2.redhat.com [10.36.117.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E05F27BD9;
        Thu,  9 Jan 2020 12:51:04 +0000 (UTC)
Message-ID: <7717e4470f6881bbc92645c72ad7f6ec71360796.camel@redhat.com>
Subject: Re: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Sascha Hauer <kernel@pengutronix.de>
Date:   Thu, 09 Jan 2020 13:51:03 +0100
In-Reply-To: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
References: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-01-08 at 15:55 +0100, Ahmad Fatoum wrote:
> I've run into an issue of CAN frames being sent out-of-order on an i.MX6 Dual
> with Linux v5.5-rc5. Bisecting has lead me down to this commit:
> 
> ba27b4cdaaa ("net: dev: introduce support for sch BYPASS for lockless qdisc")
> 
> With it, using pfifo_fast, every few hundred frames, FlexCAN's .ndo_start_xmit is
> passed frames in an order different from how userspace stuffed them into the same
> socket.
> 
> Reverting it fixes the issue as does booting with maxcpus=1 or using pfifo
> instead of pfifo_fast.
> 
> According to [1], such reordering shouldn't be happening.
> 
> Details on my setup:
> Kernel version: v5.5-rc5, (occurs much more often with LOCKDEP turned on)
> CAN-Bitrate: 250 kbit/s
> CAN frames are generated with:
> cangen canX -I2 -L1 -Di -i -g0.12 -p 100
> which keeps polling after ENOBUFS until socket is writable, sends out a CAN
> frame with one incrementing payload byte and then waits 120 usec before repeating.
> 
> Please let me know if any additional info is needed.

Thank you for the report.

I think there is a possible race condition in the 'empty' flag update
schema:

CPU 0					CPU1
(running e.g. net_tx_action)		(can xmit)

qdisc_run()				__dev_xmit_skb()
pfifo_fast_dequeue				
// queue is empty, returns NULL
WRITE_ONCE(qdisc->empty, true);
					pfifo_fast_enqueue
					qdisc_run_begin() 	
					// still locked by CPU 0,
					// return false and do nothing, 
					// qdisc->empty is still true

					(next can xmit)
					// BYPASS code path
					sch_direct_xmit()
					// send pkt 2
					__qdisc_run()
					// send pkt 1

The following patch try to addresses the above, clearing 'empty' flag
in a more aggressive way. We can end-up skipping the bypass
optimization more often than strictly needed in some contended
scenarios, but I guess that is preferrable to the current issue.

The code is only build-tested, could you please try it in your setup?

Thanks,

Paolo
---
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fceddf89592a..df460fe0773a 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -158,7 +158,6 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		if (!spin_trylock(&qdisc->seqlock))
 			return false;
-		WRITE_ONCE(qdisc->empty, false);
 	} else if (qdisc_is_running(qdisc)) {
 		return false;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index 0ad39c87b7fd..3c46575a5af5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3625,6 +3625,8 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 			qdisc_run_end(q);
 		} else {
 			rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+			if (rc != NET_XMIT_DROP && READ_ONCE(q->empty))
+				WRITE_ONCE(q->empty, false);
 			qdisc_run(q);
 		}
 

