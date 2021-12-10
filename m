Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F886470A03
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242470AbhLJTSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:18:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59362 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242195AbhLJTSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:18:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EF64CE2D28;
        Fri, 10 Dec 2021 19:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB939C341C5;
        Fri, 10 Dec 2021 19:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639163705;
        bh=isH8dT0TmGSEhclYPCWPMyxur+D/v8HVe7SNxywRjD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpTL+M7vjlD82DGwNQbtQRH5GHfSKZpPgcIUftyMLL446bBXt70be6veQah1sFW1L
         1K7OMuSPCnhmgstt3c4yITiIW46wSUIeP2E/ZPXYdM4ORbCv60RwfIQyK0N1anB9HS
         ijOV1Dabgw2rSQ2A82SzL1/JQQU9mdnl9EEo3U9tRrMPtxikb1riN2ZbZihUfdDZrS
         VhKW9iGKCABXRPZFD28De1bstq6BpSbG94pOOJxNZkPy5bWk+aG31vNcyZJxMFxkrB
         cQE+liZ+k0Zs5EjEqHRJxIPkqQVNsuIEoPeZ8ITbA4uDpot99T8xVg2eEsSyQjI1YF
         oPPoT+IkZQ15w==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v20 bpf-next 01/23] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Fri, 10 Dec 2021 20:14:08 +0100
Message-Id: <fb929b6db22166685fea807e3fc20b49fed74597.1639162845.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1639162845.git.lorenzo@kernel.org>
References: <cover.1639162845.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_frags_size field in skb_shared_info data structure
to store xdp_buff/xdp_frame frame paged size (xdp_frags_size will
be used in xdp multi-buff support). In order to not increase
skb_shared_info size we will use a hole due to skb_shared_info
alignment.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 686a666d073d..2eecb6931975 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -535,6 +535,7 @@ struct skb_shared_info {
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_size;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.33.1

