Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA04547B45
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 19:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiFLRrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 13:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbiFLRp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 13:45:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AAA9E09B;
        Sun, 12 Jun 2022 10:45:58 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25CHSRvd020600;
        Sun, 12 Jun 2022 10:45:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=TBIPbzxD7kc229QvcY1UGspi3OGvEQf1TJ7KwV9roeo=;
 b=XFp6gJV4wg+Xra/0xxN3DXnBaQbkO3kyIAOa35+Qzi9zebR2gbh5uqCbqZlokYJWndKM
 V6aVSo1ScVj1U/bRZ+P55Ao3Ohnw40jetybKnyud++Gpps5UXIy1SW9lnNTS3JAf1CRB
 ZB/vvc/ctKwThY/tGeIHCxI8Y4aXfYez1YF8HXmHw5Ne8YvBfwOIgb5s+NKPDAQ6gOG0
 pvpJifu+w5gShChLdTJpRCOydFiDiyAelgf8qIsVc3p/zWpX6EnV8ZpW+NQLMLAS8T5H
 5y3stdNZDjKlWsHFeNu6T7k5+RDFfZHpz/6p/PGmtAe9H5DyxSXDOntTF6LfPRH1MClb pA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3gmtjnubj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 12 Jun 2022 10:45:45 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 12 Jun
 2022 10:45:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Sun, 12 Jun 2022 10:45:43 -0700
Received: from localhost.localdomain (unknown [10.28.48.95])
        by maili.marvell.com (Postfix) with ESMTP id CBF333F7070;
        Sun, 12 Jun 2022 10:45:39 -0700 (PDT)
From:   Suman Ghosh <sumang@marvell.com>
To:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Suman Ghosh <sumang@marvell.com>
Subject: [net PATCH] octeontx2-vf: Add support for adaptive interrupt coalescing
Date:   Sun, 12 Jun 2022 23:15:36 +0530
Message-ID: <20220612174536.2403843-1-sumang@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: FvX9vWXhLoVBxW2js_lyOXMGFHEI5IUZ
X-Proofpoint-ORIG-GUID: FvX9vWXhLoVBxW2js_lyOXMGFHEI5IUZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-12_08,2022-06-09_02,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 6e144b47f560 (octeontx2-pf: Add support for adaptive interrupt coalescing)
Added support for VF interfaces as well.

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

