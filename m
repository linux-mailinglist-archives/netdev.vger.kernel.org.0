Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC4A531059
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiEWLyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 07:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235122AbiEWLye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 07:54:34 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A3A51587
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 04:54:33 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24NAHeDt032108;
        Mon, 23 May 2022 04:54:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=vwngwSV6lSgS1BvTSWjYPcvN1QPmGDybMx907eKx40o=;
 b=hyLw0eXR7E82qJc3KPHxJNqsFajXhfJFPYSoT9SMte5cjIkl+wYgwweLHlBufySxVe4j
 MjlsiuzRVu77BeF2X9vBwIDcBglo8Q97IOrxXws+QjWJ6Qo/GN7PtVSDLquGTl2qnffS
 8sjNt+wQJ0ds+0A5jwsH+jmNbc3dGxmbguE20Tl65PiHMVEi7Tf/a/l+Gsrl/dpJUHqw
 ya8FmeS4UTFM6hfBbUgsWlhvzyTbSrvDTIXPwawBRxF2u7xHCrUX6VNsGiRseS3FbVTz
 IaMN7Ybi26Sj+QAFxRCaHlgPiCGxFxZhgxAj0zw7r5RtCj7caqAbOFh7ag1oY+VP0muD yA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3g6ykkwmht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 May 2022 04:54:19 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 May
 2022 04:54:17 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 23 May 2022 04:54:17 -0700
Received: from localhost.localdomain (unknown [10.28.48.95])
        by maili.marvell.com (Postfix) with ESMTP id F32323F7085;
        Mon, 23 May 2022 04:54:12 -0700 (PDT)
From:   Suman Ghosh <sumang@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <gakula@marvell.com>, <Sunil.Goutham@cavium.com>,
        <hkelam@marvell.com>, <colin.king@intel.com>,
        <netdev@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net-next PATCH] octeontx2-vf: Add support for adaptive interrupt coalescing
Date:   Mon, 23 May 2022 17:24:10 +0530
Message-ID: <20220523115410.1307944-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: fr7m4Pg6IJhf_WqsEXTlAvyOLCh-18SN
X-Proofpoint-ORIG-GUID: fr7m4Pg6IJhf_WqsEXTlAvyOLCh-18SN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-23_04,2022-05-23_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethtool supported_feature flag to support adaptive interrupt
coalescing for vf(s).

Signed-off-by: Suman Ghosh <sumang@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index bc614a4def9e..3f60a80e34c8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1390,7 +1390,8 @@ static int otx2vf_get_link_ksettings(struct net_device *netdev,
 
 static const struct ethtool_ops otx2vf_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
-				     ETHTOOL_COALESCE_MAX_FRAMES,
+				     ETHTOOL_COALESCE_MAX_FRAMES |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.supported_ring_params  = ETHTOOL_RING_USE_RX_BUF_LEN |
 				  ETHTOOL_RING_USE_CQE_SIZE,
 	.get_link		= otx2_get_link,
-- 
2.25.1

