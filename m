Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BD44BC3D9
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 01:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiBSAxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 19:53:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238894AbiBSAxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 19:53:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FF6627792B
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 16:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645231965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=BuTnFWUhBBRMiJESbdOS+zm0fZMoAD6VWeIUETzvR9Q=;
        b=cEUASDxBCp2cvXMRNkHNhAx1fBxs0IeBD3D6wH9JTiWBoO2Iq5B3dAXZUJ5ovAO779BEIP
        xTi4A4Cw02S7y5o0uQRpiijsQ1uNT4RIDHREi4kbGM1YdoAjqGoCawc9ffNHsfvbcoQN03
        mVPFWeGjxJH54MJXHcyhGLtsJ5NU8I4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-de9sK9NhMqaxxLEalV_5JQ-1; Fri, 18 Feb 2022 19:52:42 -0500
X-MC-Unique: de9sK9NhMqaxxLEalV_5JQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C908A2F45;
        Sat, 19 Feb 2022 00:52:38 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (ovpn-12-39.pek2.redhat.com [10.72.12.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A173C62D4E;
        Sat, 19 Feb 2022 00:52:22 +0000 (UTC)
From:   Baoquan He <bhe@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, 42.hyeyoo@gmail.com, penberg@kernel.org,
        rientjes@google.com, iamjoonsoo.kim@lge.com, vbabka@suse.cz,
        David.Laight@ACULAB.COM, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org
Subject: [PATCH 00/22] Don't use kmalloc() with GFP_DMA
Date:   Sat, 19 Feb 2022 08:51:59 +0800
Message-Id: <20220219005221.634-1-bhe@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's replace it with other ways. This is the first step towards
removing dma-kmalloc support in kernel (Means that if everyting
is going well, we can't use kmalloc(GFP_DMA) to allocate buffer in the
future).

This series includes below changes which are easier to recognise and
make. 

1) Remove GFP_DMA from dma_alloc_wc/noncoherent(), dma_pool_alloc(),
   and dmam_alloc_coherent() which are redundant to specify GFP_DMA when
   calling.
2) Replace kmalloc(GFP_DMA)/dma_map_xxxx() pair with dma_alloc_noncoherent().

Next, plan to investigate how we should handle places as below. We
firstly need figure out whether they really need buffer from ZONE_DMA.
If yes, how to change them with other ways. This need help from
maintainers, experts from sub-components and code contributors or anyone
knowing them well. E.g s390 and crypyto, we need guidance and help.

1) Kmalloc(GFP_DMA) in s390 platform, under arch/s390 and drivers/s390;
2) Kmalloc(GFP_DMA) in drivers/crypto;
3) Kmalloc(GFP_DMA) in network drivers under drivers/net, e.g skb
   buffer requested from DMA zone.
4) Kmalloc(GFP_DMA) in device register control, e.g using regmap, devres  
   to read/write register, while memory from ZONE_DMA is required, e.g
   i2c, spi. 

For this first patch series, thanks to Hyeonggon for helping
reviewing and great suggestions on patch improving. We will work
together to continue the next steps of work.

Any comment, thought, or suggestoin is welcome and appreciated,
including but not limited to:
1) whether we should remove dma-kmalloc support in kernel();
3) why kmalloc(GFP_DMA) is needed in a certain place. why memory from
   ZONE_DMA has to be requested in the case.
2) how to replace it with other ways in any place which you are familiar
   with;

===========================Background information=======================
Prelusion:
Earlier, allocation failure was observed when calling kmalloc() with
GFP_DMA. It requests to allocate slab page from DMA zone while no managed
pages at all in there. Because in the current kernel, dma-kmalloc will
be created as long as CONFIG_ZONE_DMA is enabled. However, kdump kernel
of x86_64 doesn't have managed pages on DMA zone since below commit. The
details of this kdump issue can be found in reference link (a).

	commit 6f599d84231f ("x86/kdump: Always reserve the low 1M when the crashkernel option is specified")

To make clear the root cause and fix, many reviewers contributed their
thoughts and suggestions in the thread of the patchset v3 (a). Finally
Hyeonggon concluded what we can do to fix the kdump issue for now as a
workaround, and further action to get rid of dma-kmalloc which is not
a reasonable existence. (Please see Hyeonggon's reply in refernce (b)).
Quote Hyeonggon's words here:
~~~~
What about one of those?:

    1) Do not call warn_alloc in page allocator if will always fail
    to allocate ZONE_DMA pages.

    2) let's check all callers of kmalloc with GFP_DMA
    if they really need GFP_DMA flag and replace those by DMA API or
    just remove GFP_DMA from kmalloc()

    3) Drop support for allocating DMA memory from slab allocator
    (as Christoph Hellwig said) and convert them to use DMA32
    and see what happens
