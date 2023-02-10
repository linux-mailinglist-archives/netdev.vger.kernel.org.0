Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AC9691DBB
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbjBJLLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbjBJLLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:11:20 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7436B70CC0;
        Fri, 10 Feb 2023 03:11:19 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AB22Xc025691;
        Fri, 10 Feb 2023 03:11:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=JAuLymnNE/u5iGZm4nsypW2ETFfa16v3l6QcgBBvYnM=;
 b=BCZCbizSxau995RDANdlKipgsYGJysthJdZQ5OIEJA2W7ns+sz6pBFf3E/toDzmiIsrG
 2Q6gGwVFtRXg2KiaCVkju2ETPbdENzF7MFbVMrAXyfd22LXFfmpvn5XD6Az78Y/Ydqmc
 3y6j9N4eK6Ggd5XcpLjPCl5ulJjC8xMy5as1fqbwhYn1V8mS56d/AeYyY1tKGLPgagIh
 /c+clCCitE2HEJDGDYT3jjAoB3akYqaS0ZCylgO3ThlL+tx5DiYN1pFNoXYg71b3lSFy
 iynGfkKAL8tLt2J076jDYs+CbtGxD+QD7ebQ2I8NUFgRT8Xz640fxemV+2B4kRNvQfo5 Kg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3nnf7wgqka-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 03:11:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 10 Feb
 2023 03:10:59 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 10 Feb 2023 03:10:59 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 11D715B6939;
        Fri, 10 Feb 2023 03:10:52 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <saeedm@nvidia.com>, <richardcochran@gmail.com>,
        <tariqt@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <maxtram95@gmail.com>, <naveenm@marvell.com>,
        <bpf@vger.kernel.org>, <hariprasad.netdev@gmail.com>
Subject: [net-next Patch V4 0/4] octeontx2-pf: HTB offload support
Date:   Fri, 10 Feb 2023 16:40:47 +0530
Message-ID: <20230210111051.13654-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: X_egeSChvYkVjMM1dHctWy1udNcOsTPL
X-Proofpoint-GUID: X_egeSChvYkVjMM1dHctWy1udNcOsTPL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_06,2023-02-09_03,2023-02-09_01
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

Patch4:  Adds actual HTB offload support.


Hariprasad Kelam (1):
  octeontx2-pf: Refactor schedular queue alloc/free calls

Naveen Mamindlapalli (2):
  sch_htb: Allow HTB priority parameter in offload mode
  octeontx2-pf: Add support for HTB offload

Subbaraya Sundeep (1):
  octeontx2-pf: qos send queues management
-----
v1 -> v2 :
          ensure other drivers won't affect by allowing 'prio'
          a parameter in htb offload mode.

v2 -> v3 :
          1. discard patch supporting devlink to configure TL1 round
             robin priority
          2. replace NL_SET_ERR_MSG with NL_SET_ERR_MSG_MOD
          3. use max3 instead of using max couple of times and use a better
             naming convention in send queue management code.

v3 -> v4:
	  1. fix sparse warnings.
	  2. release mutex lock in error conditions.
          2. reuse "dev_reset_queue" instead defining new function.


 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   45 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  113 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   36 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  102 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   25 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   13 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1541 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   71 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  304 ++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |    7 +-
 include/net/pkt_cls.h                         |    1 +
 include/net/sch_generic.h                     |    2 +
 net/sched/sch_generic.c                       |    5 +-
 net/sched/sch_htb.c                           |    7 +-
 21 files changed, 2239 insertions(+), 96 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1
