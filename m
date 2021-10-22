Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4019D437C4F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbhJVR6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:58:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhJVR6F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3DF161362;
        Fri, 22 Oct 2021 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634925348;
        bh=Mvz46oOEMIh0Tug4TtVgfCUXV2RCwd1rZlGET4PwoQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkBGXZmzhVNBRRvnpUH/dS3tC/xPcMNHIZqihbiDlSn0Xq2oKDRslJDAUHZGF/d2i
         ZxrU/eRXY5v3u8b8SMOfsORPCY/dC1f0z3Z406lneky3k3D+KIScfXdWtLSDNw7jz9
         YnuxPnHtYcwW18PWICD88k/7r5t1ppJiPl0rQaNBCXfre03I7415Xa/QpDvZaQtmeO
         x2TrpHbA0EkvxLceYHezmhr53KO6/SUij9M6updRrch5twjYBgT8t7M3TZKloYWTQV
         S1uvbeQ0AnnNrYfNh43k5BIX97jjFvxUxPqNjm61DmDiv/WRoMXGZ4YQbjkaNzaiMX
         P7CXFAkcX42sg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        george.mccollister@gmail.com, marco.wenzel@a-eberle.de
Subject: [PATCH net-next 5/8] net: hsr: get ready for const netdev->dev_addr
Date:   Fri, 22 Oct 2021 10:55:40 -0700
Message-Id: <20211022175543.2518732-6-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211022175543.2518732-1-kuba@kernel.org>
References: <20211022175543.2518732-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hsr_create_self_node() may get netdev->dev_addr
passed as argument, netdev->dev_addr will be
const soon.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: george.mccollister@gmail.com
CC: marco.wenzel@a-eberle.de
---
 net/hsr/hsr_framereg.c | 4 ++--
 net/hsr/hsr_framereg.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index e31949479305..91292858a63b 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -76,8 +76,8 @@ static struct hsr_node *find_node_by_addr_A(struct list_head *node_db,
  * frames from self that's been looped over the HSR ring.
  */
 int hsr_create_self_node(struct hsr_priv *hsr,
-			 unsigned char addr_a[ETH_ALEN],
-			 unsigned char addr_b[ETH_ALEN])
+			 const unsigned char addr_a[ETH_ALEN],
+			 const unsigned char addr_b[ETH_ALEN])
 {
 	struct list_head *self_node_db = &hsr->self_node_db;
 	struct hsr_node *node, *oldnode;
diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
index d9628e7a5f05..bdbb8c822ba1 100644
--- a/net/hsr/hsr_framereg.h
+++ b/net/hsr/hsr_framereg.h
@@ -48,8 +48,8 @@ int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
 void hsr_prune_nodes(struct timer_list *t);
 
 int hsr_create_self_node(struct hsr_priv *hsr,
-			 unsigned char addr_a[ETH_ALEN],
-			 unsigned char addr_b[ETH_ALEN]);
+			 const unsigned char addr_a[ETH_ALEN],
+			 const unsigned char addr_b[ETH_ALEN]);
 
 void *hsr_get_next_node(struct hsr_priv *hsr, void *_pos,
 			unsigned char addr[ETH_ALEN]);
-- 
2.31.1

