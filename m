Return-Path: <netdev+bounces-7119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3463F71A308
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:48:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A42E31C2104A
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88D822D5E;
	Thu,  1 Jun 2023 15:48:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740222D59
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:48:25 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BBB136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
	Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
	:Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
	Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wIdrW6hUzWMgeDNii256KKTtyr8hYh66VJbVbTSmknE=; b=FvYiRzIycoeIsfSnChBMesnB6q
	DANZVZXTOKCKntjCOKK/bm8VH8wSoIIbZYqAfH2faVaFxp4RxOWsZ6ToCeAvTQ4F645S/z0mU9dw4
	WE4Z+hJ0N/jRRb+l+sb6+X4We9gn18RMaehVV6lF1TcMyJy0Bf4dlLpXH5LPKSVm7dwYzuLwOqWPL
	cUNHIDGRn+Hqa3hD94uld1ybcufNPD3bJQv7B6WsKMGoXCIRKjWCIbOh+gBnY90eDIqvIsMPTJr2u
	/1XrhvB+ZgwJ/q6Zgb/NSew/inRlpDu60QwsFWrm4WvcJYjR4CeXbLupEeHCph+Adec34lNGjniIv
	f4pFH24A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:47042 helo=rmk-PC.armlinux.org.uk)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <rmk@armlinux.org.uk>)
	id 1q4kX7-0006fd-Di; Thu, 01 Jun 2023 16:48:13 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <rmk@rmk-PC.armlinux.org.uk>)
	id 1q4kX6-00BNuM-Mx; Thu, 01 Jun 2023 16:48:12 +0100
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	 Eric Dumazet <edumazet@google.com>,
	 Jakub Kicinski <kuba@kernel.org>,
	 Paolo Abeni <pabeni@redhat.com>,
	 Dan Carpenter <dan.carpenter@linaro.org>,
	 Oleksij Rempel <linux@rempel-privat.de>,
	netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylib: fix phy_read*_poll_timeout()
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1q4kX6-00BNuM-Mx@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date: Thu, 01 Jun 2023 16:48:12 +0100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dan Carpenter reported a signedness bug in genphy_loopback(). Andrew
reports that:

"It is common to get this wrong in general with PHY drivers. Dan
regularly posts fixes like this soon after a PHY driver patch it
merged. I really wish we could somehow get the compiler to warn when
the result from phy_read() is stored into a unsigned type. It would
save Dan a lot of work."

Let's make phy_read*_poll_timeout() immune to further issues when "val"
is an unsigned type by storing the read function's result in a signed
int as well as "val", and using the signed variable both to check for
an error and for propagating that error to the caller.

The advantage of this method is we don't change where the cast from
the signed return code to the user's variable occurs - so users will
see no change.

Previously Heiner changed phy_read_poll_timeout() to check for an error
before evaluating the user supplied condition, but didn't update
phy_read_mmd_poll_timeout(). Make that change there too.

Link: https://lore.kernel.org/r/d7bb312e-2428-45f6-b9b3-59ba544e8b94@kili.mountain
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/phy.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 7addde5d14c0..11c1e91563d4 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1206,10 +1206,12 @@ static inline int phy_read(struct phy_device *phydev, u32 regnum)
 #define phy_read_poll_timeout(phydev, regnum, val, cond, sleep_us, \
 				timeout_us, sleep_before_read) \
 ({ \
-	int __ret = read_poll_timeout(phy_read, val, val < 0 || (cond), \
+	int __ret, __val; \
+	__ret = read_poll_timeout(__val = phy_read, val, \
+				  __val < 0 || (cond), \
 		sleep_us, timeout_us, sleep_before_read, phydev, regnum); \
-	if (val < 0) \
-		__ret = val; \
+	if (__val < 0) \
+		__ret = __val; \
 	if (__ret) \
 		phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
 	__ret; \
@@ -1302,11 +1304,13 @@ int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
 #define phy_read_mmd_poll_timeout(phydev, devaddr, regnum, val, cond, \
 				  sleep_us, timeout_us, sleep_before_read) \
 ({ \
-	int __ret = read_poll_timeout(phy_read_mmd, val, (cond) || val < 0, \
+	int __ret, __val; \
+	__ret = read_poll_timeout(__val = phy_read_mmd, val, \
+				  __val < 0 || (cond), \
 				  sleep_us, timeout_us, sleep_before_read, \
 				  phydev, devaddr, regnum); \
-	if (val <  0) \
-		__ret = val; \
+	if (__val < 0) \
+		__ret = __val; \
 	if (__ret) \
 		phydev_err(phydev, "%s failed: %d\n", __func__, __ret); \
 	__ret; \
-- 
2.30.2


