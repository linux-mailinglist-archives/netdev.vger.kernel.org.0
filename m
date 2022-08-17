Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA55259704B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239295AbiHQN5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiHQN5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:57:40 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55B595E49;
        Wed, 17 Aug 2022 06:57:38 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 03E1A1008B391;
        Wed, 17 Aug 2022 21:57:33 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id DDAC62009BEAF;
        Wed, 17 Aug 2022 21:57:32 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id drv0zevZDvRU; Wed, 17 Aug 2022 21:57:31 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id C2FBF2009BEA0;
        Wed, 17 Aug 2022 21:57:19 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 0/7] In order support for virtio_ring, vhost and vsock.
Date:   Wed, 17 Aug 2022 21:57:11 +0800
Message-Id: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In virtio-spec 1.1, new feature bit VIRTIO_F_IN_ORDER was introduced.
When this feature has been negotiated, virtio driver will use
descriptors in ring order: starting from offset 0 in the table, and
wrapping around at the end of the table. Vhost devices will always use
descriptors in the same order in which they have been made available.
This can reduce virtio accesses to used ring.

Based on updated virtio-spec, this series realized IN_ORDER prototype
in virtio driver and vhost. Currently IN_ORDER feature supported devices
are *vhost_test* and *vsock*, and IN_ORDER feature works well combined with
INDIRECT feature in this patch series.

Some work haven't been done in this patch series:
1. Virtio driver in_order support for packed vq is left for the future.

Guo Zhi (7):
  vhost: expose used buffers
  vhost_test: batch used buffer
  vsock: batch buffers in tx
  vsock: announce VIRTIO_F_IN_ORDER in vsock
  virtio: unmask F_NEXT flag in desc_extra
  virtio: in order support for virtio_ring
  virtio: annouce VIRTIO_F_IN_ORDER support

 drivers/vhost/test.c         |  8 ++++-
 drivers/vhost/vhost.c        | 14 +++++++--
 drivers/vhost/vhost.h        |  1 +
 drivers/vhost/vsock.c        | 10 +++++-
 drivers/virtio/virtio_ring.c | 61 ++++++++++++++++++++++++++++++------
 5 files changed, 80 insertions(+), 14 deletions(-)

-- 
2.17.1

