Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C63BD44209
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391954AbfFMQSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:18:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38048 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731107AbfFMIkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:40:12 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5D8Z0wP018316;
        Thu, 13 Jun 2019 01:39:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=DTSeHnE/xj66NnyXEJvTaOx/+ILJ2hhvRaPXL+OcOTQ=;
 b=b6MWXk5Aj83M7GfeHkDijOU0QHmJSrJfYjDZxWsfwmDs6vNWnKPOj/HGgR/cLtxxb4RI
 cDa0p1NLzdpqwbzeVYx3muk9acYbolL4erY9TjTHyPzu7SkFF3GWCAf+wGQ40Qasen4c
 SAld3wasm0GzVfmGm90BTi0sMib6bYrpehkmyBamTEyOOqLYM7zUAUhRj7hm9VYZiONI
 vj0sN1okYn1oqXczsxSe8gS4XMuBswuX386ef7ssrgi20l0o3kDSPYAd7Zt/IUECOp50
 zoudWWzsA8iXru/NXV0AaAc4XQe5x3NTBnUhvusniHgBthxh1do0FkPdQEz01Y99ZmdF XQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t3j8206jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 13 Jun 2019 01:39:37 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 13 Jun
 2019 01:39:37 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1367.3 via Frontend
 Transport; Thu, 13 Jun 2019 01:39:37 -0700
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 96E733F703F;
        Thu, 13 Jun 2019 01:39:35 -0700 (PDT)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: [PATCH v3 rdma-next 0/3] RDMA/qedr: Use the doorbell overflow recovery mechanism for RDMA
Date:   Thu, 13 Jun 2019 11:38:16 +0300
Message-ID: <20190613083819.6998-1-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_05:,,
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
 drivers/infiniband/hw/qedr/verbs.c         | 387 ++++++++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_rdma.c |   6 +-
 include/linux/qed/qed_rdma_if.h            |   2 +-
 include/uapi/rdma/qedr-abi.h               |  25 ++
 6 files changed, 378 insertions(+), 71 deletions(-)

-- 
2.14.5

