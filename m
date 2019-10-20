Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D70DDC1C
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfJTDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:20:12 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33362 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbfJTDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:11 -0400
Received: by mail-qt1-f194.google.com with SMTP id r5so15318943qtd.0;
        Sat, 19 Oct 2019 20:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mLh2s3gJ1w56tVuUDIAWtO5cV52zmuk8dwt4nrNGvLs=;
        b=XKy8QYVI+civRs3nMUu80bw5ez+TW79n2WvUyAWgI5R5DsjfuwL5tr4qlrVLMr3gsX
         GLuRRW65HUq/Vtrib2Is0bYDuv/m/dKttVAJwCxLrQ28A1sV+65gaozVy0L+GAKtU/Vs
         Yig31vQmcHpC+b+DbLapTQ6+wR1oKxhuEjg77immCua47rfIDq/apbQrai4XdnBXfZf4
         ObsBvTxEiZqjD7NtxMgA1TS46Xyg0aH7aVfrScSJ3KCsoger+TmtxgaV/b7FI8LssjEy
         F+8WY756un7WelFeSAhIAvM+YWYkohvDmkT11cqvCRco7iC28pRfncHVv1mYQXVuxLtr
         +WnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mLh2s3gJ1w56tVuUDIAWtO5cV52zmuk8dwt4nrNGvLs=;
        b=qh6vZimGsX6XC/ddoDpB/faiq7XBSLDCaRrGFcedcswEMQnnZ1BC6r4d+B4yXqERE4
         RGM8oY7/uYOkuT/siV8znhuk1ZNOPR2WkUOcOhZrI+tI5RBqlba17L0L8po0QIioyMBi
         oivPyQvHy9wHZ7cb5XZpd9ObkEit49RE2eNUprvIudcqsdYQDIh4P91Nck8trQuEhney
         ggmt6U3gS2rlnum+Rw5LyjZ54eA8DFlsHJD2CV0Vyrlbv3ADC2741NRRUVeTmOLgkgjs
         J3+uyN1yfAXeRpPCx3fSsjoSwAMyA7n3T0P8+y2cWnbe0vH9Z3RHU9GktWB43xTtm0gi
         Eiqw==
X-Gm-Message-State: APjAAAWyl6d+ckLkVGf4b/koQ2UraayGe/B3TTtacyhzlVd3RdfLoM2p
        wLM3djsTa5QanK4qyxPAHL0=
X-Google-Smtp-Source: APXvYqzmrQ5I5TA49AseUPXl1AQVTpnH7GRmEiaQ4lg8MnyN4vgPpD3b4bfWugMxsxmEGLLKlRfAzg==
X-Received: by 2002:ac8:474c:: with SMTP id k12mr18489852qtp.319.1571541610128;
        Sat, 19 Oct 2019 20:20:10 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z200sm6883273qkb.5.2019.10.19.20.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:09 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 02/16] net: dsa: add ports list in the switch fabric
Date:   Sat, 19 Oct 2019 23:19:27 -0400
Message-Id: <20191020031941.3805884-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a list of switch ports within the switch fabric. This will help the
lookup of a port inside the whole fabric, and it is the first step
towards supporting multiple CPU ports, before deprecating the usage of
the unique dst->cpu_dp pointer.

In preparation for a future allocation of the dsa_port structures,
return -ENOMEM in case no structure is returned, even though this
error cannot be reached yet.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h |  5 +++++
 net/dsa/dsa2.c    | 48 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 47 insertions(+), 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 2e4fe2f8962b..6ff6dfcdc61d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -125,6 +125,9 @@ struct dsa_switch_tree {
 	 */
 	struct dsa_port		*cpu_dp;
 
+	/* List of switch ports */
+	struct list_head ports;
+
 	/*
 	 * Data for the individual switch chips.
 	 */
@@ -195,6 +198,8 @@ struct dsa_port {
 	struct work_struct	xmit_work;
 	struct sk_buff_head	xmit_queue;
 
+	struct list_head list;
+
 	/*
 	 * Give the switch driver somewhere to hang its per-port private data
 	 * structures (accessible from the tagger).
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 1716535167ee..b6536641ac99 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -45,6 +45,8 @@ static struct dsa_switch_tree *dsa_tree_alloc(int index)
 
 	dst->index = index;
 
+	INIT_LIST_HEAD(&dst->ports);
+
 	INIT_LIST_HEAD(&dst->list);
 	list_add_tail(&dst->list, &dsa_tree_list);
 
@@ -616,6 +618,22 @@ static int dsa_tree_add_switch(struct dsa_switch_tree *dst,
 	return err;
 }
 
+static struct dsa_port *dsa_port_touch(struct dsa_switch *ds, int index)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+	struct dsa_port *dp;
+
+	dp = &ds->ports[index];
+
+	dp->ds = ds;
+	dp->index = index;
+
+	INIT_LIST_HEAD(&dp->list);
+	list_add(&dp->list, &dst->ports);
+
+	return dp;
+}
+
 static int dsa_port_parse_user(struct dsa_port *dp, const char *name)
 {
 	if (!name)
@@ -742,6 +760,20 @@ static int dsa_switch_parse_member_of(struct dsa_switch *ds,
 	return 0;
 }
 
+static int dsa_switch_touch_ports(struct dsa_switch *ds)
+{
+	struct dsa_port *dp;
+	int port;
+
+	for (port = 0; port < ds->num_ports; port++) {
+		dp = dsa_port_touch(ds, port);
+		if (!dp)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 {
 	int err;
@@ -750,6 +782,10 @@ static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
 	if (err)
 		return err;
 
+	err = dsa_switch_touch_ports(ds);
+	if (err)
+		return err;
+
 	return dsa_switch_parse_ports_of(ds, dn);
 }
 
@@ -807,6 +843,8 @@ static int dsa_switch_parse_ports(struct dsa_switch *ds,
 
 static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 {
+	int err;
+
 	ds->cd = cd;
 
 	/* We don't support interconnected switches nor multiple trees via
@@ -817,6 +855,10 @@ static int dsa_switch_parse(struct dsa_switch *ds, struct dsa_chip_data *cd)
 	if (!ds->dst)
 		return -ENOMEM;
 
+	err = dsa_switch_touch_ports(ds);
+	if (err)
+		return err;
+
 	return dsa_switch_parse_ports(ds, cd);
 }
 
@@ -849,7 +891,6 @@ static int dsa_switch_probe(struct dsa_switch *ds)
 struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
 {
 	struct dsa_switch *ds;
-	int i;
 
 	ds = devm_kzalloc(dev, struct_size(ds, ports, n), GFP_KERNEL);
 	if (!ds)
@@ -858,11 +899,6 @@ struct dsa_switch *dsa_switch_alloc(struct device *dev, size_t n)
 	ds->dev = dev;
 	ds->num_ports = n;
 
-	for (i = 0; i < ds->num_ports; ++i) {
-		ds->ports[i].index = i;
-		ds->ports[i].ds = ds;
-	}
-
 	return ds;
 }
 EXPORT_SYMBOL_GPL(dsa_switch_alloc);
-- 
2.23.0

