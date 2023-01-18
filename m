Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993A56719CD
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjARK5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:57:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjARKz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:55:26 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95575B448;
        Wed, 18 Jan 2023 02:04:30 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30I8RGFH007732;
        Wed, 18 Jan 2023 02:04:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=qs0V0ygpj5cc1VQW8u1I085voWCcRSynlhyT7DTfW54=;
 b=CfjhKGMlhnX6GxwBofzgsfaJ9IvYEEDdcIZWYhNZYY2BuUnJH4yDaFTGZa4nsGn+3DYh
 kYjy+pCzk5xuv8R+nqdfogcMXdQE7KNT7CKxWOAzu9VCys+tR4V/2ZfXQtOd8bbSXOQq
 TEjSZRRx4tgVtaBArbCRweLAHeGAEjQN1tlyNlM+ZATo6qBEjKxz1VVV03saSAPvHpkX
 enwy6yHWslYbjzwx7nN+Wr8EWdrwofB1UFtpdeh2EcvMMrncaEp+Bd+L8rZeN1uesyUO
 obbyFu4kvg6pwIxett0jUp1cNpI7k0M7nqnxCjlc107j1flmNmKNhdEsCUo8n8KT6RQ8 3w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n6avbgxb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 02:04:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 02:04:18 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 18 Jan 2023 02:04:18 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 502335B6934;
        Wed, 18 Jan 2023 02:04:11 -0800 (PST)
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
Subject: [net-next Patch v2 0/5] octeontx2-pf: HTB offload support
Date:   Wed, 18 Jan 2023 15:34:05 +0530
Message-ID: <20230118100410.8834-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: Ha7PSWKm-eWmsDYMZpPpQ7Y9nCNqWVRt
X-Proofpoint-ORIG-GUID: Ha7PSWKm-eWmsDYMZpPpQ7Y9nCNqWVRt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_04,2023-01-17_01,2022-06-22_01
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
