Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D5DF729
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 22:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbfJUUxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 16:53:00 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40133 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730383AbfJUUvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 16:51:40 -0400
Received: by mail-qk1-f193.google.com with SMTP id y81so10251799qkb.7;
        Mon, 21 Oct 2019 13:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqgsFlrNKqExdggLkADsTZXOcKKODUTxvxGTYxobfK0=;
        b=ufFCTskxImKTtNSFmXwBTnh8Wvwq4S5v0UHWaJec1kYgteEBH+FqJRa6gvrvcam4Jc
         wZcnfe6B9JuOUe/FfhpNlNzPyIQr9FHlGSz6aHUEavlx82hWPaF2DIN8vw3BNWhla+fY
         seP1Ofija8Y5FaK2akJ2LYA+ks1IxHMCX6AUFg7vIPBJ7qVohdznFd0wxJtMF5qrgmBr
         8r2vIAyZO5vR2sEyFGy3YHaAJlgBJ5G1q7tx7VYQRdZgEFKE9jq2xa6X5to0/+V6CgjJ
         NTxsYmAHOvzQpmPfF9b5D8VQjx2ViZsEXlTjJtsJQc+dgtsJQKDfJiBVyJSrStDrcBjg
         T1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqgsFlrNKqExdggLkADsTZXOcKKODUTxvxGTYxobfK0=;
        b=KjSb4+OLyZxgRldxmeHgBzGCLsnCmIT9eol0X6jr6U2j3EGvzcWg65Gw62ERenptV+
         xjE5YCorVbGaRcNgyBwnYiyzPY7bC3jmBe2Sjw4xtpn1E166FsyckKKIf6i+4JkW/hn2
         Zf9rUBajJ4+0bF1oqimuVvW9IDiqAsGBUbWLieIriqH8DbUoXw/LlUCJMh3Qdz3brGwr
         jnM/7t6hCiwZ+twB/bgnWJLD/DHi0boIhA5/ekh2AgVWAfl1LipjFB0ppmTOUVmVxeJY
         6sRcSFdrGFQZcVCZUN/fd4H1KCUnRzkf3vBCsbmbnoCalHdrfFcaCcOC/ZVZzn4MiX97
         NH/w==
X-Gm-Message-State: APjAAAU5fXAuJKZI2wlPAE6xesBRPs9q6REXCYeubxkdIWBYdHHAEbp1
        +5DLDe1Hxu+1LNsbqgxP0i0=
X-Google-Smtp-Source: APXvYqxj3tM78Wn4NSi1KnRpblo3W12er4Vr5wooDXAwq83hOwtkoHW1QFKZIdVcKlSrBmC5T2ClOQ==
X-Received: by 2002:a37:67d4:: with SMTP id b203mr24898207qkc.435.1571691098636;
        Mon, 21 Oct 2019 13:51:38 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id l129sm9831589qkd.84.2019.10.21.13.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 13:51:38 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 02/16] net: dsa: add ports list in the switch fabric
Date:   Mon, 21 Oct 2019 16:51:16 -0400
Message-Id: <20191021205130.304149-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191021205130.304149-1-vivien.didelot@gmail.com>
References: <20191021205130.304149-1-vivien.didelot@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
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
index 1716535167ee..ba27ff8b4445 100644
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
+	list_add_tail(&dp->list, &dst->ports);
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

