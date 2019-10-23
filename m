Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC20DE167D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 11:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403931AbfJWJox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 05:44:53 -0400
Received: from mail-wm1-f98.google.com ([209.85.128.98]:37124 "EHLO
        mail-wm1-f98.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403798AbfJWJow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 05:44:52 -0400
Received: by mail-wm1-f98.google.com with SMTP id f22so18977425wmc.2
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 02:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=jymaeoXc9lCIumhT/zmt2WYXQ+MD+RfPYC4j1B6RWHE=;
        b=dWYB3g1cJZIM6j5e38IfNhXtb5g+T9TdGSQSMrYiie8XaHRdInPmzVVcFAGy2QLVqs
         xM3Uj1SAFnwTemNz966MvLlP7W2lpQ/kr+F+SFtgewlLZ01rEjE5QJDoa/ayaJvwt+2D
         +TBForoI/DjBunXlqpTx0JqhMpve0rK8AkqH9glqSdgX+JiTo7QzN/SN2JGZM88lNmN8
         ze8mxHneYCl3Gxn/U0E4nU3p2mEm41gGnB+5GikVxdfTAYjhNAqDtB8/5aDdy98NfIcn
         X0ajnLFT9577OGq9AEJEtiuyo427i2qiUdP8/wdZKCJUm6E1FtFG4nzo0SMsD1oi6fuf
         bTlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jymaeoXc9lCIumhT/zmt2WYXQ+MD+RfPYC4j1B6RWHE=;
        b=qj9hWV86Ad3wgBBvl/Q7nPc3S+jluTLBG/S9YrB5uC3xJNH95ohYg8Rm6Yg5HT7PaR
         AdUK/6m61mR9Czzj9w2OFFA43vtzZS9EQ7hwFy5LV6xWWUWXSJzvoMXXbot7ilc/Y6AK
         z3tR8JiBM+MtSIYiUS6m9vrpMatJ7jqOgb2wHyVH+Yy+7u1bIrnudr1hktH7d1Y+NXUF
         M92I+TpDzh2zBqW84dvF9kHH/B2S1/4yvy+p8L2sJu83O6K4llHNo4EwJnb5pF8ZJK13
         eRmRb4aPBm/AiMzepoTBZ+x7ULDYo7t1l5r+z3HhIj6m1ydLm3Sd+1DMb0YKimSG6Wf7
         gzDQ==
X-Gm-Message-State: APjAAAWK6IopFc2oRH9+F9uMPmkx1sHOK2k3tsTgLpZrdJNyPCMGQ8az
        pUM5KFeQFOG3BZMh/yTKl9RPrZ4Ra6yQnkmQWs8MlPmr57T9
X-Google-Smtp-Source: APXvYqyc+TieKIvaDb/aCbXAsrzMko5jTwaVvvoLZQJowrPI1LiWrJjEsmKLqg7zSe7xkiJxLwUfgd109sFz
X-Received: by 2002:a1c:4c02:: with SMTP id z2mr5163159wmf.78.1571823890217;
        Wed, 23 Oct 2019 02:44:50 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id c197sm190788wme.24.2019.10.23.02.44.49
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 02:44:50 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [10.32.51.198] (port=36768 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1iNDCD-0007m5-Lv; Wed, 23 Oct 2019 11:44:49 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] net: phy: smsc: LAN8740: add PHY_RST_AFTER_CLK_EN flag
Date:   Wed, 23 Oct 2019 11:44:24 +0200
Message-Id: <1571823889-16834-1-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LAN8740, like the 8720, also requires a reset after enabling clock.
The datasheet [1] 3.8.5.1 says:
	"During a Hardware reset, an external clock must be supplied
	to the XTAL1/CLKIN signal."

I have observed this issue on a custom i.MX6 based board with
the LAN8740A.

[1] http://ww1.microchip.com/downloads/en/DeviceDoc/8740a.pdf

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index dc3d92d..b732982 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -327,6 +327,7 @@ static int smsc_phy_probe(struct phy_device *phydev)
 	.name		= "SMSC LAN8740",
 
 	/* PHY_BASIC_FEATURES */
+	.flags		= PHY_RST_AFTER_CLK_EN,
 
 	.probe		= smsc_phy_probe,
 
-- 
1.9.1

