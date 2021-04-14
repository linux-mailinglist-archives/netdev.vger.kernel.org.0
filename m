Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7287135FBB8
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbhDNThS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237401AbhDNThK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 15:37:10 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3855C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 12:36:47 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id k23-20020a17090a5917b02901043e35ad4aso13062089pji.3
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 12:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f3lpSvGte6XUIHApO9Wl4+pNvOXL45MJrEoN1FW+TsM=;
        b=VLpH2ae5OfKgdZx/ccpEg0tjupeFdVVjGGJiiwLq69tbANoXP/s5GfOz81Tlkq0haX
         MdQgluGT+PXjvVeURVnQhqpUUFlMWh8zW4QrhUVfU2c9CpAi/6OW2H9RlTzKm+tR0c73
         4bdIgI27HIR2m813ARQ74ax/07p95TZONx70PYFk7HhaCI2vXoI/FbqZXTs/2ocouKT8
         Qh5tVe7z/aSk6TmHYNI/+wM/3yk6RhKtD9kootFfhg4pX6h/9c9D4CbDz8QKi9fB/h2O
         5c5l54k6itUTXPRISjiCmV+wGLwLBVV/YZMPT7b6cTPNK++lOIbj2AkEnJRTuceRVERI
         CRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f3lpSvGte6XUIHApO9Wl4+pNvOXL45MJrEoN1FW+TsM=;
        b=UAysDz3nEirYCz4JVjCw9L60HwrY3N3E0qExoYpAXGp2zx5nwZYwKTe76F4iI0X+gX
         EJoywroEEbcqpGa0L88FzP84lo+bN/D6NjfWTsd3VEuRDidoFzkyCWkFCAlXxPHdH7CE
         fUauNK8x7xqpxLYKCW96ox3WqLfz4ReifBiHKPjdXAuDFn0cHWhssxdfz0vIc6CX08r+
         B1G2A8EP4iXl0EhKhsvyrZ5qOUtI3q0WIuBNAnbECat4pdO43HUureWn3iR1KhbVfxss
         PDO3nogQuz3UdRmDebZpY6XocK9+MpYrIcbDepain1IPf4n7rUyPCCqSMolutFXW/kJq
         sPfg==
X-Gm-Message-State: AOAM5337MQaDFtejjQyM8r9f8jAXQY+nSBduX82dpMSbGyeSFIuCg0Tr
        PJmArhTpL4k1gn+PTtM1wx4=
X-Google-Smtp-Source: ABdhPJxYNAksA4DGGzM8W1fG+GytEyGSzHHFuWGPVNqBHZgnpKxJ+joeVFKzSYhfyMmmd4m7BMyuWg==
X-Received: by 2002:a17:902:9307:b029:ea:e588:10a with SMTP id bc7-20020a1709029307b02900eae588010amr20404146plb.7.1618429007314;
        Wed, 14 Apr 2021 12:36:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:cdc0:5e6a:30a8:b515])
        by smtp.gmail.com with ESMTPSA id a13sm290695pgm.43.2021.04.14.12.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 12:36:46 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] net/packet: remove data races in fanout operations
Date:   Wed, 14 Apr 2021 12:36:44 -0700
Message-Id: <20210414193644.1421615-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.1.295.g9ea45b61b8-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

af_packet fanout uses RCU rules to ensure f->arr elements
are not dismantled before RCU grace period.

However, it lacks rcu accessors to make sure KCSAN and other tools
wont detect data races. Stupid compilers could also play games.

Fixes: dc99f600698d ("packet: Add fanout support.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
Cc: Willem de Bruijn <willemb@google.com>
---
This probably can target net-next instead of net, this is not a problem in practice.

 net/packet/af_packet.c | 15 +++++++++------
 net/packet/internal.h  |  2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e24b2841c643a1c2c471416ceb78e82a85f9a740..9611e41c7b8be7c7fa8961d9e6e91f023dd7023f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1359,7 +1359,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 	struct packet_sock *po, *po_next, *po_skip = NULL;
 	unsigned int i, j, room = ROOM_NONE;
 
-	po = pkt_sk(f->arr[idx]);
+	po = pkt_sk(rcu_dereference(f->arr[idx]));
 
 	if (try_self) {
 		room = packet_rcv_has_room(po, skb);
@@ -1371,7 +1371,7 @@ static unsigned int fanout_demux_rollover(struct packet_fanout *f,
 
 	i = j = min_t(int, po->rollover->sock, num - 1);
 	do {
-		po_next = pkt_sk(f->arr[i]);
+		po_next = pkt_sk(rcu_dereference(f->arr[i]));
 		if (po_next != po_skip && !READ_ONCE(po_next->pressure) &&
 		    packet_rcv_has_room(po_next, skb) == ROOM_NORMAL) {
 			if (i != j)
@@ -1466,7 +1466,7 @@ static int packet_rcv_fanout(struct sk_buff *skb, struct net_device *dev,
 	if (fanout_has_flag(f, PACKET_FANOUT_FLAG_ROLLOVER))
 		idx = fanout_demux_rollover(f, skb, idx, true, num);
 
-	po = pkt_sk(f->arr[idx]);
+	po = pkt_sk(rcu_dereference(f->arr[idx]));
 	return po->prot_hook.func(skb, dev, &po->prot_hook, orig_dev);
 }
 
@@ -1480,7 +1480,7 @@ static void __fanout_link(struct sock *sk, struct packet_sock *po)
 	struct packet_fanout *f = po->fanout;
 
 	spin_lock(&f->lock);
-	f->arr[f->num_members] = sk;
+	rcu_assign_pointer(f->arr[f->num_members], sk);
 	smp_wmb();
 	f->num_members++;
 	if (f->num_members == 1)
@@ -1495,11 +1495,14 @@ static void __fanout_unlink(struct sock *sk, struct packet_sock *po)
 
 	spin_lock(&f->lock);
 	for (i = 0; i < f->num_members; i++) {
-		if (f->arr[i] == sk)
+		if (rcu_dereference_protected(f->arr[i],
+					      lockdep_is_held(&f->lock)) == sk)
 			break;
 	}
 	BUG_ON(i >= f->num_members);
-	f->arr[i] = f->arr[f->num_members - 1];
+	rcu_assign_pointer(f->arr[i],
+			   rcu_dereference_protected(f->arr[f->num_members - 1],
+						     lockdep_is_held(&f->lock)));
 	f->num_members--;
 	if (f->num_members == 0)
 		__dev_remove_pack(&f->prot_hook);
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 5f61e59ebbffaa25a8fdfe31f79211fe6a755c51..48af35b1aed2565267c0288e013e23ff51f2fcac 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -94,7 +94,7 @@ struct packet_fanout {
 	spinlock_t		lock;
 	refcount_t		sk_ref;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
-	struct sock		*arr[];
+	struct sock	__rcu	*arr[];
 };
 
 struct packet_rollover {
-- 
2.31.1.295.g9ea45b61b8-goog

