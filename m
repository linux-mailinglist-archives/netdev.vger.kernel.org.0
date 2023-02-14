Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E24E695846
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 06:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbjBNFOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 00:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbjBNFOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 00:14:38 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCC1BF2;
        Mon, 13 Feb 2023 21:14:35 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31E53xVr028880;
        Mon, 13 Feb 2023 21:14:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=VYp/ltTgpWw6V+wPn06oK92AoTI1Qa86+6m9ovxIVIM=;
 b=TkQj+YMk5YB0PSDN4h9wlmoTL0FZSXv625UDHI/lOYawKVfD1JrRSZEqtaqxi8SDIRgh
 D9CjHWVYbLu91SonvEgqn0UyhFyCGIZa0/8iOxY/1+ye9hqVsmL631WSdTKsWUgI2Uhz
 zENn8KRDn4DWFrmsScsGS7stPLreajnWfS+6mUH+Zrh3ZqKDv0wSGLwU0iXBvD7KrX6K
 GOJYbQnmLlBhViDJqNFffxyYrCj2e2PyHKVY38i8KGLqiFWDHxFdIiP9iY4DOQ2H/5y0
 S7yHEfNxTWeYQlGUOZRIDnU0uXriYFsINplDHsvaYZB53lSdyj1FTEHZ/Ws4gcdEzKhV +A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98upmp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 13 Feb 2023 21:14:29 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 13 Feb
 2023 21:14:27 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 13 Feb 2023 21:14:27 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 14B4E3F706F;
        Mon, 13 Feb 2023 21:14:27 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <aayarekar@marvell.com>, <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v3 0/7] octeon_ep: deferred probe and mailbox
Date:   Mon, 13 Feb 2023 21:14:15 -0800
Message-ID: <20230214051422.13705-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _uTJnwsi-_Xi0wL4gWtQtidFDX3AM77P
X-Proofpoint-ORIG-GUID: _uTJnwsi-_Xi0wL4gWtQtidFDX3AM77P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-14_03,2023-02-13_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement Deferred probe, mailbox enhancements and heartbeat monitor.

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

Veerasenareddy Burru (7):
  octeon_ep: defer probe if firmware not ready
  octeon_ep: poll for control messages
  octeon_ep: control mailbox for multiple PFs
  octeon_ep: enhance control mailbox for VF support
  octeon_ep: support asynchronous notifications
  octeon_ep: control mbox support for VF stats and link info
  octeon_ep: add heartbeat monitor

 .../marvell/octeon_ep/octep_cn9k_pf.c         |  74 ++--
 .../ethernet/marvell/octeon_ep/octep_config.h |   6 +
 .../marvell/octeon_ep/octep_ctrl_mbox.c       | 318 ++++++++------
 .../marvell/octeon_ep/octep_ctrl_mbox.h       | 102 +++--
 .../marvell/octeon_ep/octep_ctrl_net.c        | 404 ++++++++++++------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 196 +++++----
 .../marvell/octeon_ep/octep_ethtool.c         |  12 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   | 181 +++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  18 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |   6 +
 10 files changed, 855 insertions(+), 462 deletions(-)


base-commit: 75da437a2f172759b2273091a938772e687242d0
-- 
2.36.0

