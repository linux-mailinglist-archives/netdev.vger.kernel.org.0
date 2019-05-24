Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50CA2928C
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389349AbfEXIMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:12:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389093AbfEXIMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 04:12:31 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C814307D851;
        Fri, 24 May 2019 08:12:31 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C7ED19C4F;
        Fri, 24 May 2019 08:12:20 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, peterx@redhat.com,
        James.Bottomley@hansenpartnership.com, hch@infradead.org,
        davem@davemloft.net, jglisse@redhat.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        christophe.de.dinechin@gmail.com, jrdr.linux@gmail.com
Subject: [PATCH net-next 0/6] vhost: accelerate metadata access
Date:   Fri, 24 May 2019 04:12:12 -0400
Message-Id: <20190524081218.2502-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 24 May 2019 08:12:31 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

This series tries to access virtqueue metadata through kernel virtual
address instead of copy_user() friends since they had too much
overheads like checks, spec barriers or even hardware feature
toggling like SMAP. This is done through setup kernel address through
direct mapping and co-opreate VM management with MMU notifiers.

Test shows about 23% improvement on TX PPS. TCP_STREAM doesn't see
obvious improvement.

Thanks

Changes from RFC V3:
- rebase to net-next
- Tweak on the comments
Changes from RFC V2:
- switch to use direct mapping instead of vmap()
- switch to use spinlock + RCU to synchronize MMU notifier and vhost
  data/control path
- set dirty pages in the invalidation callbacks
- always use copy_to/from_users() friends for the archs that may need
  flush_dcache_pages()
- various minor fixes
Changes from V4:
- use invalidate_range() instead of invalidate_range_start()
- track dirty pages
Changes from V3:
- don't try to use vmap for file backed pages
- rebase to master
Changes from V2:
- fix buggy range overlapping check
- tear down MMU notifier during vhost ioctl to make sure
  invalidation request can read metadata userspace address and vq size
  without holding vq mutex.
Changes from V1:
- instead of pinning pages, use MMU notifier to invalidate vmaps
  and remap duing metadata prefetch
- fix build warning on MIPS

Jason Wang (6):
  vhost: generalize adding used elem
  vhost: fine grain userspace memory accessors
  vhost: rename vq_iotlb_prefetch() to vq_meta_prefetch()
  vhost: introduce helpers to get the size of metadata area
  vhost: factor out setting vring addr and num
  vhost: access vq metadata through kernel virtual address

 drivers/vhost/net.c   |   4 +-
 drivers/vhost/vhost.c | 850 ++++++++++++++++++++++++++++++++++++------
 drivers/vhost/vhost.h |  38 +-
 3 files changed, 766 insertions(+), 126 deletions(-)

-- 
2.18.1

