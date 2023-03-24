Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212FD6C838D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjCXRr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjCXRr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:47:26 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B761819F39;
        Fri, 24 Mar 2023 10:47:22 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OH2r7V001150;
        Fri, 24 Mar 2023 10:47:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=RQJnUV0LgzhgDRqK+teJvOHzNPq+nNWZbwxNL4URU0I=;
 b=jHVRWs/VmjGTLeTkzM98/BeFyt1mvw3PJf+tlYgDmCyc69evILXgpu+PAknBjRrR5uKY
 731PLkC7f5Bg6jJIbTlRR7Ke/NNIGl3Zzakd2KTC5fqGvDJvb2R5SKQH22br11hXpdol
 5HYPOeV6XklPKJ4FoXeUHF7q2GN2tloQUSdP1toFps/aGQHTBq8lXrLq8iIx8X10hvfS
 9Wxx4DaYclHqKRJ90jPJ/J4Gu3WNU3z7Oqg6mIF7ICNUTOB5YFmHnmQY6T+zu3HlnYNH
 qiPKf+XmRRJQ7q1jkOcOymwPa7rjIXjI5u2geRQT9BAfrltGkBJtrYnDJkA/R6DgIGbl 6Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pgxmfkdp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 10:47:14 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 24 Mar
 2023 10:47:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Fri, 24 Mar 2023 10:47:12 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 0A1923F7059;
        Fri, 24 Mar 2023 10:47:12 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v5 0/8] octeon_ep: deferred probe and mailbox
Date:   Fri, 24 Mar 2023 10:46:55 -0700
Message-ID: <20230324174704.9752-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: R5aHlj6t82mx3b1MLlUJeH5zsfunVayT
X-Proofpoint-ORIG-GUID: R5aHlj6t82mx3b1MLlUJeH5zsfunVayT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement Deferred probe, mailbox enhancements and heartbeat monitor.

v4 -> v5:
   - addressed review comments
     https://lore.kernel.org/all/20230323104703.GD36557@unreal/
     replaced atomic_inc() + atomic_read() with atomic_inc_return().

v3 -> v4:
   - addressed review comments on v3
     https://lore.kernel.org/all/20230214051422.13705-1-vburru@marvell.com/
   - 0004-xxx.patch v3 is split into 0004-xxx.patch and 0005-xxx.patch
     in v4.
   - API changes to accept function ID are moved to 0005-xxx.patch.
   - fixed rct violations.
   - reverted newly added changes that do not yet have use cases.

v2 -> v3:
   - removed SRIOV VF support changes from v2, as new drivers which use
     ndo_get_vf_xxx() and ndo_set_vf_xxx() are not accepted.
     https://lore.kernel.org/all/20221207200204.6819575a@kernel.org/

     Will implement VF representors and submit again.
   - 0007-xxx.patch and 0008-xxx.patch from v2 are removed and
     0009-xxx.patch in v2 is now 0007-xxx.patch in v3.
   - accordingly, changed title for cover letter.

v1 -> v2:
   - remove separate workqueue task to wait for firmware ready.
     instead defer probe when firmware is not ready.
     Reported-by: Leon Romanovsky <leon@kernel.org>
   - This change has resulted in update of 0001-xxx.patch and
     all other patches in the patchset.

Veerasenareddy Burru (8):
  octeon_ep: defer probe if firmware not ready
  octeon_ep: poll for control messages
  octeon_ep: control mailbox for multiple PFs
  octeon_ep: add separate mailbox command and response queues
  octeon_ep: include function id in mailbox commands
  octeon_ep: support asynchronous notifications
  octeon_ep: function id in link info and stats mailbox commands
  octeon_ep: add heartbeat monitor

 .../marvell/octeon_ep/octep_cn9k_pf.c         |  72 ++--
 .../ethernet/marvell/octeon_ep/octep_config.h |   6 +
 .../marvell/octeon_ep/octep_ctrl_mbox.c       | 276 +++++++------
 .../marvell/octeon_ep/octep_ctrl_mbox.h       |  88 ++--
 .../marvell/octeon_ep/octep_ctrl_net.c        | 387 ++++++++++++------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 196 +++++----
 .../marvell/octeon_ep/octep_ethtool.c         |  12 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   | 180 +++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  18 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   6 +
 10 files changed, 784 insertions(+), 457 deletions(-)


base-commit: 323fe43cf9aef79159ba8937218a3f076bf505af
-- 
2.36.0

