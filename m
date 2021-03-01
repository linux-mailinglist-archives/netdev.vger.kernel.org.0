Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D301032798E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 09:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhCAIoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 03:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbhCAIoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 03:44:02 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47159C061756;
        Mon,  1 Mar 2021 00:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ek5kJL1ujiFKFtGeUxZiZdEhbkWQuXJzNlrMDDHSiZY=; b=joVg0CWz6LOS4vHGAG6rOh1CYA
        VoKirvya1vx0R653IThlzzolk/FLpUhL1sfQ311khwX7z/Y43KLMfWX94+SNy22cIQB9BdyFuAnQq
        IoESLZejtT4K9+4i0pIIOti8gNZuSmcQfsYrSZL27OtRB+I8Pf2Kkmln+CTiCHMDQZ88+j1BsOmul
        RhmH18HUErxq1FhyH/4E+cdIw5COFzr+KOLMCExHYYaWgF0opImqih4Xjo+VFEsu5KGe1IcPVB4uv
        +H7eXnnD3AUfP/Dpzfr0KWPnYguG3RnGj3C0sVTTJc+REBlm1iIODwrEywoe80ldRgW7psNaNhJS1
        yEk9uS6A==;
Received: from [2001:4bb8:19b:e4b7:cdf9:733f:4874:8eb4] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lGe8q-00FUUo-TU; Mon, 01 Mar 2021 08:43:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Li Yang <leoyang.li@nxp.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        iommu@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: cleanup unused or almost unused IOMMU APIs and the FSL PAMU driver
Date:   Mon,  1 Mar 2021 09:42:40 +0100
Message-Id: <20210301084257.945454-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

there are a bunch of IOMMU APIs that are entirely unused, or only used as
a private communication channel between the FSL PAMU driver and it's only
consumer, the qbman portal driver.

So this series drops a huge chunk of entirely unused FSL PAMU
functionality, then drops all kinds of unused IOMMU APIs, and then
replaces what is left of the iommu_attrs with properly typed, smaller
and easier to use specific APIs.

Diffstat:
 arch/powerpc/include/asm/fsl_pamu_stash.h   |   12 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c     |    2 
 drivers/iommu/amd/iommu.c                   |   23 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   85 ---
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  122 +---
 drivers/iommu/dma-iommu.c                   |    8 
 drivers/iommu/fsl_pamu.c                    |  264 ----------
 drivers/iommu/fsl_pamu.h                    |   10 
 drivers/iommu/fsl_pamu_domain.c             |  694 ++--------------------------
 drivers/iommu/fsl_pamu_domain.h             |   46 -
 drivers/iommu/intel/iommu.c                 |   55 --
 drivers/iommu/iommu.c                       |   75 ---
 drivers/soc/fsl/qbman/qman_portal.c         |   56 --
 drivers/vfio/vfio_iommu_type1.c             |   31 -
 drivers/vhost/vdpa.c                        |   10 
 include/linux/iommu.h                       |   81 ---
 16 files changed, 214 insertions(+), 1360 deletions(-)
