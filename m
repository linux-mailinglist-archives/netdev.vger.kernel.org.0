Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C9E2FDFC8
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 03:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393286AbhAUCwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 21:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436888AbhAUCoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:44:54 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD63EC0613CF
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:31 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id gx5so504692ejb.7
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aPBASNZ04bQ2xEMx8chx1NkbrJAZPY3DxbRH+9uILec=;
        b=K80awa37UKDmvjpXmtkp5G9f5Gz2D18Ro1tNqie29VBSAFDyutqpEk2OkPmrGuSFs+
         PHE6A5CCcobhxN6a8PcjqHgNrTz6lamzRheTKXUvDrW1mpX5slYwpwSWhQ5l5rU7QZy/
         9D8DjlYi39fhbm5NcS19LYRE72t/imEI6vWfKZyq153xncmte9mT10C8vuUtYJWq9WIK
         SxG8bEfXE3sZLhcc05ezB4ej+TGvjRnm20N+/KP8lel6ZCJ0nnZDJxEkAJo4Zazub+li
         7oQYRe0pZ1OVE7+oNNAN6zPJ2zLU/5go8z+pX3f7KpUgfp1bPBi9MFGmgUiwHnqPrbUY
         Sd7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aPBASNZ04bQ2xEMx8chx1NkbrJAZPY3DxbRH+9uILec=;
        b=Drcn9vPOo7T0GCe1LmLIRuVuH0WSlmPg191NrqRJrpGJ8WEIB+dNiF8K6I290tU7UZ
         ZqFFeIdINU1S0FtKA9A0W4nYvu9Bgf/euBBkOii9BBlkB9lVwc9xg6UpYAK9NHOhZEWT
         iyzQ9ILP86ie7oLlVLzRG8EGmkxfbkjkwNFFBIKfbNy/jmmMAiFSG/yhvc1c0YJzBdP+
         Ofcbl/20f/E4ARu9Y861rhDRvd7SNcshiZdSvXD2+4YHEyQCl8MhV4Fb/JmCLE2zT2Jn
         HtXMEyug2uVc9MI7Yy6nXOGAlkEZHWuNMR+YgvWjD078HDtnywcaMQOibPBLW9VRXUGm
         8E/w==
X-Gm-Message-State: AOAM530V9IiMUOMm4G2U4jYQzo1eiP7GxVuuVRh/oEJE0skyuz5m4WXg
        jgKmMVpfVRzMfw9ZmTQAINM=
X-Google-Smtp-Source: ABdhPJzPA8oJ35pIpy/5PwkNlk1pFpGnsvwHNZ/iR6XRy/Q1j/Ru9hL+X/HyXNNb1uf5F2ZWhpRwQw==
X-Received: by 2002:a17:907:c2a:: with SMTP id ga42mr7561686ejc.511.1611196590612;
        Wed, 20 Jan 2021 18:36:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k22sm2025787edv.33.2021.01.20.18.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 18:36:30 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 03/10] net: mscc: ocelot: store a namespaced VCAP filter ID
Date:   Thu, 21 Jan 2021 04:36:09 +0200
Message-Id: <20210121023616.1696021-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121023616.1696021-1-olteanv@gmail.com>
References: <20210121023616.1696021-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

We will be adding some private VCAP filters that should not interfere in
any way with the filters added using tc-flower. So we need to allocate
some IDs which will not be used by tc.

Currently ocelot uses an u32 id derived from the flow cookie, which in
itself is an unsigned long. This is a problem in itself, since on 64 bit
systems, sizeof(unsigned long)=8, so the driver is already truncating
these.

Create a struct ocelot_vcap_id which contains the full unsigned long
cookie from tc, as well as a boolean that is supposed to namespace the
filters added by tc with the ones that aren't.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_flower.c |  7 ++++---
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 16 ++++++++++++----
 drivers/net/ethernet/mscc/ocelot_vcap.h   |  3 ++-
 include/soc/mscc/ocelot_vcap.h            |  7 ++++++-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 729495a1a77e..c3ac026f6aea 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -622,7 +622,8 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	int ret;
 
 	filter->prio = f->common.prio;
-	filter->id = f->cookie;
+	filter->id.cookie = f->cookie;
+	filter->id.tc_offload = true;
 
 	ret = ocelot_flower_parse_action(ocelot, port, ingress, f, filter);
 	if (ret)
@@ -717,7 +718,7 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 
 	block = &ocelot->block[block_id];
 
-	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie, true);
 	if (!filter)
 		return 0;
 
@@ -741,7 +742,7 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 
 	block = &ocelot->block[block_id];
 
-	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie);
+	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie, true);
 	if (!filter || filter->type == OCELOT_VCAP_FILTER_DUMMY)
 		return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 489bf16362a7..b82fd4103a68 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -959,6 +959,12 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 	list_add(&filter->list, pos->prev);
 }
 
+static bool ocelot_vcap_filter_equal(const struct ocelot_vcap_filter *a,
+				     const struct ocelot_vcap_filter *b)
+{
+	return !memcmp(&a->id, &b->id, sizeof(struct ocelot_vcap_id));
+}
+
 static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 					      struct ocelot_vcap_filter *filter)
 {
@@ -966,7 +972,7 @@ static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
 	int index = 0;
 
 	list_for_each_entry(tmp, &block->rules, list) {
-		if (filter->id == tmp->id)
+		if (ocelot_vcap_filter_equal(filter, tmp))
 			return index;
 		index++;
 	}
@@ -991,12 +997,14 @@ ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
 }
 
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id)
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int cookie,
+				    bool tc_offload)
 {
 	struct ocelot_vcap_filter *filter;
 
 	list_for_each_entry(filter, &block->rules, list)
-		if (filter->id == id)
+		if (filter->id.tc_offload == tc_offload &&
+		    filter->id.cookie == cookie)
 			return filter;
 
 	return NULL;
@@ -1161,7 +1169,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_vcap_filter, list);
-		if (tmp->id == filter->id) {
+		if (ocelot_vcap_filter_equal(filter, tmp)) {
 			if (tmp->block_id == VCAP_IS2 &&
 			    tmp->action.police_ena)
 				ocelot_vcap_policer_del(ocelot, block,
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
index cfc8b976d1de..3b0c7916056e 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.h
@@ -15,7 +15,8 @@
 int ocelot_vcap_filter_stats_update(struct ocelot *ocelot,
 				    struct ocelot_vcap_filter *rule);
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id);
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
+				    bool tc_offload);
 
 void ocelot_detect_vcap_constants(struct ocelot *ocelot);
 int ocelot_vcap_init(struct ocelot *ocelot);
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 7f1b82fba63c..76e01c927e17 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -648,6 +648,11 @@ enum ocelot_vcap_filter_type {
 	OCELOT_VCAP_FILTER_OFFLOAD,
 };
 
+struct ocelot_vcap_id {
+	unsigned long cookie;
+	bool tc_offload;
+};
+
 struct ocelot_vcap_filter {
 	struct list_head list;
 
@@ -657,7 +662,7 @@ struct ocelot_vcap_filter {
 	int lookup;
 	u8 pag;
 	u16 prio;
-	u32 id;
+	struct ocelot_vcap_id id;
 
 	struct ocelot_vcap_action action;
 	struct ocelot_vcap_stats stats;
-- 
2.25.1

