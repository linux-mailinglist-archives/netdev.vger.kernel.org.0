Return-Path: <netdev+bounces-4399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EEC370C570
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:42:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B8B61C20BEC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B594171AE;
	Mon, 22 May 2023 18:41:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B92D171A9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:40 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E3B7
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780892; x=1716316892;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=3k1FqpTmY/asTbLgdAzN+mcuoZJ6n/wt6prPnRSDePk=;
  b=fwjRoZ6xfqi7Rzqmah/WXJKOuhlXY0D2jxC4VbdX2Kv0Fuclihmri7+5
   Tl7MKIlAPrX0qaPwRaii2VFT/MW+tIFOiujWJYyRGle2vj7dTKqaS5qG0
   txjd7HSbwKlG++T5ur2eGXJTEc7XzOwSOdSPgimtxarpOa3dEW1pnpomn
   i7kwznGGcm1QtIsbUCW8kxSytUAIm8QCLkCancjj1PIoLc9+C2tnRsIAA
   cou9urpooWTsjDLJ0zCjJb507Ji7Tt2NECpo1pG9WDVjOKJS2JK76a5gm
   xJdp7Jt/Tl1eNx/yDupVLBBpRpeHI9Jb6d/RYdGw6pWPmcd0Fug+HKFcO
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="216701921"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:30 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:29 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:06 +0200
Subject: [PATCH iproute2-next 3/9] dcb: app: modify dcb-app print functions
 for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-3-83adc1f93356@microchip.com>
References: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
In-Reply-To: <20230510-dcb-rewr-v1-0-83adc1f93356@microchip.com>
To: <netdev@vger.kernel.org>
CC: <dsahern@kernel.org>, <stephen@networkplumber.org>, <petrm@nvidia.com>,
	<UNGLinuxDriver@microchip.com>, <daniel.machon@microchip.com>
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Whereas dcb-app requires protocol to be the printed key, dcb-rewr
requires it to be the priority. Existing dcb-app print functions can
easily be adapted to support this, by using the newly introduced dcbnl
attribute in the dcb_app_table struct.

- dcb_app_print_key_*() functions have been renamed to
  dcb_app_print_pid_*() to align with new situation. Also, none of them
  will print the colon anymore.

- dcb_app_print_filtered() will now print either priority or protocol
  first, depending on the dcbnl set/get attribute.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 62 ++++++++++++++++++++++++++++++++---------------------------
 dcb/dcb_app.h | 10 +++++++---
 2 files changed, 41 insertions(+), 31 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 1d0da35f987d..9bb64f32e12e 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -389,40 +389,38 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
 }
 
-int dcb_app_print_key_dec(__u16 protocol)
+int dcb_app_print_pid_dec(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%d", protocol);
 }
 
-static int dcb_app_print_key_hex(__u16 protocol)
+static int dcb_app_print_pid_hex(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%x:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%x", protocol);
 }
 
-int dcb_app_print_key_dscp(__u16 protocol)
+int dcb_app_print_pid_dscp(__u16 protocol)
 {
 	const char *name = rtnl_dsfield_get_name(protocol << 2);
 
-
 	if (!is_json_context() && name != NULL)
-		return print_string(PRINT_FP, NULL, "%s:", name);
-	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+		return print_string(PRINT_FP, NULL, "%s", name);
+	return print_uint(PRINT_ANY, NULL, "%d", protocol);
 }
 
-int dcb_app_print_key_pcp(__u16 protocol)
+int dcb_app_print_pid_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
-		return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+		return print_uint(PRINT_ANY, NULL, "%d", protocol);
 
-	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
+	return print_string(PRINT_ANY, NULL, "%s", pcp_names[protocol]);
 }
 
