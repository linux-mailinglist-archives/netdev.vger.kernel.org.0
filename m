Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BAF495D80
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379942AbiAUKMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379945AbiAUKM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:12:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783C0C061747;
        Fri, 21 Jan 2022 02:12:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40235B81ED8;
        Fri, 21 Jan 2022 10:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE81DC340E9;
        Fri, 21 Jan 2022 10:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759944;
        bh=KxgT3lI8XlIXUdrYPblv6WAjSlRW8mlbV317CWutWdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NNFtKvmXSWvvxdplqmkFCd/dBhpx3ioIVTAeJkzkwfa4k13SE/tNpaZrn0TdyQ/xE
         xY5c0Fapd8M/IhwlePO7N+1IRnkswmpLJbntP2x/Fkl+LxEfPe1UsAJDWuGHd8e/zn
         npWELF511v78qqUPitfOmn+jTkWcPNLQaikNMOORhNMchnvUGHgIHiCpF/MPGVMbP+
         MiEnAZjF3ZhxzGp+iTfn1GAqZ1FQ6jTJ0ac+5mRqNQCiEfKU8Z5Gj0zgyfQrAm8SR6
         4ul4MmwobAuKdfyDjp8vmKOPPfZanFaNcWTqXLBomuVtl0WNGiRX0e+Pq3C/GkObAR
         HYY1lrHJDGPJQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp frags
Date:   Fri, 21 Jan 2022 11:10:06 +0100
Message-Id: <0da25e117d0e2673f5d0ce6503393c55c6fb1be9.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1642758637.git.lorenzo@kernel.org>
References: <cover.1642758637.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_REDIRECT is not fully supported yet for xdp frags since not
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
index 945ccaaab3cb..a06931c27eeb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4266,6 +4266,14 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	enum bpf_map_type map_type = ri->map_type;
 
+	/* XDP_REDIRECT is not fully supported yet for xdp frags since
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

