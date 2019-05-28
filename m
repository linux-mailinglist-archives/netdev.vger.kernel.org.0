Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D02C4EF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 12:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfE1K4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 06:56:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfE1K4g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 06:56:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BD432C05D3F4;
        Tue, 28 May 2019 10:56:36 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-13.ams2.redhat.com [10.36.117.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 391E97D59A;
        Tue, 28 May 2019 10:56:25 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 0/4] vsock/virtio: several fixes in the .probe() and .remove()
Date:   Tue, 28 May 2019 12:56:19 +0200
Message-Id: <20190528105623.27983-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 28 May 2019 10:56:36 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the review of "[PATCH] vsock/virtio: Initialize core virtio vsock
before registering the driver", Stefan pointed out some possible issues
in the .probe() and .remove() callbacks of the virtio-vsock driver.

This series tries to solve these issues:
- Patch 1 postpones the 'the_virtio_vsock' assignment at the end of the
  .probe() to avoid that some sockets queue works when the initialization
  is not finished.
- Patches 2 and 3 stop workers before to call vdev->config->reset(vdev) to
  be sure that no one is accessing the device, and adds another flush at the
  end of the .remove() to avoid use after free.
- Patch 4 free also used buffers in the virtqueues during the .remove().

Stefano Garzarella (4):
  vsock/virtio: fix locking around 'the_virtio_vsock'
  vsock/virtio: stop workers during the .remove()
  vsock/virtio: fix flush of works during the .remove()
  vsock/virtio: free used buffers during the .remove()

 net/vmw_vsock/virtio_transport.c | 105 ++++++++++++++++++++++++++-----
 1 file changed, 90 insertions(+), 15 deletions(-)

-- 
2.20.1

