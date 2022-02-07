Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE134AB883
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 11:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358219AbiBGKNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 05:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245324AbiBGKIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:08:22 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE9C043181;
        Mon,  7 Feb 2022 02:08:21 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id z7so18780005ljj.4;
        Mon, 07 Feb 2022 02:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=s5p54l/5ghXdgSmZcw68jguzPsn8MNmzYbYS1HcBzhQ=;
        b=RzMbPy1Ln5QC6ew2bpQt2fFy5Gg4iv7JtdI3IUXtfqISS/HnN0e86EcT7Di/nEKMxE
         1NadGpBz6dm7Q4yJ5wejlLcbT2YiydWbY0KrhlqgdPm/o3bPUTm+yqbvl0nNIqjwoaD2
         SGBnI8aDBDsezm963aQhsje0reUXEAc0i9BHqFs6iUaa5NdDNOZ6kHeH+LqpXjDpUkE+
         5Z+l92urz0maruhjX3vzEGZf+tks0CM3tCNjn9Dzi0C+1ImRdLzgDv79IzTC0DzPlTs9
         eZNh5g0ZdlI8FpmT4zgLHyw1Twr3mcA0Vd2WzQUWxekdtA7YXTx6O4RNsztpkypFklQP
         sPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=s5p54l/5ghXdgSmZcw68jguzPsn8MNmzYbYS1HcBzhQ=;
        b=gC0EIV42IwLPt8hfq1N1cuK8Gk2FkDoy2KgsSV5fHjpbllvWhn2SXpfJqRxc5NWZbm
         8Ue2cB/4EewzlWAzYk4gcI8R2VkVISfV46E3mCYQ5OaawB5ca5pN4WXusxZan8MbOYIO
         rj6lY1u8tMwwclUpGMkzog5XmwxTxhMHW6hEXFegRMnUIyXVuX79tIV7pWJ97eU2NOi6
         lLhIUSV8TkTb5bnngWD4KhyHB6ZyjWLT5lNL6Zin+5Xekg3hj4//cIldgVDhPSVA7sR9
         Y80CQTu2C/2PdY3iydzefHyzkJMW5Ksa0XBYYJytYasoXUsJ84wtfF9jtjXanXg+Jjap
         TH+A==
X-Gm-Message-State: AOAM532i+g6/yoK1PUTfVgmlN32fBJez3RyU4uBbmVyOYHluBCOkkE37
        rj3104p6e5ytcGsuJUESUpk=
X-Google-Smtp-Source: ABdhPJxMQy4Pq8xSBb2Kxdy0UnyMlVEthzWHERuU3S/+zvpQY031kDEBJGyRzezNzLjiKs+NiMTyJg==
X-Received: by 2002:a2e:5810:: with SMTP id m16mr8134875ljb.261.1644228499706;
        Mon, 07 Feb 2022 02:08:19 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id k12sm1546034ljh.45.2022.02.07.02.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 02:08:19 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/4] net: bridge: Refactor bridge port in locked mode to use jump labels
Date:   Mon,  7 Feb 2022 11:07:42 +0100
Message-Id: <20220207100742.15087-5-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
References: <20220207100742.15087-1-schultz.hans+netdev@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the locked mode feature is in the hot path of the bridge modules
reception of packets, it needs to be refactored to use jump labels
for optimization.

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 net/bridge/br_input.c   | 22 ++++++++++++++++++----
 net/bridge/br_netlink.c |  6 ++++++
 net/bridge/br_private.h |  2 ++
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 469e3adbce07..6fc428d6bac5 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -23,6 +23,18 @@
 #include "br_private.h"
 #include "br_private_tunnel.h"
 
+static struct static_key_false br_input_locked_port_feature;
+
+void br_input_locked_port_add(void)
+{
+	static_branch_inc(&br_input_locked_port_feature);
+}
+
+void br_input_locked_port_remove(void)
+{
+	static_branch_dec(&br_input_locked_port_feature);
+}
+
 static int
 br_netif_receive_skb(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
@@ -91,10 +103,12 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 				&state, &vlan))
 		goto out;
 
-	if (p->flags & BR_PORT_LOCKED) {
-		fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
-		if (!(fdb_entry && fdb_entry->dst == p))
-			goto drop;
+	if (static_branch_unlikely(&br_input_locked_port_feature)) {
+		if (p->flags & BR_PORT_LOCKED) {
+			fdb_entry = br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
+			if (!(fdb_entry && fdb_entry->dst == p))
+				goto drop;
+		}
 	}
 
 	nbp_switchdev_frame_mark(p, skb);
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 7d4432ca9a20..e3dbe9fed75c 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -860,6 +860,7 @@ static int br_set_port_state(struct net_bridge_port *p, u8 state)
 static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 			     int attrtype, unsigned long mask)
 {
+	bool locked = p->flags & BR_PORT_LOCKED;
 	if (!tb[attrtype])
 		return;
 
@@ -867,6 +868,11 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 		p->flags |= mask;
 	else
 		p->flags &= ~mask;
+
+	if ((p->flags & BR_PORT_LOCKED) && !locked)
+		br_input_locked_port_add();
+	if (!(p->flags & BR_PORT_LOCKED) && locked)
+		br_input_locked_port_remove();
 }
 
 /* Process bridge protocol info on port */
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2661dda1a92b..0ec3ef897978 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -832,6 +832,8 @@ void br_manage_promisc(struct net_bridge *br);
 int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
 
 /* br_input.c */
+void br_input_locked_port_add(void);
+void br_input_locked_port_remove(void);
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
 
-- 
2.30.2

