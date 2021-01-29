Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9699D3082D0
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbhA2BB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:01:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhA2BBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:15 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A47EC0613D6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:34 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g3so10567677ejb.6
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3quznWQEHRQM8uriLwEaRKejMBTOKP101eDoYnUe1aE=;
        b=qAh0BdCye9sDsj7AI2j0sEqVSeTip/z4AQrBiDEUPWjXCJeLoZPhEBF3gUvXfcs3Tb
         quGPe/+SEKjBuvws9+xZ43/TRCIgrL6DCjjo39eNw2njp7jEHZQayZyWt1ujA1MrsICH
         P0sVc8qC8c6reXGtc4dBXNCnfDLJZ2IjPfL0ATSJCmXC3Ytb/24flWkOzEDil3/dvYFU
         eFVGVLQ/sjdl7AHyXs4M5RsYkp2poVtxK11JxxlVpkEeOr30wRMGEcapXdK4Zj4mJr9A
         1n7vALsh17s6rnJ4liNdrf/1K670353zJh/OIk1PhfM77b6p2gk33Cwsi3GkrEK/Qyu8
         etkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3quznWQEHRQM8uriLwEaRKejMBTOKP101eDoYnUe1aE=;
        b=q2FWuQ/YYR9cKzelNnddZnxey6C1+B9na9eP3EY8hV2LkNnhsHXeWgqJVIO0qM6MU9
         ph9mWCKMMRGXCVPowyaDBnUfZWMhaKIgS4oLxg7/+iKv2Qlo81R9yvRDK7+v5xZr39nW
         fmr0mnWWI3LTMjVomyNff7a2w9BdcetvjmmvE0f7Abwt8A90jytsDedGpvpOOj9FJfE7
         IEAqTJnkWwJ0yrfwZZrErKFdlG7mFfNx3+KRTCvoqrhq6WXkRzBAxIG8rOx03iNe7BbS
         afGlFet0rT8ozN16C4H51LRy93dp8Od8aARbFOWJGFp4AIbiW4WuoCse0tiLPtgzHfmG
         fgpQ==
X-Gm-Message-State: AOAM5315x30GPzGRryG7Tm3OIy24HEX3pYLXgkCEz/LMNBmv9YOFHjRH
        t+8A0i1eEllx9GGTPzPzkVc=
X-Google-Smtp-Source: ABdhPJyzOXjP8+UtE0dBCNS7rAc7uJvzqtni3e2qbFwmxUUGwi65IjNHHMeNJ0zZxh2fgkfa+QwVLQ==
X-Received: by 2002:a17:907:2138:: with SMTP id qo24mr2118846ejb.425.1611882033266;
        Thu, 28 Jan 2021 17:00:33 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:32 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v8 net-next 03/11] net: mscc: ocelot: store a namespaced VCAP filter ID
Date:   Fri, 29 Jan 2021 03:00:01 +0200
Message-Id: <20210129010009.3959398-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
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
Changes in v8:
None.

Changes in v7:
None.

Changes in v6:
None.

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

