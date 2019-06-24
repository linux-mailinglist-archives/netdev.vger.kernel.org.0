Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D90508E9
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 12:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfFXK3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 06:29:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726716AbfFXK3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 06:29:44 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OAP1ar024324;
        Mon, 24 Jun 2019 03:29:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=kIvSjjJLemcqITMyyko8l9L5PB29ZI1VuBEq4O2sqsk=;
 b=JbsaoLLUjcepiZ+oC2R2t1cEWfgTeLzKenxk55oGYgmM9VD+dn/DivVZD/YibjLwkxJC
 8SRXeNrk7X6mcmaondFeKDsHIVet1sZYB8keHuccHZZQpQrBWeHnz2xpFvhVrk/EyXuS
 70mhwiKWODiJbRpwAcihkz0etf4hiSI2dmKz4kdFPpnYEoM6nIU70KLXfhAdsrumDGAc
 JGXrsqTuotVVsq4SWVvjFFnHbFHose6E3eE7A/dejsV0Ufc8X/CirPVwm2Vj9VTQkeyI
 QBRyE+W0ibk9IJ/iFrgB489AKXifgxxVpjFRd9AWoo6rfj4oCraSKo7DhtF0LUHmUsKq wg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t9kuje9s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 03:29:38 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 24 Jun
 2019 03:29:36 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Mon, 24 Jun 2019 03:29:36 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id C1C103F703F;
        Mon, 24 Jun 2019 03:29:34 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow recovery mechanism for RDMA
Date:   Mon, 24 Jun 2019 13:28:06 +0300
Message-ID: <20190624102809.8793-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series used the doorbell overflow recovery mechanism
introduced in
commit 36907cd5cd72 ("qed: Add doorbell overflow recovery mechanism")
for rdma ( RoCE and iWARP )

rdma-core pull request #493

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


Michal Kalderon (3):
  qed*: Change dpi_addr to be denoted with __iomem
  RDMA/qedr: Add doorbell overflow recovery support
  RDMA/qedr: Add iWARP doorbell recovery support

 drivers/infiniband/hw/qedr/main.c          |   2 +-
 drivers/infiniband/hw/qedr/qedr.h          |  27 +-
 drivers/infiniband/hw/qedr/verbs.c         | 386 ++++++++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |   5 +-
 include/linux/qed/qed_rdma_if.h            |   2 +-
 include/uapi/rdma/qedr-abi.h               |  25 ++
 6 files changed, 376 insertions(+), 71 deletions(-)

-- 
2.14.5

