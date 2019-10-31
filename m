Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2460EA916
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 03:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfJaCJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 22:09:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43908 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbfJaCJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 22:09:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id a194so5225937qkg.10;
        Wed, 30 Oct 2019 19:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aow7KV2fAS1Nutezq+6q1cPoJtz4+LBCy3ES0kPGlYs=;
        b=Ays//Twp7Ud/2LkNFY44HQfkVBfriE56FtpphtoFOM1BdzWp7Z9hxgYlvEdX3BTrcQ
         z348Hgpkgw0zTsh/2SjFZv7AeYsd/NgC/vFcdXNHPU7anrQOhIbpCx2ljEc+vN80i/VX
         2QwmLXFOmO2WNwNTC9sDWu62My904mJySJi5QlkIgdkCg3pwtB5+d5cTzHsostT8D8qX
         452tyA1p/srrCffmrlW1KmLzVN6TElbeVnUdp1WK/unVLRq7aVtZAHMUQ6PR2Iz4ZH2I
         JeOBZtfN54t0nwe0qoRxYQoJh1HElLIJvmnLVv1A2VziQz+nOO9vR9wxUrzV/lBHvDuy
         yrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aow7KV2fAS1Nutezq+6q1cPoJtz4+LBCy3ES0kPGlYs=;
        b=ix3A5KpT9VQeDXybL35pR3qlZPYu1a7SwUdGYYWjuyEvhZgs99XJiugbUw+TcWI62h
         Fhab9p8ab7iFWQCRvCB7YvcZSy3Ko8Bh68/87pzoZW0vMAYOLkQF8sUqZrCWhMGBAcEH
         EvvrmRszKRRrijzRey5REa6t3sseDS9TcjxP3FqazLpGS+5a286CXhj8O8lJZNX2Nnih
         ERj7bH4tkNcaNUq+5U0Vc7l3N7BB/HiKV/yGgn11UDG5Uf6KNJXcY8QAOoLCkLWRt0C7
         MaQ5fPzjmFamSVkbwbJwCAyw0lvF9d2UceplWykThkXRmEGlwRL8BEYwyEpDQpQ3Yw91
         BSZw==
X-Gm-Message-State: APjAAAXzW91P5ZSHRiMEberaMI+nq5+wk8lmfVEkXOURplT7nadAlfMb
        T33ShLMzMTJ+dXjqfa58hLI=
X-Google-Smtp-Source: APXvYqzNPEsrHxDbSilGlPyzmW6AJk4uospspPZNoSHWUkRkaP+0jGQm1MAHFkxuYQHP9RgwrfFt3g==
X-Received: by 2002:a37:6554:: with SMTP id z81mr3292968qkb.9.1572487773879;
        Wed, 30 Oct 2019 19:09:33 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id p7sm1080125qkc.21.2019.10.30.19.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2019 19:09:33 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/7] net: dsa: list DSA links in the fabric
Date:   Wed, 30 Oct 2019 22:09:13 -0400
Message-Id: <20191031020919.139872-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191031020919.139872-1-vivien.didelot@gmail.com>
References: <20191031020919.139872-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement a new list of DSA links in the switch fabric itself, to
provide an alterative to the ds->rtable static arrays.

