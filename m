Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB983EE69E
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 08:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbhHQGg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 02:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbhHQGg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 02:36:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFFDC061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 23:36:25 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1mFsht-0007o2-2g; Tue, 17 Aug 2021 08:36:17 +0200
Received: from afa by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <afa@pengutronix.de>)
        id 1mFshq-0006vl-De; Tue, 17 Aug 2021 08:36:14 +0200
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     kernel@pengutronix.de, Ahmad Fatoum <a.fatoum@pengutronix.de>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: pcie: fix oops on failure to resume and reprobe
Date:   Tue, 17 Aug 2021 08:35:22 +0200
Message-Id: <20210817063521.22450-1-a.fatoum@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: afa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When resuming from suspend, brcmf_pcie_pm_leave_D3 will first attempt a
hot resume and then fall back to removing the PCI device and then
reprobing. If this probe fails, the kernel will oops, because brcmf_err,
which is called to report the failure will dereference the stale bus
pointer. Open code and use the default bus-less brcmf_err to avoid this.

Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
---
To: Arend van Spriel <aspriel@gmail.com>
To: Franky Lin <franky.lin@broadcom.com>
To: Hante Meuleman <hante.meuleman@broadcom.com>
To: Chi-hsien Lin <chi-hsien.lin@infineon.com>
To: Wright Feng <wright.feng@infineon.com>
To: Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc: SHA-cyfmac-dev-list@infineon.com
Cc: brcm80211-dev-list.pdl@broadcom.com
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 9ef94d7a7ca7..d824bea4b79d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2209,7 +2209,7 @@ static int brcmf_pcie_pm_leave_D3(struct device *dev)
 
 	err = brcmf_pcie_probe(pdev, NULL);
 	if (err)
-		brcmf_err(bus, "probe after resume failed, err=%d\n", err);
+		__brcmf_err(NULL, __func__, "probe after resume failed, err=%d\n", err);
 
 	return err;
 }
-- 
2.30.2

