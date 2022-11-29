Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4614963C09B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 14:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiK2NKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 08:10:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiK2NJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 08:09:58 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF262F2;
        Tue, 29 Nov 2022 05:09:57 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATBxjWr029859;
        Tue, 29 Nov 2022 05:09:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=ziWSXeV9ysDgZr0fXLpkUbdYkY2wr1vhV42a/SQFj98=;
 b=DwdJ8NxKq3RX1ncL5b/aOqhD10P/vNofba5WumP54Wdpz+MhdItHrZe1yc6abRNVWbwH
 AB4sK+YnW2AHKVz8umHQT0HiuKhj+AqClywP8S5ZcCIzxaMmuewY90b7IjSLG2KgSdED
 7ZB50DFc9Z/aO8ch2fh7KaiAhQBYQ17dwtCWm0BFDO00wTqkxH1tS2B6I11sA6x1qaCy
 tq3Fda2ZID3uOV0IWb3z39u7BZLsj52hbYVqZ6YHsx8w3/rnbgrNJQxykyem6OUv2OG+
 EgVXwshNIEONrlYyXN9E+NmCgYseFdk9cXu2BmEcYto7d/pOyP1Xx1ZA4iJjVs8sy5AT YA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3m5a509ysx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 05:09:48 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 29 Nov
 2022 05:09:39 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 29 Nov 2022 05:09:39 -0800
Received: from sburla-PowerEdge-T630.caveonetworks.com (unknown [10.106.27.217])
        by maili.marvell.com (Postfix) with ESMTP id 631453F7084;
        Tue, 29 Nov 2022 05:09:39 -0800 (PST)
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lironh@marvell.com>, <aayarekar@marvell.com>,
        <sedara@marvell.com>, <sburla@marvell.com>
CC:     <linux-doc@vger.kernel.org>,
        Veerasenareddy Burru <vburru@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v2 0/9] octeon_ep: Update PF mailbox for VF
Date:   Tue, 29 Nov 2022 05:09:23 -0800
Message-ID: <20221129130933.25231-1-vburru@marvell.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DNHue05sYINjsqhYFL1YSGs5Wa7KWSoE
X-Proofpoint-GUID: DNHue05sYINjsqhYFL1YSGs5Wa7KWSoE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update PF mailbox for VF support.
Octeon VF driver will be submitted as separate patchset.

v1 -> v2:
   - remove separate workqueue task to wait for firmware ready.
     instead defer probe when firmware is not ready.
     Reported-by: Leon Romanovsky <leon@kernel.org>
   - This change has resulted in update of 0001-xxx.patch and 
     all other patches in the patchset.

Veerasenareddy Burru (9):
  octeon_ep: defer probe if firmware not ready
  octeon_ep: poll for control messages
  octeon_ep: control mailbox for multiple PFs
  octeon_ep: enhance control mailbox for VF support
  octeon_ep: support asynchronous notifications
  octeon_ep: control mbox support for VF stats and link info
  octeon_ep: add SRIOV VF creation
  octeon_ep: add PF-VF mailbox communication
  octeon_ep: add heartbeat monitor

 .../net/ethernet/marvell/octeon_ep/Makefile   |   3 +-
 .../marvell/octeon_ep/octep_cn9k_pf.c         | 114 +++--
 .../ethernet/marvell/octeon_ep/octep_config.h |   6 +
 .../marvell/octeon_ep/octep_ctrl_mbox.c       | 318 ++++++++------
 .../marvell/octeon_ep/octep_ctrl_mbox.h       | 102 +++--
 .../marvell/octeon_ep/octep_ctrl_net.c        | 404 ++++++++++++------
 .../marvell/octeon_ep/octep_ctrl_net.h        | 196 +++++----
 .../marvell/octeon_ep/octep_ethtool.c         |  12 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   | 246 ++++++++---
 .../ethernet/marvell/octeon_ep/octep_main.h   |  62 ++-
 .../marvell/octeon_ep/octep_pfvf_mbox.c       | 305 +++++++++++++
 .../marvell/octeon_ep/octep_pfvf_mbox.h       | 126 ++++++
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h    |  15 +
 .../net/ethernet/marvell/octeon_ep/octep_tx.h |  24 +-
 14 files changed, 1427 insertions(+), 506 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.c
 create mode 100644 drivers/net/ethernet/marvell/octeon_ep/octep_pfvf_mbox.h


base-commit: 7a168f560e3c3829b74a893d3655caab14a7aef8
-- 
2.36.0

