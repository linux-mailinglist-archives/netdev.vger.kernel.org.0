Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150BB356E8E
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352869AbhDGO2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:28:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43767 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348517AbhDGO2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 10:28:16 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lU9A2-0003X8-PI; Wed, 07 Apr 2021 14:28:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eilon Greenstein <eilong@broadcom.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bnx2x: Fix potential infinite loop
Date:   Wed,  7 Apr 2021 15:28:02 +0100
Message-Id: <20210407142802.495539-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The for_each_tx_queue loop iterates with a u8 loop counter i and
compares this with the loop upper limit of bp->num_queues that
is an int type.  There is a potential infinite loop if bp->num_queues
is larger than the u8 loop counter. Fix this by making the loop
counter the same type as bp->num_queues.

Addresses-Coverity: ("Infinite loop")
Fixes: ad5afc89365e ("bnx2x: Separate VF and PF logic")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 1a6ec1a12d53..edfbeb710ad4 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -2959,7 +2959,8 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 
 int bnx2x_drain_tx_queues(struct bnx2x *bp)
 {
-	u8 rc = 0, cos, i;
+	u8 rc = 0, cos;
+	int i;
 
 	/* Wait until tx fastpath tasks complete */
 	for_each_tx_queue(bp, i) {
-- 
2.30.2

