Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD44F470A34
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343600AbhLJTUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbhLJTUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:20:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BC6C061746;
        Fri, 10 Dec 2021 11:17:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B5090CE2D29;
        Fri, 10 Dec 2021 19:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1148CC341CA;
        Fri, 10 Dec 2021 19:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163816;
        bh=KRuwvmELayNeOQBaAYt8FMDWk0ogkUtR2XkJ2lcNJWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBD1srTAYHd/67Cm1IFM4cXulW7uG8IFCGK2FxSpebInk9dVEMmhx8sMuxehwzEfy
         ApsFSjMUbAetKCtSf1eQKgo9bvGlryTMRLR+CNuYhm8/XH9OUJiT46JObb5hGhomOV
         fnQKWAW/CFe4wIIO/99YqOMXimRagL8o+7v7JEOa9Fi2Vq4uLCMe9fFALoLcZx7+Ma
         YHj/vNoOJqHLrviyp+4ZHFJ0dygbCMORSVCoPUBIX7jTj3Gftuz5/cGQTYw5SkKlSE
         08UUGmWCIctTgueIWUpfipSswv3iWZ0l19Q0+RYk6JY1IQT21PJR5ft51WL4gWBIk/
         Y5sICXn1bIa4w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-buff
Date:   Fri, 10 Dec 2021 20:14:30 +0100
Message-Id: <a6b33109dea5e82d975ea1ee229f7714d0ffdf77.1639162846.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
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
index 14860931733d..def6e9f451a7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4186,6 +4186,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 	struct bpf_map *map;
 	int err;
 
+	/* XDP_REDIRECT is not fully supported yet for xdp multi-buff since
+	 * not all XDP capable drivers can map non-linear xdp_frame in
+	 * ndo_xdp_xmit.
+	 */
+	if (unlikely(xdp_buff_is_mb(xdp) && map_type != BPF_MAP_TYPE_CPUMAP))
+		return -EOPNOTSUPP;
+
 	ri->map_id = 0; /* Valid map id idr range: [1,INT_MAX[ */
 	ri->map_type = BPF_MAP_TYPE_UNSPEC;
 
-- 
2.33.1

