Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4486F2B425D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgKPLNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbgKPLNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:13:45 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E98C0613CF;
        Mon, 16 Nov 2020 03:13:45 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id j19so6107682pgg.5;
        Mon, 16 Nov 2020 03:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+SbxyZahfMfXnU/FChOm2quTfC2gyIuFdUfnHAtZnoI=;
        b=dm4VnmqrFU23MKn/TKtIS4x/rNBKQpkzivbC6Xa+MPM04MO8nbeTUZY8HTgfvYys1j
         EOYiVrhB58A2akTYPFjGXf7c2SMKcPDfdAOiRAGjSu+oOvaTYIfJ+Dk+od/gIVIu2D8r
         cbAXyVwzvuDEhe9GUS0IqSfIbRiAgw61hQ6AMbBpv7o2B07EiT2/VFrTgsIiM9Kj4YMs
         fMj06Fw8BwmdGHUA0QAA8rCG19HY4PSZu+iB0zY4NfNI9ZV19WWE+YrumAo01AqbuRyQ
         bNu465+g6EAYR8Rx3rjh4x/Z8Y+Y4BRhvMbr2o7xLXlnZC8QqcDlOa18ogeYc9eqYMMT
         MikQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+SbxyZahfMfXnU/FChOm2quTfC2gyIuFdUfnHAtZnoI=;
        b=sDj24V1ySvPnldSVJlt8pftQephcGpQF/gsi4ZIM2tEPeWVkEgx7h1JYSDXQe0vyyo
         Z3zcWrvxJCszVVAMHhidpgctKZf4s978qk2ZQve8CI0raby1P0bTMApwv7Gh0h87Brf1
         oWjYqvu8SvJwdCRJelOfSB8wYA9FLzPzv7iEz6XNWIOpeXcdo988zF3ADNQCHds4h87B
         DIyE4zqKJ0jjL7Sf16s6KKcZdIJcdZVbjmP67bqW8INMp1u0G4n3+AdaYeF2Z8DJL6Ha
         1r7xl/53d5S5Qx9AA/My/wvsG4CaZ7hy0XmFtn4BjT9pcICwkS4/xOKNnn0cIbhBbjTh
         9yKw==
X-Gm-Message-State: AOAM533VFtaIm/ajeQh+mraYWIouPUBtt0+AHx/QPs6XK43XxUOCbWR+
        pjxPwSTdsfWF7+EYAyrumNM=
X-Google-Smtp-Source: ABdhPJybPSvfextFY3UUIP4zrPkriv1bO8XhL0wD6bS3IGeBhbnbQ10ErLFdZ26Ko4b4QBOR6o+FWg==
X-Received: by 2002:a17:90a:fd0d:: with SMTP id cv13mr15802905pjb.124.1605525225333;
        Mon, 16 Nov 2020 03:13:45 -0800 (PST)
Received: from localhost.localdomain ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id u24sm19486826pfm.81.2020.11.16.03.13.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 03:13:44 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 1/5] samples/bpf: increment Tx stats at sending
Date:   Mon, 16 Nov 2020 12:12:43 +0100
Message-Id: <1605525167-14450-2-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
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

