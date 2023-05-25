Return-Path: <netdev+bounces-5415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0E8771134A
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:12:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB6BA2815F1
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C557020985;
	Thu, 25 May 2023 18:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B916622608
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:10 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002911A2
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038267; x=1716574267;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=TwS+SgQnLkUmPQUlmnMvKsHqzy6kjPsgI99KvblQszk=;
  b=pVAUrnsalFRZMcCB/iijYYDlB14URvDZe96FV8y+TChcH4Ep78LBo0Ly
   d6XhxMnV7oF2IqOQD4E9JuSW5J7b+fd8ynX1USsrFSlfQQsLbWWVbvkIy
   Zj4g/BZ7CEaTzxdtJvehhvmFo8mbL3oU7fLXSRSb7p9WJ0IrlyCLoKkiR
   pxgg+c06WjlYpKpewr+ZCfsKpsx+fQQuf8XHOMQKIDqKLuXZ/L91Wc/vQ
   MwRAVdXZ7axh8UAOSLacVX6334R4mClE3FlHjFbNUhm48eUa17+GsmmHX
   jrg3NClMYd7kRRbJ6TASr5Vgi3dkFtXhOL08BVvLbos+k02JHhwBzdtwP
   A==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="227025978"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:04 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:03 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:23 +0200
Subject: [PATCH iproute2-next v2 3/8] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-3-9f38e688117e@microchip.com>
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

When doing a replace command, entries are checked against selector and
protocol. Rewrite requires the check to be against selector and
priority.

Adapt the existing dcb_app_table_remove_replace function for this, by
using callback functions for selector, pid and prio checks.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb.h     | 14 ++++++++++++++
 dcb/dcb_app.c | 32 ++++++++++++++++++++------------
 2 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/dcb/dcb.h b/dcb/dcb.h
index d40664f29dad..84ce95d5c1b2 100644
--- a/dcb/dcb.h
+++ b/dcb/dcb.h
@@ -56,11 +56,25 @@ void dcb_print_array_kw(const __u8 *array, size_t array_size,
 
 /* dcb_app.c */
 
+struct dcb_app_table {
+	struct dcb_app *apps;
+	size_t n_apps;
+	int attr;
+};
+
 int dcb_cmd_app(struct dcb *dcb, int argc, char **argv);
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector);
 bool dcb_app_attr_type_validate(enum ieee_attrs_app type);
 bool dcb_app_selector_validate(enum ieee_attrs_app type, __u8 selector);
 
+bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab);
+bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab);
+
+void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+				   const struct dcb_app_table *b,
+				   bool (*key_eq)(const struct dcb_app *aa,
+						  const struct dcb_app *ab));
+
 /* dcb_apptrust.c */
 
 int dcb_cmd_apptrust(struct dcb *dcb, int argc, char **argv);
diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 1e36541bec61..4cd175a0623b 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -68,12 +68,6 @@ static void dcb_app_help(void)
 	dcb_app_help_add();
 }
 
-struct dcb_app_table {
-	struct dcb_app *apps;
-	size_t n_apps;
-	int attr;
-};
-
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
 {
 	switch (selector) {
@@ -153,8 +147,22 @@ static void dcb_app_table_remove_existing(struct dcb_app_table *a,
 	a->n_apps = ja;
 }
 
-static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
-					  const struct dcb_app_table *b)
+bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab)
+{
+	return aa->selector == ab->selector &&
+	       aa->protocol == ab->protocol;
+}
+
+bool dcb_app_prio_eq(const struct dcb_app *aa, const struct dcb_app *ab)
+{
+	return aa->selector == ab->selector &&
+	       aa->priority == ab->priority;
+}
+
+void dcb_app_table_remove_replaced(struct dcb_app_table *a,
+				   const struct dcb_app_table *b,
+				   bool (*key_eq)(const struct dcb_app *aa,
+						  const struct dcb_app *ab))
 {
 	size_t ia, ja;
 	size_t ib;
@@ -167,13 +175,13 @@ static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 		for (ib = 0; ib < b->n_apps; ib++) {
 			const struct dcb_app *ab = &b->apps[ib];
 
-			if (aa->selector == ab->selector &&
-			    aa->protocol == ab->protocol)
+			if (key_eq(aa, ab))
 				present = true;
 			else
 				continue;
 
-			if (aa->priority == ab->priority) {
+			if (aa->protocol == ab->protocol &&
+			    aa->priority == ab->priority) {
 				found = true;
 				break;
 			}
@@ -891,7 +899,7 @@ static int dcb_cmd_app_replace(struct dcb *dcb, const char *dev, int argc, char
 	}
 
 	/* Remove the obsolete entries. */
-	dcb_app_table_remove_replaced(&orig, &tab);
+	dcb_app_table_remove_replaced(&orig, &tab, dcb_app_pid_eq);
 	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
 	if (ret != 0) {
 		fprintf(stderr, "Could not remove replaced APP entries\n");

-- 
2.34.1


