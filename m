Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C096C8164
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 16:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjCXPhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 11:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjCXPha (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 11:37:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955FA1ACC8
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679672180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Z/Kz7kV+UiInmN3q36fZWIJQ0sjJV/FHyS/DppuKTvQ=;
        b=eW4Ah/mrfC7pv7ma80zN3R370PX2euPb2qm2LBIa7wvv6x5uO3pmBg3NkMxdDTKGZE3Nnp
        JvDzCj8v452/k3jZBECeQ9pEXoDMUW3zE4VfnjASEakS83drUi1oVvldt5xr1K4MbsVRVC
        xlyuTkZeGLqAEDVQAL9Cr0f+GGsFsBA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-Nw5GEuXuOlWtVifM9DU_fA-1; Fri, 24 Mar 2023 11:36:18 -0400
X-MC-Unique: Nw5GEuXuOlWtVifM9DU_fA-1
Received: by mail-ed1-f71.google.com with SMTP id h11-20020a0564020e8b00b004e59d4722a3so3744176eda.6
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 08:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679672177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z/Kz7kV+UiInmN3q36fZWIJQ0sjJV/FHyS/DppuKTvQ=;
        b=2Z+ISLIv5Ud8UMx0YYkuu38B0ybnd3MfzViqRo67S171LH+h9GYjbbShQTU8pMO1Xv
         EMvo2ZoGeqKtJ6OZ4lDE9XnhBRYRcjY8Qe1qy4V8WxB36nqNi7UYVBGqF9Ff6iAOt1bf
         B6A+wvXjwvJOswxhyRarfn55ZcPv7Ll4K3Inpj1pnrX55S+cqtolnDRif/MQiAgTYZg2
         4MNBBhSGHsqd6T+9vk4Ume5vdjXq0CyiaS+5VZXq3g9xBTj15xlD4wk0t9so1xjQ8XEF
         weOBomE3WL/Th27cXapdQUEC8u7bFWjWBas29CttqkZIWN9ZIgugfPpvYFAQlbbUX33n
         GMzA==
X-Gm-Message-State: AAQBX9dw2gAfy928LHvjH/JnLK0vLrFv1c9o4Dl/SOAMs5gxJd0CN5Cq
        p9ySn89yLbXMALs7VFrLpwD2kNkWPLdXgR9TrgMQz34jDRTBjNsUTl6nyH5U+BNC+KXP7XGqIMH
        Z8aBguDX9NbBc9jGC
X-Received: by 2002:aa7:c6c8:0:b0:4f9:deb4:b986 with SMTP id b8-20020aa7c6c8000000b004f9deb4b986mr2885732eds.7.1679672177755;
        Fri, 24 Mar 2023 08:36:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350ay1iv3SvkhVkCpZgFjlrGDYTHaf4l+WBI3Lkacaxfq08vNdhGScQ/rdLUDCOdmvue3dyREYA==
X-Received: by 2002:aa7:c6c8:0:b0:4f9:deb4:b986 with SMTP id b8-20020aa7c6c8000000b004f9deb4b986mr2885714eds.7.1679672177492;
        Fri, 24 Mar 2023 08:36:17 -0700 (PDT)
Received: from localhost.localdomain (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id a27-20020a509b5b000000b00501dd53dbfbsm5468613edj.75.2023.03.24.08.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 08:36:16 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     stefanha@redhat.com, Jason Wang <jasowang@redhat.com>,
        linux-kernel@vger.kernel.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, eperezma@redhat.com,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH v4 0/9] vdpa_sim: add support for user VA
Date:   Fri, 24 Mar 2023 16:35:58 +0100
Message-Id: <20230324153607.46836-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
v3: https://lore.kernel.org/lkml/20230321154228.182769-1-sgarzare@redhat.com/
v2: https://lore.kernel.org/lkml/20230302113421.174582-1-sgarzare@redhat.com/
RFC v1: https://lore.kernel.org/lkml/20221214163025.103075-1-sgarzare@redhat.com/

Stefano Garzarella (9):
  vdpa: add bind_mm/unbind_mm callbacks
  vhost-vdpa: use bind_mm/unbind_mm device callbacks
  vringh: replace kmap_atomic() with kmap_local_page()
  vringh: define the stride used for translation
  vringh: support VA with iotlb
  vdpa_sim: make devices agnostic for work management
  vdpa_sim: use kthread worker
  vdpa_sim: replace the spinlock with a mutex to protect the state
  vdpa_sim: add support for user VA

 drivers/vdpa/vdpa_sim/vdpa_sim.h     |  11 +-
 include/linux/vdpa.h                 |  10 ++
 include/linux/vringh.h               |   9 ++
 drivers/vdpa/vdpa_sim/vdpa_sim.c     | 161 ++++++++++++++++++++-----
 drivers/vdpa/vdpa_sim/vdpa_sim_blk.c |  10 +-
 drivers/vdpa/vdpa_sim/vdpa_sim_net.c |  10 +-
 drivers/vhost/vdpa.c                 |  34 ++++++
 drivers/vhost/vringh.c               | 173 ++++++++++++++++++++++-----
 8 files changed, 340 insertions(+), 78 deletions(-)

-- 
2.39.2

