Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C49C6DAC9A
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 14:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240764AbjDGMY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 08:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240748AbjDGMYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 08:24:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754289EE5;
        Fri,  7 Apr 2023 05:24:19 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337AwmfO000614;
        Fri, 7 Apr 2023 05:24:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=r5iQOyecge+mIAqmb5xI+ZhCpEcoa0uCD3OrB1FbqPQ=;
 b=IlOMHZ6Hl+rM08co9ysg2r0HKO156U0j3Q87KA1HqSr4O78aSt0Udjx5nc6pRkddKiCG
 h20ROaoyELkwk8sZju5vhe1i/77f8n5YYoTy2cfgbqpSjUE1wW4MzUyQaggUfRPQtfn4
 VMSjAAjSCjdsaK3pzfSuDYaowuysJ2Z927kkQd2njuoBuwZh6GrgjAPwNvaDSz33tgQN
 mkdET8FhtNOqibV2+ZMDFavc7Y3b/OMIa49OPw+t+z67zoX4qWcdNTmJCHBYSBbNhN2/
 SbozRgjMC0nsb6mQVHjBB/Dchtv3JztIJMfty35DEubmCROldZcJjV97EeepNJ38Sfsv Gg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pthvw88qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Apr 2023 05:24:13 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 7 Apr
 2023 05:24:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 7 Apr 2023 05:24:11 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 73DED3F7060;
        Fri,  7 Apr 2023 05:24:07 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <richardcochran@gmail.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Suman Ghosh <sumang@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v2 4/7] octeontx2-af: Update correct mask to filter IPv4 fragments
Date:   Fri, 7 Apr 2023 17:53:41 +0530
Message-ID: <20230407122344.4059-5-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230407122344.4059-1-saikrishnag@marvell.com>
References: <20230407122344.4059-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _Zjzh5fTO8GzjSKuJUmGChikr8j2uS0A
X-Proofpoint-GUID: _Zjzh5fTO8GzjSKuJUmGChikr8j2uS0A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_08,2023-04-06_03,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

