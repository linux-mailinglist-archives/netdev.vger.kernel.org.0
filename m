Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D885C488380
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 12:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbiAHLzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 06:55:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53426 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiAHLzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 06:55:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7AF760EFE;
        Sat,  8 Jan 2022 11:55:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816FCC36AF3;
        Sat,  8 Jan 2022 11:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641642930;
        bh=+pY8Gxp6GNs6G5Vt7EVYy9afy7V3+Q1ovoCsdRbjfNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdjbbX4zKgXGpwoC9WIKGIu9uZ9szTb++MwsPRrJO3QbPzlHgTphPV2v7jss1GNBy
         EMPkfjn65qb/4YmgROV/7mL7dK06iHkexDdr65X86APbWRkJpJqmpLd3NA99hhbJYY
         D+sGo3bxJ0pssxeZ2RI4ywodk7D95a8jXdgfXo2SZ2u0x8QDEyU/cAQPoRIJGng4Jo
         08PuR4J36JGg0FRUB/Mpmym0iuegbXw/k5tpW1BH5V7DBu3uPEKkmvT887OLr2jsW0
         cdnQ5aC634ta4rhh4kCeujHic7Utb/ZTCImLgXcHpMv7ZdRolShNOCoqOMEaw0U9bq
         KL8tBELerN6SA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v21 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-buff
Date:   Sat,  8 Jan 2022 12:53:26 +0100
Message-Id: <e3544f2e786b9442385be37a658d9562724e5395.1641641663.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641641663.git.lorenzo@kernel.org>
References: <cover.1641641663.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP_REDIRECT is not fully supported yet for xdp multi-buff since not
all XDP capable drivers can map non-linear xdp_frame in ndo_xdp_xmit
so disable it for the moment.

Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/core/filter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 2249377b3b1f..e6f6abb54af1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4266,6 +4266,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
 	enum bpf_map_type map_type = ri->map_type;
 
+	/* XDP_REDIRECT is not fully supported yet for xdp multi-buff since
+	 * not all XDP capable drivers can map non-linear xdp_frame in
+	 * ndo_xdp_xmit.
+	 */
+	if (unlikely(xdp_buff_is_mb(xdp) && map_type != BPF_MAP_TYPE_CPUMAP))
+		return -EOPNOTSUPP;
+
 	if (map_type == BPF_MAP_TYPE_XSKMAP)
 		return __xdp_do_redirect_xsk(ri, dev, xdp, xdp_prog);
 
-- 
2.33.1

