Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE12B2947
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 03:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404084AbfINBUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 21:20:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42977 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390908AbfINBUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 21:20:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id q14so33648575wrm.9
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 18:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=02DMcXJmXP3SoUfsmRBoOGEWZ0Cp7Sl9T7/iy0vFDGY=;
        b=AqZmSDGdXZTHo6ZkTEXjxINVREP7TzxpSrv7TlkOfW7ustRVuRP7a6fJNtVffPX/wA
         Ie/OcdbVjs3faNQaSRpZ8nvFBaxcOxbZu1AqS3isvptV2jvOTMlhA/53ZOGYyXmKROdJ
         K79haJyj5uSfb89KhRwy2E0SAhpG0il4tu628T2AMdP5exmVDIjQTAJamr6yE09MtAag
         Tei2EQUE37v+b35YL1UVYv2CmhKNZ66ZTMKgXNyq+8b2Ctkp/LW5NJO00dVwzWJ1gaO0
         uTZrcj1eg3uuNGolcx4TErMc3i56foqeL090dTi7fb1ORfuAnCLq5wh9d5PaTUZp+rUd
         BOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=02DMcXJmXP3SoUfsmRBoOGEWZ0Cp7Sl9T7/iy0vFDGY=;
        b=MsrcINX47O1iAoBhBKUFK7BirM0oMVmJC5LYEjyJS4tL4h0jttGYyqmHIwtyKgE/Rd
         ZJsjKpzLebthVSP45iy/1BSGRBspxndfvJLU9VV4J9cw9DZtTL9spgMS44500bbXE7PE
         8heG9fsfST17oIH92qab9NFGCqIiEtmFeWHeYfICFaJUo/WeyitEjLnWTwSTH6A6VUn/
         O9+M3/4Kfcc4+arqRoOkSWuu6JymXcYKKPYsgF/t2MDdjIpl2E2iSHj2bNm04fcv2hxO
         koS3sLYfBV6WIi8hgZugW6F2d0CnE4JXqODp1hg2AWDm5l09HXsnW3MPfV9k1RBz8uxX
         TlFA==
X-Gm-Message-State: APjAAAXnkmLCsu8xU26bODZswlLsAW121o3V3WGuvxU0cmG8yJh+vCnb
        KZfRC2KpY29aXfjJTFCEzfk=
X-Google-Smtp-Source: APXvYqwXEj4abHyzjPlZEUNuaaLxeGk8L/0Jf17OxeKG+x1cHJn6KmiMlKhXSgyKtdLeUSuwk2NOKQ==
X-Received: by 2002:adf:ec48:: with SMTP id w8mr7107867wrn.198.1568424050382;
        Fri, 13 Sep 2019 18:20:50 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id o14sm21857979wrw.11.2019.09.13.18.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 18:20:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 2/7] net: dsa: Pass ndo_setup_tc slave callback to drivers
Date:   Sat, 14 Sep 2019 04:17:57 +0300
Message-Id: <20190914011802.1602-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190914011802.1602-1-olteanv@gmail.com>
References: <20190914011802.1602-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA currently handles shared block filters (for the classifier-action
qdisc) in the core due to what I believe are simply pragmatic reasons -
hiding the complexity from drivers and offerring a simple API for port
mirroring.

Extend the dsa_slave_setup_tc function by passing all other qdisc
offloads to the driver layer, where the driver may choose what it
implements and how. DSA is simply a pass-through in this case.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
---
Changes since v1:
- Added Kurt Kanzenbach's Acked-by.

Changes since RFC:
- Removed the unused declaration of struct tc_taprio_qopt_offload.

 include/net/dsa.h |  2 ++
 net/dsa/slave.c   | 12 ++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 96acb14ec1a8..541fb514e31d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -515,6 +515,8 @@ struct dsa_switch_ops {
 				   bool ingress);
 	void	(*port_mirror_del)(struct dsa_switch *ds, int port,
 				   struct dsa_mall_mirror_tc_entry *mirror);
+	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data);
 
 	/*
 	 * Cross-chip operations
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9a88035517a6..75d58229a4bd 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1035,12 +1035,16 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 static int dsa_slave_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
-	switch (type) {
-	case TC_SETUP_BLOCK:
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
+
+	if (type == TC_SETUP_BLOCK)
 		return dsa_slave_setup_tc_block(dev, type_data);
-	default:
+
+	if (!ds->ops->port_setup_tc)
 		return -EOPNOTSUPP;
-	}
+
+	return ds->ops->port_setup_tc(ds, dp->index, type, type_data);
 }
 
 static void dsa_slave_get_stats64(struct net_device *dev,
-- 
2.17.1

