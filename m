Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37063667D73
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbjALSFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239903AbjALSEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:04:47 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2BE17E17;
        Thu, 12 Jan 2023 09:31:56 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C9dqqV021081;
        Thu, 12 Jan 2023 09:31:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Vba5hKsngwoVBT0yo2mCNI34NkgLVaMYA8lRyrGgcf4=;
 b=k5gMcyaw8/R06gi+rz2U8EOGPRm6ZmDoBEDOzFY/2464B/+pASSeDVqrL85RFZ02LM6i
 i7+/DsGAcu8YvqPu3mF0N5rUM7G4mgS8cSBCaA+Fdo7tdLq+qfXD0twmsxpj1Skt4Uda
 p0iGeEm+GGabrQDS5j1Q9S/BDCEUlzgQjtn5fsi8XczbBeaaOxQ/nukgz5JqicbqvaX4
 /s3EYhld/4bYmVvBJJZ5HIc5oNm4JbPEc2okb04tVNwj6xyQWieDZ78DrxrEL9waCK9d
 uq0bv/vRcXUA4xTDeQJDse3V795DI+9IGPS4d1DO5VAZq0G99sNceZEl2S4raA5k85kT 0w== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k57198y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Jan 2023 09:31:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 12 Jan
 2023 09:31:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Thu, 12 Jan 2023 09:31:45 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 550213F7075;
        Thu, 12 Jan 2023 09:31:41 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>,
        "Naveen Mamindlapalli" <naveenm@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: [net-next PATCH 1/5] sch_htb: Allow HTB priority parameter in offload mode
Date:   Thu, 12 Jan 2023 23:01:16 +0530
Message-ID: <20230112173120.23312-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230112173120.23312-1-hkelam@marvell.com>
References: <20230112173120.23312-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: KXRaqFHfvbfP4JVZmb9yrOezFWgRU36-
X-Proofpoint-GUID: KXRaqFHfvbfP4JVZmb9yrOezFWgRU36-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_10,2023-01-12_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naveen Mamindlapalli <naveenm@marvell.com>

The current implementation of HTB offload returns the EINVAL error
for unsupported parameters like prio and quantum. This patch removes
the error returning checks for 'prio' parameter and populates its
value to tc_htb_qopt_offload structure such that driver can use the
same.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 include/net/pkt_cls.h | 1 +
 net/sched/sch_htb.c   | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 4cabb32a2ad9..02afb1baf39d 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -864,6 +864,7 @@ struct tc_htb_qopt_offload {
 	u16 qid;
 	u64 rate;
 	u64 ceil;
+	u8 prio;
 };
 
 #define TC_HTB_CLASSID_ROOT U32_MAX
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 2238edece1a4..f2d034cdd7bd 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1806,10 +1806,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
 			goto failure;
 		}
-		if (hopt->prio) {
-			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
-			goto failure;
-		}
 	}
 
 	/* Keeping backward compatible with rate_table based iproute2 tc */
@@ -1905,6 +1901,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 					TC_HTB_CLASSID_ROOT,
 				.rate = max_t(u64, hopt->rate.rate, rate64),
 				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+				.prio = hopt->prio,
 				.extack = extack,
 			};
 			err = htb_offload(dev, &offload_opt);
@@ -1925,6 +1922,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 					TC_H_MIN(parent->common.classid),
 				.rate = max_t(u64, hopt->rate.rate, rate64),
 				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+				.prio = hopt->prio,
 				.extack = extack,
 			};
 			err = htb_offload(dev, &offload_opt);
@@ -2010,6 +2008,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 				.classid = cl->common.classid,
 				.rate = max_t(u64, hopt->rate.rate, rate64),
 				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+				.prio = hopt->prio,
 				.extack = extack,
 			};
 			err = htb_offload(dev, &offload_opt);
-- 
2.17.1

