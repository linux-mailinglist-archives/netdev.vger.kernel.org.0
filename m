Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2836C6EED9C
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbjDZFrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238440AbjDZFrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:47:53 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03472133;
        Tue, 25 Apr 2023 22:47:52 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33Q08kYg003410;
        Tue, 25 Apr 2023 22:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=JTfxwqkfeo+OZ4ivi5IkCaSG/A/YyNvJhN2rrPjPEW8=;
 b=SAsQ/CdS212bqZOv7MrWinKwZhNtPiqCXwZ4BK2yRfyXgHa5c3CFtNfNco+qxEUQsaG6
 Cmz3o3nH0vPTkiCgzZZfbS6jxw2GVFKnjegNtkdk09cfrtMG0eSrUTamkl2bzVbY5KQp
 9StRWSXlEoni+AzufkRlhBfOsPr1tEDZumIFp4XA8XC/S+25Kte9C+pJDk0my5hcUhat
 rFQ7BODXnqOcfDeQa8XlxnhEs/HSVW+DFDxe38Ku882sXgXobFzcm86al1KA2qqWAwmb
 /Chfd4zgkwjs2w8UhwAzgN7g5SVXBGQMO2+Smmk0xrepBmxvL4cdyZN0zkGFxrsxWI7d +Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3q4f3pd9jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 25 Apr 2023 22:47:40 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 25 Apr
 2023 22:47:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 25 Apr 2023 22:47:38 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id A4D383F706D;
        Tue, 25 Apr 2023 22:47:32 -0700 (PDT)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <naveenm@marvell.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
Subject: [net-next Patch v10 0/8] octeontx2-pf: HTB offload support
Date:   Wed, 26 Apr 2023 11:17:23 +0530
Message-ID: <20230426054731.5720-1-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ibm8Fwl3JPcWhFpdo5XbB73ZQN78AiVB
X-Proofpoint-GUID: Ibm8Fwl3JPcWhFpdo5XbB73ZQN78AiVB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_02,2023-04-25_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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

Patch2: Rename existing total tx queues for better readability

Patch3: defines APIs such that the driver can dynamically initialize/
        deinitialize the send queues.

Patch4: Refactors transmit alloc/free calls as preparation for QOS
        offload code.

Patch5: moves rate limiting logic to common header which will be used
        by qos offload code.

Patch6: Adds actual HTB offload support.

Patch7: exposes qos send queue stats over ethtool.

Patch8: Add documentation about htb offload flow in driver

Hariprasad Kelam (5):
  octeontx2-pf: Rename tot_tx_queues to non_qos_queues
  octeontx2-pf: Refactor schedular queue alloc/free calls
  octeontx2-pf: Prepare for QOS offload
  octeontx2-pf: ethtool expose qos stats
  docs: octeontx2: Add Documentation for QOS

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

v4 -> v5:
	  1. fix pahole reported issues
          2. add documentation for htb offload flow.

v5 -> v6:
	  1. fix synchronization issues w.r.t hlist accessing
             from ndo_select_queue with rcu lock.
          2. initialize qos related resources in device init.

v6 -> v7:
	  1. fix erros reported by sparse and clang

v7 -> v8:
	  1. cover letter header is malformed in last version.
             correct the cover letter
v8 -> v9:
	  1. fix issues reported by smatch

v9 -> v10:
         1. split the htb offload patch
         2. define helper APIs for txschq config
         3. update commit description and documentation.


 .../ethernet/marvell/octeontx2.rst            |   45 +
 .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
 .../marvell/octeontx2/af/rvu_debugfs.c        |    5 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |   45 +
 .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  121 +-
 .../marvell/octeontx2/nic/otx2_common.h       |   82 +-
 .../marvell/octeontx2/nic/otx2_ethtool.c      |   29 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  114 +-
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
 .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |   29 +-
 .../marvell/octeontx2/nic/otx2_txrx.c         |   24 +-
 .../marvell/octeontx2/nic/otx2_txrx.h         |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   14 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1363 +++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/qos.h  |   69 +
 .../ethernet/marvell/octeontx2/nic/qos_sq.c   |  296 ++++
 .../net/ethernet/mellanox/mlx5/core/en/qos.c  |    7 +-
 include/net/pkt_cls.h                         |    1 +
 net/sched/sch_htb.c                           |    7 +-
 20 files changed, 2144 insertions(+), 127 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c

--
2.17.1
