Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1763C30A475
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 10:38:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhBAJgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 04:36:54 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232573AbhBAJgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 04:36:52 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1119UgHd027655;
        Mon, 1 Feb 2021 01:35:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=LxnivVJL/AEhOWt0BG5ZwWtBGuWRf2DakQvWD2rbrwQ=;
 b=UEXlRPNbmv5brIWuIGqarCyENVyOlYa33Cdi3TshCPe/GWHTr5mpPBNvvhc+lNiFNHbt
 pAXuOkDUEDBMKlu/SM010ZEscMAu4zlgPBkBR1QpNN8pBtwDXUCRPqJHPNTI/2NutUQl
 bajoXcxCpSjVIz2Dmhav5CJ9ZYjhm8fQ6qlzyrsiMigOx4JeHhJribnxBR7jnrKQzVfz
 juDKZm9NU8nKSLc7ZWUbFzo9lBqhaCKAT2iMmHjB7k1KIautPQMAa0I2vBHH71bSKo6I
 E8MVfvCCBZYxTfNVC2YM9YNsLivE6xaSqqPFSOjhWA521zd6lAc6EgVKPPO0xucMBIS6 DQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5psudvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 01:35:50 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Feb
 2021 01:35:49 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 1 Feb
 2021 01:35:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 1 Feb 2021 01:35:48 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id CAE5E3F703F;
        Mon,  1 Feb 2021 01:35:45 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH net] net: mvpp2: TCAM entry enable should be written after SRAM data
Date:   Mon, 1 Feb 2021 11:35:39 +0200
Message-ID: <1612172139-28343-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_04:2021-01-29,2021-02-01 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Last TCAM data contains TCAM enable bit.
It should be written after SRAM data before entry enabled.

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
index 0b2ff08..f4a905f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c
@@ -29,16 +29,16 @@ static int mvpp2_prs_hw_write(struct mvpp2 *priv, struct mvpp2_prs_entry *pe)
 	/* Clear entry invalidation bit */
 	pe->tcam[MVPP2_PRS_TCAM_INV_WORD] &= ~MVPP2_PRS_TCAM_INV_MASK;
 
-	/* Write tcam index - indirect access */
-	mvpp2_write(priv, MVPP2_PRS_TCAM_IDX_REG, pe->index);
-	for (i = 0; i < MVPP2_PRS_TCAM_WORDS; i++)
-		mvpp2_write(priv, MVPP2_PRS_TCAM_DATA_REG(i), pe->tcam[i]);
-
 	/* Write sram index - indirect access */
 	mvpp2_write(priv, MVPP2_PRS_SRAM_IDX_REG, pe->index);
 	for (i = 0; i < MVPP2_PRS_SRAM_WORDS; i++)
 		mvpp2_write(priv, MVPP2_PRS_SRAM_DATA_REG(i), pe->sram[i]);
 
+	/* Write tcam index - indirect access */
+	mvpp2_write(priv, MVPP2_PRS_TCAM_IDX_REG, pe->index);
+	for (i = 0; i < MVPP2_PRS_TCAM_WORDS; i++)
+		mvpp2_write(priv, MVPP2_PRS_TCAM_DATA_REG(i), pe->tcam[i]);
+
 	return 0;
 }
 
-- 
1.9.1

