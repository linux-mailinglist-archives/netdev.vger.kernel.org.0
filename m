Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9862F6665
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728608AbfKJDN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:13:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728001AbfKJCmr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:42:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAACE21019;
        Sun, 10 Nov 2019 02:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353766;
        bh=38A7lZnLtnGmRLXkDKXv2Syi9AZbbMf5E6dfb84ep1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVECUx2m1tHy+SPcKXwghA9z7ZXVytyCaxzuEV8igj8bJIK8CEDxQLgIONwnqP+WC
         k9gOargGybQ478e/z4m41j/atsc66y0SORnHP71kQHVWwgE6/KIsimBCBijLB4OHlJ
         HaiVyQUcE5zAP6GwApzJ2Y5LGz/R5SbH5ztrq58o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shahed Shaikh <Shahed.Shaikh@cavium.com>,
        Ariel Elior <ariel.elior@cavium.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 078/191] bnx2x: Ignore bandwidth attention in single function mode
Date:   Sat,  9 Nov 2019 21:38:20 -0500
Message-Id: <20191110024013.29782-78-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahed Shaikh <Shahed.Shaikh@cavium.com>

[ Upstream commit 75a110a1783ef8324ffd763b24f4ac268253cbca ]

This is a workaround for FW bug -
MFW generates bandwidth attention in single function mode, which
is only expected to be generated in multi function mode.
This undesired attention in SF mode results in incorrect HW
configuration and resulting into Tx timeout.

Signed-off-by: Shahed Shaikh <Shahed.Shaikh@cavium.com>
Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 68c62e32e8820..af57568c922eb 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -3540,6 +3540,16 @@ static void bnx2x_drv_info_iscsi_stat(struct bnx2x *bp)
  */
 static void bnx2x_config_mf_bw(struct bnx2x *bp)
 {
+	/* Workaround for MFW bug.
+	 * MFW is not supposed to generate BW attention in
+	 * single function mode.
+	 */
+	if (!IS_MF(bp)) {
+		DP(BNX2X_MSG_MCP,
+		   "Ignoring MF BW config in single function mode\n");
+		return;
+	}
+
 	if (bp->link_vars.link_up) {
 		bnx2x_cmng_fns_init(bp, true, CMNG_FNS_MINMAX);
 		bnx2x_link_sync_notify(bp);
-- 
2.20.1

