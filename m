Return-Path: <netdev+bounces-8301-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C447238CF
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAF9C1C20E40
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0C7F6124;
	Tue,  6 Jun 2023 07:20:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16446112
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:30 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580BC1702
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036009; x=1717572009;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=lihZEA8md6Ln0rRdNt1bbPU1NnyU/TsRvNIoNfvDfGM=;
  b=VyRav/OuS1zMF5n5g1BMTLw1F84D7xiD5LGUsC1rbbnj0uGVn73bMszR
   cATTUSi1qlgc1DbcvyHCG2niaLXgsPpNd4GZTwxFHZ5Tmgx10ZbnBWhMX
   TSLFucf85f7BqznxhWNTf9xZyEWtpwp5x3Y5tQrh+PefIfz946tP28myf
   0maOsPPLsHnybltO0TnbRjfasWP96GG/2AgAskU4m3Q1lsGHevjOQG1bw
   Oe2N90FAYshPHnvuj1xjVjWCN5HOxlic5kgyHeq+ikyDkSWF8/2bEsxbp
   6/Wm4j3sbzpSPQzHzD8+yFOXxt+/51r8n8gIAoW3WLGm+m+3aHLF/Qbvy
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="216378678"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:08 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:06 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:36 +0200
Subject: [PATCH iproute2-next v3 01/12] dcb: app: add new dcbnl attribute
 field
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-1-60a766f72e61@microchip.com>
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
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

Add a new field 'attr' to the dcb_app_table struct, in order to inject
different dcbnl get/set attributes for APP and rewrite.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index eeb78e70f63f..8073415ad084 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -71,6 +71,7 @@ static void dcb_app_help(void)
 struct dcb_app_table {
 	struct dcb_app *apps;
 	size_t n_apps;
+	int attr;
 };
 
 enum ieee_attrs_app dcb_app_attr_type_get(__u8 selector)
@@ -583,7 +584,7 @@ static int dcb_app_get(struct dcb *dcb, const char *dev, struct dcb_app_table *t
 	void *payload;
 	int ret;
 
-	ret = dcb_get_attribute_va(dcb, dev, DCB_ATTR_IEEE_APP_TABLE, &payload, &payload_len);
+	ret = dcb_get_attribute_va(dcb, dev, tab->attr, &payload, &payload_len);
 	if (ret != 0)
 		return ret;
 
@@ -606,7 +607,7 @@ static int dcb_app_add_del_cb(struct dcb *dcb, struct nlmsghdr *nlh, void *data)
 	struct nlattr *nest;
 	size_t i;
 
-	nest = mnl_attr_nest_start(nlh, DCB_ATTR_IEEE_APP_TABLE);
+	nest = mnl_attr_nest_start(nlh, add_del->tab->attr);
 
 	for (i = 0; i < add_del->tab->n_apps; i++) {
 		const struct dcb_app *app = &add_del->tab->apps[i];
@@ -715,7 +716,7 @@ static int dcb_cmd_app_parse_add_del(struct dcb *dcb, const char *dev,
 
 static int dcb_cmd_app_add(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
@@ -729,7 +730,7 @@ static int dcb_cmd_app_add(struct dcb *dcb, const char *dev, int argc, char **ar
 
 static int dcb_cmd_app_del(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_cmd_app_parse_add_del(dcb, dev, argc, argv, &tab);
@@ -743,7 +744,7 @@ static int dcb_cmd_app_del(struct dcb *dcb, const char *dev, int argc, char **ar
 
 static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_app_get(dcb, dev, &tab);
@@ -795,7 +796,7 @@ out:
 
 static int dcb_cmd_app_flush(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table tab = {};
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_app_get(dcb, dev, &tab);
@@ -848,9 +849,9 @@ out:
 
 static int dcb_cmd_app_replace(struct dcb *dcb, const char *dev, int argc, char **argv)
 {
-	struct dcb_app_table orig = {};
-	struct dcb_app_table tab = {};
-	struct dcb_app_table new = {};
+	struct dcb_app_table orig = { .attr = DCB_ATTR_IEEE_APP_TABLE };
+	struct dcb_app_table tab = { .attr = DCB_ATTR_IEEE_APP_TABLE };
+	struct dcb_app_table new = { .attr = DCB_ATTR_IEEE_APP_TABLE };
 	int ret;
 
 	ret = dcb_app_get(dcb, dev, &orig);

-- 
2.34.1


