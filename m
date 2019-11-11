Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F1F7E83
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 20:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfKKSjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:39:39 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33182 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfKKSjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:39:37 -0500
Received: by mail-pf1-f195.google.com with SMTP id c184so11279682pfb.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nhGIRz6QX/09rRzMB9LkOY2ugIk6+O7cw+eQqhkTBKs=;
        b=nm5gLhylFLTVYYbZLG7glIjg/dr90JpPJMqQlivDGSZBBSk03jNf12o43CbKsO7wWA
         gOIoaEN2PYgYupW9nW70xpr/IJyWbLQX0jAYE8fVF+p1R/qFvH326CFCOtCSxH2riO/g
         TAFF6rlgcP9VMznjuMpv5xH0LFz+HTKouSkd60hX1P0/rTOJIuXIdWFSkSffDupQsXMR
         LkTry0OXIG1PoKln6e429G40r6IDOxLjGjlf/kWxhJt7XS9pPMM+h8px/P0FQhDWUcQq
         9QwJ2f3kqIakXjuupHMzfCKIHX7CJOO6IY1Cshc/1mlJiWV/kzN/1M84bhLx85XC4KGf
         NQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nhGIRz6QX/09rRzMB9LkOY2ugIk6+O7cw+eQqhkTBKs=;
        b=YY2bSNe0NTD9yeqe/E22HrOl+S2SQXoRp8zphLsgSPRGgSngJp3lDOStxagNg4z6WJ
         MrXZggN5ZV4xrGXYyPSGM4W2MlH7YStXRdZiZDbsrWGzKv43iTr6v7cAv0EkWTYWRXbR
         000eeovm/NOCJ2ZgL6B59EW7e6suP9WouVVn61oZq3h+vKIShAkXX+7HaF1d7X8BMMZv
         IHiLaCvtsDACo6MakuN82CLH3oBt5a1bvNJyDpIPWGuODcY2LVr+Fu/E40dZ60FYvn8E
         fMPTmJU0QYVPVRMIbwnu4ADxcj4YO9y1qaT8j3HgRowXzUBQSLAV4ESGC//Nt87rvLjW
         HdbQ==
X-Gm-Message-State: APjAAAX0TAcmCOm5o1zg9JGvpp7hccRtv/Ip9JleeCnAMi4Jq4+8hPrM
        M1qEamHeF+c8Y1b7znpQi3OHFiIiXS4=
X-Google-Smtp-Source: APXvYqxW+rfbv+aG8r/W+PGiTmjp6IPGAvcV4K9eYVtoE1qeTJ1JRt+BkvxyNCqKYGiYbn6LpdE17Q==
X-Received: by 2002:a63:de0b:: with SMTP id f11mr24246537pgg.8.1573497576483;
        Mon, 11 Nov 2019 10:39:36 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id b5sm16921762pfp.149.2019.11.11.10.39.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 11 Nov 2019 10:39:35 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 12/18] octeontx2-af: Clear NPC MCAM entries before update
Date:   Tue, 12 Nov 2019 00:08:08 +0530
Message-Id: <1573497494-11468-13-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573497494-11468-1-git-send-email-sunil.kovvuri@gmail.com>
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

