Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CF26C3604
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbjCUPn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjCUPnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:43:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F05CDF5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679413353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+21M6FOpDI3Nr+X7KYn7VxKMZfev1okJOfwsG6shoDo=;
        b=NhYvEp2Z0O+DsKzLmf8iVaWjDI8PEtrg6CxZtghm2aQFKuSrKVqOesmsyRpkwYOjQ6ZXaL
        q1dJp6Sy2fYFsdqsFV2rDEknhagnCcnNG7nM7PDmtwtrJgfmOQr5NrvBYaDxKqBe4hbH93
        /0uejU5Rbes3xNCV0G1dyISDnHIDDos=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-BfDlAbQ2MDy3KjSamOeaMw-1; Tue, 21 Mar 2023 11:42:32 -0400
X-MC-Unique: BfDlAbQ2MDy3KjSamOeaMw-1
Received: by mail-wm1-f70.google.com with SMTP id m27-20020a05600c3b1b00b003ee502f1b16so66589wms.9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:42:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679413351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+21M6FOpDI3Nr+X7KYn7VxKMZfev1okJOfwsG6shoDo=;
        b=WmMXUMA+kMXBErRrARkSss+C/1zoTaIv99VyoDe5wrf2bm9QV+DzDbBx3uTjsvXTU2
         JATMMlgWSEVqdC75sGMAH2fq5oaLUCZ1XdTlj6D3/V7ayWXiSfrsZkbKtPxr35qSAQ5Z
         thz73n40V/bxytGchkcDlxStxliFZ8zMUQly0VbJIO2ixr6aPNqJBBVVLajRtMbw2MTh
         AA1akoN+2/KdFicP+6UpKINr7Wq1nZ9Hqrodp8HbPMvEGSla36tBeXTEVh4DCl77QeGs
         djkuZJ06K1qLj52R6TcYnY3EWvdNZkYWMHeSr4XWQdow49mN56DFRlS/A9wXyb3djci5
         uvjg==
X-Gm-Message-State: AO0yUKWvK6hcfpsreHuNh6GsS0mqGOVzdenh8FIPFACMyHBK6gVLETG4
        eFR/fMHAcaeCwQngV29nkPZE+wwC/M2zB2V0Hm6DhHVcbxfHfCfrnl+psXPkL3fcZvbyR7+iDzn
        /HLY1tOp8xT9oxi+I
X-Received: by 2002:a5d:6b50:0:b0:2cf:ee6b:36aa with SMTP id x16-20020a5d6b50000000b002cfee6b36aamr2562221wrw.64.1679413351351;
        Tue, 21 Mar 2023 08:42:31 -0700 (PDT)
X-Google-Smtp-Source: AK7set+jl15tAxH9/4PthYuff9mKcJ9PlapXD8hbv/rRlufjrczN3T38t3QWIyMzX15FRRs1sZibOQ==
X-Received: by 2002:a5d:6b50:0:b0:2cf:ee6b:36aa with SMTP id x16-20020a5d6b50000000b002cfee6b36aamr2562203wrw.64.1679413351047;
        Tue, 21 Mar 2023 08:42:31 -0700 (PDT)
Received: from step1.redhat.com (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id n2-20020adffe02000000b002cfeffb442bsm11582490wrr.57.2023.03.21.08.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 08:42:30 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v3 0/8] vdpa_sim: add support for user VA
Date:   Tue, 21 Mar 2023 16:42:20 +0100
Message-Id: <20230321154228.182769-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the use of user virtual addresses in the
vDPA simulator devices.

The main reason for this change is to lift the pinning of all guest memory.
Especially with virtio devices implemented in software.

The next step would be to generalize the code in vdpa-sim to allow the
implementation of in-kernel software devices. Similar to vhost, but using vDPA
so we can reuse the same software stack (e.g. in QEMU) for both HW and SW
devices.

For example, we have never merged vhost-blk, and lately there has been interest.
So it would be nice to do it directly with vDPA to reuse the same code in the
VMM for both HW and SW vDPA block devices.

The main problem (addressed by this series) was due to the pinning of all
guest memory, which thus prevented the overcommit of guest memory.

Thanks,
Stefano

Changelog listed in each patch.
v2: https://lore.kernel.org/lkml/20230302113421.174582-1-sgarzare@redhat.com/
RFC v1: https://lore.kernel.org/lkml/20221214163025.103075-1-sgarzare@redhat.com/

Stefano Garzarella (8):
  vdpa: add bind_mm/unbind_mm callbacks
  vhost-vdpa: use bind_mm/unbind_mm device callbacks
  vringh: replace kmap_atomic() with kmap_local_page()
  vringh: support VA with iotlb
  vdpa_sim: make devices agnostic for work management
  vdpa_sim: use kthread worker
  vdpa_sim: replace the spinlock with a mutex to protect the state
  vdpa_sim: add support for user VA

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  11 +-
 include/linux/vdpa.h                 |  10 ++
 include/linux/vringh.h               |   5 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c    |   2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 144 ++++++++++++++++++++-----
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  10 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  10 +-
 drivers/vhost/vdpa.c                 |  31 ++++++
 drivers/vhost/vringh.c               | 153 +++++++++++++++++++++------
 9 files changed, 301 insertions(+), 75 deletions(-)

-- 
2.39.2

