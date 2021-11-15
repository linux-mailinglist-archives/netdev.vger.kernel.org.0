Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD3E4517E7
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351334AbhKOWtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 17:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351221AbhKOWlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 17:41:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC95F6325D;
        Mon, 15 Nov 2021 22:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015725;
        bh=GEsNAfXHJHpOepsniwhhtZAL1mAAfzENjn4djEbmaZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAhsb+8qLgO2SMaqv1FKEmPWpl3NIAWyCRYEWe3o9IbbNkVTCeVFd3tToZXB3S5HF
         I+1VYSySjxIzH04aBYt5le+HI2Kgl02S2bI2ApH7Uw9lwmrRLmKg6pnN6a1gwFdnNI
         49exhey5MTOhgIH8W2zm2vTTw21u1xkjD2VF3k1mp2ECm2ChJN6cReV/P8WQsp6Aw+
         fepymDECe5kFyDYVYu7DAmsuqhMHHcdf9XDa/eRo4kn3e6GaApj+cuzTaDitVAa5E/
         kePhPyt8x7MCFlR6IsmesiRyF/Ohyt3iTwhDqb0XxyGR8pm73M+IECdhe+e5HfVk++
         rJ/2QDdp/ziVA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v18 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-buff
Date:   Mon, 15 Nov 2021 23:33:17 +0100
Message-Id: <f3e76f7cd2862f0075de896cd1f221cb0dbeb9aa.1637013639.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1637013639.git.lorenzo@kernel.org>
References: <cover.1637013639.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_REDIRECT is not fully supported yet for xdp multi-buff since not
all XDP capable drivers can map non-linear xdp_frame in ndo_xdp_xmit
so disable it for the moment.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/filter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 21a2c47809b5..1de13a790570 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4182,6 +4182,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_map *map;
 	int err;
 
+	/* XDP_REDIRECT is not fully supported yet for xdp multi-buff since
+	 * not all XDP capable drivers can map non-linear xdp_frame in
+	 * ndo_xdp_xmit.
+	 */
+	if (unlikely(xdp_buff_is_mb(xdp)))
+		return -EOPNOTSUPP;
+
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-- 
2.31.1

