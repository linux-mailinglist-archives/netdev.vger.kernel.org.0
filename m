Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 784A78450B
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 08:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfHGGzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 02:55:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33962 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbfHGGzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 02:55:01 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 58CDC8EA41;
        Wed,  7 Aug 2019 06:55:01 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C5081000324;
        Wed,  7 Aug 2019 06:54:55 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH V3 00/10] Fixes for metadata accelreation
Date:   Wed,  7 Aug 2019 02:54:39 -0400
Message-Id: <20190807065449.23373-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 07 Aug 2019 06:55:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:

This series try to fix several issues introduced by meta data
accelreation series. Please review.

Changes from V2:
- use seqlck helper to synchronize MMU notifier with vhost worker

Changes from V1:

- try not use RCU to syncrhonize MMU notifier with vhost worker
- set dirty pages after no readers
- return -EAGAIN only when we find the range is overlapped with
  metadata

Jason Wang (9):
  vhost: don't set uaddr for invalid address
  vhost: validate MMU notifier registration
  vhost: fix vhost map leak
  vhost: reset invalidate_count in vhost_set_vring_num_addr()
  vhost: mark dirty pages during map uninit
  vhost: don't do synchronize_rcu() in vhost_uninit_vq_maps()
  vhost: do not use RCU to synchronize MMU notifier with worker
  vhost: correctly set dirty pages in MMU notifiers callback
  vhost: do not return -EAGAIN for non blocking invalidation too early

Michael S. Tsirkin (1):
  vhost: disable metadata prefetch optimization

 drivers/vhost/vhost.c | 228 +++++++++++++++++++++++++++---------------
 drivers/vhost/vhost.h |  10 +-
 2 files changed, 151 insertions(+), 87 deletions(-)

-- 
2.18.1

