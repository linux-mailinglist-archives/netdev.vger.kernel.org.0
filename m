Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB6D5A8DB7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233176AbiIAFzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbiIAFy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:54:58 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5B66375;
        Wed, 31 Aug 2022 22:54:53 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 5CEFD1008B39D;
        Thu,  1 Sep 2022 13:54:49 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id D6FAB2009BEAD;
        Thu,  1 Sep 2022 13:54:47 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id GtBnxunfCybj; Thu,  1 Sep 2022 13:54:46 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 00982200A5E62;
        Thu,  1 Sep 2022 13:54:34 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v3 0/7] In order support for virtio_ring, vhost and vsock.
Date:   Thu,  1 Sep 2022 13:54:27 +0800
Message-Id: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
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

Based on updated virtio-spec, this series realized IN_ORDER prototype in virtio
driver and vhost. Currently IN_ORDER feature supported devices are *vhost_test*
and *vsock* in vhost and virtio-net in QEMU. IN_ORDER feature works well
combined with INDIRECT feature in this patch series.

Virtio driver in_order support for packed vq hasn't been done in this patch
series now.

Guo Zhi (7):
  vhost: expose used buffers
  vhost_test: batch used buffer
  vsock: batch buffers in tx
  vsock: announce VIRTIO_F_IN_ORDER in vsock
  virtio: unmask F_NEXT flag in desc_extra
  virtio: in order support for virtio_ring
  virtio: announce VIRTIO_F_IN_ORDER support

 drivers/vhost/test.c         | 16 ++++++--
 drivers/vhost/vhost.c        | 16 ++++++--
 drivers/vhost/vsock.c        | 13 +++++-
 drivers/virtio/virtio_ring.c | 79 +++++++++++++++++++++++++++++++-----
 4 files changed, 104 insertions(+), 20 deletions(-)

-- 
2.17.1

