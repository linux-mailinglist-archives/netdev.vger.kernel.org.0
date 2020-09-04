Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F9025E3D8
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 00:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbgIDWmf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 18:42:35 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:40061 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbgIDWma (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 18:42:30 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f52c2cf0001>; Sat, 05 Sep 2020 06:42:23 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Fri, 04 Sep 2020 15:42:23 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Fri, 04 Sep 2020 15:42:23 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Sep
 2020 22:42:06 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Sep 2020 22:42:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YBjHrHKb5QSt1gN2cpQ+XOorCmaibv0AcwokZLsEH8dx7YSuzWAWycceRyllw4m+1rx41TmBjRzsNuCZmOgTraJ63U//vOeYrshjJMWIUanJGLzWMQMHpYVP6Kc025kCI//HaBikA4R6MV+Dcmr0SsiwzWAnvAg2VS9C0dZIdzgf5PnjfBQ5Wfyx1LgYkq/FO845NMCK2Ck21CdN6scNP4cFLyIpFw+CN+eCxOa/qF7V8Q5BKUx3GgxomVbB7ucT9seq/r9fI0cXsw5/6Mo33P5O+fHHJ7iYLHkk6qZg1UY/bJjp2Citd+LOl8Bns9njnxGXpZ8sKLcMVq85VivqMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7BTxAtsMjdAseiXuafyjbbKWxTe0BrWj7xPy+dRYH0=;
 b=A8OBbpodRxOR6Ti9kuInXrYob4BtBmK8WfWCOORH0rhVLQYe/kgJ5/MiY5IpdDrgU6bSvQZID4zVesirW/LzZeerjJpLzhYBIgk6XPKS7BRqk5swvGeZ0mAD9IhmNXfz39pX8/7/YWtErdM3LIWrxiNAf9dFB+zh1gtZ6YztPfkx/Q5zaStU7O17w6CZjG8ESveu4aruKncUTNxGY+1cwCJZ4UbpjD93FgZzjQpjKU2LOcmFHI+5Dif/Q6pRCwl0p2tBUxJWPQcO9mV7kOZiGQozB3F5zUxRFK8eb7kKTKXsqecia/nQaNjyBMuZK3syy+1UEU7ybcvyAQ2ig+AXJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vmware.com; dkim=none (message not signed)
 header.d=none;vmware.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB2806.namprd12.prod.outlook.com (2603:10b6:a03:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.22; Fri, 4 Sep
 2020 22:42:04 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::445b:111e:a091:66f9]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::445b:111e:a091:66f9%6]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 22:42:04 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Adit Ranadive <aditr@vmware.com>, Ariel Elior <aelior@marvell.com>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        "Doug Ledford" <dledford@redhat.com>,
        Faisal Latif <faisal.latif@intel.com>,
        "Gal Pressman" <galpress@amazon.com>,
        <GR-everest-linux-l2@marvell.com>,
        "Wei Hu(Xavier)" <huwei87@hisilicon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Leon Romanovsky" <leon@kernel.org>, <linux-rdma@vger.kernel.org>,
        Weihang Li <liweihang@huawei.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Naresh Kumar PBS" <nareshkumar.pbs@broadcom.com>,
        <netdev@vger.kernel.org>, Lijun Ou <oulijun@huawei.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "Selvin Xavier" <selvin.xavier@broadcom.com>,
        Yossi Leybovich <sleybo@amazon.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Yishai Hadas <yishaih@nvidia.com>
CC:     Firas JahJah <firasj@amazon.com>,
        Henry Orosco <henry.orosco@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v2 00/17] RDMA: Improve use of umem in DMA drivers
