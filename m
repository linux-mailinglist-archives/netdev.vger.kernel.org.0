Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15FD2BA660
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgKTJjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:39:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4574 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgKTJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:39:17 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AK9UASt020771;
        Fri, 20 Nov 2020 01:39:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=G2f15KFVOaWO/tmiYun8n2G9uCpaD/m5NpwG8IPRrZ4=;
 b=U+ByMwkjTzWwzI4Bg40yZpbJagXNn/PxWD9PI/A0fyr/qsEztxTfsRUVYeldFrXhPhvk
 4F8kUJLAl6Vsl4BNHW5Km3sL2Lsu8RGmWaA+WW117XUe8484/UbqtK/oSShL4KFapB6G
 C917y6pcrYOK5OQTaADCi77WBGlZsD5ps9ol41EZWhhDyF9zszfeksebKh2s0eZVuppH
 2C3fNDqbZSqIe49q875ymasAudl7BtCUrapED79JuA+Ap0elPcctkr8d/QPSy2rH1WKb
 FR14z518MNITPyVJ8QMnS5F1lEsDlaod0o+9ndjYHQf2bnfqZ8nHqfuculTmy/g9R4f0 AQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34w7ncyk3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 20 Nov 2020 01:39:13 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 01:39:11 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 20 Nov
 2020 01:39:11 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 20 Nov 2020 01:39:11 -0800
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id E530E3F7040;
        Fri, 20 Nov 2020 01:39:07 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>
Subject: [PATCH] octeontx2-af: Add support for RSS hashing based on Transport protocol field
Date:   Fri, 20 Nov 2020 15:09:06 +0530
Message-ID: <20201120093906.2873616-1-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_04:2020-11-19,2020-11-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to choose RSS flow key algorithm with IPv4 transport protocol
field included in hashing input data. This will be enabled by default.
There-by enabling 3/5 tuple hash

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h         | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c      | 7 +++++++
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index f46de8419b77..97c8566b7da8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -644,6 +644,7 @@ struct nix_rss_flowkey_cfg {
 #define NIX_FLOW_KEY_TYPE_INNR_SCTP     BIT(16)
 #define NIX_FLOW_KEY_TYPE_INNR_ETH_DMAC BIT(17)
 #define NIX_FLOW_KEY_TYPE_VLAN		BIT(20)
+#define NIX_FLOW_KEY_TYPE_IPV4_PROTO	BIT(21)
 	u32	flowkey_cfg; /* Flowkey types selected */
 	u8	group;       /* RSS context or group */
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8bac1dd3a1c2..ef016521b277 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2429,6 +2429,13 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			/* This should be set to 1, when SEL_CHAN is set */
 			field->bytesm1 = 1;
 			break;
+		case NIX_FLOW_KEY_TYPE_IPV4_PROTO:
+			field->lid = NPC_LID_LC;
+			field->hdr_offset = 9; /* offset */
+			field->bytesm1 = 0; /* 1 byte */
+			field->ltype_match = NPC_LT_LC_IP;
+			field->ltype_mask = 0xF;
+			break;
 		case NIX_FLOW_KEY_TYPE_IPV4:
 		case NIX_FLOW_KEY_TYPE_INNR_IPV4:
 			field->lid = NPC_LID_LC;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 9f3d6715748e..2ab927408656 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -355,7 +355,8 @@ int otx2_rss_init(struct otx2_nic *pfvf)
 	rss->flowkey_cfg = rss->enable ? rss->flowkey_cfg :
 			   NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6 |
 			   NIX_FLOW_KEY_TYPE_TCP | NIX_FLOW_KEY_TYPE_UDP |
-			   NIX_FLOW_KEY_TYPE_SCTP | NIX_FLOW_KEY_TYPE_VLAN;
+			   NIX_FLOW_KEY_TYPE_SCTP | NIX_FLOW_KEY_TYPE_VLAN |
+			   NIX_FLOW_KEY_TYPE_IPV4_PROTO;
 
 	ret = otx2_set_flowkey_cfg(pfvf);
 	if (ret)
-- 
2.25.1

