Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C19CE106A8
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfEAJ61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:58:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:34268 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfEAJ60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:58:26 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x419unpN015845;
        Wed, 1 May 2019 02:58:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=b3HmliJJ7ZJRafZhMbhNvKlUGw2rkoLHSmWVvtIpV0g=;
 b=EdRZEvH7m34RyQCp6r7BBBnKQ+2zMaiAoYL1QHdOQpAtIyJLbAOb0p8jdNQ3MHx3IrqT
 wpbcp+C5anzq52vBTXEYTDHKEJCRfaVZoKu1xMPytAhhSoCGaBA185cAq4UmI0cFZ7T1
 jnX1RbILL47nNrjEKYnkEVQ6CaRmmX8JKPRLdm5bfAQox19sh/11T6sGgexjfu1zHTOi
 DGvv1kWVWeMdEcwD6SsI2a/zuu3KGOZixri5d+WtDTyQjibmNGSIpZC04Fzze6Slh2OY
 CH+jQpiYzYC3k+zw9XpO/SVG1W4YEb3aoOL1mfa+CE3U/cGmyaLrAdU5sEO+tSnbeATk GQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2s6xgchw9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 May 2019 02:58:20 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 1 May
 2019 02:58:18 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Wed, 1 May 2019 02:58:18 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 8011A3F7043;
        Wed,  1 May 2019 02:58:16 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <jgg@ziepe.ca>, <dledford@redhat.com>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH net-next 00/10] qed*: Improve performance on 100G link for offload protocols
Date:   Wed, 1 May 2019 12:57:12 +0300
Message-ID: <20190501095722.6902-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-01_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series modifies the current implementation of PF selection.
The refactoring of the llh code enables setting additional filters
(mac / protocol) per PF, and improves performance for offload protocols
(RoCE, iWARP, iSCSI, fcoe) on 100G link (was capped at 90G per single
PF).

Improved performance on 100G link is achieved by configuring engine
affinty to each PF.
The engine affinity is read from the Management FW and hw is configured accordingly.
A new hw resource called PPFID is exposed and an API is introduced to utilize
it. This additional resource enables setting the affinity of a PF and providing
more classification rules per PF.
qedr,qedi,qedf are also modified as part of the series. Without the
changes functionality is broken.


Chad Dupuis (1):
  qedf: Use hwfns and affin_hwfn_idx to get MSI-X vector index to use

Manish Rangankar (2):
  Revert "scsi: qedi: Allocate IRQs based on msix_cnt"
  qedi: Use hwfns and affin_hwfn_idx to get MSI-X vector index

Michal Kalderon (7):
  qed: Modify api for performing a dmae to another PF
  qed: Add llh ppfid interface and 100g support for offload protocols
  qed: Change hwfn used for sb initialization
  qed: Modify offload protocols to use the affined engine
  qedr: Change the MSI-X vectors selection to be based on affined engine
  qed: Set the doorbell address correctly
  qed*: Add iWARP 100g support

 drivers/infiniband/hw/qedr/main.c              |   34 +-
 drivers/infiniband/hw/qedr/qedr.h              |    2 +
 drivers/net/ethernet/qlogic/qed/qed.h          |   21 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c      |    5 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c    |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 1275 +++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h  |  113 ++-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c     |   26 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h      |   16 +-
 drivers/net/ethernet/qlogic/qed/qed_hw.c       |   45 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c |   11 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c      |   12 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c    |   35 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c    |   24 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h    |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |    6 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c      |  406 +++++---
 drivers/net/ethernet/qlogic/qed/qed_main.c     |   47 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c      |   65 ++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h      |   16 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c     |   71 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h |    6 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |    4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c   |    3 +-
 drivers/scsi/qedf/qedf_main.c                  |   39 +-
 drivers/scsi/qedi/qedi_main.c                  |   34 +-
 include/linux/qed/qed_if.h                     |   10 +-
 include/linux/qed/qed_rdma_if.h                |    2 +
 28 files changed, 1712 insertions(+), 622 deletions(-)

-- 
2.14.5

