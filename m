Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CE6E7B34
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbjDSNoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbjDSNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:44:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D2415619
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 06:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681911833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MK0UGxGV6JsBO8AYL7soTcS9wXMNV0whUDQXJnSnGMA=;
        b=E/Z1giyboWmWIUuHyi0+9SARPUavcONUdUx+9/04iV80Lr9ZQg2TLCdUxFhBagYRvReJcB
        BuQv+ppZQTKgNLT3UivSK+iX9hS8jRE2xiopMEWS+tyTw3jm5FaPMVFdf2kAZp+aLnEKS/
        +XEUC5z7GfETTB32Rr/VfCacp3SRJo4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-4rw8mCRpPNme_IUbRr3wmA-1; Wed, 19 Apr 2023 09:43:50 -0400
X-MC-Unique: 4rw8mCRpPNme_IUbRr3wmA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC1B2101A554;
        Wed, 19 Apr 2023 13:43:49 +0000 (UTC)
Received: from max-t490s.redhat.com (unknown [10.39.208.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BDAB6492B04;
        Wed, 19 Apr 2023 13:43:47 +0000 (UTC)
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
To:     xieyongji@bytedance.com, jasowang@redhat.com, mst@redhat.com,
        david.marchand@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com,
        Maxime Coquelin <maxime.coquelin@redhat.com>
Subject: [RFC 0/2] vduse: add support for networking devices
Date:   Wed, 19 Apr 2023 15:43:27 +0200
Message-Id: <20230419134329.346825-1-maxime.coquelin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series enables virtio-net device type in VDUSE.
With it, basic operation have been tested, both with
virtio-vdpa and vhost-vdpa using DPDK Vhost library series
adding VDUSE support [0] using split rings layout.

Control queue support (and so multiqueue) has also been
tested, but require a Kernel series from Jason Wang
relaxing control queue polling [1] to function reliably.

Other than that, we have identified a few gaps:

1. Reconnection:
 a. VDUSE_VQ_GET_INFO ioctl() returns always 0 for avail
    index, even after the virtqueue has already been
    processed. Is that expected? I have tried instead to
    get the driver's avail index directly from the avail
    ring, but it does not seem reliable as I sometimes get
    "id %u is not a head!\n" warnings. Also such solution
    would not be possible with packed ring, as we need to
    know the wrap counters values.

 b. Missing IOCTLs: it would be handy to have new IOCTLs to
    query Virtio device status, and retrieve the config
    space set at VDUSE_CREATE_DEV time.

2. VDUSE application as non-root:
  We need to run the VDUSE application as non-root. There
  is some race between the time the UDEV rule is applied
  and the time the device starts being used. Discussing
  with Jason, he suggested we may have a VDUSE daemon run
  as root that would create the VDUSE device, manages its
  rights and then pass its file descriptor to the VDUSE
  app. However, with current IOCTLs, it means the VDUSE
  daemon would need to know several information that
  belongs to the VDUSE app implementing the device such
  as supported Virtio features, config space, etc...
  If we go that route, maybe we should have a control
  IOCTL to create the device which would just pass the
  device type. Then another device IOCTL to perform the
  initialization. Would that make sense?

3. Coredump:
  In order to be able to perform post-mortem analysis, DPDK
  Vhost library marks pages used for vrings and descriptors
  buffers as MADV_DODUMP using madvise(). However with
  VDUSE it fails with -EINVAL. My understanding is that we
  set VM_DONTEXPAND flag to the VMAs and madvise's
  MADV_DODUMP fails if it is present. I'm not sure to
  understand why madvise would prevent MADV_DODUMP if
  VM_DONTEXPAND is set. Any thoughts?

[0]: https://patchwork.dpdk.org/project/dpdk/list/?series=27594&state=%2A&archive=both
[1]: https://lore.kernel.org/lkml/CACGkMEtgrxN3PPwsDo4oOsnsSLJfEmBEZ0WvjGRr3whU+QasUg@mail.gmail.com/T/

Maxime Coquelin (2):
  vduse: validate block features only with block devices
  vduse: enable Virtio-net device type

 drivers/vdpa/vdpa_user/vduse_dev.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.39.2