-static void dcb_app_print_filtered(const struct dcb_app_table *tab,
-				   bool (*filter)(const struct dcb_app *),
-				   int (*print_key)(__u16 protocol),
-				   const char *json_name,
-				   const char *fp_name)
+void dcb_app_print_filtered(const struct dcb_app_table *tab,
+			    bool (*filter)(const struct dcb_app *),
+			    int (*print_pid)(__u16 protocol),
+			    const char *json_name, const char *fp_name)
 {
 	bool first = true;
 	size_t i;
@@ -439,8 +437,14 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 		}
 
 		open_json_array(PRINT_JSON, NULL);
-		print_key(app->protocol);
-		print_uint(PRINT_ANY, NULL, "%d ", app->priority);
+		if (tab->attr == DCB_ATTR_IEEE_APP_TABLE) {
+			print_pid(app->protocol);
+			print_uint(PRINT_ANY, NULL, ":%d", app->priority);
+		} else {
+			print_uint(PRINT_ANY, NULL, "%d:", app->priority);
+			print_pid(app->protocol);
+		}
+		print_string(PRINT_ANY, NULL, "%s", " ");
 		close_json_array(PRINT_JSON, NULL);
 	}
 
@@ -452,7 +456,7 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 
 static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_ethtype,  dcb_app_print_key_hex,
+	dcb_app_print_filtered(tab, dcb_app_is_ethtype, dcb_app_print_pid_hex,
 			       "ethtype_prio", "ethtype-prio");
 }
 
@@ -460,8 +464,8 @@ static void dcb_app_print_pcp_prio(const struct dcb *dcb,
 				   const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_pcp,
-			       dcb->numeric ? dcb_app_print_key_dec
-					    : dcb_app_print_key_pcp,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_pcp,
 			       "pcp_prio", "pcp-prio");
 }
 
@@ -469,26 +473,28 @@ static void dcb_app_print_dscp_prio(const struct dcb *dcb,
 				    const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_dscp,
-			       dcb->numeric ? dcb_app_print_key_dec
-					    : dcb_app_print_key_dscp,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_dscp,
 			       "dscp_prio", "dscp-prio");
 }
 
 static void dcb_app_print_stream_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_stream_port, dcb_app_print_key_dec,
-			       "stream_port_prio", "stream-port-prio");
+	dcb_app_print_filtered(tab, dcb_app_is_stream_port,
+			       dcb_app_print_pid_dec, "stream_port_prio",
+			       "stream-port-prio");
 }
 
 static void dcb_app_print_dgram_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_dgram_port, dcb_app_print_key_dec,
-			       "dgram_port_prio", "dgram-port-prio");
+	dcb_app_print_filtered(tab, dcb_app_is_dgram_port,
+			       dcb_app_print_pid_dec, "dgram_port_prio",
+			       "dgram-port-prio");
 }
 
 static void dcb_app_print_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_pid_dec,
 			       "port_prio", "port-prio");
 }
 
diff --git a/dcb/dcb_app.h b/dcb/dcb_app.h
index 3aea0bfd1786..8f048605c3a8 100644
--- a/dcb/dcb_app.h
+++ b/dcb/dcb_app.h
@@ -41,9 +41,13 @@ void dcb_app_table_remove_existing(struct dcb_app_table *a,
 bool dcb_app_is_pcp(const struct dcb_app *app);
 bool dcb_app_is_dscp(const struct dcb_app *app);
 
-int dcb_app_print_key_dec(__u16 protocol);
-int dcb_app_print_key_dscp(__u16 protocol);
-int dcb_app_print_key_pcp(__u16 protocol);
+int dcb_app_print_pid_dec(__u16 protocol);
+int dcb_app_print_pid_dscp(__u16 protocol);
+int dcb_app_print_pid_pcp(__u16 protocol);
+void dcb_app_print_filtered(const struct dcb_app_table *tab,
+			    bool (*filter)(const struct dcb_app *),
+			    int (*print_pid)(__u16 protocol),
+			    const char *json_name, const char *fp_name);
 
 int dcb_app_parse_pcp(__u32 *key, const char *arg);
 int dcb_app_parse_dscp(__u32 *key, const char *arg);

-- 
2.34.1


