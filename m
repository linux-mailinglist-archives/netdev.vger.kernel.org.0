Return-Path: <netdev+bounces-7032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B48B719581
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:27:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 277B928164E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F6F2168A8;
	Thu,  1 Jun 2023 08:26:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B441641D
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:26:19 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2B5128
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:26:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddE-0002tt-GT; Thu, 01 Jun 2023 10:26:04 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddC-004JKe-VT; Thu, 01 Jun 2023 10:26:02 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddB-00A5yW-Tw; Thu, 01 Jun 2023 10:26:01 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next 1/4] ath10k: Drop cleaning of driver data from probe error path and remove
Date: Thu,  1 Jun 2023 10:25:53 +0200
Message-Id: <20230601082556.2738446-2-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=942; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=/b+eoSPz9HG2VPpR1UR16uVKTcTD7gKSXld+WjvDuk4=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkeFYMjksFhfS3h1NyC7+gR5ba3ymfDLI1F5L1W gHLt4wuLt2JATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZHhWDAAKCRCPgPtYfRL+ TskTCAC7CWyAAZFHB8MYkQ+a5zOuyFeqHkD8VWZl7bDu3yq6x4OTYwLbvQnLT+r42HFnISJV69m xjJhmqV5zUGCSt9SUQKeNHfJFjUX1mK1q7i2jhKPD6Nk6n3Za+72WIB4tv5V8bVQEri5h37OffV OSt9rmwBRHSCAyClqqI0jiU6iZKzkIKyxkmew+rhrKepaIrhFvx3CoB9rk7sObsHF8IydpaM+J4 0OcEbDAPIvWahtN/xETDwsYYNK9xF3oSlCFpGxNM/9CuJDR770Nuvo8wvobCsAm3WkxZb02qUnX /0xx6DGSmkw/xM3wfEvl0OyC+ib8XuR0Y/ukEhc4PUB6SQ2F
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The driver core cares for resetting driver data if probe fails and after
remove. So drop the explicit and duplicate cleanup in the driver's
functions.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index f0c615fa5614..7bb45c66cff7 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -816,7 +816,6 @@ static int ath10k_ahb_probe(struct platform_device *pdev)
 
 err_core_destroy:
 	ath10k_core_destroy(ar);
-	platform_set_drvdata(pdev, NULL);
 
 	return ret;
 }
@@ -845,8 +844,6 @@ static int ath10k_ahb_remove(struct platform_device *pdev)
 	ath10k_ahb_resource_deinit(ar);
 	ath10k_core_destroy(ar);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
2.39.2


