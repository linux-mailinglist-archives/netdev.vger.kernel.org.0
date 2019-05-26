Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00D7F2A99A
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 14:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfEZMXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 08:23:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40518 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727577AbfEZMXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 08:23:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4QCLchB001282;
        Sun, 26 May 2019 05:23:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=HIPHPhbwdNJDlQ0Y1LqTXu0wTZnLIEcsKOh08Mk5LUU=;
 b=g4myCAvQ1gYUcMjhPBqxjGDYP0s2Tiuct8s/HXOpty5WX3nVtb7hJRifmJFHCKzh4xhE
 v+EsgKXTqN5/OjBKahURv1dRII5iTEWj8MC7eqnxGQmQwZiDXPueN/pPZ28zjyoaHAZY
 EgK5QYZwUMaN5gFbOUqPrPudqgXUmK5B+47v4MlR5Bcp0WpfxMD5sNEdKMeC8C5OUfQx
 VTScLOiSzcdlnfpWfTMYfhZ5teVh9piOCHlfHb4jszDnkBhMSVwIaNQaLW5A+4x5ohHx
 UvPzlT7agdZ796ACTD1fxuv5OZ7u7zgyp0+Fiy+BUEIz4DHT2QhxZ71qCmtSqfhrackf yw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sq57fubsh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 26 May 2019 05:23:48 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 26 May
 2019 05:23:47 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Sun, 26 May 2019 05:23:47 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 2410B3F703F;
        Sun, 26 May 2019 05:23:44 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <dledford@redhat.com>, <jgg@ziepe.ca>, <leon@kernel.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 00/11] qed*: Improve performance on 100G link for offload protocols
Date:   Sun, 26 May 2019 15:22:19 +0300
Message-ID: <20190526122230.30039-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-26_08:,,
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

v1 --> v2
---------
- Remove iWARP module parameter. Instead use devlink param infrastructure
  for setting the iwarp_cmt mode. Additional patch added to the series for
  adding the devlink support.

- Fix kbuild test robot warning on qed_llh_filter initialization.

- Remove comments inside function calls

Chad Dupuis (1):
  qedf: Use hwfns and affin_hwfn_idx to get MSI-X vector index to use

Manish Rangankar (2):
  Revert "scsi: qedi: Allocate IRQs based on msix_cnt"
  qedi: Use hwfns and affin_hwfn_idx to get MSI-X vector index

Michal Kalderon (8):
  qed: Modify api for performing a dmae to another PF
  qed: Add llh ppfid interface and 100g support for offload protocols
  qed*: Change hwfn used for sb initialization
  qed: Modify offload protocols to use the affined engine
  qedr: Change the MSI-X vectors selection to be based on affined engine
  qed: Set the doorbell address correctly
  qed: Add qed devlink parameters table
  qed*: Add iWARP 100g support

 drivers/infiniband/hw/qedr/main.c              |   25 +-
 drivers/infiniband/hw/qedr/qedr.h              |    2 +
 drivers/net/ethernet/qlogic/qed/qed.h          |   24 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c      |    5 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c    |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 1275 +++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h  |  113 ++-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c     |   26 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h      |   16 +-
 drivers/net/ethernet/qlogic/qed/qed_hw.c       |   44 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c |    9 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c      |    8 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c    |   35 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c    |   24 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h    |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c      |  406 +++++---
 drivers/net/ethernet/qlogic/qed/qed_main.c     |  157 ++-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c      |   65 ++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h      |   16 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c     |   75 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h |    6 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |    3 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c   |    3 +-
 drivers/scsi/qedf/qedf_main.c                  |   39 +-
 drivers/scsi/qedi/qedi_main.c                  |   34 +-
 include/linux/qed/qed_if.h                     |   10 +-
 include/linux/qed/qed_rdma_if.h                |    2 +
 28 files changed, 1810 insertions(+), 622 deletions(-)

-- 
2.14.5

