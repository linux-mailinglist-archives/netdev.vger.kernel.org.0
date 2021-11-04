Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945C64458C6
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhKDRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233983AbhKDRk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D5A1611C4;
        Thu,  4 Nov 2021 17:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047468;
        bh=+5b5e7V3suXF9bMBYwNIaMhKxwfF2xoxxSlP1bkU+B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuyNm/s0MNRUWY+U6Ch47SWK2s9g29CkzYFbvNPtqcglBaM7XO8UD6nU+wvWNVX8l
         vU5sCgE9lzSx4uxIK4yhzdl0TurTNs8G8fHKsGHyTRNNspvFu7AyRJi+O1bZLkwKCd
         +vZwQTQDsj8OiEhvqVhqnkYuTQYggh+yJg7rWRnuCSCYRFQennfs2yxYRbTOXjXJu1
         /PUMQO/nzRcUtgAtreyceF98/YFK+M0pWRjJuhITr95yGAdRC/PA4SUA2TZF9VEugP
         HNModJkU6TnrDjNJAjeXvE2jaqm/w1wTDddwdW5CAro3XVCDoZU9uCiXMsxcHu16hN
         jh26ZpJlTirbQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 23/23] xdp: disable XDP_REDIRECT for xdp multi-buff
Date:   Thu,  4 Nov 2021 18:35:43 +0100
Message-Id: <b90891939e6a4c9a803cd1b5072bb971baa4fb69.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
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
index 534305037ad7..00e08bdeb5f2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4183,6 +4183,13 @@ int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
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

