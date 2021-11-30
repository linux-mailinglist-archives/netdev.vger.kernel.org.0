Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC044633AF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 12:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbhK3MA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbhK3L7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 06:59:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4B1C0613B6;
        Tue, 30 Nov 2021 03:55:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E99A0CE18BA;
        Tue, 30 Nov 2021 11:55:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F48C53FC1;
        Tue, 30 Nov 2021 11:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638273341;
        bh=Ocr5jJvga2fTrYuwB4nW6CxeA7OdZ+6l9qbMPW89eIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDUhwUuzprPpX4/CxXSoCOXBdwEvozvD2AM3rPuLFLfEDWFocEfnIZzljay/86Gjh
         9t0ljd9kNYZvjd/062UsDEIG9qwiFR2ojOPVsYwiTaNxeblB7wUl/sRbrfoyNbX7qA
         3TXq612vofYFCoqzIhMBpxkUA4QX5i0lT2q7/+b6hClM2qWDRLAJsODLqvVr7QrIYU
         8vZHO4QeZFOTf5RfDPA7vdAG5XKssms9QwvFGUkplHwTROVV75+NPI/Jk1NDycvf7k
         LhLJrdN1pfHWu2nZMfphN9UoIeVd98cWPMrxH9dhmjnMqoG+jUpPleJCM8LbxUE1mw
         V1DUY4DW9KFNA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v19 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-buff
Date:   Tue, 30 Nov 2021 12:53:07 +0100
Message-Id: <df855fe05b80746fa7f657fce78b24d582f133cb.1638272239.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1638272238.git.lorenzo@kernel.org>
References: <cover.1638272238.git.lorenzo@kernel.org>
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
index b70725313442..a87d835d1122 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4189,6 +4189,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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

