Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95956719D0
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjARK5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:57:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjARKzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:55:39 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC8D5CE44;
        Wed, 18 Jan 2023 02:04:36 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I9uxjJ029997;
        Wed, 18 Jan 2023 02:04:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=y1grzq7R9RDVjtctRgb/VN3YQCLX4mIMdl3YjdWZcCI=;
 b=bn9Z3gpFV1CLmOR2mpuRuVSEQShAEasPpZq90h7zkyM3aVmE3XqOZB1+O/iGIsKix7+2
 uIkpdJkB/yjdfiXuhFHTpy38Y26Cx2Zxv4wbBG49hhBSxOqaj5gpBw632FNMiCado5dg
 v0efDzOeLrBpj1V15HbEl0L2hGmqpnc+pka6ez4XC2JF278agOPxqyw0dbWXgBaDfn6W
 LO9VpxGrR+BdFpLzEmzvGdO7KXpb1WG0m5wHkqgo9MhTE7dSt4oUZLg46gYdEPPdDJmS
 ogA1r+BqOg1IrYIb2Cs78SjJUErsh2zIozcyYtXwnRNMDDE1ahjXd57Ia8efT1gU2ept qA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstgarp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 02:04:25 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 02:04:23 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 02:04:23 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 63D165B6947;
        Wed, 18 Jan 2023 02:04:17 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <maximmi@nvidia.com>, <tariqt@nvidia.com>, <moshet@nvidia.com>,
        <linux-rdma@vger.kernel.org>, <maxtram95@gmail.com>
Subject: [net-next Patch v2 1/5] sch_htb: Allow HTB priority parameter in offload mode
Date:   Wed, 18 Jan 2023 15:34:06 +0530
Message-ID: <20230118100410.8834-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118100410.8834-1-hkelam@marvell.com>
References: <20230118100410.8834-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4ldRqT51klEvFuu06I3huCWnxWttyKO7
X-Proofpoint-GUID: 4ldRqT51klEvFuu06I3huCWnxWttyKO7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-18_01,2022-06-22_01
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

Add prio parameter check in mlx5 driver, as mlx5 devices are not capable
of supporting the prio parameter when htb offload is used. Report error
if prio parameter is set to a non-default value.

Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
v2*  ensure other drivers won't effect by allowing 'prio'
     parameter in htb offload mode


 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 6 ++++++
 include/net/pkt_cls.h                            | 1 +
 net/sched/sch_htb.c                              | 7 +++----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 2842195ee548..e16b3d6ea471 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -379,6 +379,12 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb_
 	if (!htb && htb_qopt->command != TC_HTB_CREATE)
 		return -EINVAL;

+	if (htb_qopt->prio) {
+		NL_SET_ERR_MSG(htb_qopt->extack,
+			       "prio parameter is not supported by device with HTB offload enabled.");
+		return -EINVAL;
+	}
+
 	switch (htb_qopt->command) {
 	case TC_HTB_CREATE:
 		if (!mlx5_qos_is_supported(priv->mdev)) {
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
