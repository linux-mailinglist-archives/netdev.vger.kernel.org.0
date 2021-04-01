Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789D23518BE
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhDARrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236008AbhDARnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:43:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA766C02D56A;
        Thu,  1 Apr 2021 08:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=F/At/y3YpRYA0xMifJb6WYaRvzw/qWs4U1Utp3fOA3I=; b=HFkBoDC2gQqzR0/BMkABluFzVb
        3gakMZuzB5XR+6BX0Aj1OytKg2i4hAn10GfCqqYygamx5QBLvyvglTO+CwociDtgFFHoBElQl2z9C
        8vSKoiBIAW3F6tqOLYPp5fiGR2bP6vbJGLE7cWb6BixFCeOSNvJ4K1maSU3n4g1Q7mpPZT2T07c35
        IOMTZ0zeIeEGgKA2dxIZ8EK0kU0QMV3JhqqKyPs1AV8kBZN19SvvyFxFLUzRFNH5pIb+XJhARJbkW
        zRtou/lbZms6YtiTWLVyM7tCMX4ldsM7ZmafF6EhBjKGqEfhr9PhwxC99sSvMht8lYVuOOmKk4W3l
        pxTq5pyQ==;
Received: from [2001:4bb8:180:7517:83e4:a809:b0aa:ca74] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lRzd6-00CiZO-UO; Thu, 01 Apr 2021 15:53:09 +0000
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
Subject: cleanup unused or almost unused IOMMU APIs and the FSL PAMU driver v3
Date:   Thu,  1 Apr 2021 17:52:36 +0200
Message-Id: <20210401155256.298656-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
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

Changes since v2:
 - remove a comment fragment a little bit earlier
 - fix the aperture end passed to pamu_config_ppaace
 - fix a few trivial typos
 - remove more unused arguments to pamu_config_ppaace
 - do not accidentally enable lazy flushing for non-dma domains

Changes since v1:
 - use a different way to control strict flushing behavior (from Robin)
 - remove the iommu_cmd_line wrappers
 - simplify the pagetbl quirks a little more
 - slightly improved patch ordering
 - better changelogs

Diffstat:
 arch/powerpc/include/asm/fsl_pamu_stash.h   |   12 
 drivers/gpu/drm/msm/adreno/adreno_gpu.c     |    5 
 drivers/iommu/amd/iommu.c                   |   23 
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |   75 ---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |    1 
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  111 +---
 drivers/iommu/arm/arm-smmu/arm-smmu.h       |    2 
 drivers/iommu/dma-iommu.c                   |    9 
 drivers/iommu/fsl_pamu.c                    |  293 -----------
 drivers/iommu/fsl_pamu.h                    |   12 
 drivers/iommu/fsl_pamu_domain.c             |  688 ++--------------------------
 drivers/iommu/fsl_pamu_domain.h             |   46 -
 drivers/iommu/intel/iommu.c                 |   95 ---
 drivers/iommu/iommu.c                       |  118 +---
 drivers/soc/fsl/qbman/qman_portal.c         |   55 --
 drivers/vfio/vfio_iommu_type1.c             |   31 -
 drivers/vhost/vdpa.c                        |   10 
 include/linux/io-pgtable.h                  |    4 
 include/linux/iommu.h                       |   76 ---
 19 files changed, 203 insertions(+), 1463 deletions(-)