At the same time, provide a new dsa_routing_port() helper to abstract
the usage of ds->rtable in drivers. If there's no port to reach a
given device, return the first invalid port, ds->num_ports. This avoids
potential signedness errors or the need to define special values.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |  8 +++----
 include/net/dsa.h                | 29 +++++++++++++++++++++-
 net/dsa/dsa2.c                   | 41 +++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 619cd081339e..66de492117ad 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1143,6 +1143,7 @@ static int mv88e6xxx_pri_setup(struct mv88e6xxx_chip *chip)
 
 static int mv88e6xxx_devmap_setup(struct mv88e6xxx_chip *chip)
 {
+	struct dsa_switch *ds = chip->ds;
 	int target, port;
 	int err;
 
@@ -1151,10 +1152,9 @@ static int mv88e6xxx_devmap_setup(struct mv88e6xxx_chip *chip)
 
 	/* Initialize the routing port to the 32 possible target devices */
 	for (target = 0; target < 32; target++) {
-		port = 0x1f;
-		if (target < DSA_MAX_SWITCHES)
-			if (chip->ds->rtable[target] != DSA_RTABLE_NONE)
-				port = chip->ds->rtable[target];
+		port = dsa_routing_port(ds, target);
+		if (port == ds->num_ports)
+			port = 0x1f;
 
 		err = mv88e6xxx_g2_device_mapping_write(chip, target, port);
 		if (err)
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9aba326abb64..3d7366d634d8 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -123,6 +123,9 @@ struct dsa_switch_tree {
 	/* List of switch ports */
 	struct list_head ports;
 
+	/* List of DSA links composing the routing table */
+	struct list_head rtable;
+
 	/*
 	 * Data for the individual switch chips.
 	 */
@@ -214,6 +217,17 @@ struct dsa_port {
 	bool setup;
 };
 
+/* TODO: ideally DSA ports would have a single dp->link_dp member,
+ * and no dst->rtable nor this struct dsa_link would be needed,
+ * but this would require some more complex tree walking,
+ * so keep it stupid at the moment and list them all.
+ */
+struct dsa_link {
+	struct dsa_port *dp;
+	struct dsa_port *link_dp;
+	struct list_head list;
+};
+
 struct dsa_switch {
 	bool setup;
 
@@ -324,6 +338,19 @@ static inline u32 dsa_user_ports(struct dsa_switch *ds)
 	return mask;
 }
 
+/* Return the local port used to reach an arbitrary switch device */
+static inline unsigned int dsa_routing_port(struct dsa_switch *ds, int device)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_link *dl;
+
+	list_for_each_entry(dl, &dst->rtable, list)
+		if (dl->dp->ds == ds && dl->link_dp->ds->index == device)
+			return dl->dp->index;
+
+	return ds->num_ports;
+}
+
 /* Return the local port used to reach an arbitrary switch port */
 static inline unsigned int dsa_towards_port(struct dsa_switch *ds, int device,
 					    int port)
@@ -331,7 +358,7 @@ static inline unsigned int dsa_towards_port(struct dsa_switch *ds, int device,
 	if (device == ds->index)
 		return port;
 	else
-		return ds->rtable[device];
+		return dsa_routing_port(ds, device);
 }
 
 /* Return the local port used to reach the dedicated CPU port */
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e7aae96b54bb..222d7dbfcfea 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -45,6 +45,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 	dst->index = index;
 
+	INIT_LIST_HEAD(&dst->rtable);
+
 	INIT_LIST_HEAD(&dst->ports);
 
 	INIT_LIST_HEAD(&dst->list);
@@ -122,6 +124,31 @@ static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
 	return NULL;
 }
 
+struct dsa_link *dsa_link_touch(struct dsa_port *dp, struct dsa_port *link_dp)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct dsa_switch_tree *dst;
+	struct dsa_link *dl;
+
+	dst = ds->dst;
+
+	list_for_each_entry(dl, &dst->rtable, list)
+		if (dl->dp == dp && dl->link_dp == link_dp)
+			return dl;
+
+	dl = kzalloc(sizeof(*dl), GFP_KERNEL);
+	if (!dl)
+		return NULL;
+
+	dl->dp = dp;
+	dl->link_dp = link_dp;
+
+	INIT_LIST_HEAD(&dl->list);
+	list_add_tail(&dl->list, &dst->rtable);
+
+	return dl;
+}
+
 static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
@@ -129,6 +156,7 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 	struct device_node *dn = dp->dn;
 	struct of_phandle_iterator it;
 	struct dsa_port *link_dp;
+	struct dsa_link *dl;
 	int err;
 
 	of_for_each_phandle(&it, err, dn, "link", NULL, 0) {
@@ -138,7 +166,11 @@ static bool dsa_port_setup_routing_table(struct dsa_port *dp)
 			return false;
 		}
 
-		ds->rtable[link_dp->ds->index] = dp->index;
+		dl = dsa_link_touch(dp, link_dp);
+		if (!dl) {
+			of_node_put(it.node);
+			return false;
+		}
 	}
 
 	return true;
@@ -544,6 +576,8 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 
 static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 {
+	struct dsa_link *dl, *next;
+
 	if (!dst->setup)
 		return;
 
@@ -553,6 +587,11 @@ static void dsa_tree_teardown(struct dsa_switch_tree *dst)
 
 	dsa_tree_teardown_default_cpu(dst);
 
+	list_for_each_entry_safe(dl, next, &dst->rtable, list) {
+		list_del(&dl->list);
+		kfree(dl);
+	}
+
 	pr_info("DSA: tree %d torn down\n", dst->index);
 
 	dst->setup = false;
-- 
2.23.0

