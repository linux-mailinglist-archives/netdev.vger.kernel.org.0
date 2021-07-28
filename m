Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36433D8AC7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhG1Jiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235542AbhG1Jiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 05:38:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBACD60F9C;
        Wed, 28 Jul 2021 09:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627465130;
        bh=ZHYt3GjYt3MYVH4Lq1KjkAChdSn6YjLzFL0kkz/+UKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diwRXg2hXp0jtpMyIPBDTu4sxBnu9vscAF0IQhFm6bjpB4hWpy+5jxMWkZfbNSX0u
         NMcEsehw3xBghUwu3os6TiQ3eT6fRykspjXFf5rdnML22GoUxhsuPWfuqeDa8UH12f
         RwWgeuyielYx8pWCrZJrKTUEA5i671jDKu17bKv6EN1fOHKALNSC26LPBhUzKa5z59
         DG2f8sTILdxWNuhaBX1jc1VqXcLN9PdQ+OJ2SI/9UwaLy3Jye+YGZHVJf9zcQvl4my
         Y8KpZFOqOTbF7QrmGxK7v+0SturCFYTAbSv4N0cegIayoeyZLiXZp7PhXr2hxo2RYB
         8KjOd4T/xaUpA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v10 bpf-next 01/18] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Wed, 28 Jul 2021 11:38:06 +0200
Message-Id: <97cd38b4b4e6cd531e7444df345317f4bf39ef85.1627463617.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1627463617.git.lorenzo@kernel.org>
References: <cover.1627463617.git.lorenzo@kernel.org>
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
index f19190820e63..4ece1775179c 100644
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

