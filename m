Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8797637AE
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGIOTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 10:19:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbfGIOTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 10:19:35 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69EG7nW017350;
        Tue, 9 Jul 2019 07:19:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=YXaJd4oWKFdRZvAqEmp7BalYuXi6zbcrAdSM8Y7OgDY=;
 b=OnhkdiqFLc90bnnXvsRX+p058cU2h6R852vOQm1ErRSaZlBqKvnc1BbhPu2izNgF7veJ
 ipzYk3u9rtFxXW799zSq8BlIFb4jneM0zBomYNAf05U2Okb26xT9cF2KRwzkFukPwA4k
 j1yiX3fPL/TamtzRn0yfZqjuIDw+bA0l6JqvGQkoYYVeb3+ONE7fK1IZorRZpV09mVbG
 kxaWCGW/pk2WM1vtuOh98G+3JquIh+MaO/ZyF5cwoWxYSC/EFuDTgv+9lXdVbcPuikos
 uAMJrKIPrtnFN5IC+JG5IYPnxw8o+40FNPgpJLwL4aOoaob9fTMYTJ7cYe6M2sR3wRlb Mw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tmn10hjxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 07:19:05 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 9 Jul
 2019 07:19:04 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Tue, 9 Jul 2019 07:19:04 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 028AC3F7045;
        Tue,  9 Jul 2019 07:19:01 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v6 rdma-next 0/6] RDMA/qedr: Use the doorbell overflow recovery mechanism for RDMA
Date:   Tue, 9 Jul 2019 17:17:29 +0300
Message-ID: <20190709141735.19193-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series uses the doorbell overflow recovery mechanism
introduced in
commit 36907cd5cd72 ("qed: Add doorbell overflow recovery mechanism")
for rdma ( RoCE and iWARP )

The first three patches modify the core code to contain helper
functions for managing mmap_xa inserting, getting and freeing
entries. The code was taken almost as is from the efa driver.
There is still an open discussion on whether we should take
this even further and make the entire mmap generic. Until a
decision is made, I only created the database API and modified
the efa and qedr driver to use it. The doorbell recovery code will be based
on the common code.

Efa driver was compile tested only.

rdma-core pull request #493

Changes from V5:
- Switch between driver dealloc_ucontext and mmap_entries_remove.
- No need to verify the key after using the key to load an entry from
  the mmap_xa.
- Change mmap_free api to pass an 'entry' object.
- Add documentation for mmap_free and for newly exported functions.
- Fix some extra/missing line breaks.

Changes from V4:
- Add common mmap database and cookie helper functions.

Changes from V3:
- Remove casts from void to u8. Pointer arithmetic can be done on void
- rebase to tip of rdma-next

Changes from V2:
- Don't use long-lived kmap. Instead use user-trigger mmap for the
  doorbell recovery entries.
- Modify dpi_addr to be denoted with __iomem and avoid redundant
  casts

Changes from V1:
- call kmap to map virtual address into kernel space
- modify db_rec_delete to be void
- remove some cpu_to_le16 that were added to previous patch which are
  correct but not related to the overflow recovery mechanism. Will be
  submitted as part of a different patch


Michal Kalderon (6):
  RDMA/core: Create mmap database and cookie helper functions
  RDMA/efa: Use the common mmap_xa helpers
  RDMA/qedr: Use the common mmap API
  qed*: Change dpi_addr to be denoted with __iomem
  RDMA/qedr: Add doorbell overflow recovery support
  RDMA/qedr: Add iWARP doorbell recovery support

 drivers/infiniband/core/device.c           |   1 +
 drivers/infiniband/core/rdma_core.c        |   1 +
 drivers/infiniband/core/uverbs_cmd.c       |   1 +
 drivers/infiniband/core/uverbs_main.c      | 135 +++++++++
 drivers/infiniband/hw/efa/efa.h            |   3 +-
 drivers/infiniband/hw/efa/efa_main.c       |   1 +
 drivers/infiniband/hw/efa/efa_verbs.c      | 186 +++---------
 drivers/infiniband/hw/qedr/main.c          |   3 +-
 drivers/infiniband/hw/qedr/qedr.h          |  32 +-
 drivers/infiniband/hw/qedr/verbs.c         | 463 ++++++++++++++++++++---------
 drivers/infiniband/hw/qedr/verbs.h         |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |   5 +-
 include/linux/qed/qed_rdma_if.h            |   2 +-
 include/rdma/ib_verbs.h                    |  46 +++
 include/uapi/rdma/qedr-abi.h               |  25 ++
 15 files changed, 600 insertions(+), 308 deletions(-)

-- 
2.14.5

