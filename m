Return-Path: <netdev+bounces-4403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EE5F70C577
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:43:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 225461C20BCF
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291BB171DF;
	Mon, 22 May 2023 18:41:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16537171D8
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 18:41:43 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C0910D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684780899; x=1716316899;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=CEix2089coFr4QW9fnXh9p4fXbFtV4ZyIkR4k/A8XIo=;
  b=BV+5sxKPSMhVOthfHo9EEXL1KSvlGraQV23JcMhWnDKLRtkZYPVw5/17
   PCKBNWuHaKQbL482uai23i3Lk0lGmNZt2K6Vtb6D6VtX0yPCOHHv937Gs
   JfxQ4iZaeyg4DTWKVBEbHVVtZpSOy8KPfPpP3gkgHNErUbFGIEM3xBnZ7
   E/LfMSbpFYE3xAZtA2rN5WYvJPi9JW+z9toG+Jh/gdLw+WwUlF/VHBige
   o3B+I9FFsmkQ3FkIncELLPBRoSHGL57ro9ZrwiSGoWuAP2D5xs7NEMWGL
   K/2ov/MWcXgxlElsFccNFvP5Qr9/wdYyV7D+/j4ZlRZDBSzT8qw3AQMtL
   w==;
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="216701945"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 May 2023 11:41:33 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 22 May 2023 11:41:33 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Mon, 22 May 2023 11:41:32 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Mon, 22 May 2023 20:41:08 +0200
Subject: [PATCH iproute2-next 5/9] dcb: app: modify
 dcb_app_parse_mapping_cb for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v1-5-83adc1f93356@microchip.com>
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

When parsing APP table entries, priority and protocol is assigned from
value and key, respectively. Rewrite requires it opposite.

Modify the existing dcb_app_parse_mapping_cb for dcb-rewr reuse, by
using the newly introduced dcbnl attribute in the dcb_app_table struct.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index 23d6bb2a0013..46af67112748 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -232,10 +232,17 @@ void dcb_app_parse_mapping_cb(__u32 key, __u64 value, void *data)
 	struct dcb_app_parse_mapping *pm = data;
 	struct dcb_app app = {
 		.selector = pm->selector,
-		.priority = value,
-		.protocol = key,
 	};
 
+	if (pm->tab->attr == DCB_ATTR_IEEE_APP_TABLE) {
+		app.priority = value;
+		app.protocol = key;
+
+	} else {
+		app.priority = key;
+		app.protocol = value;
+	}
+
 	if (pm->err)
 		return;
 

-- 
2.34.1


