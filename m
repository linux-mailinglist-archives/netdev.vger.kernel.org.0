Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6094E5FA2A4
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbiJJRUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJJRUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:20:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCFE3A145
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 10:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665422439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=L7mzWGm9Fi3J3wL3BVtMdGC7y0bZYjMeGp/4Tbn7IOo=;
        b=M6P9Y1jT04D8NdRenBKIz69pcAKgkikKL+vr+uweeExKjX6YrX4PD5A+KwMG5JSmWYU+UU
        BAgN7CMxYV17TRbOKQLcDecVxUPYeesX3IM/tQML7H/7CCMDkXPFJi9pawsvSb0Y5++gYB
        1eP3Dh7u0gC0goLXj0olT7ftdU7KqKw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-417-vM7g3UgoNT2pubRwSaFoOA-1; Mon, 10 Oct 2022 13:20:38 -0400
X-MC-Unique: vM7g3UgoNT2pubRwSaFoOA-1
Received: by mail-wr1-f69.google.com with SMTP id e19-20020adfa453000000b0022e3608df56so2973161wra.10
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 10:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=L7mzWGm9Fi3J3wL3BVtMdGC7y0bZYjMeGp/4Tbn7IOo=;
        b=BiC/W+0FYCth6SA0rDZ7fWcqwN90CwbFpY/rJw12ZRAPltQV6iiE4Sz1uyTQ26dcTZ
         UVsZfj3A4kYyvl+Ro3R3u0lbJmpTy4fSFh6sq23pXT1Cz24aMPik1MMfT+2+npVuMf0i
         giKSAqoH7nR4Ra2tJHTpLrK6H3Ad1ZE/vXFdVHmvWZZeqqJGymSRpSRmNfalW9hIZdXq
         x1S9RBJieuioEuAzKqL00WVl8JhZrqsq9kpy3SR6pTauIc+zbaYg+xXBK2W1ighc27gB
         HxX5yopRy9gfwTy2VHUOmhxuHyrEasxpFX0Ob2ATZWH10k0vND/QHTABIxOeiWOzSa0G
         +EzQ==
X-Gm-Message-State: ACrzQf2MxCpEGdz0f4YUoGG+oqRZKXT6qmcXIAp6aZRL5VJne2A84wjm
        kuTgBBJoTqKCr7Morg0CYzG8ty010acPulZUl02ZPiBxv+j1DGYJVyMHRuyGr6V8LpfSXXJjyF1
        D6OH0Ef/mLEaUOhfS
X-Received: by 2002:a5d:456b:0:b0:230:9e5b:c64c with SMTP id a11-20020a5d456b000000b002309e5bc64cmr3561534wrc.211.1665422436616;
        Mon, 10 Oct 2022 10:20:36 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM68dVAhvzTyD7Fyx5nUJiGXtTyQolK/pvb6X+fnB98gJfJ7lgZeRyv+gqj4yQ08CijJAvcdWw==
X-Received: by 2002:a5d:456b:0:b0:230:9e5b:c64c with SMTP id a11-20020a5d456b000000b002309e5bc64cmr3561523wrc.211.1665422436338;
        Mon, 10 Oct 2022 10:20:36 -0700 (PDT)
Received: from redhat.com ([2.55.183.131])
        by smtp.gmail.com with ESMTPSA id g7-20020a056000118700b0022ac38fb20asm9337483wrx.111.2022.10.10.10.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 10:20:35 -0700 (PDT)
Date:   Mon, 10 Oct 2022 13:20:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mst@redhat.com, wangdeming@inspur.com, xiujianfeng@huawei.com
Subject: [GIT PULL] virtio: fixes, features
Message-ID: <20221010132030-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 4fe89d07dcc2804c8b562f6c7896a45643d34b2f:

  Linux 6.0 (2022-10-02 14:09:07 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 71491c54eafa318fdd24a1f26a1c82b28e1ac21d:

  virtio_pci: don't try to use intxif pin is zero (2022-10-07 20:00:44 -0400)

----------------------------------------------------------------
virtio: fixes, features

9k mtu perf improvements
vdpa feature provisioning
virtio blk SECURE ERASE support

Fixes, cleanups all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alvaro Karsz (1):
      virtio_blk: add SECURE ERASE command support

Angus Chen (1):
      virtio_pci: don't try to use intxif pin is zero

Deming Wang (2):
      virtio_ring: split: Operators use unified style
      virtio_ring: make vring_alloc_queue_packed prettier

Gavin Li (2):
      virtio-net: introduce and use helper function for guest gso support checks
      virtio-net: use mtu size as buffer length for big packets

Jason Wang (3):
      vdpa: device feature provisioning
      vdpa_sim_net: support feature provisioning
      vp_vdpa: support feature provisioning

Michael S. Tsirkin (1):
      virtio: drop vp_legacy_set_queue_size

Xiu Jianfeng (1):
      vhost: add __init/__exit annotations to module init/exit funcs

Zhu Lingshan (6):
      vDPA: allow userspace to query features of a vDPA device
      vDPA: only report driver features if FEATURES_OK is set
      vDPA: check VIRTIO_NET_F_RSS for max_virtqueue_paris's presence
      vDPA: check virtio device features to detect MQ
      vDPA: fix spars cast warning in vdpa_dev_net_mq_config_fill
      vDPA: conditionally read MTU and MAC in dev cfg space

 drivers/block/virtio_blk.c           | 110 +++++++++++++++++++++++++++++------
 drivers/net/virtio_net.c             |  48 ++++++++++-----
 drivers/vdpa/vdpa.c                  |  73 ++++++++++++++++++-----
 drivers/vdpa/vdpa_sim/vdpa_sim.c     |  12 +++-
 drivers/vdpa/vdpa_sim/vdpa_sim.h     |   3 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |   5 +-
 drivers/vdpa/virtio_pci/vp_vdpa.c    |  22 ++++++-
 drivers/vhost/net.c                  |   4 +-
 drivers/virtio/virtio_pci_common.c   |   3 +
 drivers/virtio/virtio_ring.c         |   8 +--
 include/linux/vdpa.h                 |   1 +
 include/linux/virtio_pci_legacy.h    |   2 -
 include/uapi/linux/vdpa.h            |   6 ++
 include/uapi/linux/virtio_blk.h      |  19 ++++++
 15 files changed, 253 insertions(+), 65 deletions(-)

