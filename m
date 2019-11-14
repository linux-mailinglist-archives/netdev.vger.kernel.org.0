Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABA1FBFA1
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfKNF1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:50 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40875 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbfKNF1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:50 -0500
Received: by mail-pf1-f194.google.com with SMTP id r4so3344385pfl.7
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nhGIRz6QX/09rRzMB9LkOY2ugIk6+O7cw+eQqhkTBKs=;
        b=TxVe0fUVaVscXbcaC/VdkQq8SN4FOXrbUHLFXcGSDuQS7c5Sp6oqStFG5aZ/mO8Ji9
         0rpQx/fopBml5Y6yXhOeQCTI7h4vUVASELc5zBjBxp4TcFnvHnJJ4ntzlnWPXVm/BOH3
         A6f9R/80yehea7QTHIeBsm/yQWyGAoLwbewZvVJ+xIPQKe6of7ZU0Brfb/Jx3G2yIpCt
         tVPqVEhNK71pgeS6Kft3KKyr1MaboepCDgLEpp7NoILsmJ9jDK64eQStr0Tr4aELVP6j
         n14L8bmvo8GEN02k3jWVMGR9rB6C/kYsr2eaXJ31oGJF6so+fRIwbjKOltSYZ0blrPvo
         /GiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nhGIRz6QX/09rRzMB9LkOY2ugIk6+O7cw+eQqhkTBKs=;
        b=jqMMneMJHBBwALgX+6kAyVuyEdRrCEY9LB2h1L9LhnQHCU7Me6fIhL+NFtsbLHl6o0
         +edFPD4wNRDkuRZVjfIeivAkJ1rGGHsCdfUX7VFdiLUMV+xbnQigIJhrcrr0rcL5sTYw
         pW9T9oouxkanyA6QIIALxRZXrmyg3h2uEiXP2x8n+fljbbNskGGNHa1OVhAATEhhYsEG
         CklpD3izFP1C5ybzosGaGPEKz5uC1qvRTnhg13HkQUFdZRA+6UTpzvF1pkGEzYtSgvmF
         QT+DBr9psobTclJ9SYHgGdKgCNhrdo74GmdG625lnWaUKBSirxoCyIhWU8k+KubXMvN9
         Q6gw==
X-Gm-Message-State: APjAAAVMzC4ibLrHkih245GeMbWXhprOKPkgNXYfNCBa6lyBLIHe52qB
        zuYAKwfKGvHcbAxNB7lnj2dI8Aj8LQ0=
X-Google-Smtp-Source: APXvYqyEAdNinwItq4r3ZSlXu2tU3vkPLP1q1S2EbY4NRqWHjlnrgK7StF8AJscXlPcCWyeCmjn7IA==
X-Received: by 2002:a62:6086:: with SMTP id u128mr8920865pfb.4.1573709269678;
        Wed, 13 Nov 2019 21:27:49 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:49 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 12/18] octeontx2-af: Clear NPC MCAM entries before update
Date:   Thu, 14 Nov 2019 10:56:27 +0530
Message-Id: <1573709193-15446-13-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Writing into NPC MCAM1 and MCAM0 registers are suppressed if
they happened to form a reserved combination. Hence
clear and disable MCAM entries before update.

For HRM:
[CAM(1)]<n>=1, [CAM(0)]<n>=1: Reserved.
The reserved combination is not allowed. Hardware suppresses any
write to CAM(0) or CAM(1) that would result in the reserved combination for
any CAM bit.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 33 ++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index ce44729..a3b4315 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -120,6 +120,31 @@ static void npc_enable_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	}
 }
 
+static void npc_clear_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
+				 int blkaddr, int index)
+{
+	int bank = npc_get_bank(mcam, index);
+	int actbank = bank;
+
+	index &= (mcam->banksize - 1);
+	for (; bank < (actbank + mcam->banks_per_entry); bank++) {
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_MCAMEX_BANKX_CAMX_INTF(index, bank, 1), 0);
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_MCAMEX_BANKX_CAMX_INTF(index, bank, 0), 0);
+
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_MCAMEX_BANKX_CAMX_W0(index, bank, 1), 0);
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_MCAMEX_BANKX_CAMX_W0(index, bank, 0), 0);
+
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_MCAMEX_BANKX_CAMX_W1(index, bank, 1), 0);
+		rvu_write64(rvu, blkaddr,
+			    NPC_AF_MCAMEX_BANKX_CAMX_W1(index, bank, 0), 0);
+	}
+}
+
 static void npc_get_keyword(struct mcam_entry *entry, int idx,
 			    u64 *cam0, u64 *cam1)
 {
@@ -211,6 +236,12 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	actindex = index;
 	index &= (mcam->banksize - 1);
 
+	/* Disable before mcam entry update */
+	npc_enable_mcam_entry(rvu, mcam, blkaddr, actindex, false);
+
+	/* Clear mcam entry to avoid writes being suppressed by NPC */
+	npc_clear_mcam_entry(rvu, mcam, blkaddr, actindex);
+
 	/* CAM1 takes the comparison value and
 	 * CAM0 specifies match for a bit in key being '0' or '1' or 'dontcare'.
 	 * CAM1<n> = 0 & CAM0<n> = 1 => match if key<n> = 0
@@ -251,8 +282,6 @@ static void npc_config_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
 	/* Enable the entry */
 	if (enable)
 		npc_enable_mcam_entry(rvu, mcam, blkaddr, actindex, true);
-	else
-		npc_enable_mcam_entry(rvu, mcam, blkaddr, actindex, false);
 }
 
 static void npc_copy_mcam_entry(struct rvu *rvu, struct npc_mcam *mcam,
-- 
2.7.4

