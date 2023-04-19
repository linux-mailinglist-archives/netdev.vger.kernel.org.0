Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1956E7316
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjDSGVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjDSGVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:21:39 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003346E8E;
        Tue, 18 Apr 2023 23:21:06 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J49asc013387;
        Tue, 18 Apr 2023 23:20:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ULQ0BrR7wzq3hufaukTzQqwThQaxiFl+ufv1LiMejOQ=;
 b=LKmlLBk2ohuFAG0EwSC2kKscLz9TXbSVbKQuajD0VevIh55ni7laN/INHgk7AQ0SV8ZJ
 vvOIw1yNYsdhyHbFY1uc5R0kjG53leE3ouD3mJmWmT+RbAol1EImfeAQcN7f7N7mOica
 /5EA1fY/Orng6fA1yodgaKqo8o18tc+Ei7Okv178GDviKPn8wKaQkT0QPwlDbol8J3hi
 SKc9OWKj0fmPrJSHbGcLUlJ5iBm5sqm+G44f7kIRvakFHpb1LNhiqQVCLK8/cng6JCjx
 jMbgq/IVbocXLwdbnUE7PX1i9C1RYRNd4rZwoyqnlUrkWF/Y6tmsWK8C/Z/mvQH2XF+F 0g== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q2917rjt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Apr 2023 23:20:58 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 18 Apr
 2023 23:20:56 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 18 Apr 2023 23:20:56 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 7731E3F7055;
        Tue, 18 Apr 2023 23:20:51 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Suman Ghosh <sumang@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v3 06/10] octeontx2-af: Update correct mask to filter IPv4 fragments
Date:   Wed, 19 Apr 2023 11:50:14 +0530
Message-ID: <20230419062018.286136-7-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419062018.286136-1-saikrishnag@marvell.com>
References: <20230419062018.286136-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: EHK2-thx-_qVw4UfISoBy78ObPzNSIUl
X-Proofpoint-ORIG-GUID: EHK2-thx-_qVw4UfISoBy78ObPzNSIUl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_02,2023-04-18_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Suman Ghosh <sumang@marvell.com>

During the initial design, the IPv4 ip_flag mask was set to 0xff.
Which results to filter only fragmets with (fragment_offset == 0).
As part of the fix, updated the mask to 0x20 to filter all the
fragmented packets irrespective of the fragment_offset value.

Fixes: c672e3727989 ("octeontx2-pf: Add support to filter packet based on IP fragment")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 044cc211424e..8392f63e433f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -544,7 +544,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
 			if (ntohs(flow_spec->etype) == ETH_P_IP) {
 				flow_spec->ip_flag = IPV4_FLAG_MORE;
-				flow_mask->ip_flag = 0xff;
+				flow_mask->ip_flag = IPV4_FLAG_MORE;
 				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
 			} else if (ntohs(flow_spec->etype) == ETH_P_IPV6) {
 				flow_spec->next_header = IPPROTO_FRAGMENT;
-- 
2.25.1

