Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F5445ED7
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 15:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728633AbfFNNrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 09:47:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728583AbfFNNro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 09:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2klM0787YOypidTxFFKkFXrGCXrbMhQ5qreI3X9Vu1k=; b=Cj3+LM9vIrA6nltYCay8yBPba
        y6IkbYwpLx9JZh8kK5t2kLy0T8EhKYFLd4ni8FEoVyGRGa1u1i3grWUes4UAS9IJ9k3PGBxh0Ddkp
        +eH6rF5lBzxCwQMwke6G/c2TJda2p6rGBomPUsGZBfRc0dQxUxHgwIel6XPax0+lxmSXe9hnoqneL
        tM4WnvDTXZk0YQhKyEzCwXVDmrezpr/WzX/aQS4stZilw7GkSoqCXo2Zka98OqbC6gFV5/7OKNZNF
        BKEvRnmiaTr9rp4o4Y6qOWysCXUmGZc3uHBgRcuKZdrN51a9q9TVTZ/wz3VsIWst8b5uTNKZ6nDin
        VS2+DYitQ==;
Received: from 213-225-9-13.nat.highway.a1.net ([213.225.9.13] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbmYG-0004Xc-Jk; Fri, 14 Jun 2019 13:47:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc:     Intel Linux Wireless <linuxwifi@intel.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-s390@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: use exact allocation for dma coherent memory
Date:   Fri, 14 Jun 2019 15:47:10 +0200
Message-Id: <20190614134726.3827-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

various architectures have used exact memory allocations for dma
allocations for a long time, but x86 and thus the common code based
on it kept using our normal power of two allocator, which tends to
waste a lot of memory for certain allocations.

Switching to a slightly cleaned up alloc_pages_exact is pretty easy,
but it turns out that because we didn't filter valid gfp_t flags
on the DMA allocator, a bunch of drivers were passing __GFP_COMP
to it, which is rather bogus in too many ways to explain.  Arm has
been filtering it for a while, but this series instead tries to fix
the drivers and warn when __GFP_COMP is passed, which makes it much
larger than just adding the functionality.
