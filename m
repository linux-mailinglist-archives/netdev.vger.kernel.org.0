Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2209406F60
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhIJQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231499AbhIJQQB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:16:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3436124F;
        Fri, 10 Sep 2021 16:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631290490;
        bh=OtXy2sqW24wC3do4Jylbo/pDS5yRSQDDAaP9eh3EpT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IViGwvUmGqybfc98+AAD3lGVuzbiZ55g+BCND1M437Yi/K+H2BkdZvnRJgRFkN7Kk
         0p9oFue3fzm/uwBdZX+iPuCWjAmTKeYQeSK2WIQZtfGtFfMyGl7pSi3OdteG7CFr1B
         MiShMm5Yzm2UJkLfXHgyqUpsdOyPH33USUxrFDLxYB1qtC0MmmzmvpHuxrBuJnuQSe
         sTFxHM5uko2y6oXQRzHsmLmqRNeo6NOb6YX3SZC5dm00+DoD/W1ukuqrqWosUB3ccj
         TPRD7F6kNDgilGdhgLNyHpgZQFQ/uj8LGLaMivg7x08hYXMkesfBNw43foSCiKWwxe
         BB6xyqEm6Z07A==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v14 bpf-next 01/18] net: skbuff: add size metadata to skb_shared_info for xdp
Date:   Fri, 10 Sep 2021 18:14:07 +0200
Message-Id: <1a6336639c151227b263d6d621c490a8267d4119.1631289870.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1631289870.git.lorenzo@kernel.org>
References: <cover.1631289870.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_frags_truesize field in skb_shared_info data structure
to store xdp_buff/xdp_frame truesize (xdp_frags_truesize will be used
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
index 6bdb0db3e825..769ffd09f975 100644
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
+	unsigned int	xdp_frags_truesize;
 
 	/* Intermediate layers must ensure that destructor_arg
 	 * remains valid until skb destructor */
-- 
2.31.1

