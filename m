Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD635DDC14
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 05:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfJTDVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 23:21:08 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35470 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbfJTDUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 23:20:22 -0400
Received: by mail-qk1-f195.google.com with SMTP id w2so9092209qkf.2;
        Sat, 19 Oct 2019 20:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CflRWxTTSuHHI9dat0IWG+C1/a3J48CuHdxeuay/vjU=;
        b=S1o27lKspW+W28Wh1Dk4eg+u5fpO0kJw/lmlxD9iz/27oNPT44UHK5MJpUNsU1f91h
         8vmXYBeij1G8gI2xj0V5MSPW0q+YEyDCldvEHxoKjNU8e89BmssweJ4jRhrDQEsUDzAo
         K2j2AgHfhsD7x46iMli/a63gDYS6P6vxRqTo0b++sq4i/Y1ufkl06QBm4kkxKjU96rpV
         pjdbD9pTAH/+9uMvHYX81mGV1/4HY6rJwE2vug3kEjIa8cd4ODcuyt84WxfLYeEEfpy4
         kopaIY2eo+qbkcSZQqAQ5d3k1xTdX6fisDQ9Jcc5LKnC7Bxv4f46aqAEeS9HgmT7fN7J
         GRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CflRWxTTSuHHI9dat0IWG+C1/a3J48CuHdxeuay/vjU=;
        b=URr6cU01xtoj+vZ8gBU9Z+lxiplpAle/O0ebgL0xrVOrYRNmyWcphZ2ofjrPYlbjd4
         rZIS8XN8MHIQ50hkc5CUQC7kI65BsmA0GcrBBROZON5P6htn2XxBwagWUlsvmbu/iVVD
         Dw8kO73VHBUBdXTe9bGZ9Hk2OZhpQ4Nwy7P8Q0XZMa0DYjBCPN3fo6chNXVfNnc0YiRP
         agoan1WgCTW5JsbiXCjgV85FWf2ueCCGhGw4bpvGMtZasALWMMv2BEZ7RzPtMJp5peYe
         GDjytD1gZ6+9abdeJlRAYkAi+HV/ZNqOLEniLq9UUwB5gHvq1sEdAEpgqungQNi2bm4o
         TEeg==
X-Gm-Message-State: APjAAAXDFW/Zzs/xhQXVEwmO/tgqTG8mTghvzSzavFmuJGvnU881Z2tY
        enSBT6CYlBWBBHn0HGIvdaQ=
X-Google-Smtp-Source: APXvYqyCk6NnL1as17Ndsa6bK+QwAdfufgVpAjQhblRl1nBI5EwTEDN652FFbJwhxT7pl51qf5i0Ww==
X-Received: by 2002:a37:4c42:: with SMTP id z63mr15291733qka.79.1571541621148;
        Sat, 19 Oct 2019 20:20:21 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u43sm6057529qte.19.2019.10.19.20.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 20:20:20 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: [PATCH net-next 10/16] net: dsa: use ports list to setup default CPU port
Date:   Sat, 19 Oct 2019 23:19:35 -0400
Message-Id: <20191020031941.3805884-11-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191020031941.3805884-1-vivien.didelot@gmail.com>
References: <20191020031941.3805884-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ports list instead of iterating over switches and their
ports when setting up the default CPU port. Unassign it on teardown.

Now that we can iterate over multiple CPU ports, remove dst->cpu_dp.

At the same time, provide a better error message for CPU-less tree.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h |  5 -----
 net/dsa/dsa2.c    | 33 ++++++++++++---------------------
 2 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index b199a8ca6393..020f5db8666b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -120,11 +120,6 @@ struct dsa_switch_tree {
 	 */
 	struct dsa_platform_data	*pd;
 
-	/*
-	 * The switch port to which the CPU is attached.
-	 */
-	struct dsa_port		*cpu_dp;
-
 	/* List of switch ports */
 	struct list_head ports;
 
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 99f5dab06787..772deacc33d3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -197,38 +197,29 @@ static struct dsa_port *dsa_tree_find_first_cpu(struct dsa_switch_tree *dst)
 
 static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 {
-	struct dsa_switch *ds;
-	struct dsa_port *dp;
-	int device, port;
+	struct dsa_port *cpu_dp, *dp;
 
-	/* DSA currently only supports a single CPU port */
-	dst->cpu_dp = dsa_tree_find_first_cpu(dst);
-	if (!dst->cpu_dp) {
-		pr_warn("Tree has no master device\n");
+	cpu_dp = dsa_tree_find_first_cpu(dst);
+	if (!cpu_dp) {
+		pr_err("DSA: tree %d has no CPU port\n", dst->index);
 		return -EINVAL;
 	}
 
 	/* Assign the default CPU port to all ports of the fabric */
-	for (device = 0; device < DSA_MAX_SWITCHES; device++) {
-		ds = dst->ds[device];
-		if (!ds)
-			continue;
-
-		for (port = 0; port < ds->num_ports; port++) {
-			dp = &ds->ports[port];
-
-			if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
-				dp->cpu_dp = dst->cpu_dp;
-		}
-	}
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
+			dp->cpu_dp = cpu_dp;
 
 	return 0;
 }
 
 static void dsa_tree_teardown_default_cpu(struct dsa_switch_tree *dst)
 {
-	/* DSA currently only supports a single CPU port */
-	dst->cpu_dp = NULL;
+	struct dsa_port *dp;
+
+	list_for_each_entry(dp, &dst->ports, list)
+		if (dsa_port_is_user(dp) || dsa_port_is_dsa(dp))
+			dp->cpu_dp = NULL;
 }
 
 static int dsa_port_setup(struct dsa_port *dp)
-- 
2.23.0

