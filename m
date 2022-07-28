Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92040583EFF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 14:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbiG1Mi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 08:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238100AbiG1Mi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 08:38:28 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8356B26F;
        Thu, 28 Jul 2022 05:38:26 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SA1B2m017495;
        Thu, 28 Jul 2022 05:38:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=2sQdxStA3QWW1aB1U5UjG5US9bN5e+V57BQhpz6KBfg=;
 b=Da5s7EbfEENcj58BgipV6q2dRx4hNC+0DWTeBPJakDoRS+vKm2BZO1xja9L4VFk4rtlW
 pzvjXpn6gPVlHDLZFz85p5dSELjr7a8oQMSLVqLkr+y5eVlfKRq5D6seLqrganyVQcIT
 Y5GoyOoq2mqt/X80WqVKqpfb3iI3dgqdbgvvjlC8t0/l8Ag5/cNNyUNlrmQaxjC3Sb4V
 4ipUHxjKfoInwSwdSiH5wzPKBXkg11PmteR327I+ksexEjbKx/LYoi5ElTVY5mEenDiB
 /za2C790cbKjx4HV63UpqmugLZM3oNAC2dv0U09THcZjY3DN8+kZ4agAeOtW2j3rv0Sa oQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hk2fyd81u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 05:38:20 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 28 Jul
 2022 05:38:18 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 28 Jul 2022 05:38:18 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id 674503F707E;
        Thu, 28 Jul 2022 05:38:15 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH] octeontx2-pf: Reduce minimum mtu size to 60
Date:   Thu, 28 Jul 2022 18:08:12 +0530
Message-ID: <20220728123812.21974-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ij0PEEoWAndal1sKskURdSnKHJiKUy1g
X-Proofpoint-GUID: ij0PEEoWAndal1sKskURdSnKHJiKUy1g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_05,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

PTP messages like SYNC, FOLLOW_UP, DELAY_REQ are of size 58 bytes.
Using a minimum packet length as 64 makes NIX to pad 6 bytes of
zeroes while transmission. This is causing latest ptp4l application to
emit errors since length in PTP header and received packet are not same.
Padding upto 3 bytes is fine but more than that makes ptp4l to assume
the pad bytes as a TLV. Hence reduce the size to 60 from 64.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
index c88e8a436029..fbe62bbfb789 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.h
@@ -21,7 +21,7 @@
 #define OTX2_HEAD_ROOM		OTX2_ALIGN
 
 #define	OTX2_ETH_HLEN		(VLAN_ETH_HLEN + VLAN_HLEN)
-#define	OTX2_MIN_MTU		64
+#define	OTX2_MIN_MTU		60
 
 #define OTX2_MAX_GSO_SEGS	255
 #define OTX2_MAX_FRAGS_IN_SQE	9
-- 
2.16.5

