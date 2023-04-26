Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E37696EEF94
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 09:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbjDZHpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 03:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240093AbjDZHou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 03:44:50 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94D13AAB;
        Wed, 26 Apr 2023 00:44:29 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q75YDp012965;
        Wed, 26 Apr 2023 00:44:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ULQ0BrR7wzq3hufaukTzQqwThQaxiFl+ufv1LiMejOQ=;
 b=CYW4UEhKR1tyYydOiw8f29CDcJjPYLdr2z32PlfjHRJR1Qg0IfHK+IAwfgn8ewBPQiN2
 QvE7y5LRLIVI8pmZptgS9Af0dcCW3xrIuDmXbB6rXRRSjsTrnB7SwfL/FXUObdhIP0ts
 0Bby6z5NIuywpH+GaBYQnkbHr5muPA8+UfzWmSbj1VtJ2etcRww6tvDdTgmBWX5rnZvA
 YDqbC6xkYdUQH6B/OT1MMutWZs5d9ehP3b4RWR6Fsq8OnTy8r3uj28RodH6xqtwpRx1X
 We4b6NPqqsPhdNRoKReW2emCeaxwwrK6SOy/z07C0se65pTBpsgV2eXVAPCUqRSPKBov IA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3q6c2fdd4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 00:44:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Wed, 26 Apr
 2023 00:44:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Wed, 26 Apr 2023 00:44:21 -0700
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 235455B692A;
        Wed, 26 Apr 2023 00:44:16 -0700 (PDT)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <simon.horman@corigine.com>,
        <leon@kernel.org>, <sgoutham@marvell.com>, <gakula@marvell.com>,
        <lcherian@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>
CC:     Suman Ghosh <sumang@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH v4 06/10] octeontx2-af: Update correct mask to filter IPv4 fragments
Date:   Wed, 26 Apr 2023 13:13:41 +0530
Message-ID: <20230426074345.750135-7-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230426074345.750135-1-saikrishnag@marvell.com>
References: <20230426074345.750135-1-saikrishnag@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 1JXJAv1ZH1Ck31ZKlhiSvcgWjlE7kbqL
X-Proofpoint-ORIG-GUID: 1JXJAv1ZH1Ck31ZKlhiSvcgWjlE7kbqL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-26_01,2023-02-09_01
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

