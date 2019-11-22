Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2E5C106109
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbfKVFxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728842AbfKVFxW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 410692071B;
        Fri, 22 Nov 2019 05:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402001;
        bh=HyUpOubg4nCTigLj213XCg7VyoiWNH/jI1E2Ve+V/hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QeChBv8p+eEG21IQjiIT4ztd4wNSwnh5B4qZ0tGJNZ2eWlKQYpgB0esh4gHDEqjaF
         /fsoSOF3ByKyOzAYrNqdNSNAbOBRkkSl/3LuZ+8++4KIaKCwUTDAIsb9Add8d7Oa/1
         vJQpe9P6ttQA1N2OPi1lNX5DasPVdV+Xfkkqd9r4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 218/219] xdp: fix cpumap redirect SKB creation bug
Date:   Fri, 22 Nov 2019 00:49:09 -0500
Message-Id: <20191122054911.1750-210-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>

[ Upstream commit 676e4a6fe703f2dae699ee9d56f14516f9ada4ea ]

We want to avoid leaking pointer info from xdp_frame (that is placed in
top of frame) like commit 6dfb970d3dbd ("xdp: avoid leaking info stored in
frame data on page reuse"), and followup commit 97e19cce05e5 ("bpf:
reserve xdp_frame size in xdp headroom") that reserve this headroom.

These changes also affected how cpumap constructed SKBs, as xdpf->headroom
size changed, the skb data starting point were in-effect shifted with 32
bytes (sizeof xdp_frame). This was still okay, as the cpumap frame_size
calculation also included xdpf->headroom which were reduced by same amount.

A bug was introduced in commit 77ea5f4cbe20 ("bpf/cpumap: make sure
frame_size for build_skb is aligned if headroom isn't"), where the
xdpf->headroom became part of the SKB_DATA_ALIGN rounding up. This
round-up to find the frame_size is in principle still correct as it does
not exceed the 2048 bytes frame_size (which is max for ixgbe and i40e),
but the 32 bytes offset of pkt_data_start puts this over the 2048 bytes
limit. This cause skb_shared_info to spill into next frame. It is a little
hard to trigger, as the SKB need to use above 15 skb_shinfo->frags[] as
far as I calculate. This does happen in practise for TCP streams when
skb_try_coalesce() kicks in.

KASAN can be used to detect these wrong memory accesses, I've seen:
 BUG: KASAN: use-after-free in skb_try_coalesce+0x3cb/0x760
 BUG: KASAN: wild-memory-access in skb_release_data+0xe2/0x250

Driver veth also construct a SKB from xdp_frame in this way, but is not
affected, as it doesn't reserve/deduct the room (used by xdp_frame) from
the SKB headroom. Instead is clears the pointers via xdp_scrub_frame(),
and allows SKB to use this area.

The fix in this patch is to do like veth and instead allow SKB to (re)use
the area occupied by xdp_frame, by clearing via xdp_scrub_frame().  (This
does kill the idea of the SKB being able to access (mem) info from this
area, but I guess it was a bad idea anyhow, and it was already killed by
the veth changes.)

Fixes: 77ea5f4cbe20 ("bpf/cpumap: make sure frame_size for build_skb is aligned if headroom isn't")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 8974b3755670e..3c18260403dde 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -162,10 +162,14 @@ static void cpu_map_kthread_stop(struct work_struct *work)
 static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 					 struct xdp_frame *xdpf)
 {
+	unsigned int hard_start_headroom;
 	unsigned int frame_size;
 	void *pkt_data_start;
 	struct sk_buff *skb;
 
+	/* Part of headroom was reserved to xdpf */
+	hard_start_headroom = sizeof(struct xdp_frame) +  xdpf->headroom;
+
 	/* build_skb need to place skb_shared_info after SKB end, and
 	 * also want to know the memory "truesize".  Thus, need to
 	 * know the memory frame size backing xdp_buff.
@@ -183,15 +187,15 @@ static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 	 * is not at a fixed memory location, with mixed length
 	 * packets, which is bad for cache-line hotness.
 	 */
-	frame_size = SKB_DATA_ALIGN(xdpf->len + xdpf->headroom) +
+	frame_size = SKB_DATA_ALIGN(xdpf->len + hard_start_headroom) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
-	pkt_data_start = xdpf->data - xdpf->headroom;
+	pkt_data_start = xdpf->data - hard_start_headroom;
 	skb = build_skb(pkt_data_start, frame_size);
 	if (!skb)
 		return NULL;
 
-	skb_reserve(skb, xdpf->headroom);
+	skb_reserve(skb, hard_start_headroom);
 	__skb_put(skb, xdpf->len);
 	if (xdpf->metasize)
 		skb_metadata_set(skb, xdpf->metasize);
@@ -205,6 +209,9 @@ static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 	 * - RX ring dev queue index	(skb_record_rx_queue)
 	 */
 
+	/* Allow SKB to reuse area used by xdp_frame */
+	xdp_scrub_frame(xdpf);
+
 	return skb;
 }
 
-- 
2.20.1

