Return-Path: <netdev+bounces-4398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 439F570C56E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:42:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F317728106F
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD38156C1;
	Mon, 22 May 2023 18:41:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCD4168B9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:39 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15974C2
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780894; x=1716316894;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=P3Qm4amTf84BGBm659hkzAx4jwgXeM+DlxWmKpizBOE=;
  b=MkiYtvcuLKh6A2tmT2IxBMpLynDGZdmNn4leLgw/vC4/lMa68yCT1XJj
   scjb27SRacMQWhzKic/C4W5Ig+cXpOAafm/t6QiYe2aCtIR0aATO/BOJh
   kbVSBdUY3tqUcKrgK6UwOxMWp355sThKZ486pg+saz8k4yy3n7c1qcUl6
   Q2CCVnsMYM7VrrzaHSoHlfzvdj7aif8QgOljQ9qtOgnX38VvbscIjfb6t
   AhoyM7eOQQ/BK4ME+Re+14XlhD/gGJI8imzRZWdh1rZ71TdnZhl0hfRFH
   MzFJDpFahn/2AhPUqD367EBxMRtMFQK3gHuYJ5nUJO08qASqq5aMZn4JO
   g==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="216701930"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:32 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:31 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:30 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:07 +0200
Subject: [PATCH iproute2-next 4/9] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-4-83adc1f93356@microchip.com>
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

When doing a replace command, entries are checked against selector and
protocol. Rewrite requires the check to be against selector and
priority.

Modify the existing dcb_app_table_remove_replace function for dcb-rewr
reuse, by using the newly introduced dcbnl attribute in the
dcb_app_table struct.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 9bb64f32e12e..23d6bb2a0013 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -160,15 +160,27 @@ void dcb_app_table_remove_replaced(struct dcb_app_table *a,
 		for (ib = 0; ib < b->n_apps; ib++) {
 			const struct dcb_app *ab = &b->apps[ib];
 
-			if (aa->selector == ab->selector &&
-			    aa->protocol == ab->protocol)
-				present = true;
-			else
+			if (aa->selector != ab->selector)
 				continue;
 
-			if (aa->priority == ab->priority) {
-				found = true;
-				break;
+			if (a->attr == DCB_ATTR_IEEE_APP_TABLE) {
+				if (aa->protocol == ab->protocol)
+					present = true;
+				else
+					continue;
+				if (aa->priority == ab->priority) {
+					found = true;
+					break;
+				}
+			} else {
+				if (aa->priority == ab->priority)
+					present = true;
+				else
+					continue;
+				if (aa->protocol == ab->protocol) {
+					found = true;
+					break;
+				}
 			}
 		}
 

-- 
2.34.1


