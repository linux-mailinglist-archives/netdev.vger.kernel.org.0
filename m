Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8B3A66FE
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhFNMwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:52:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233451AbhFNMwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 08:52:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C6161244;
        Mon, 14 Jun 2021 12:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623675038;
        bh=ZULHSPrzZ0pILxvKsK1p2nxDiZcwA3jCkWQHpmSUrVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJXcgJPBePmxGChw/QHOS8P+uyMwEBXhqcQH6GGcoz1SUflV81vLHs2Qn1MLbOyyd
         H4//h/xm8/RoRcK7nbAdzWEqDnuCXjcxKfy24WJgfJeEEftuMBbm44QxdH6ZmYECUM
         qoKnMPWacr1JO4OIHWvumM9D4zbIuo53+5GOWgZ/4G75uUX1ZtRSBrTnIVb53Cuq2m
         6K5Q+DnEDjqxOPrU1xdCEzJ40g6vnJEHQoBZJNEWQOdpef3jatyFVQzXRTJeRZftUp
         ITIrW9V388Dp6Lg/W3sVIoJ/8+GllZqq7AMY/1jO1W2HNe54uOYhahJOu8qUZlq3pj
         4DnA5FKRy8Tfw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, john.fastabend@gmail.com, dsahern@kernel.org,
        brouer@redhat.com, echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Subject: [PATCH v9 bpf-next 01/14] net: skbuff: add data_len field to skb_shared_info
Date:   Mon, 14 Jun 2021 14:49:39 +0200
Message-Id: <8ad0d38259a678fb42245368f974f1a5cf47d68d.1623674025.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623674025.git.lorenzo@kernel.org>
References: <cover.1623674025.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

data_len field will be used for paged frame len for xdp_buff/xdp_frame.
This is a preliminary patch to properly support xdp-multibuff

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 include/linux/skbuff.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbf820a50a39..332ec56c200d 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -522,7 +522,10 @@ struct skb_shared_info {
 	struct sk_buff	*frag_list;
 	struct skb_shared_hwtstamps hwtstamps;
 	unsigned int	gso_type;
-	u32		tskey;
+	union {
+		u32	tskey;
+		u32	data_len;
+	};
 
 	/*
 	 * Warning : all fields before dataref are cleared in __alloc_skb()
-- 
2.31.1

