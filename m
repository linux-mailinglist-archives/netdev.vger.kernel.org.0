Return-Path: <netdev+bounces-5416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E0E3B711350
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BA3B2815E6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CF1E22626;
	Thu, 25 May 2023 18:11:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114E42261D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:11 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91FC1A6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038268; x=1716574268;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=pY1cAaxQTGK3OaSPybs5KAReghNK/3w3j7LcNLDonac=;
  b=KszM+XheJ2P1TpD+PCH5VGzYKBlmTm3pSHYvixgZqy5lMAWhy9oLiLrK
   By/Ii6wxpGIaZISps3NnquFHmyLqJLjRn09ejvoXLTA8tWeHatucaDJWe
   doPrz20z+D92PttyL4ZzO61fluW/I+70z/eFx1roHJkxFdHS1+fpb6nAX
   CmqZquGzRSikoTNM6iDxGVIGvooOTDsQ1qp3ToBkQ4eY5uMZ9TLTPYNfn
   +NSkeunsBVMulU5f6qlOw/0GMxj0iOuKs4CH9vjDMo8ZKbAk8ESbJYzer
   khq94GG1k2wDANl9610cSjMkU3xaRR5OUSEgkie8gvxWMfIutzmYfRLVd
   g==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="227025983"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:06 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:04 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:24 +0200
Subject: [PATCH iproute2-next v2 4/8] dcb: app: modify
 dcb_app_parse_mapping_cb for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-4-9f38e688117e@microchip.com>
References: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v2-0-9f38e688117e@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When parsing APP table entries, priority and protocol is assigned from
value and key, respectively. Rewrite requires it opposite.

Adapt the existing dcb_app_parse_mapping_cb for this, by using callbacks
for pushing app or rewr entries to the table.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb.h     | 12 ++++++++++++
 dcb/dcb_app.c | 23 ++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/dcb/dcb.h b/dcb/dcb.h
index 84ce95d5c1b2..b3bc30cd02c5 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -62,7 +62,16 @@ struct dcb_app_table {
 	int attr;
 };
 
+struct dcb_app_parse_mapping {
+	__u8 selector;
+	struct dcb_app_table *tab;
+	int (*push)(struct dcb_app_table *tab,
+		    __u8 selector, __u32 key, __u64 value);
+	int err;
+};
+
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
+
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
 bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
 bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
@@ -70,11 +79,14 @@ bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
 bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
 bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
 
+int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app);
 void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 				   const struct dcb_app_table *b,
 				   bool (*key_eq)(const struct dcb_app *aa,
 						  const struct dcb_app *ab));
 
+void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data);
+
 /* dcb_apptrust.c */
 
 int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 4cd175a0623b..97cba658aa6b 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -105,7 +105,7 @@ static void dcb_app_table_fini(struct dcb_app_table *tab)
 	free(tab->apps);
 }
 
-static int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
+int dcb_app_table_push(struct dcb_app_table *tab, struct dcb_app *app)
 {
 	struct dcb_app *apps = realloc(tab->apps, (tab->n_apps + 1) * sizeof(*tab->apps));
 
@@ -231,25 +231,25 @@ static void dcb_app_table_sort(struct dcb_app_table *tab)
 	qsort(tab->apps, tab->n_apps, sizeof(*tab->apps), dcb_app_cmp_cb);
 }
 
-struct dcb_app_parse_mapping {
-	__u8 selector;
-	struct dcb_app_table *tab;
-	int err;
-};
-
-static void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
+static int dcb_app_push(struct dcb_app_table *tab,
+			__u8 selector, __u32 key, __u64 value)
 {
-	struct dcb_app_parse_mapping *pm = data;
 	struct dcb_app app = {
-		.selector = pm->selector,
+		.selector = selector,
 		.priority = value,
 		.protocol = key,
 	};
+	return dcb_app_table_push(tab, &app);
+}
+
+void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
+{
+	struct dcb_app_parse_mapping *pm = data;
 
 	if (pm->err)
 		return;
 
-	pm->err = dcb_app_table_push(pm->tab, &app);
+	pm->err = pm->push(pm->tab, pm->selector, key, value);
 }
 
 static int dcb_app_parse_mapping_ethtype_prio(__u32 key, char *value, void *data)
@@ -663,6 +663,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
 {
 	struct dcb_app_parse_mapping pm = {
 		.tab = tab,
+		.push = dcb_app_push,
 	};
 	int ret;
 

-- 
2.34.1


