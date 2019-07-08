Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BF761C47
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 11:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbfGHJRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 05:17:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12302 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbfGHJRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 05:17:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x689FSOK013243;
        Mon, 8 Jul 2019 02:16:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=wUHTRFgmJ0XZTTjqXXgwrbh+jS1o0zASftJ2Quajh1E=;
 b=P1298bTcdm3h53VTUCGjG5HYZFBPe+UTDCg0REznsqYxqIV1erECX76fI+gTU6YeYnWL
 QrRiNtAeYuZdWjYfqOk7HkOogMiMPmcuxO1RlL3HpDovMsLLoguRgXLuUuDn4Nr8Xixf
 vTOOHRJ5/ywto32SkWZSoPlz8QkQhbzD5GkxcbgVAdwqdUtAbcHvVtE6AEgPjhytpnTf
 9RO0eUdn8c9KnC16j7gWvORo7JuPToSg007cblKf7qSrjiWbsg1R3U62wE00olfsMWI+
 3yJv1FMWNLQlc4siXXaJKPBduvXBwpIeGfAHsqNSco8C8fOqy5G291CIjQKaGAjXRheE qA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j6f8g-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 02:16:39 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 02:16:38 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 8 Jul 2019 02:16:38 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id D72563F7040;
        Mon,  8 Jul 2019 02:16:35 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>, <galpress@amazon.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 rdma-next 0/6] RDMA/qedr: Use the doorbell overflow recovery mechanism for RDMA
Date:   Mon, 8 Jul 2019 12:14:57 +0300
Message-ID: <20190708091503.14723-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_02:,,
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
 drivers/infiniband/core/uverbs_main.c      | 105 +++++++
 drivers/infiniband/hw/efa/efa.h            |   3 +-
 drivers/infiniband/hw/efa/efa_main.c       |   1 +
 drivers/infiniband/hw/efa/efa_verbs.c      | 183 +++---------
 drivers/infiniband/hw/qedr/main.c          |   3 +-
 drivers/infiniband/hw/qedr/qedr.h          |  32 +-
 drivers/infiniband/hw/qedr/verbs.c         | 463 ++++++++++++++++++++---------
 drivers/infiniband/hw/qedr/verbs.h         |   4 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |   5 +-
 include/linux/qed/qed_rdma_if.h            |   2 +-
 include/rdma/ib_verbs.h                    |  32 ++
 include/uapi/rdma/qedr-abi.h               |  25 ++
 15 files changed, 554 insertions(+), 307 deletions(-)

-- 
2.14.5

