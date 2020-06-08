Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22971F2B24
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730819AbgFHXTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:19:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbgFHXTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D339E2086A;
        Mon,  8 Jun 2020 23:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658372;
        bh=3PuiUQqDTe/7yEbzJ6QkJxv9BBE61RSsdN3LyjCVq2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVB0UJnh+X/PZ77XJKYy0Oir0Kcc2cdWr2Lx+lownIryuTaQ+XrA/YqZSl1ADooBX
         Tjpn7DUG5vH4HzvdicXv8mS3o5F3XoV3wv68EDvImFGbpbJ5QhGM9Fj5Vgnat0glGv
         NjXxcxaeByoYei/+n9T42ktT/dFfHuBt/7v/EY8s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 035/175] ixgbe: Fix XDP redirect on archs with PAGE_SIZE above 4K
Date:   Mon,  8 Jun 2020 19:16:28 -0400
Message-Id: <20200608231848.3366970-35-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 88eb0ee17b2ece64fcf6689a4557a5c2e7a89c4b ]

The ixgbe driver have another memory model when compiled on archs with
PAGE_SIZE above 4096 bytes. In this mode it doesn't split the page in
two halves, but instead increment rx_buffer->page_offset by truesize of
packet (which include headroom and tailroom for skb_shared_info).

This is done correctly in ixgbe_build_skb(), but in ixgbe_rx_buffer_flip
which is currently only called on XDP_TX and XDP_REDIRECT, it forgets
to add the tailroom for skb_shared_info. This breaks XDP_REDIRECT, for
veth and cpumap.  Fix by adding size of skb_shared_info tailroom.

Maintainers notice: This fix have been queued to Jeff.

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Link: https://lore.kernel.org/bpf/158945344946.97035.17031588499266605743.stgit@firesoul
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index a26f9fb95ac0..edaa0bffa5c3 100644
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
-- 
2.25.1

