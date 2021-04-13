Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C277535D76C
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 07:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344601AbhDMFsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 01:48:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20316 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344335AbhDMFsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 01:48:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618292870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=NoGLR1VJ5gNLYdaNxmqjFzT6An+veHXT72XxxlzyW7A=;
        b=LqGNea/evVgwZkDAOqvivMIXeUppJv7L4x7yOogPxdkuLSujkgG3VlGPxH3aRuH5b1MbzV
        iCwBc6qL0y51WjSqxAF2ieq/frnZ/grR8Tzy5PXn5xkGXwMELHiXu05IZKMhq2oCBZUdDM
        M10L0MfnfbQLv324lpQpDyyX3N+wfiM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-uTnJxCW7N8y-ytn7GhZXlg-1; Tue, 13 Apr 2021 01:47:49 -0400
X-MC-Unique: uTnJxCW7N8y-ytn7GhZXlg-1
Received: by mail-wm1-f69.google.com with SMTP id o3-20020a1c75030000b029010f4e02a2f2so666855wmc.6
        for <netdev@vger.kernel.org>; Mon, 12 Apr 2021 22:47:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=NoGLR1VJ5gNLYdaNxmqjFzT6An+veHXT72XxxlzyW7A=;
        b=jY/i1T8/Nxt48vB7EgzbhJmtVlvRToLarOMKVixRaiquXZJ4+q5vyd5syW6CP5iBkA
         FY1XwX3oAWfjAXWjlZ/0hg6zZwrzplF086IqWwHG/1r4dcoNXZ+9fL6p2z4t7VgeecK8
         N2LquHOs6W82cgbMPTbXXIGBP+IY1ScxYUgEmw0xkHIaKFALlx8NWyaZhb86DK7muEQJ
         DCVGXlmwHCF71q9GmAA3anlEW3k32Tx+tWqVx6HgyaXCKpY2NDjFHDlULzmgO/84+xwU
         xwu7avXcan4iUOoAk/wAxgO21pWfZb+MjU19GVgFAsLScM009lvFKzT9cHbfvY309d2R
         68Jg==
X-Gm-Message-State: AOAM530WngNKuoX8mVzq3RKllyaHln7z3I6rUB0aFj0iO+XjoPYWQjYN
        oEhUJaUyRLnEztkWQb+eDLejT7eAkvjLtD054DYwxcKpaUdWrnDgcIBl9zwnI9MmsW/vudJAtgm
        vVXI3ieG/VU1nxrwM
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr35092242wrj.420.1618292867442;
        Mon, 12 Apr 2021 22:47:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxHY/ypRcjTg5TsZRaoQK31psb9y/vV26Xnbj/l6lE6PeheJEYSaDyTSaGX+fe0fFMMvdRZw==
X-Received: by 2002:adf:dc4f:: with SMTP id m15mr35092229wrj.420.1618292867318;
        Mon, 12 Apr 2021 22:47:47 -0700 (PDT)
Received: from redhat.com ([2a10:8006:2281:0:1994:c627:9eac:1825])
        by smtp.gmail.com with ESMTPSA id u9sm1326079wmc.38.2021.04.12.22.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 22:47:46 -0700 (PDT)
Date:   Tue, 13 Apr 2021 01:47:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jason Wang <jasowang@redhat.com>,
        Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH RFC v2 0/4] virtio net: spurious interrupt related fixes
Message-ID: <20210413054733.36363-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the implementation of napi-tx in virtio driver, we clean tx
descriptors from rx napi handler, for the purpose of reducing tx
complete interrupts. But this introduces a race where tx complete
interrupt has been raised, but the handler finds there is no work to do
because we have done the work in the previous rx interrupt handler.
A similar issue exists with polling from start_xmit, it is however
less common because of the delayed cb optimization of the split ring -
but will likely affect the packed ring once that is more common.

In particular, this was reported to lead to the following warning msg:
[ 3588.010778] irq 38: nobody cared (try booting with the
"irqpoll" option)
[ 3588.017938] CPU: 4 PID: 0 Comm: swapper/4 Not tainted
5.3.0-19-generic #20~18.04.2-Ubuntu
[ 3588.017940] Call Trace:
[ 3588.017942]  <IRQ>
[ 3588.017951]  dump_stack+0x63/0x85
[ 3588.017953]  __report_bad_irq+0x35/0xc0
[ 3588.017955]  note_interrupt+0x24b/0x2a0
[ 3588.017956]  handle_irq_event_percpu+0x54/0x80
[ 3588.017957]  handle_irq_event+0x3b/0x60
[ 3588.017958]  handle_edge_irq+0x83/0x1a0
[ 3588.017961]  handle_irq+0x20/0x30
[ 3588.017964]  do_IRQ+0x50/0xe0
[ 3588.017966]  common_interrupt+0xf/0xf
[ 3588.017966]  </IRQ>
[ 3588.017989] handlers:
[ 3588.020374] [<000000001b9f1da8>] vring_interrupt
[ 3588.025099] Disabling IRQ #38

This patchset attempts to fix this by cleaning up a bunch of races
related to the handling of sq callbacks (aka tx interrupts).
Very lightly tested, sending out for help with testing, early feedback
and flames. Thanks!

Michael S. Tsirkin (4):
  virtio: fix up virtio_disable_cb
  virtio_net: disable cb aggressively
  virtio_net: move tx vq operation under tx queue lock
  virtio_net: move txq wakeups under tx q lock

 drivers/net/virtio_net.c     | 35 +++++++++++++++++++++++++++++------
 drivers/virtio/virtio_ring.c | 26 +++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 7 deletions(-)

-- 
MST

