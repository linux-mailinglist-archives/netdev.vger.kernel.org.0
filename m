Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99C156D93D5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 12:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbjDFKVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 06:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236189AbjDFKVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 06:21:31 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29EBA3C38;
        Thu,  6 Apr 2023 03:21:30 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3365ZOvF017988;
        Thu, 6 Apr 2023 03:21:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=UwaiQtkl+qbIlhH6TYmo7NQvDfY7VKhSRVBjO/W/A9E=;
 b=EAnVcH6YhO81NVx1a9VC/CNMRAy/FraYJUDsHMSpMKOQybHTsVtqNoo3Q3eIr7z795L/
 CdR6QUMZpf9iMQ+5i1xVItljOR2R3TSKOzlib8ZqR3OHX3f92tuhbuWvTV7wCBNeMNcj
 Cpar4NGYpKRvoxKGGGx6mEmoWcKqVwAYwICbmAcfIzEA30qQGm9Sc0xZloV3ci0KMrua
 N1nXV+ugyKYYUXrK51HWxYLrcKUnS0fGdBRe5LuuRrQRHqvaofQt2bklO+ztXysnbEGd
 KDqJFTsfUEBxOajety9Jjqvt5eqC8jMC7I69KVX2pgyZjnUes5xsVX1PHWyUQC4Q0Pdy qQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3psr2e1ckd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 06 Apr 2023 03:21:17 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 6 Apr
 2023 03:21:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 6 Apr 2023 03:21:16 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 391D73F707C;
        Thu,  6 Apr 2023 03:21:09 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>
Subject: [net-next Patch v6 1/6] sch_htb: Allow HTB priority parameter in offload mode
Date:   Thu, 6 Apr 2023 15:50:58 +0530
Message-ID: <20230406102103.19910-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406102103.19910-1-hkelam@marvell.com>
References: <20230406102103.19910-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8iJXHTOEA7Yj8uXQYV6pyE9Leavc8C7o
X-Proofpoint-ORIG-GUID: 8iJXHTOEA7Yj8uXQYV6pyE9Leavc8C7o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_04,2023-04-06_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 7 ++++++-
 include/net/pkt_cls.h                            | 1 +
 net/sched/sch_htb.c                              | 7 +++----
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
index 2842195ee548..1874c2f0587f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
@@ -379,6 +379,12 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv, struct tc_htb_qopt_offload *htb_
 	if (!htb && htb_qopt->command != TC_HTB_CREATE)
 		return -EINVAL;
 
+	if (htb_qopt->prio) {
+		NL_SET_ERR_MSG_MOD(htb_qopt->extack,
+				   "prio parameter is not supported by device with HTB offload enabled.");
+		return -EOPNOTSUPP;
+	}
+
 	switch (htb_qopt->command) {
 	case TC_HTB_CREATE:
 		if (!mlx5_qos_is_supported(priv->mdev)) {
@@ -515,4 +521,3 @@ int mlx5e_mqprio_rl_get_node_hw_id(struct mlx5e_mqprio_rl *rl, int tc, u32 *hw_i
 	*hw_id = rl->leaves_id[tc];
 	return 0;
 }
-
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index b3b5b0b62f16..a2ea45c7b53e 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -868,6 +868,7 @@ struct tc_htb_qopt_offload {
 	u16 qid;
 	u64 rate;
 	u64 ceil;
+	u8 prio;
 };
 
 #define TC_HTB_CLASSID_ROOT U32_MAX
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 92f2975b6a82..1cd9b48c96cd 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1814,10 +1814,6 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
 			goto failure;
 		}
-		if (hopt->prio) {
-			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
-			goto failure;
-		}
 	}
 
 	/* Keeping backward compatible with rate_table based iproute2 tc */
@@ -1913,6 +1909,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 					TC_HTB_CLASSID_ROOT,
 				.rate = max_t(u64, hopt->rate.rate, rate64),
 				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+				.prio = hopt->prio,
 				.extack = extack,
 			};
 			err = htb_offload(dev, &offload_opt);
@@ -1933,6 +1930,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 					TC_H_MIN(parent->common.classid),
 				.rate = max_t(u64, hopt->rate.rate, rate64),
 				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+				.prio = hopt->prio,
 				.extack = extack,
 			};
 			err = htb_offload(dev, &offload_opt);
@@ -2018,6 +2016,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 				.classid = cl->common.classid,
 				.rate = max_t(u64, hopt->rate.rate, rate64),
 				.ceil = max_t(u64, hopt->ceil.rate, ceil64),
+				.prio = hopt->prio,
 				.extack = extack,
 			};
 			err = htb_offload(dev, &offload_opt);
-- 
2.17.1

