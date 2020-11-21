Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9232BBEC5
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 12:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgKULpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 06:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgKULpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 06:45:21 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB417C0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 03:45:20 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605959119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qigJQbKQFSP4c6lJ4vijSarKeYToBXwmf9g1KDr6BxU=;
        b=hKW+uXMjCIeAnEhEQ6a58Sn9lUlr3Y57LnFwtK2eRgLp/ojdtiIfDXvgg6f61RZGHoNMp0
        kqgcJ0ctHvIvuZYaAQ0ByfVCMjLvnps6bW36GTKJeOlrb3O2eNcO709MuGTbr+W82R/LXq
        GprgtFcNfeDcwe9mAreywsVVRh9nroU7X2UF4cZp0eWgdlN36v4/I6ClAUxu+WgVc+80YR
        flO8hdOWf/uimCFX6nhzdSWnRv23fhBtd9vGQCFyftDabD/A50w5ncu+pJyUZNOtb1cpmg
        tgL7eMJV1CzCILAZBkB+6Ns6qls03/fFav6O3OA7LVnJn6sbdcko0iaKIeVBig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605959119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qigJQbKQFSP4c6lJ4vijSarKeYToBXwmf9g1KDr6BxU=;
        b=Mp4xRwTy11GWZ5lZDf51auKWRxw6w105GmNf/7mk2h0xnTtTxKgt3+NfLEktQ35+NJ+zeQ
        Sr8gJ5SOAbgRkqBA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 2/2] net: dsa: hellcreek: Don't print error message on defer
Date:   Sat, 21 Nov 2020 12:44:55 +0100
Message-Id: <20201121114455.22422-3-kurt@linutronix.de>
In-Reply-To: <20201121114455.22422-1-kurt@linutronix.de>
References: <20201121114455.22422-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When DSA is not loaded when the driver is probed an error message is
printed. But, that's not really an error, just a defer. Use dev_err_probe()
instead.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index d42f40c76ba5..6420b76ea37c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1266,7 +1266,7 @@ static int hellcreek_probe(struct platform_device *pdev)
 
 	ret = dsa_register_switch(hellcreek->ds);
 	if (ret) {
-		dev_err(dev, "Unable to register switch\n");
+		dev_err_probe(dev, ret, "Unable to register switch\n");
 		return ret;
 	}
 
-- 
2.20.1

