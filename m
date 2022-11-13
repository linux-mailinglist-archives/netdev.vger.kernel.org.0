Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310E46270AD
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 17:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiKMQgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 11:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235397AbiKMQgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 11:36:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A2C95A7;
        Sun, 13 Nov 2022 08:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=p8fZXFOilxr1b8Vw8YSIZYORkb8OJr3ydr3tjQdLjg4=; b=lSs7voTqaJMI0HO0w/yDtxu1V5
        bFe2oVzPY3oP8bREwzfNwOfWUgcPhllF1FYQEtFuUdqSntgGpVcEKGvjdMdeRZNgtepgsxwzJLiSn
        GvChig1xISPaA22YRe2fmw21MmtcqUGwGi1MQGchbpeaxiOepb97cZQSGxx7iCEz0vLWLoLK0kc3z
        YrVB1crY8jRv7Zr9cNcMJV+zZMfzYNgpLoWblTjEfj+DSomHWeqFcLXkIgabUpr2UAWzxcb1BU95i
        sOERMpomMz96rkOTLwN3fbdaqSgxsjj3g7QlZtlea2h4gsFZH2Nu8pE5vgZOBKQ0vsKohRmYD3rmk
        JdGh1NIA==;
Received: from 213-225-8-167.nat.highway.a1.net ([213.225.8.167] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouFxL-00CLQc-V1; Sun, 13 Nov 2022 16:35:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Russell King <linux@armlinux.org.uk>,
        Robin Murphy <robin.murphy@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux.dev, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: stop drivers from passing GFP_COMP to dma_alloc_coherent
Date:   Sun, 13 Nov 2022 17:35:28 +0100
Message-Id: <20221113163535.884299-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

this series fixes up various drivers that either try to get a compound
page from dma_alloc_coherent or more often just did a bit of cargo
cult copy and paste, and then warns about this flag passed in the
DMA layer instead of silently clearing it like done by ARM and dma-iommu
before.

Diffstat:
 arch/arm/mm/dma-mapping.c                     |   17 -----------------
 drivers/infiniband/hw/hfi1/init.c             |   21 +++------------------
 drivers/infiniband/hw/qib/qib_iba6120.c       |    2 +-
 drivers/infiniband/hw/qib/qib_init.c          |   21 ++++-----------------
 drivers/iommu/dma-iommu.c                     |    3 ---
 drivers/media/v4l2-core/videobuf-dma-contig.c |   22 ++++++++--------------
 drivers/net/ethernet/broadcom/cnic.c          |    6 ++----
 drivers/s390/net/ism_drv.c                    |    3 ++-
 kernel/dma/mapping.c                          |    8 ++++++++
 sound/core/memalloc.c                         |    5 ++---
 10 files changed, 30 insertions(+), 78 deletions(-)
