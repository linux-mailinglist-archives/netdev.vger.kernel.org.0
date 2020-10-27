Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B833299DDF
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438851AbgJ0AGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438142AbgJ0AFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 20:05:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A52BB20754;
        Tue, 27 Oct 2020 00:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757107;
        bh=TA0zwGB5uyXbQp3szJHZeHaAligXdGLtW8PDFSqSldk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPrdlv9GV56X1bqt8TS6rmfc+fGEAH7qD77sP7X1zqRwshIQvZqOgtXsUXpqFwiZq
         fcvYOqV8R1Jq460u3Hs41J+nJdvFSm9nKZbZOip/QXen66XE/ZjdWxnAE2cCTJKoQg
         kwq+IU82i3+fEL70CcWT5mNW70BNdes1ShgyFRHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 44/60] bnxt_en: Log unknown link speed appropriately.
Date:   Mon, 26 Oct 2020 20:03:59 -0400
Message-Id: <20201027000415.1026364-44-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027000415.1026364-1-sashal@kernel.org>
References: <20201027000415.1026364-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 8eddb3e7ce124dd6375d3664f1aae13873318b0f ]

If the VF virtual link is set to always enabled, the speed may be
unknown when the physical link is down.  The driver currently logs
the link speed as 4294967295 Mbps which is SPEED_UNKNOWN.  Modify
the link up log message as "speed unknown" which makes more sense.

Reviewed-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/1602493854-29283-7-git-send-email-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c3f04fb319556..01d28ede1fb20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6326,6 +6326,11 @@ static void bnxt_report_link(struct bnxt *bp)
 		u16 fec;
 
 		netif_carrier_on(bp->dev);
+		speed = bnxt_fw_to_ethtool_speed(bp->link_info.link_speed);
+		if (speed == SPEED_UNKNOWN) {
+			netdev_info(bp->dev, "NIC Link is Up, speed unknown\n");
+			return;
+		}
 		if (bp->link_info.duplex == BNXT_LINK_DUPLEX_FULL)
 			duplex = "full";
 		else
@@ -6338,7 +6343,6 @@ static void bnxt_report_link(struct bnxt *bp)
 			flow_ctrl = "ON - receive";
 		else
 			flow_ctrl = "none";
-		speed = bnxt_fw_to_ethtool_speed(bp->link_info.link_speed);
 		netdev_info(bp->dev, "NIC Link is Up, %u Mbps %s duplex, Flow control: %s\n",
 			    speed, duplex, flow_ctrl);
 		if (bp->flags & BNXT_FLAG_EEE_CAP)
-- 
2.25.1