Date:   Fri, 4 Sep 2020 19:41:41 -0300
Message-ID: <0-v2-270386b7e60b+28f4-umem_1_jgg@nvidia.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0004.namprd02.prod.outlook.com
 (2603:10b6:207:3c::17) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0004.namprd02.prod.outlook.com (2603:10b6:207:3c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.17 via Frontend Transport; Fri, 4 Sep 2020 22:42:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kEKP8-001vBw-Ox; Fri, 04 Sep 2020 19:41:58 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96ebb523-8a7e-4bd1-eaca-08d85123bd8d
X-MS-TrafficTypeDiagnostic: BYAPR12MB2806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR12MB28061AE45CFE4DA2FF088BF8C22D0@BYAPR12MB2806.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:590;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IOfHdnOLBvt2PsDfPO26inGL87993UmeeTBEF5HzPJtRLVO8IZvbGdFDb797g2dhO7Psys8+vXy82sB5U2viiUvpiS6JlsGSYCXxk52swxh+2sapeb8A8L+StEj+wxJ0UMiU9qFgm3NzfA1LFml/tTBW/05RXsBKrbRmbewQ0lCxFV/WEJDR6ofukx/YTMcQ0XVplxCJMOk0JD6Skcbltd4lurfyA/sZHx9jLWBK7fgNND2+nnCE5FAyOokfzWKTIJh+RSBwILeJv9SHT6rVnucXMZ69u6IikOH2gU+IUe8gvWaT1OQvBD0TQ29IvHE0G7n8ODxbyDjoM8NhT5ouYqdu6JMNxwzBKj9a7SBD7U9wkR4rmBmvhZKSThK0vLLOg4lnanhIRhODVMbo7g64IHGw/QJk6QMLQS3OP+Al3EP+MIMYaCuYQjnHGxTkJzj9yVKKnct9ojrWcWrvywytpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(396003)(136003)(346002)(66556008)(26005)(54906003)(66476007)(6666004)(110136005)(8676002)(186003)(316002)(83380400001)(426003)(7416002)(2616005)(9786002)(478600001)(6636002)(36756003)(9746002)(86362001)(8936002)(5660300002)(2906002)(966005)(4326008)(66946007)(4216001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qm6fQz5ybPbKFqMpfq8RweQGBh9QdezMB2qbEvLh4bpaAr9z3ALdOjC+zGl4gHdqwuTTL30U00YqGiOSrGUjXanLb9cztoxPScYk9Rw8s7KLlzDsV35lG4BwBJOD8vJc+KiDeFvaM4LtRXKiq4Pw8gNtSrg7qnlrh/Gd6IWH8+B7GtpqfdNirle4dTgiSnlZUa8eZer9KIw/T6FrmoHwdCSAvNyj4F8JrBFpSs/PNRnfuolt6XOIveGAE4GX91f1csxkKdLRzk6av6WdV5edhe3hELBOHA+pf2JQspDjuPWjst+L8bm9Z/YBmnbDfbloyJBzE6bQ04IWaddsmow7HumrvPpzRzhFTuCdSsst80ujDm7bLKhwC2qgNy59vTfvOQmtJGHEHeLaVo29CQIkvTTG4I+phGig60cWcLqqMXHdJ253gi4vMwtJj5SaH3DVbIuz5oSUMD+Q7/t1maU82ojC6zbozv8m2uHKYuQQ0vmYrxG//lkYXPd3KmrSLU/RrjAFO77xbpsuF2L03Sutx5qudime+3KTojXSKz4HUqMDFdNbTJQMt4QKjX3BV+k4Uzai+7NVgXoGJDFS9RKgmS0vcNHPzt7MwnifNOkB2Zr+vI+7C3wOz3ZwaaMFNIQfDH6ReckfSaMs/m8GKm+upA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ebb523-8a7e-4bd1-eaca-08d85123bd8d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2020 22:42:02.3552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JXPWmkvNFLJqE8zV85dP0DN/GEjFTQDYVRS2oFFsgUZCn7kFsrMeyj6y2VwpyD1p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2806
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599259343; bh=1BzpAroTuYp2wYzkMeguTWDtS2lFOQNt83dbkyE27QY=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:From:To:CC:
         Subject:Date:Message-ID:Content-Transfer-Encoding:Content-Type:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=XPGvgAC19Mfp/80tYLlm4QNWKX0i0D4OeeMjaEQz6laQVPS2k+wn1XY44n0K0RLT4
         8OM4SwP+ycYUI5ghyw146qNEYz/P1V65s33cetLJWAtLQk3wcfiFlLKg2f4W1oOwqQ
         wVQ1yMOew8/LTBocxZJz6IrtDYugoVVf98heiNZUutRGyhGXQZId58ZayfBnoeq2Se
         befG8lt2PnE0Z9lmoyUJ8ZN6bk+Y/rGwt4NEqveN2FESmtQutDG4vFTwLZ4xeUhxcs
         9rbEwiGyBR6yaNId4zaEQ2K7rsnkKKUU4n8bO9W67gzNj+pz3ituWgdQrEbLsqJSJd
         1JXrprwC51RPw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most RDMA drivers rely on a linear table of DMA addresses organized in
some device specific page size.

For a while now the core code has had the rdma_for_each_block() SG
iterator to help break a umem into DMA blocks for use in the device lists.

Improve on this by adding rdma_umem_for_each_dma_block(),
ib_umem_dma_offset() and ib_umem_num_dma_blocks().

Replace open codings, or calls to fixed PAGE_SIZE APIs, in most of the
drivers with one of the above APIs.

Get rid of the really weird and duplicative ib_umem_page_count().

Fix two problems with ib_umem_find_best_pgsz(), and several problems
related to computing the wrong DMA list length if IOVA !=3D umem->address.

At this point many of the driver have a clear path to call
ib_umem_find_best_pgsz() and replace hardcoded PAGE_SIZE or PAGE_SHIFT
values when constructing their DMA lists.

This is the first series in an effort to modernize the umem usage in all
the DMA drivers.

v1: https://lore.kernel.org/r/0-v1-00f59ce24f1f+19f50-umem_1_jgg@nvidia.com
v2:
 - Fix ib_umem_find_best_pgsz() to use IOVA not umem->addr
 - Fix ib_umem_num_dma_blocks() to use IOVA not umem->addr
 - Two new patches to remove wrong open coded versions of
   ib_umem_num_dma_blocks() from EFA and i40iw
 - Redo the mlx4 ib_umem_num_dma_blocks() to do less and be safer
   until the whole thing can be moved to ib_umem_find_best_pgsz()
 - Two new patches to delete calls to ib_umem_offset() in qedr and
   ocrdma

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (17):
  RDMA/umem: Fix ib_umem_find_best_pgsz() for mappings that cross a page
    boundary
  RDMA/umem: Prevent small pages from being returned by
    ib_umem_find_best_pgsz()
  RDMA/umem: Use simpler logic for ib_umem_find_best_pgsz()
  RDMA/umem: Add rdma_umem_for_each_dma_block()
  RDMA/umem: Replace for_each_sg_dma_page with
    rdma_umem_for_each_dma_block
  RDMA/umem: Split ib_umem_num_pages() into ib_umem_num_dma_blocks()
  RDMA/efa: Use ib_umem_num_dma_pages()
  RDMA/i40iw: Use ib_umem_num_dma_pages()
  RDMA/qedr: Use rdma_umem_for_each_dma_block() instead of open-coding
  RDMA/qedr: Use ib_umem_num_dma_blocks() instead of
    ib_umem_page_count()
  RDMA/bnxt: Do not use ib_umem_page_count() or ib_umem_num_pages()
  RDMA/hns: Use ib_umem_num_dma_blocks() instead of opencoding
  RDMA/ocrdma: Use ib_umem_num_dma_blocks() instead of
    ib_umem_page_count()
  RDMA/pvrdma: Use ib_umem_num_dma_blocks() instead of
    ib_umem_page_count()
  RDMA/mlx4: Use ib_umem_num_dma_blocks()
  RDMA/qedr: Remove fbo and zbva from the MR
  RDMA/ocrdma: Remove fbo from MR

 .clang-format                                 |  1 +
 drivers/infiniband/core/umem.c                | 45 +++++++-----
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 72 +++++++------------
 drivers/infiniband/hw/cxgb4/mem.c             |  8 +--
 drivers/infiniband/hw/efa/efa_verbs.c         |  9 ++-
 drivers/infiniband/hw/hns/hns_roce_alloc.c    |  3 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c       | 49 +++++--------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     | 13 +---
 drivers/infiniband/hw/mlx4/cq.c               |  1 -
 drivers/infiniband/hw/mlx4/mr.c               |  5 +-
 drivers/infiniband/hw/mlx4/qp.c               |  2 -
 drivers/infiniband/hw/mlx4/srq.c              |  5 +-
 drivers/infiniband/hw/mlx5/mem.c              |  4 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |  8 +--
 drivers/infiniband/hw/ocrdma/ocrdma.h         |  1 -
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c      |  5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   | 25 +++----
 drivers/infiniband/hw/qedr/verbs.c            | 52 +++++---------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c  |  2 +-
 .../infiniband/hw/vmw_pvrdma/pvrdma_misc.c    |  9 ++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |  2 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |  6 +-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c    | 12 +---
 include/linux/qed/qed_rdma_if.h               |  2 -
 include/rdma/ib_umem.h                        | 37 ++++++++--
 include/rdma/ib_verbs.h                       | 24 -------
 27 files changed, 170 insertions(+), 234 deletions(-)

--=20
2.28.0