~~~~

Then Christoph acked Hyeonggon's conclusion, and said "This is the right
thing to do, but it will take a while." (See reference link (c))


==========Reference links=======
(a) v4 post including the details of kdump issue:
https://lore.kernel.org/all/20211223094435.248523-1-bhe@redhat.com/T/#u

(b) v3 post including many reviewers' comments:
https://lore.kernel.org/all/20211213122712.23805-1-bhe@redhat.com/T/#u

(c) Hyeonggon's mail concluding the solution:
https://lore.kernel.org/all/20211215044818.GB1097530@odroid/T/#u

(d) Christoph acked the plan in this mail:
https://lore.kernel.org/all/20211215072710.GA3010@lst.de/T/#u

Baoquan He (21):
  parisc: pci-dma: remove stale code and comment
  gpu: ipu-v3: Don't use GFP_DMA when calling dma_alloc_coherent()
  drm/sti: Don't use GFP_DMA when calling dma_alloc_wc()
  sound: n64: Don't use GFP_DMA when calling dma_alloc_coherent()
  fbdev: da8xx: Don't use GFP_DMA when calling dma_alloc_coherent()
  fbdev: mx3fb: Don't use GFP_DMA when calling dma_alloc_wc()
  usb: gadget: lpc32xx_udc: Don't use GFP_DMA when calling
    dma_alloc_coherent()
  usb: cdns3: Don't use GFP_DMA when calling dma_alloc_coherent()
  uio: pruss: Don't use GFP_DMA when calling dma_alloc_coherent()
  staging: emxx_udc: Don't use GFP_DMA when calling dma_alloc_coherent()
  staging: emxx_udc: Don't use GFP_DMA when calling dma_alloc_coherent()
  spi: atmel: Don't use GFP_DMA when calling dma_alloc_coherent()
  spi: spi-ti-qspi: Don't use GFP_DMA when calling dma_alloc_coherent()
  usb: cdns3: Don't use GFP_DMA when calling dma_pool_alloc()
  usb: udc: lpc32xx: Don't use GFP_DMA when calling dma_pool_alloc()
  net: marvell: prestera: Don't use GFP_DMA when calling
    dma_pool_alloc()
  net: ethernet: mtk-star-emac: Don't use GFP_DMA when calling
    dmam_alloc_coherent()
  ethernet: rocker: Use dma_alloc_noncoherent() for dma buffer
  HID: intel-ish-hid: Use dma_alloc_noncoherent() for dma buffer
  mmc: wbsd: Use dma_alloc_noncoherent() for dma buffer
  mtd: rawnand: Use dma_alloc_noncoherent() for dma buffer

Hyeonggon Yoo (1):
  net: moxa: Don't use GFP_DMA when calling dma_alloc_coherent()

 arch/parisc/kernel/pci-dma.c                  |  8 ---
 drivers/gpu/drm/sti/sti_cursor.c              |  4 +-
 drivers/gpu/drm/sti/sti_hqvdp.c               |  2 +-
 drivers/gpu/ipu-v3/ipu-image-convert.c        |  2 +-
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c   | 23 +++-----
 drivers/mmc/host/wbsd.c                       | 45 +++-----------
 drivers/mtd/nand/raw/marvell_nand.c           | 55 ++++++++++-------
 .../ethernet/marvell/prestera/prestera_rxtx.c |  2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c |  2 +-
 drivers/net/ethernet/moxa/moxart_ether.c      |  4 +-
 drivers/net/ethernet/rocker/rocker_main.c     | 59 ++++++++-----------
 drivers/spi/spi-atmel.c                       |  4 +-
 drivers/spi/spi-ti-qspi.c                     |  2 +-
 drivers/staging/emxx_udc/emxx_udc.c           |  2 +-
 drivers/staging/media/imx/imx-media-utils.c   |  2 +-
 drivers/uio/uio_pruss.c                       |  2 +-
 drivers/usb/cdns3/cdns3-gadget.c              |  4 +-
 drivers/usb/gadget/udc/lpc32xx_udc.c          |  4 +-
 drivers/video/fbdev/da8xx-fb.c                |  4 +-
 drivers/video/fbdev/fsl-diu-fb.c              |  2 +-
 drivers/video/fbdev/mx3fb.c                   |  2 +-
 sound/mips/snd-n64.c                          |  2 +-
 22 files changed, 97 insertions(+), 139 deletions(-)

-- 
2.17.2

