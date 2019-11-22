Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AD2106553
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728934AbfKVGXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:23:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:56838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbfKVFvi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F2720726;
        Fri, 22 Nov 2019 05:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401898;
        bh=ihPG//jNFj6mdLcSyAiHByfXaouHt8MxyYWi42hQ/NQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ck3hL2BXqee42NFIpEabYZaHhrSGQGsmMHtlDaLV2D29zwEYpIATgY7FE8RnHoHeI
         M+gZt15S3ivo30lal0hzfQZWC1hepGvpN5uYJxFb2p85XyTM3MeSXpt6MBq197u5ex
         bxjxpti9bDFh34q3cVYoT6VnwkPOqGMskdNeSTFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 130/219] bpf/cpumap: make sure frame_size for build_skb is aligned if headroom isn't
Date:   Fri, 22 Nov 2019 00:47:42 -0500
Message-Id: <20191122054911.1750-123-sashal@kernel.org>
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

[ Upstream commit 77ea5f4cbe2084db9ab021ba73fb7eadf1610884 ]

The frame_size passed to build_skb must be aligned, else it is
possible that the embedded struct skb_shared_info gets unaligned.

For correctness make sure that xdpf->headroom in included in the
alignment. No upstream drivers can hit this, as all XDP drivers provide
an aligned headroom.  This was discovered when playing with implementing
XDP support for mvneta, which have a 2 bytes DSA header, and this
Marvell ARM64 platform didn't like doing atomic operations on an
unaligned skb_shinfo(skb)->dataref addresses.

Fixes: 1c601d829ab0 ("bpf: cpumap xdp_buff to skb conversion and allocation")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 24aac0d0f4127..8974b3755670e 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -183,7 +183,7 @@ static struct sk_buff *cpu_map_build_skb(struct bpf_cpu_map_entry *rcpu,
 	 * is not at a fixed memory location, with mixed length
 	 * packets, which is bad for cache-line hotness.
 	 */
-	frame_size = SKB_DATA_ALIGN(xdpf->len) + xdpf->headroom +
+	frame_size = SKB_DATA_ALIGN(xdpf->len + xdpf->headroom) +
 		SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	pkt_data_start = xdpf->data - xdpf->headroom;
-- 
2.20.1

