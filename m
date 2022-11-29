Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5932863C5C9
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiK2Q6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbiK2Q53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:57:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D986770441
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:51:43 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669740701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7EazyHGHCpeTiiHucwroXGYdDx6pSWXMjFRJN0efiU=;
        b=ch/s6fN4Am4Uxiu0RKnMDjx9fWWC4L9tps9QSGyUzgdzOv4sJGF2VeBB9zurwp6JEhvqMM
        H104vTKgaN0rynLYwEOKqaTT3mJWc2oUkUW4EIjijd3DzKlNolNDl1/RmyrQXr8YrPvrzC
        jpQPs3SlSAQdgvP872aQ9BTi8FDM4tXMO4Hgf5FWHHzEbfprCrM6py/mkdPf768vS1XE8v
        LxcBM2rWO7IuYVku9JpwANjcf4ONtjdkH0tjFUwqfs8DWAl1ooQ9Tl2SzXlhfnpest4y5C
        v4sR5ueS6KchvuHHm5WoItlPtC6pBAJQJYFX3yoNuqTmGgdZ9ZuywXnTE+RcCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669740701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7EazyHGHCpeTiiHucwroXGYdDx6pSWXMjFRJN0efiU=;
        b=1VkNEU/v8Mc/Ox/JTXn2XhLvcoV6FWK1K39mSPIPFsKTytua69jqjhGW4L+Kk2cbGpTH4l
        6PIS4h815+4eqVBw==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v5 net-next 3/8] hsr: Avoid double remove of a node.
Date:   Tue, 29 Nov 2022 17:48:10 +0100
Message-Id: <20221129164815.128922-4-bigeasy@linutronix.de>
In-Reply-To: <20221129164815.128922-1-bigeasy@linutronix.de>
References: <20221129164815.128922-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to the hashed-MAC optimisation one problem become visible:
hsr_handle_sup_frame() walks over the list of available nodes and merges
two node entries into one if based on the information in the supervision
both MAC addresses belong to one node. The list-walk happens on a RCU
protected list and delete operation happens under a lock.

If the supervision arrives on both slave interfaces at the same time
then this delete operation can occur simultaneously on two CPUs. The
result is the first-CPU deletes the from the list and the second CPUs
BUGs while attempting to dereference a poisoned list-entry. This happens
more likely with the optimisation because a new node for the mac_B entry
is created once a packet has been received and removed (merged) once the
supervision frame has been received.

Avoid removing/ cleaning up a hsr_node twice by adding a `removed' field
which is set to true after the removal and checked before the removal.

Fixes: f266a683a4804 ("net/hsr: Better frame dispatch")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 net/hsr/hsr_framereg.c | 16 +++++++++++-----
 net/hsr/hsr_framereg.h |  1 +
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 9b8eaebce2549..f2dd846ff9038 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -366,9 +366,12 @@ void hsr_handle_sup_frame(struct hsr_frame_info *frame)
 	node_real->addr_B_port =3D port_rcv->type;
=20
 	spin_lock_bh(&hsr->list_lock);
-	list_del_rcu(&node_curr->mac_list);
+	if (!node_curr->removed) {
+		list_del_rcu(&node_curr->mac_list);
+		node_curr->removed =3D true;
+		kfree_rcu(node_curr, rcu_head);
+	}
 	spin_unlock_bh(&hsr->list_lock);
-	kfree_rcu(node_curr, rcu_head);
=20
 done:
 	/* Push back here */
@@ -539,9 +542,12 @@ void hsr_prune_nodes(struct timer_list *t)
 		if (time_is_before_jiffies(timestamp +
 				msecs_to_jiffies(HSR_NODE_FORGET_TIME))) {
 			hsr_nl_nodedown(hsr, node->macaddress_A);
-			list_del_rcu(&node->mac_list);
-			/* Note that we need to free this entry later: */
-			kfree_rcu(node, rcu_head);
+			if (!node->removed) {
+				list_del_rcu(&node->mac_list);
+				node->removed =3D true;
+				/* Note that we need to free this entry later: */
+				kfree_rcu(node, rcu_head);
+			}
 		}
 	}
 	spin_unlock_bh(&hsr->list_lock);
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index bdbb8c822ba1a..b5f902397bf1a 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -80,6 +80,7 @@ struct hsr_node {
 	bool			san_a;
 	bool			san_b;
 	u16			seq_out[HSR_PT_PORTS];
+	bool			removed;
 	struct rcu_head		rcu_head;
 };
=20
--=20
2.38.1

