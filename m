Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69BE6C4622
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 10:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCVJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 05:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbjCVJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 05:20:15 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AF9193DB;
        Wed, 22 Mar 2023 02:20:15 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32M3vvUi020894;
        Wed, 22 Mar 2023 02:20:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=pNUT4xxe8F+3xoirRr6WYzwCH2Yn6FpdTcvJR+ZTawc=;
 b=jjQE64M2GjtlWAD5kY1k/88N0m95Ukd+qbqm/xZs0/DqLAT0y/9Pn8InVeMA5AafTkJV
 BnQwz33DZgXYmDt7bSBdb+C9ZB23t8+8lFoPoG/96yt2cg39eGgyvK3J/yPqCRyuitTE
 eYlEQ7KxJQRZ3BKV8fJCWCPt3dvWSgBmtiZBS6bIbwUOB01zQkqSbHl01euffsS18eHt
 zzur9f/5VUSBut+iCgMzXuKRetpgD0CB56R8pFU8wzuJoDQUoE8IR9bc6IXHXMF8a6KD
 pGvOPnkvEaivjAlWtJP4vno7+tWeCkbsDM9JMQCD7Zg7NrSrR+i2ukVqYPLCthE6QRR6 nw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pft7uh1rw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Mar 2023 02:20:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 22 Mar
 2023 02:20:05 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 22 Mar 2023 02:20:05 -0700
Received: from sburla-PowerEdge-T630.sclab.marvell.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 2A2A85B6932;
        Wed, 22 Mar 2023 02:20:05 -0700 (PDT)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v4 0/8] octeon_ep: deferred probe and mailbox
Date:   Wed, 22 Mar 2023 02:19:49 -0700
Message-ID: <20230322091958.13103-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: e3craRpPi-X1_NI3Vlvb5wy08hnQRltc
X-Proofpoint-ORIG-GUID: e3craRpPi-X1_NI3Vlvb5wy08hnQRltc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_06,2023-03-21_01,2023-02-09_01
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement Deferred probe, mailbox enhancements and heartbeat monitor.

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
 .../ethernet/marvell/octeon_ep/octep_main.c   | 181 +++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  18 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   6 +
 10 files changed, 785 insertions(+), 457 deletions(-)


base-commit: 56c874f7dbcab2ab5cf8055d46a2ef36dec3d664
-- 
2.36.0

