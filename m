Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637F14028E0
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 14:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344131AbhIGMhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 08:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343886AbhIGMhB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 08:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C23E6103E;
        Tue,  7 Sep 2021 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631018155;
        bh=GGQon1PPp8SKWGMfOK2C1SfWj6w31CT6tgDn+rh4m0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aopCcJ5PlxHNsucpF85aS7zoDGaxO4g3HdpdDM9+y91ZPavCQTYeRRF5VfwcjEwwC
         F5kzpe9ybIB981cXO7xxmKjxDHfUdJG4Zah6St9kVgUndflmal9Isn1KJvE/XC4oAW
         o0Ho7RG5CzqHPhF4UqvFrmADiQut81Znd/otx3gecktLAEcn3ZnzMI7nLg1lRlsw3g
         7qSU08yWBqCGYN3fziTcQCSqlb9SfC6Dutc7fBPrX75QxMtc6BDNp0gOH8UQM7BiDq
         hZ73Aji3eda5YX06kJqkmdOI2LJZULxyMgvuSv1y4YvZ7E4GXcSf1+nWMZW9Foi5pX
         uvPgOfT/qtLXQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v13 bpf-next 01/18] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Tue,  7 Sep 2021 14:35:05 +0200
Message-Id: <1721d45800a333a46c2cdde0fd25eb6f02f49ecf.1631007211.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631007211.git.lorenzo@kernel.org>
References: <cover.1631007211.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_frags_tsize field in skb_shared_info data structure
to store xdp_buff/xdp_frame truesize (xdp_frags_tsize will be used
in xdp multi-buff support). In order to not increase skb_shared_info
size we will use a hole due to skb_shared_info alignment.
Introduce xdp_frags_size field in skb_shared_info data structure
reusing gso_type field in order to store xdp_buff/xdp_frame paged size.
xdp_frags_size will be used in xdp multi-buff support.

Acked-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6bdb0db3e825..1abeba7ef82e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -522,13 +522,17 @@ struct skb_shared_info {
 	unsigned short	gso_segs;
 	struct sk_buff	*frag_list;
 	struct skb_shared_hwtstamps hwtstamps;
-	unsigned int	gso_type;
+	union {
+		unsigned int	gso_type;
+		unsigned int	xdp_frags_size;
+	};
 	u32		tskey;
 
 	/*
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
 	 */
 	atomic_t	dataref;
+	unsigned int	xdp_frags_tsize;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.31.1

