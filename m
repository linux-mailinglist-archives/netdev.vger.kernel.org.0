Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3349F340799
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhCROQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60466 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231430AbhCROQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IEEgf9027109;
        Thu, 18 Mar 2021 07:16:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=BZnmteev1OD32fPEp9pSDG9p4+7EMfj7P+ATJvNpqAY=;
 b=idEOQdH+2Fq67j6tvptexW9dxFkAw2NUJdhPgQZs6htHMCN5KXZc3k3d1XTE/3HKTwuF
 scMLBeSr2gIBv4AXbTf2hDGjRaSUpmsL8CdV4/nyhkgcVCxCUuBjw1VbQebtIopV8U/h
 QRo7KhOi5cvNFXHaQMeVVMMqoT5wIno6dwlikV4tRQTWLlr41cQ5Bi3IGHBJobuO83e+
 bVpkifzHjRYdMuD625rB9M7PU7soSe7b5vRFJBaYs7/S+fMTdHnQ6HoqAck2KD9RKA3a
 Nhrn0ABL0X05PZZNPtHvvJN5hUt9rflNtDNAdiGx+Y9bCyXoHitwJ8RQPOLm6LCSp1rM oA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 37b5vdpkc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 07:16:07 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 07:16:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 07:16:05 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id BD94E3F7041;
        Thu, 18 Mar 2021 07:16:01 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [net PATCH v2 3/8] octeontx2-af: Remove TOS field from MKEX TX
Date:   Thu, 18 Mar 2021 19:45:44 +0530
Message-ID: <20210318141549.2622-4-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210318141549.2622-1-hkelam@marvell.com>
References: <20210318141549.2622-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_07:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

The MKEX profile describes what packet fields need to be extracted from
the input packet and how to place those packet fields in the output key
for MCAM matching.  The MKEX profile can be in a way where higher layer
packet fields can overwrite lower layer packet fields in output MCAM
Key.
Hence MKEX profile is always ensured that there are no overlaps between
any of the layers. But the commit 42006910b5ea
("octeontx2-af: cleanup KPU config data") introduced TX TOS field which
overlaps with DMAC in MCAM key.
This led to AF driver returning error when TX rule is installed with
DMAC as match criteria since DMAC gets overwritten and cannot be
supported. This patch fixes the issue by removing TOS field from MKEX TX
profile.

Fixes: 42006910b5ea ("octeontx2-af: cleanup KPU config data")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index b192692b4fc..5c372d2c24a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -13499,8 +13499,6 @@ static struct npc_mcam_kex npc_mkex_default = {
 			[NPC_LT_LC_IP] = {
 				/* SIP+DIP: 8 bytes, KW2[63:0] */
 				KEX_LD_CFG(0x07, 0xc, 0x1, 0x0, 0x10),
-				/* TOS: 1 byte, KW1[63:56] */
-				KEX_LD_CFG(0x0, 0x1, 0x1, 0x0, 0xf),
 			},
 			/* Layer C: IPv6 */
 			[NPC_LT_LC_IP6] = {
-- 
2.17.1

