Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938B2490F9F
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 18:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238882AbiAQRa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 12:30:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41744 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAQRay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 12:30:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A14BFB81055;
        Mon, 17 Jan 2022 17:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5A7C36AE7;
        Mon, 17 Jan 2022 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642440651;
        bh=+QcweZFoQoyVtKcd6UBT+oVRxyH4F1ClnSvb77XOSQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U6yweeKmtrlt7D4cnfYR72YwgfTD+PxTTrO7/MrJdHCjdUhxcxqE/GJ3n62c0hqhx
         2/s30luKiq1qI/1X2vJO75khtYzAhjvpvFY7SWSN5wk4hQircG0a9b6I/FYSsD6aIb
         ASXX3bnG47hS0/JOEX0KfrUUcRaacrTckciQFhFEdARsfHtzU+veS6oQ/bMmjK/tMk
         ZmLZdIBdGrdf39Y2AH8lNvcSwQm7slygCwJrkt3e2tZ9a4n/ga5TWkmDc7koO9vpJB
         bhB+7CgMLVIeEuvDgpp+yNSsTRe2d5RVJQPu+toNcCs5NCP2P/yotbrNQRZ7Xh/qMi
         5Hr6UiSpx1ymA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v22 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-frags
Date:   Mon, 17 Jan 2022 18:28:35 +0100
Message-Id: <b74ddaeb1110645c82b50a949ec4497784626322.1642439548.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642439548.git.lorenzo@kernel.org>
References: <cover.1642439548.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_REDIRECT is not fully supported yet for xdp multi-frags since not
all XDP capable drivers can map non-linear xdp_frame in ndo_xdp_xmit
so disable it for the moment.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 06b4b946fa45..546df4152d6f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4266,6 +4266,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	enum bpf_map_type map_type = ri->map_type;
 
+	/* XDP_REDIRECT is not fully supported yet for xdp multi-frags since
+	 * not all XDP capable drivers can map non-linear xdp_frame in
+	 * ndo_xdp_xmit.
+	 */
+	if (unlikely(xdp_buff_has_frags(xdp) &&
+		     map_type != BPF_MAP_TYPE_CPUMAP))
+		return -EOPNOTSUPP;
+
 	if (map_type == BPF_MAP_TYPE_XSKMAP)
 		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
 
-- 
2.34.1

