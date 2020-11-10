Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE24A2AD44F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgKJLCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729630AbgKJLCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:02:08 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB74CC0613CF;
        Tue, 10 Nov 2020 03:02:07 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id h6so9848109pgk.4;
        Tue, 10 Nov 2020 03:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+SbxyZahfMfXnU/FChOm2quTfC2gyIuFdUfnHAtZnoI=;
        b=HDo2tLvTPlUvSl/ynyu+g51F9cSukXV+T7MVRGwd/ECz1C+0G0+I2wcLPsSbC18oXd
         inwKKlEU3sDBIhLVNZk+P/sw4/DfsG0ikuc8rcDBubiB8nStQezh2QFpA9tVWy/mmYXm
         0NGQm50exAolDD2y6mImHFcw8p691Yr8NaP+eFDCmJ+Ep0mHz2HmqPLgWqxyRjBm+x/2
         wrkiY0LtzeZvMJXty6GT15PD+2pZog2E2BfDbekl3yL+wTk6+IBdbl4rq/X3ialkWXa/
         D5nNSkCip85Tn6/xHsVoPBXLanXtl9GKLQslz/3j3gvSFeTCMeS6SxuMRQ5eomkKYJ/f
         Q2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+SbxyZahfMfXnU/FChOm2quTfC2gyIuFdUfnHAtZnoI=;
        b=oOOt8918G75V2PJdGrFK71DFQ61YEGILrQgYyK6pgRfTJQcQJrWS779t+lmJ0pe6n7
         NbW8kA7dGbnpcxYuiIT/PeQY11AUeiKJOzqzsIr004OHXtbW9WPKctiSywiSgxFbwy2w
         dEVB6hRFYzlYgRtZw8mDiYlS4qdbHxy9Pu//bD//8Yy997XgyPLpbmSq6mxTXceIN2Ba
         fQpj+1lgEfRFZYPLa7Juhmp9p2AqO6bRBHP1iA3aIngDQEOFkKP/Ki3IaCKiqeR3Y73l
         66d0pzex/RqMKHIa/JN1U8V3X32l/GfnTro4MjPGd8TFfw+elEQtU66t0haGCXN+FoIz
         Hp3Q==
X-Gm-Message-State: AOAM531atR93xP7skoQ3U+S/pLVno8XLoRbFTN1sCRKsPKuaodpuI5Jn
        gqJOh1pFx2r2hysCkp9M0JA=
X-Google-Smtp-Source: ABdhPJzxXLLj8wlpgU6Uci22CTaPUGpi5ulPRN9nH5GXepx6NeUX+461wyJD5OnMiToM2Fxo8oX5zQ==
X-Received: by 2002:a63:4912:: with SMTP id w18mr17141230pga.131.1605006127544;
        Tue, 10 Nov 2020 03:02:07 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 22sm3012024pjb.40.2020.11.10.03.02.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 03:02:06 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v2 1/5] samples/bpf: increment Tx stats at sending
Date:   Tue, 10 Nov 2020 12:01:30 +0100
Message-Id: <1605006094-31097-2-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
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
Acked-by: John Fastabend <john.fastabend@gmail.com>
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

