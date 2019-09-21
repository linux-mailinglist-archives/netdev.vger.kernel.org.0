Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDFFB9D0B
	for <lists+netdev@lfdr.de>; Sat, 21 Sep 2019 10:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393425AbfIUIoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 04:44:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393078AbfIUIoW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Sep 2019 04:44:22 -0400
Received: from localhost.lan (unknown [151.66.30.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B815120820;
        Sat, 21 Sep 2019 08:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569055461;
        bh=2EK1eMjutkmTt6GB4oReABgT7XhOEPsnqLHZFN/FIbY=;
        h=From:To:Cc:Subject:Date:From;
        b=L8VMwhrh6SUN6tdYnuXIlb55+Nscc9FlLw2r8HIOmu/MwizW7miTvPJcv1MrQA1np
         9A8cx2+DQXsZ4dChnT61TMjpASiUoNo4C8QUw/hF+cKU5z3ycihsU+d9Pb0LzeYiMG
         saL5eFda1HQ9zQAdIyVg1bH3Jntnz3XFK0M0Gzx8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kubakici@wp.pl
Subject: [PATCH] mt7601u: fix bbp version check in mt7601u_wait_bbp_ready
Date:   Sat, 21 Sep 2019 10:44:01 +0200
Message-Id: <9a33455c19ef6ec0427b45b2e7f7053cf7353fe8.1569055057.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bbp ready check in mt7601u_wait_bbp_ready. The issue is reported by
coverity with the following error:

Logical vs. bitwise operator
The expression's value does not depend on the operands; inadvertent use
of the wrong operator is a likely logic error.

Addresses-Coverity-ID: 1309441 ("Logical vs. bitwise operator")
Fixes: c869f77d6abb ("add mt7601u driver")
Acked-by: Jakub Kicinski <kubakici@wp.pl>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt7601u/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/phy.c b/drivers/net/wireless/mediatek/mt7601u/phy.c
index 06f5702ab4bd..d863ab4a66c9 100644
--- a/drivers/net/wireless/mediatek/mt7601u/phy.c
+++ b/drivers/net/wireless/mediatek/mt7601u/phy.c
@@ -213,7 +213,7 @@ int mt7601u_wait_bbp_ready(struct mt7601u_dev *dev)
 
 	do {
 		val = mt7601u_bbp_rr(dev, MT_BBP_REG_VERSION);
-		if (val && ~val)
+		if (val && val != 0xff)
 			break;
 	} while (--i);
 
-- 
2.21.0

