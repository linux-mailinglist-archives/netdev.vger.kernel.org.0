Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6528D635908
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236672AbiKWKHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiKWKGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:06:18 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1378B114BA3
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:56:46 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669197405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7EazyHGHCpeTiiHucwroXGYdDx6pSWXMjFRJN0efiU=;
        b=W1UIEfROOYezoFdcuMrKjptJkQdRB2e1OtImPlzPNT37h8OIJ/G4dzANci+xJSuxL6MxbU
        RzMb39ANiFKGhTF+Cj+H9IdwW1JjSkDBcC19LJNE6O4AALrBUejnWWB3/hI+nKcpicHgzF
        lYSAFpZZ10fbu7z4IhDKyiFDTk6RIDJp3kcS6HM9OEUA0NBdwWpqP7SqkGT0PLLyA98gxN
        8kkmJJPa9wSKQkof7/FWm2BDEBF0qYZ64/ndYJKsJL8KxbNhwdGsVzMLA6Sd6BGRZKeybW
        ba6dG8I06zNUNELFMcEEnV2GPEFr2WChYaRZNikgAwKHE7pdyTq251qZrJl0JQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669197405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x7EazyHGHCpeTiiHucwroXGYdDx6pSWXMjFRJN0efiU=;
        b=1qttiztw8lJByJD1kKdxBWJ6Otzq0lML/N96VKUilau2E44BDnjsTzzVOuSfDR5eJ6Pz+F
        t7jZMxwydkws8eBA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH v3 net 3/6] hsr: Avoid double remove of a node.
Date:   Wed, 23 Nov 2022 10:56:35 +0100
Message-Id: <20221123095638.2838922-4-bigeasy@linutronix.de>
In-Reply-To: <20221123095638.2838922-1-bigeasy@linutronix.de>
References: <20221123095638.2838922-1-bigeasy@linutronix.de>
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

