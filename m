Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C364F17371A
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 13:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgB1MUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 07:20:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52655 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725769AbgB1MUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 07:20:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582892411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=w9cxFp8LDEAVTHlgkfdjkdM6yZMYvsET80U5OR5BNZU=;
        b=YhiUiTltYJ6YwAxy0RFGDQm98tc9aoyCV3I/jVQsjfzRUeHuGIMaqK17BzSz+MCX47lLnK
        AQEYykzhSw8dPC/1jk7enDo6uHCyLk3jh+Xl/5C2v01NdZ5Ozs693e/x/WaeeWbxIaN1Nu
        H99IT6FiyY8pm0PW5JYb0QUW2ly1IzE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-L8ZPG99NPxWSgrPGihX6Ag-1; Fri, 28 Feb 2020 07:20:09 -0500
X-MC-Unique: L8ZPG99NPxWSgrPGihX6Ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 854C81882CDD;
        Fri, 28 Feb 2020 12:20:08 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-20.brq.redhat.com [10.40.200.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA9BC1CB;
        Fri, 28 Feb 2020 12:20:05 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 42BB130737E05;
        Fri, 28 Feb 2020 13:20:04 +0100 (CET)
Subject: [net-next PATCH] ixgbe: fix XDP redirect on archs with PAGE_SIZE
 above 4K
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org
Date:   Fri, 28 Feb 2020 13:20:04 +0100
Message-ID: <158289240414.1877500.8426359194461700361.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ixgbe driver have another memory model when compiled on archs with
PAGE_SIZE above 4096 bytes. In this mode it doesn't split the page in
two halves, but instead increment rx_buffer->page_offset by truesize of
packet (which include headroom and tailroom for skb_shared_info).

This is done correctly in ixgbe_build_skb(), but in ixgbe_rx_buffer_flip
which is currently only called on XDP_TX and XDP_REDIRECT, it forgets
to add the tailroom for skb_shared_info. This breaks XDP_REDIRECT, for
veth and cpumap.  Fix by adding size of skb_shared_info tailroom.

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 718931d951bc..ea6834bae04c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2254,7 +2254,8 @@ static void ixgbe_rx_buffer_flip(struct ixgbe_ring *rx_ring,
 	rx_buffer->page_offset ^= truesize;
 #else
 	unsigned int truesize = ring_uses_build_skb(rx_ring) ?
-				SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) :
+				SKB_DATA_ALIGN(IXGBE_SKB_PAD + size) +
+				SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) :
 				SKB_DATA_ALIGN(size);
 
 	rx_buffer->page_offset += truesize;


