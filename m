Return-Path: <netdev+bounces-8306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E776B7238DC
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59E391C20E15
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC9E261D0;
	Tue,  6 Jun 2023 07:20:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEBC24132
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:33 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECBC10CB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036015; x=1717572015;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=/mGXLFJ93FJ8GUFL1KF9OktNd9g1tlzoZgFFvKACtu0=;
  b=MPC03y9vcjQJ5cXxctHzTXM/Lfxi0OE8xg8zcT1HUhpmUrmU08OlJiGf
   9COCm9isKAKgtqOlo4OexTlJzDLSvNV7rdvq3TADDkQIgxScHD0WSIAD8
   2ZvjPJo6pfEt02qk3xhVYJv6iL2NwjCLqG+XCq/pvG9iftnz4pt4dgoAK
   xZrOj97Q7pnTRGe3oLjwOyEOHLsRV+7rF9uMSoHC5ja+UdkPO5A/4mJfh
   2UA96kKrIvitKJEYHv9EYRNtr43EIV0P1ARZYDBhhtAaV/9FJFFyZWKBp
   tnYh4yZQygz+A6pqzxwJoP8sxrWCFYkfBxTQFrQZg+ZKYAZNR80flAZ6L
   g==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="228600036"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:15 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:13 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:40 +0200
Subject: [PATCH iproute2-next v3 05/12] dcb: app: modify
 dcb_app_print_filtered() for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-5-60a766f72e61@microchip.com>
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

Where dcb-app requires protocol to be the printed key, dcb-rewr requires
it to be the priority. Adapt existing dcb-app print functions for this.

dcb_app_print_filtered() has been modified, to take two callbacks; one
for printing the entire string (pid and prio), and one for the pid type
(dec, hex, dscp, pcp). This saves us for making one dedicated function
for each pid type for both app and rewr.

Also, printing the colon is now expected to be handled by the
print_pid_prio() callback.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index a8f3424db9f7..aa248cc40bdf 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -434,7 +434,9 @@ static int dcb_app_print_pid_pcp(__u16 protocol)
 
 static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 				   bool (*filter)(const struct dcb_app *),
-				   int (*print_key)(__u16 protocol),
+				   void (*print_pid_prio)(int (*print_pid)(__u16),
+							  const struct dcb_app *),
+				   int (*print_pid)(__u16 protocol),
 				   const char *json_name,
 				   const char *fp_name)
 {
@@ -453,8 +455,8 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
 		}
 
 		open_json_array(PRINT_JSON, NULL);
-		print_key(app->protocol);
-		print_uint(PRINT_ANY, NULL, ":%u ", app->priority);
+		print_pid_prio(print_pid, app);
+		print_string(PRINT_ANY, NULL, "%s", " ");
 		close_json_array(PRINT_JSON, NULL);
 	}
 
@@ -464,9 +466,17 @@ static void dcb_app_print_filtered(const struct dcb_app_table *tab,
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
-	dcb_app_print_filtered(tab, dcb_app_is_ethtype,  dcb_app_print_pid_hex,
+	dcb_app_print_filtered(tab, dcb_app_is_ethtype,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_hex,
 			       "ethtype_prio", "ethtype-prio");
 }
 
@@ -474,8 +484,9 @@ static void dcb_app_print_pcp_prio(const struct dcb *dcb,
 				   const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_pcp,
-			       dcb->numeric ? dcb_app_print_pid_dec
-					    : dcb_app_print_pid_pcp,
+			       dcb_app_print_pid_prio,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_pcp,
 			       "pcp_prio", "pcp-prio");
 }
 
@@ -483,26 +494,30 @@ static void dcb_app_print_dscp_prio(const struct dcb *dcb,
 				    const struct dcb_app_table *tab)
 {
 	dcb_app_print_filtered(tab, dcb_app_is_dscp,
-			       dcb->numeric ? dcb_app_print_pid_dec
-					    : dcb_app_print_pid_dscp,
+			       dcb_app_print_pid_prio,
+			       dcb->numeric ? dcb_app_print_pid_dec :
+					      dcb_app_print_pid_dscp,
 			       "dscp_prio", "dscp-prio");
 }
 
 static void dcb_app_print_stream_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_stream_port, dcb_app_print_pid_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_stream_port,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_dec,
 			       "stream_port_prio", "stream-port-prio");
 }
 
 static void dcb_app_print_dgram_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_dgram_port, dcb_app_print_pid_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_dgram_port,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_dec,
 			       "dgram_port_prio", "dgram-port-prio");
 }
 
 static void dcb_app_print_port_prio(const struct dcb_app_table *tab)
 {
-	dcb_app_print_filtered(tab, dcb_app_is_port, dcb_app_print_pid_dec,
+	dcb_app_print_filtered(tab, dcb_app_is_port,
+			       dcb_app_print_pid_prio, dcb_app_print_pid_dec,
 			       "port_prio", "port-prio");
 }
 

-- 
2.34.1


