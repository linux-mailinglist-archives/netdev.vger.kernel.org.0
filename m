Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEFC2742A7
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 15:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIVNHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 09:07:49 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40266 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726573AbgIVNHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 09:07:49 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08MD6TQA021917;
        Tue, 22 Sep 2020 06:07:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=/zh/e0e62r9Fg/8OC0BZawqz430DRZoYBPCIxxCEL9c=;
 b=Rl9GhUug/RmpL7sg/uXenhW7/H2lDNY9+9fRehNhkeOFx37WPsa/ovZvncL9Mo8NqynN
 fArGbHJvQvxZXwdaCRNkIKoqx/A5S2H2PpnYvs3PorLLLvi9AukwG2PaMlw7hIiO54VI
 9xnVzeLG5Nue93Gu82zTbZeazjY3ijIckGW2TNN7vwUK+lUdFtrIvYWGzZjZnYTgmkJU
 ngaveZvXcxH9A1Y7F/3+WHFgis8+T1oUVPKi3UOS5VoDGqSw+e2ftOus25SMotTaRO08
 cUbd4ZYmyYsiEUNZgP1MWGFLn28F0YGUfjbKLY3k4tMsIt7huPUO3kmAYmZWwXKv8elv 3Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33nhgna5dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 22 Sep 2020 06:07:45 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 22 Sep
 2020 06:07:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 22 Sep 2020 06:07:44 -0700
Received: from hyd1584.caveonetworks.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 4CB7B3F703F;
        Tue, 22 Sep 2020 06:07:41 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     George Cherian <george.cherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [net-next PATCH 1/2] octeontx2-af: Add support for VLAN based RSS hashing
Date:   Tue, 22 Sep 2020 18:37:26 +0530
Message-ID: <20200922130727.2350661-2-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200922130727.2350661-1-george.cherian@marvell.com>
References: <20200922130727.2350661-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_12:2020-09-21,2020-09-22 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for PF/VF drivers to choose RSS flow key algorithm
with VLAN tag included in hashing input data. Only CTAG is considered.

Signed-off-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 8 ++++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4aaef0a2b51c..aa3bda3f34be 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -625,6 +625,7 @@ struct nix_rss_flowkey_cfg {
 #define NIX_FLOW_KEY_TYPE_INNR_UDP      BIT(15)
 #define NIX_FLOW_KEY_TYPE_INNR_SCTP     BIT(16)
 #define NIX_FLOW_KEY_TYPE_INNR_ETH_DMAC BIT(17)
+#define NIX_FLOW_KEY_TYPE_VLAN		BIT(20)
 	u32	flowkey_cfg; /* Flowkey types selected */
 	u8	group;       /* RSS context or group */
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 08181fc5f5d4..4bdc4baa3c59 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2509,6 +2509,14 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			field->ltype_match = NPC_LT_LE_GTPU;
 			field->ltype_mask = 0xF;
 			break;
+		case NIX_FLOW_KEY_TYPE_VLAN:
+			field->lid = NPC_LID_LB;
+			field->hdr_offset = 2; /* Skip TPID (2-bytes) */
+			field->bytesm1 = 1; /* 2 Bytes (Actually 12 bits) */
+			field->ltype_match = NPC_LT_LB_CTAG;
+			field->ltype_mask = 0xF;
+			field->fn_mask = 1; /* Mask out the first nibble */
+			break;
 		}
 		field->ena = 1;
 
-- 
2.25.1

