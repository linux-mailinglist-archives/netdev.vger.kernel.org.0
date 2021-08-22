Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 328DC3F3F2C
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 14:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhHVMDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 08:03:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231414AbhHVMDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 08:03:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17MB0KTa005798;
        Sun, 22 Aug 2021 05:02:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hSE7RWISIMoYhRkahQcHjHPsWhNSg2EbPiwP4Vj0FLk=;
 b=cfcHb6YDrQGLbRQlkHqN7q8Y7SXy4OPTDJVoD1H+ASecfXC18O/EJ19yDil3xIkmXrnQ
 pEqQPNJ949XIeBDJ7RqRWna0p5fvc7ykbbd73tDbDjEXXMfMigitUo2pPLntMVdGaH3a
 Zhmf68ikMfdqqZEE4zMSg8oDx6xrwqb8YUVEaB0/c9jIo1eBq30icKcuBRJIJjaUwtxl
 61Y/9SR6TkhEtwGAVyCd47XGyEDTxzwN8YmS/oEX8h99sY1DAAgFdzJylSWRohI+iDZX
 g+de1LdXyTPk0gQVMj3tRNM80e7rBkex2xbASTmRdqyziZySmOgZFGtylJq+wKNWp0xT Eg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ak10mtr63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 22 Aug 2021 05:02:50 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.23; Sun, 22 Aug
 2021 05:02:47 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.23 via Frontend
 Transport; Sun, 22 Aug 2021 05:02:47 -0700
Received: from machine421.marvell.com (unknown [10.29.37.2])
        by maili.marvell.com (Postfix) with ESMTP id 6031A3F706C;
        Sun, 22 Aug 2021 05:02:46 -0700 (PDT)
From:   Sunil Goutham <sgoutham@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Hariprasad Kelam <hkelam@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [net PATCH 04/10] octeontx2-pf: Don't mask out supported link modes
Date:   Sun, 22 Aug 2021 17:32:21 +0530
Message-ID: <1629633747-22061-5-git-send-email-sgoutham@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
References: <1629633747-22061-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: _4FlFMwWnPGOdqx5BUyymQVPqEl6UUTa
X-Proofpoint-ORIG-GUID: _4FlFMwWnPGOdqx5BUyymQVPqEl6UUTa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-21_11,2021-08-20_03,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Supported link modes are updated by firmware in shared
structure per interface. Kernel uses this value to display
supported link modes via ethtool.

Currently there is extra validation that firmware updated
modes are validated against internal list of supported modes.
As intenal list of supported modes are not updated frequently
new modes supported by firmware are not updated to ethtool.

Hence remove extra validation and report all firmware updated
modes.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index b906a0e..b90decf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -33,9 +33,6 @@ struct otx2_stat {
 	.index = offsetof(struct otx2_dev_stats, stat) / sizeof(u64), \
 }
 
-/* Physical link config */
-#define OTX2_ETHTOOL_SUPPORTED_MODES 0x638CCBF //110001110001100110010111111
-
 enum link_mode {
 	OTX2_MODE_SUPPORTED,
 	OTX2_MODE_ADVERTISED
@@ -1116,8 +1113,6 @@ static void otx2_get_link_mode_info(u64 link_mode_bmap,
 	};
 	u8 bit;
 
-	link_mode_bmap = link_mode_bmap & OTX2_ETHTOOL_SUPPORTED_MODES;
-
 	for_each_set_bit(bit, (unsigned long *)&link_mode_bmap, 27) {
 		/* SGMII mode is set */
 		if (bit == 0)
-- 
2.7.4

