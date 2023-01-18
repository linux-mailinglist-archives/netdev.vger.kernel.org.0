Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02E3D671A9F
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjARLbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjARLbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:31:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A513267979;
        Wed, 18 Jan 2023 02:51:25 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8gARB008715;
        Wed, 18 Jan 2023 02:51:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=qs0V0ygpj5cc1VQW8u1I085voWCcRSynlhyT7DTfW54=;
 b=cXY6ZiLtf7wj17LJyieIAwzoQBmpi8Oj/NVt1/cngLeOOU+WOsFoADCTySFJQA8LNZTq
 Jc7DaVg4vQOkXFM8VKF1Df/Vb907BvIrp7mch3efH3oxNg28Hr67ztyk3iStosWYrTow
 NX4OfOgUsW+pcnVHBEfnTk6GWHeNVIKx2S6i2YVshpzoQl7Ma4aNiMhKjleT9suecBH6
 tlZrJRr3gyyekqcF0WX0HZ8TqLM+V7DhPEHcXz/sDsKVxTe8NrsP3p6sWCIRM846I8A1
 g+9B7E/xtoZzyEER1g3y8vKHM0edJT4mLHNBsYsNnH6HinP351hmm5U7PFzLbPPvfVXi oA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n3vstggsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 02:51:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 02:51:13 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 02:51:13 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 532375B6938;
        Wed, 18 Jan 2023 02:51:08 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <tariqt@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <maxtram95@gmail.com>
Subject: [net-next Patch v2 0/5] octeontx2-pf: HTB offload support
Date:   Wed, 18 Jan 2023 16:21:02 +0530
Message-ID: <20230118105107.9516-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ldkt2GmoDndztXPnsG6r-CgQaWc0OkTI
X-Proofpoint-GUID: ldkt2GmoDndztXPnsG6r-CgQaWc0OkTI
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

octeontx2 silicon and CN10K transmit interface consists of five
transmit levels starting from MDQ, TL4 to TL1. Once packets are
submitted to MDQ, hardware picks all active MDQs using strict
priority, and MDQs having the same priority level are chosen using
round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
Each level contains an array of queues to support scheduling and
shaping.

As HTB supports classful queuing mechanism by supporting rate and
ceil and allow the user to control the absolute bandwidth to
particular classes of traffic the same can be achieved by
configuring shapers and schedulers on different transmit levels.

This series of patches adds support for HTB offload,

Patch1: Allow strict priority parameter in HTB offload mode.

Patch2: defines APIs such that the driver can dynamically initialize/
        deinitialize the send queues.

Patch3: Refactors transmit alloc/free calls as preparation for QOS
        offload code.

Patch4: Adds devlink support for the user to configure round-robin
        priority at TL1

Hariprasad Kelam (2):
  octeontx2-pf: Refactor schedular queue alloc/free calls
  octeontx2-pf: Add devlink support to configure TL1 RR_PRIO

Naveen Mamindlapalli (2):
  sch_htb: Allow HTB priority parameter in offload mode
  octeontx2-pf: Add support for HTB offload

Subbaraya Sundeep (1):
  octeontx2-pf: qos send queues management

V2 * ensure other drivers won't effect by allowing 'prio'
     parameter in htb offload mode.

 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |    9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   15 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |    1 +
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   84 +-
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  115 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   30 +-
 .../marvell/octeontx2/nic/otx2_devlink.c      |   84 +
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   93 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   27 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |    8 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1547 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   71 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  304 ++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |    6 +
 include/net/pkt_cls.h                         |    1 +
 net/sched/sch_htb.c                           |    7 +-
 23 files changed, 2378 insertions(+), 87 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1
