Return-Path: <netdev+bounces-9982-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E8672B8D5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:41:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A6162810F7
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 07:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1AACD302;
	Mon, 12 Jun 2023 07:41:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9711946BB
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:41:27 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A836110F7
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 00:40:38 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8bnF-000173-Gy; Mon, 12 Jun 2023 09:16:49 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8bn9-006pgR-T0; Mon, 12 Jun 2023 09:16:43 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q8bn8-00DQbL-S2; Mon, 12 Jun 2023 09:16:42 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next] mctp i2c: Switch back to use struct i2c_driver's .probe()
Date: Mon, 12 Jun 2023 09:16:41 +0200
Message-Id: <20230612071641.836976-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1003; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=F5Y9dLDUPh9mSKaD0otwFVUyJ0hU/iTCJkDpyLj9WaM=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkhsZYT1WNBgJx+XyC9bXYf1JzttoUP7R4+55H5 5XLQTT8jEGJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZIbGWAAKCRCPgPtYfRL+ TlqUB/9FT64tMwwnS9lorQxAreAZYBPgD0LgXdWlQEcj2NSKeXDBBEAJ4F+X0DxXqcvlMclBWoZ XJJYIK//0E+/mMqYEoQJtfAjUzjQ3xWN57Fqvx/v7RcayGRbf/o3/gZARJYc3SzFwTehOD9nxE8 gPFheMx93TT2MOfZk06hkbyU8UuI5Ejde3ROeyK/2KC9gyf+5AGuWnRV4719zPNJeoPrG51CahT 6QK4vorQWo+cdp7gAKyFa7yPGOfMR3e21ziRk4mMM9/lvEW+Hv7mnx6zuBfEWEAPP5mvFRBNDHW wxnlB8LC5haa8akc4g4VfuyC142dQK/ZfQHI5R7bd2rD6+6q
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
call-back type"), all drivers being converted to .probe_new() and then
commit 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
convert back to (the new) .probe() to be able to eventually drop
.probe_new() from struct i2c_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/net/mctp/mctp-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 1d67a3ca1fd1..b37a9e4bade4 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -1058,7 +1058,7 @@ static struct i2c_driver mctp_i2c_driver = {
 		.name = "mctp-i2c-interface",
 		.of_match_table = mctp_i2c_of_match,
 	},
-	.probe_new = mctp_i2c_probe,
+	.probe = mctp_i2c_probe,
 	.remove = mctp_i2c_remove,
 	.id_table = mctp_i2c_id,
 };

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


