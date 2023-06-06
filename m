Return-Path: <netdev+bounces-8305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA00D7238D7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:21:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65343281421
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30838134D9;
	Tue,  6 Jun 2023 07:20:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446811CB7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:20:33 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1388E40
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686036017; x=1717572017;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=/b0vlFBMmpaGtvdJcraK0mZPYL+hb/4YXfWKj4Xsn0g=;
  b=jkR/aOdw4mwNVxAvzFKnGDSl6/2BBr6usj/126HxQgGxSwVM+enhOZUi
   e03qRkO387P/SFeCL/ITk31IOjCBtWv8xJ/EYS8yk7KYpq6KJvR0TJ9OQ
   1oawrBsFq8zU0UfHX7aW/LNhPPEiznwJy1VTpRpD7kvvFTgy9Ic8BWLbZ
   oqoICnxD0BjnavOu7kI6ot69vqL/WnT6lnK29nogbD7WVrcP8F8qgfDnO
   hauF6DEWZ2wW7PdKzX4KEqYg+evXj1roAOTEgOLrXB0jz70O+9kzOhy70
   BLXX1jhkttrONTJnKFAYqXTSxw07MxkArw6bM+N+Ru09rpvUiyTcAIKlI
   w==;
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="216378703"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 00:20:17 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 00:20:16 -0700
Received: from [10.205.21.38] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 00:20:15 -0700
From: Daniel Machon <daniel.machon@microchip.com>
Date: Tue, 6 Jun 2023 09:19:41 +0200
Subject: [PATCH iproute2-next v3 06/12] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20230510-dcb-rewr-v3-6-60a766f72e61@microchip.com>
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

When doing a replace command, entries are checked against selector and
protocol. Rewrite requires the check to be against selector and
priority.

Adapt the existing dcb_app_table_remove_replace function for this, by
using callback functions for selector, pid and prio checks.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 dcb/dcb_app.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
index aa248cc40bdf..4b309016fb65 100644
--- a/dcb/dcb_app.c
+++ b/dcb/dcb_app.c
@@ -153,8 +153,16 @@ static void dcb_app_table_remove_existing(struct dcb_app_table *a,
 	a->n_apps = ja;
 }
 
+static bool dcb_app_pid_eq(const struct dcb_app *aa, const struct dcb_app *ab)
+{
+	return aa->selector == ab->selector &&
+	       aa->protocol == ab->protocol;
+}
+
 static void dcb_app_table_remove_replaced(struct dcb_app_table *a,
-					  const struct dcb_app_table *b)
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
@@ -892,7 +900,7 @@ static int dcb_cmd_app_replace(struct dcb *dcb, const char *dev, int argc, char
 	}
 
 	/* Remove the obsolete entries. */
-	dcb_app_table_remove_replaced(&orig, &tab);
+	dcb_app_table_remove_replaced(&orig, &tab, dcb_app_pid_eq);
 	ret = dcb_app_add_del(dcb, dev, DCB_CMD_IEEE_DEL, &orig, NULL);
 	if (ret != 0) {
 		fprintf(stderr, "Could not remove replaced APP entries\n");

-- 
2.34.1


