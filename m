Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059B12A65F0
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgKDOJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730160AbgKDOJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:09:42 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91D3C0613D3;
        Wed,  4 Nov 2020 06:09:42 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id i7so14774000pgh.6;
        Wed, 04 Nov 2020 06:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8+wmdl8dxGrL4PiYjqO1IGkwfNXPjaWfQTVtL5mk3TU=;
        b=pqfALFjyvFpVFRkFsJUEQWBG1QOKGsIgGOga8VgN6ZqRXRoEarHrMOg3EaA/cevxMJ
         OHh7oDXHKItfvhHKg1l8hH4ze1C88whzbodX2iRIa36ANhUrOvAkHVPt5BWpIugKsvgx
         VV4yfRMElhX7WfIRm8xopCdT3bqnm84kNIf924oric/ZSsQ9VQ/iwMkjlnRFjWiZII1r
         Deq1joxcO65nhHdaoBOG7PErCT7dPxbW4UbOJ6cQ3vtMkywVEY4RpwtMNswx79Df8JYO
         /vwb+mOSe90WdBa2G3BzTlALfjrh/VOCiE0k7TUNEZT37Xb7hIwUKvxxKWAilBDqqxeG
         Yz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8+wmdl8dxGrL4PiYjqO1IGkwfNXPjaWfQTVtL5mk3TU=;
        b=c4I1Vo9UBvJCDzjo/qKnqABkTA/sNyA0v6yRb/MqacmW0T3pMhgyLjPNRrPRQ2yFIK
         91KOYfzUfjHBZtfkhkiVL8+LMOJ054MtIXVfwLS9JLd2XiXqR9+ur3FVNwOEMXrK+75Z
         Hzgf8nbgEPBG+0E1sZYz5vJtsq4LHvj2T2kV9cmNiiWp+r9T3VEj1gPvBjiJmqhkktrK
         +SiLlx67ZVKampCLkmbvgoAEKRQ8pgkDe2WC3B5TCFgRp+84lCfS5uV8B1w/dcB7fpmh
         Qc1rrJvwUQHJdK1pD0BTFW0G5g1fdwPNWjI40dYBAZj844Av5nyuMKpuL/F23YpLo93C
         EKvA==
X-Gm-Message-State: AOAM5305mjPozRKSmu/Ks3rfZSPS2GGDAd3JTy2/YG8ucw6ION9+soLD
        nGAcx97EMbtMkuz7Ti6F4nKfwZACes63kFboZGs=
X-Google-Smtp-Source: ABdhPJzIoXz/gBu1yr5pXzZGVVq8Z08Ksz/3VbhzpwCKerO50ZqQ6h9oFGmPWePptpisDK0xiKadmg==
X-Received: by 2002:a17:90a:e658:: with SMTP id ep24mr3478312pjb.171.1604498982258;
        Wed, 04 Nov 2020 06:09:42 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q123sm2724818pfq.56.2020.11.04.06.09.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 06:09:41 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next 2/6] samples/bpf: increment Tx stats at sending
Date:   Wed,  4 Nov 2020 15:08:58 +0100
Message-Id: <1604498942-24274-3-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Increment the statistics over how many Tx packets have been sent at
the time of sending instead of at the time of completion. This as a
completion event means that the buffer has been sent AND returned to
user space. The packet always gets sent shortly after sendto() is
called. The kernel might, for performance reasons, decide to not
return every single buffer to user space immediately after sending,
for example, only after a batch of packets have been
transmitted. Incrementing the number of packets sent at completion,
will in that case be confusing as if you send a single packet, the
counter might show zero for a while even though the packet has been
transmitted.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index 1149e94..2567f0d 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1146,7 +1146,6 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
 		xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
-		xsk->ring_stats.tx_npkts += rcvd;
 	}
 }
 
@@ -1168,7 +1167,6 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk,
 	if (rcvd > 0) {
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
-		xsk->ring_stats.tx_npkts += rcvd;
 	}
 }
 
@@ -1260,6 +1258,7 @@ static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batch_size)
 	}
 
 	xsk_ring_prod__submit(&xsk->tx, batch_size);
+	xsk->ring_stats.tx_npkts += batch_size;
 	xsk->outstanding_tx += batch_size;
 	*frame_nb += batch_size;
 	*frame_nb %= NUM_FRAMES;
@@ -1348,6 +1347,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 		}
 		return;
 	}
+	xsk->ring_stats.rx_npkts += rcvd;
 
 	ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
 	while (ret != rcvd) {
@@ -1379,7 +1379,7 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
 	xsk_ring_prod__submit(&xsk->tx, rcvd);
 	xsk_ring_cons__release(&xsk->rx, rcvd);
 
-	xsk->ring_stats.rx_npkts += rcvd;
+	xsk->ring_stats.tx_npkts += rcvd;
 	xsk->outstanding_tx += rcvd;
 }
 
-- 
2.7.4

