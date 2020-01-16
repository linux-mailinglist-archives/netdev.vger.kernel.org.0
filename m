Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8FD13F7FB
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733194AbgAPQ4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729604AbgAPQ4M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3458A24656;
        Thu, 16 Jan 2020 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193772;
        bh=9Y8lZosqwOZm9f9IpU+vg+FnGM9OlCRJiHE5R83s5tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fVioAeugnMVb6B5YFgtClQnMSLV9F1Q+CxzPdmTsXGKP9ql4lOPYFpwELGyJvSbCv
         nDh2JC0/AO/pLZbMxdv7XB21yozKjcYSd9pblEiqRO8WweiEeHqI5XiLasq4N/NLuI
         +/Kam6xD/F65/EsfCpQLmDvttiRxw4hVg5qshGiE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 055/671] net: always initialize pagedlen
Date:   Thu, 16 Jan 2020 11:44:46 -0500
Message-Id: <20200116165502.8838-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit aba36930a35e7f1fe1319b203f25c05d6c119936 ]

In ip packet generation, pagedlen is initialized for each skb at the
start of the loop in __ip(6)_append_data, before label alloc_new_skb.

Depending on compiler options, code can be generated that jumps to
this label, triggering use of an an uninitialized variable.

In practice, at -O2, the generated code moves the initialization below
the label. But the code should not rely on that for correctness.

Fixes: 15e36f5b8e98 ("udp: paged allocation with gso")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_output.c  | 3 ++-
 net/ipv6/ip6_output.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d63091812342..fbf30122e8bf 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -940,7 +940,7 @@ static int __ip_append_data(struct sock *sk,
 			unsigned int fraglen;
 			unsigned int fraggap;
 			unsigned int alloclen;
-			unsigned int pagedlen = 0;
+			unsigned int pagedlen;
 			struct sk_buff *skb_prev;
 alloc_new_skb:
 			skb_prev = skb;
@@ -957,6 +957,7 @@ static int __ip_append_data(struct sock *sk,
 			if (datalen > mtu - fragheaderlen)
 				datalen = maxfraglen - fragheaderlen;
 			fraglen = datalen + fragheaderlen;
+			pagedlen = 0;
 
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index eed9231c90ad..9886a84c2511 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1357,7 +1357,7 @@ static int __ip6_append_data(struct sock *sk,
 			unsigned int fraglen;
 			unsigned int fraggap;
 			unsigned int alloclen;
-			unsigned int pagedlen = 0;
+			unsigned int pagedlen;
 alloc_new_skb:
 			/* There's no room in the current skb */
 			if (skb)
@@ -1381,6 +1381,7 @@ static int __ip6_append_data(struct sock *sk,
 			if (datalen > (cork->length <= mtu && !(cork->flags & IPCORK_ALLFRAG) ? mtu : maxfraglen) - fragheaderlen)
 				datalen = maxfraglen - fragheaderlen - rt->dst.trailer_len;
 			fraglen = datalen + fragheaderlen;
+			pagedlen = 0;
 
 			if ((flags & MSG_MORE) &&
 			    !(rt->dst.dev->features&NETIF_F_SG))
-- 
2.20.1

