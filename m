Return-Path: <netdev+bounces-5414-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4114711341
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:11:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A41971C20EF7
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:11:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DDB2108C;
	Thu, 25 May 2023 18:11:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E841221080
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:11:08 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC5D19C
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685038266; x=1716574266;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=lnAdOtE8rJJeWM0rv7uiFotMQI30BMt2qwsC5jOoSLM=;
  b=XuitoUajnU92kQixEPy+srPlR2N7UAsLPeJPbAHMUuAvHBvtxBl3p2Ve
   Ue7iEs1TAD15wZvmgYVUrckXMrWfXwKoJI4zjyQk1NyzuZhP+RaH3lyh3
   NJwMWHEwtFt6RQdrMkUW/dLuNU18WYVJYGZI/flE5tS+Cp83l36L4Yds3
   FLv1IK2r7stPsa5g9NK/YXa231F1qDsKoBAqAuL76zg5GuayWNoDjqVWv
   Sswe4mC95H9GL0RPik7z0uDRgyqjSf4mQheSrwgNW+AkMGhUUNevPqmfD
   dkpqTSIiGdMgCAGV33oLgSt5gMaJ3Mo0J/YI7Q4tK4w5o4+NP13eiVJ78
   g==;
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="227025976"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 May 2023 11:11:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 25 May 2023 11:11:02 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 25 May 2023 11:11:01 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Thu, 25 May 2023 20:10:22 +0200
Subject: [PATCH iproute2-next v2 2/8] dcb: app: modify dcb-app print
 functions for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v2-2-9f38e688117e@microchip.com>
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

Where dcb-app requires protocol to be the printed key, dcb-rewr requires
it to be the priority. Adapt existing dcb-app print functions for this.

dcb_app_print_filtered() has been modified, to take two callbacks; one
for printing the entire string (pid and prio), and one for the pid type
(dec, hex, dscp, pcp). This saves us for making one dedicated function
for each pid type for both app and rewr.

dcb_app_print_key_*() functions have been renamed to
dcb_app_print_pid_*() to align with new situation. Also, none of them
will print the colon anymore.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 58 ++++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 8073415ad084..1e36541bec61 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -403,38 +403,39 @@ static bool dcb_app_is_port(const struct dcb_app *app)
 	return app->selector == IEEE_8021QAZ_APP_SEL_ANY;
 }
 
-static int dcb_app_print_key_dec(__u16 protocol)
+static int dcb_app_print_pid_dec(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
-static int dcb_app_print_key_hex(__u16 protocol)
+static int dcb_app_print_pid_hex(__u16 protocol)
 {
-	return print_uint(PRINT_ANY, NULL, "%x:", protocol);
+	return print_uint(PRINT_ANY, NULL, "%x", protocol);
 }
 
-static int dcb_app_print_key_dscp(__u16 protocol)
+static int dcb_app_print_pid_dscp(__u16 protocol)
 {
 	const char *name = rtnl_dsfield_get_name(protocol << 2);
 
-
 	if (!is_json_context() && name != NULL)
-		return print_string(PRINT_FP, NULL, "%s:", name);
-	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+		return print_string(PRINT_FP, NULL, "%s", name);
+	return print_uint(PRINT_ANY, NULL, "%u", protocol);
 }
 
-static int dcb_app_print_key_pcp(__u16 protocol)
+static int dcb_app_print_pid_pcp(__u16 protocol)
 {
 	/* Print in numerical form, if protocol value is out-of-range */
 	if (protocol > DCB_APP_PCP_MAX)
-		return print_uint(PRINT_ANY, NULL, "%d:", protocol);
+		return print_uint(PRINT_ANY, NULL, "%u", protocol);
 
-	return print_string(PRINT_ANY, NULL, "%s:", pcp_names[protocol]);
+	return print_string(PRINT_ANY, NULL, "%s", pcp_names[protocol]);
 }
 
 static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 				   bool (*filter)(const struct dcb_app *),
-				   int (*print_key)(__u16 protocol),
+				   void (*print_pid_prio)(int (*print_pid)(__u16),
+							  const struct dcb_app *),
+				   int (*print_pid)(__u16 protocol),
 				   const char *json_name,
 				   const char *fp_name)
 {
@@ -453,8 +454,8 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 		}
 
 		open_json_array(PRINT_JSON, NULL);
-		print_key(app->protocol);
-		print_uint(PRINT_ANY, NULL, "%d ", app->priority);
+		print_pid_prio(print_pid, app);
+		print_string(PRINT_ANY, NULL, "%s", " ");
 		close_json_array(PRINT_JSON, NULL);
 	}
 
@@ -464,9 +465,17 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 	}
 }
 
+static void dcb_app_print_pid_prio(int (*print_pid)(__u16 protocol),
+				   const struct dcb_app *app)
+{
+	print_pid(app->protocol);
+	print_uint(PRINT_ANY, NULL, ":%u", app->priority);
+}
+
 static void dcb_app_print_ethtype_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_ethtype,  dcb_app_print_key_hex,
+	dcb_app_print_filtered(tab, dcb_app_is_ethtype,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_hex,
 			       "ethtype_prio", "ethtype-prio");
 }
 
@@ -474,8 +483,9 @@ static void dcb_app_print_pcp_prio(const struct dcb *dcb,
 				   const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_pcp,
-			       dcb->numeric ? dcb_app_print_key_dec
-					    : dcb_app_print_key_pcp,
+			       dcb_app_print_pid_prio,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_pcp,
 			       "pcp_prio", "pcp-prio");
 }
 
@@ -483,26 +493,30 @@ static void dcb_app_print_dscp_prio(const struct dcb *dcb,
 				    const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_dscp,
-			       dcb->numeric ? dcb_app_print_key_dec
-					    : dcb_app_print_key_dscp,
+			       dcb_app_print_pid_prio,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_dscp,
 			       "dscp_prio", "dscp-prio");
 }
 
 static void dcb_app_print_stream_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_stream_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_stream_port,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_dec,
 			       "stream_port_prio", "stream-port-prio");
 }
 
 static void dcb_app_print_dgram_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_dgram_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_dgram_port,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_dec,
 			       "dgram_port_prio", "dgram-port-prio");
 }
 
 static void dcb_app_print_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_key_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_port,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_dec,
 			       "port_prio", "port-prio");
 }
 

-- 
2.34.1


