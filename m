Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9882D3C7211
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 16:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbhGMOYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 10:24:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236765AbhGMOYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 10:24:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eX4hVmJ3QGEY7UloWk+yqK0D8oFDPe7rJcELgdBy7xI=;
        b=B2u49Q23thHhp9568o2e90lKeIVDWvwjyIeI0Jvg9UTrr3xg4XHSHaim/GDWZw4wUVpVZ6
        duGfB5s09uFjwL8Wvfx2uOT6C6P4f3gFASj3DfGdCIJ7kJWzkuI6N5OP1T4psZYvcdL1Dl
        SZ/KLFT2GRBtFK+P2GHsLGwkrOr3mkM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-TaYJXXWBNIKw7jbIdKwJGQ-1; Tue, 13 Jul 2021 10:21:49 -0400
X-MC-Unique: TaYJXXWBNIKw7jbIdKwJGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88B0391FCC1;
        Tue, 13 Jul 2021 14:21:47 +0000 (UTC)
Received: from localhost.localdomain (ovpn-115-18.ams2.redhat.com [10.36.115.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B571C5C1C5;
        Tue, 13 Jul 2021 14:21:44 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ivan@cloudflare.com
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH v3 0/3] Fix lack of XDP TX queues
Date:   Tue, 13 Jul 2021 16:21:26 +0200
Message-Id: <20210713142129.17077-1-ihuguet@redhat.com>
In-Reply-To: <20210707081642.95365-1-ihuguet@redhat.com>
References: <20210707081642.95365-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A change introduced in commit e26ca4b53582 ("sfc: reduce the number of
requested xdp ev queues") created a bug in XDP_TX and XDP_REDIRECT
because it unintentionally reduced the number of XDP TX queues, letting
not enough queues to have one per CPU, which leaded to errors if XDP
TX/REDIRECT was done from a high numbered CPU.

This patchs make the following changes:
- Fix the bug mentioned above
- Revert commit 99ba0ea616aa ("sfc: adjust efx->xdp_tx_queue_count with
  the real number of initialized queues") which intended to fix a related
  problem, created by mentioned bug, but it's no longer necessary
- Add a new error log message if there are not enough resources to make
  XDP_TX/REDIRECT work

V1 -> V2: keep the calculation of how many tx queues can handle a single
event queue, but apply the "max. tx queues per channel" upper limit.
V2 -> V3: WARN_ON if the number of initialized XDP TXQs differs from the
expected.

Íñigo Huguet (3):
  sfc: fix lack of XDP TX queues - error XDP TX failed (-22)
  sfc: ensure correct number of XDP queues
  sfc: add logs explaining XDP_TX/REDIRECT is not available

 drivers/net/ethernet/sfc/efx_channels.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

-- 
2.31.1

