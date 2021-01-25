Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F064302EA6
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbhAYWGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733155AbhAYWFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:05:09 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 132B0C061756
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:29 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f1so17361169edr.12
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qg/4up8Zvai8vksH4rAIXOtpatM8jVNOUkUD0I41kNQ=;
        b=SapSEvqQi0uIgaf6HOiwkYBeT1oQUgf9iFXwYawmLNLVjSibUUu5c5IdkPi8Q07YgF
         Gqj5VH9e+MmeCaWUfyWicgIYf0bcoan7IV1nEmNF/ABc3Ez8PHe84xFBLTaOjZZWRB9+
         wlhWkj8eqRwlJfMvsDghUi8iSjFMDIo/lWhRUhsU+TORra29Sc07WWEqRJ4TjFCNodmu
         XA6mX1NFq6x72x44a0l4GUJPwYU1E/5aooPoD4qCehmxN8HkGW+EJMpjZ9BmSzvupDcv
         h0pDRVwPrcwj0/ptoV/x9wQ0ETbOf6s09lVpDDyAyqzJmLcqL8F7NurZYL2KpcIQPuJE
         fT1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qg/4up8Zvai8vksH4rAIXOtpatM8jVNOUkUD0I41kNQ=;
        b=SVhraflzOa8R4cpUEYgDtdppaz1Hpi4OOa0LYaxgvJusfKYWETZT+8eHo3E6zwEFRk
         8hz2tECP7T/syIBRQAhfz9XpT74LmiJhcR8YpNssZMe9gs3xjcuDheci8XhrMAFXINgR
         NWVTnG9xFInDG2o3GkuBfNm17fveXLHcwwrGybQW9aOYFK6L+QAVbwlgM1vFGfTC43SJ
         NNc8UVizN9hJZpskkvN7C8ks1B1WJMsJccjJjkNkI+NSC2J+7afZvNmMflXuN3kCRorl
         iruQMY3WzvOA07k576giabgw4DYl9CNuzdYlf2n31kOwgX0PN3SE13KQI2EMwKSIHKd/
         Cc+A==
X-Gm-Message-State: AOAM532E6PhAnod4cGh64G0ZPR7x2kIV8U/ArFYHoMSFVXw/emAqPYkF
        2mnsjTzxsacrSgyck5vHQqU=
X-Google-Smtp-Source: ABdhPJwQui3PCKX/AfYm07tB3q3IZiCStM4LDhYCVBsv9OAOaKuskZmoFwpFPvJo4m+4muYbd4D/pA==
X-Received: by 2002:aa7:ca51:: with SMTP id j17mr2274339edt.124.1611612267842;
        Mon, 25 Jan 2021 14:04:27 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:27 -0800 (PST)
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
Subject: [PATCH v7 net-next 03/11] net: mscc: ocelot: store a namespaced VCAP filter ID
Date:   Tue, 26 Jan 2021 00:03:25 +0200
Message-Id: <20210125220333.1004365-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
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

