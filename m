Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1880C3EB4B4
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 13:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240128AbhHMLth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 07:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239827AbhHMLt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 07:49:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E348961042;
        Fri, 13 Aug 2021 11:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628855343;
        bh=hyQ5oUK2g5LJ1uB0M3VyqPpmL20XIKOGHR2YsZfWqOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKjbogMAYd6NAt+aNi/SOm/q/knL3/MZ/xB3t/O3G7uswVESMMmQB3PfpCJp1LlxK
         iufdvEC8kRlJVGoRTZ2bHW8RsA+AkvbqcIZIHr4fhWQFKFT6pqIRdt+OJlPUotrSqw
         7UpRqfbrJYud7zqMN3e8Iahnrnk8tDn3of2DG4neGqCn1TzvoBFgTlOClAcyAao9Hs
         a+ITbdIhbuYeZtWOHzqeUrrsssSELzXpllutnoeElsid5dZ1QpLzSbMLLVLctH2oyE
         K4ZUYoQEEQJRUqhkg81vkrGyOPrf3gkYHAmlUBvIGI4inRJJ557gBUtumorw6DJ9rU
         tU9Nc7Hd5TL5A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v11 bpf-next 01/18] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Fri, 13 Aug 2021 13:47:42 +0200
Message-Id: <834032195120da5313dbb3f972658d0a6de33b4b.1628854454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854454.git.lorenzo@kernel.org>
References: <cover.1628854454.git.lorenzo@kernel.org>
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

