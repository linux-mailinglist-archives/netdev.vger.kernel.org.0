Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2926433F144
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhCQNgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:36:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:27324 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231280AbhCQNfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 09:35:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12HDQIIR006940;
        Wed, 17 Mar 2021 06:35:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=dgyMvGGeiD0MWLjQyFDcn0C/tx1d/a8Y5fjMTY8cIBQ=;
 b=hHBtlFqxtwawkp7F/HR6PHRp4HYTuA9v2kUQhw1bJJeYf/EgIcV5IOvFq6ETTKupRLpr
 2tCTKK3/8n+wvPIq9Rhy61zUeQxBTJjLMIj2d/RCu0akbznr8XRUlFyxFxfRx5ez+Lo4
 1aHq8J4nF135iTW0MMFXC+fZ/CYf065YOh877ayB/t69QUiuhFJprCo8xN33M5kKkbWj
 y+d09vCLYLpzngpc/ruIeKfCg2R5Zk6deZvnrr0LSqUX3BBc0rloy602eU5xRFvCUGwI
 OLmgXFEE5nkbJLZi2deuQ/6omtp2O9uYNJ4OAcc2RoDMqXQ6mpR0N1saESUkbnrrsLA4 vA== 
Received: from dc6wp-exch01.marvell.com ([4.21.29.232])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqvf3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 17 Mar 2021 06:35:47 -0700
Received: from DC6WP-EXCH01.marvell.com (10.76.176.21) by
 DC6WP-EXCH01.marvell.com (10.76.176.21) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 17 Mar 2021 09:35:46 -0400
Received: from maili.marvell.com (10.76.176.51) by DC6WP-EXCH01.marvell.com
 (10.76.176.21) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 17 Mar 2021 09:35:46 -0400
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id C70943F703F;
        Wed, 17 Mar 2021 06:35:42 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 0/5] refactor code related to npc install flow
Date:   Wed, 17 Mar 2021 19:05:33 +0530
Message-ID: <20210317133538.15609-1-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_07:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset refactors and cleans up the code associated with the
npc install flow API, specifically to eliminate different code paths
while installing MCAM rules by AF and PF. This makes the code easier
to understand and maintain. Also added support for multi channel NIX
promisc entry.

Nalla, Pradeep (1):
  octeontx2-af: Add support for multi channel in NIX promisc entry

Naveen Mamindlapalli (3):
  octeontx2-af: refactor function npc_install_flow for default entry
  octeontx2-af: Use npc_install_flow API for promisc and broadcast
    entries
  octeontx2-af: Modify the return code for unsupported flow keys

Subbaraya Sundeep (1):
  octeontx2-af: Avoid duplicate unicast rule in mcam_rules list

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   2 +
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  17 ++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    | 157 +++++++++++----------
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  62 ++++----
 7 files changed, 139 insertions(+), 116 deletions(-)

-- 
2.16.5

