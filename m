Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A72D31194E2
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfLJVQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:16:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:39172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfLJVNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1735206EC;
        Tue, 10 Dec 2019 21:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012393;
        bh=5FGK8L0ogpLPS6b89aghX3QuJKo/ina7I9SvdO3b1MQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zzdCCNgq6Byn5mkVMn9lu6L8hHKomOuY0hO3NRzx2GCF7N/SUmKKvs/aBtsNqgYVI
         HS4esdRpmKW5a9xdlnGu1OHwppk4TlMCgHWA8BIKvOM7uAY/tD9r5c4YUzTCHUwPFS
         UoXbzPkIZUPNTi/Vs53BoccxCqc7XKeBJ3fDc5nA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 314/350] brcmfmac: remove monitor interface when detaching
Date:   Tue, 10 Dec 2019 16:06:59 -0500
Message-Id: <20191210210735.9077-275-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 4f61563da075bc8faefddfd5f8fc0cc14c49650a ]

This fixes a minor WARNING in the cfg80211:
[  130.658034] ------------[ cut here ]------------
[  130.662805] WARNING: CPU: 1 PID: 610 at net/wireless/core.c:954 wiphy_unregister+0xb4/0x198 [cfg80211]

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 406b367c284ca..85cf96461ddeb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1350,6 +1350,11 @@ void brcmf_detach(struct device *dev)
 	brcmf_fweh_detach(drvr);
 	brcmf_proto_detach(drvr);
 
+	if (drvr->mon_if) {
+		brcmf_net_detach(drvr->mon_if->ndev, false);
+		drvr->mon_if = NULL;
+	}
+
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS - 1; i > -1; i--) {
 		if (drvr->iflist[i])
-- 
2.20.1

