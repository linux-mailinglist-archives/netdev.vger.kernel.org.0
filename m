Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32F376560ED
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiLZHuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbiLZHuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:50:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714DD5FF7
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 23:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672040959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=r0SQFSZXD8Vb1EKKItz+UfkpNXT80NYrf2iD+mDfQXM=;
        b=GjXvKJXOTdycRXPt/NgJ22tDlCaxr+j2cZ+5eVmL3IOtnVFTfewngS7DZv8MZWuPGvJGc3
        d+TdxXaP1TRGboEYxQBIUfqNvLLXnhQhSUTTnqahe0C8yDqAn97j+PYwzzH5H04Q2bz5jS
        hml8rp1VmLRbC/4B/TRM/T9nh1+HQnk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-Bwd-GaOKMOud6zZNOUbn6Q-1; Mon, 26 Dec 2022 02:49:15 -0500
X-MC-Unique: Bwd-GaOKMOud6zZNOUbn6Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20A448533DF;
        Mon, 26 Dec 2022 07:49:15 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-100.pek2.redhat.com [10.72.13.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83DFB492B00;
        Mon, 26 Dec 2022 07:49:10 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [PATCH 0/4] virtio-net: don't busy poll for cvq command
Date:   Mon, 26 Dec 2022 15:49:04 +0800
Message-Id: <20221226074908.8154-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:

The code used to busy poll for cvq command which turns out to have
several side effects:

1) infinite poll for buggy devices
2) bad interaction with scheduler

So this series tries to use sleep + timeout instead of busy polling.

Please review.

Thanks

Changes since RFC:

- switch to use BAD_RING in virtio_break_device()
- check virtqueue_is_broken() after being woken up
- use more_used() instead of virtqueue_get_buf() to allow caller to
  get buffers afterwards
- break the virtio-net device when timeout
- get buffer manually since the virtio core check more_used() instead

Jason Wang (4):
  virtio-net: convert rx mode setting to use workqueue
  virtio_ring: switch to use BAD_RING()
  virtio_ring: introduce a per virtqueue waitqueue
  virtio-net: sleep instead of busy waiting for cvq command

 drivers/net/virtio_net.c     | 90 +++++++++++++++++++++++++++++++-----
 drivers/virtio/virtio_ring.c | 37 +++++++++++++--
 include/linux/virtio.h       |  3 ++
 3 files changed, 115 insertions(+), 15 deletions(-)

-- 
2.25.1

