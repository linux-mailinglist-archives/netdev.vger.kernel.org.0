Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612DF1F2AA5
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731547AbgFIAKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgFHXUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EA4420870;
        Mon,  8 Jun 2020 23:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658405;
        bh=78lqsqfhV2hRIt6jjvP7FgkuhLowVJqsLOtYp1/tuMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vr9MXdZX2UlRkeFpn3CPS5Ju5JgrZTqtmm1Vj36DEH/0uqzVaoi+5zreJbeqWr6iw
         QS/HkVXZFUb93gn9DRqeMB/gzIxQHKJ7QRSGQNVJquAcU+Xc0sieurydNxINZr0B+m
         jdzb4upqHjP4c9Jot/BNCBJL8LlP3nqhg45pWAyU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 059/175] tun: correct header offsets in napi frags mode
Date:   Mon,  8 Jun 2020 19:16:52 -0400
Message-Id: <20200608231848.3366970-59-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit 96aa1b22bd6bb9fccf62f6261f390ed6f3e7967f ]

Tun in IFF_NAPI_FRAGS mode calls napi_gro_frags. Unlike netif_rx and
netif_gro_receive, this expects skb->data to point to the mac layer.

But skb_probe_transport_header, __skb_get_hash_symmetric, and
xdp_do_generic in tun_get_user need skb->data to point to the network
header. Flow dissection also needs skb->protocol set, so
eth_type_trans has to be called.

Ensure the link layer header lies in linear as eth_type_trans pulls
ETH_HLEN. Then take the same code paths for frags as for not frags.
Push the link layer header back just before calling napi_gro_frags.

By pulling up to ETH_HLEN from frag0 into linear, this disables the
frag0 optimization in the special case when IFF_NAPI_FRAGS is used
with zero length iov[0] (and thus empty skb->linear).

Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Petar Penkov <ppenkov@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 6e9a59e3d822..46bdd0df2eb8 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1908,8 +1908,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		skb->dev = tun->dev;
 		break;
 	case IFF_TAP:
-		if (!frags)
-			skb->protocol = eth_type_trans(skb, tun->dev);
+		if (frags && !pskb_may_pull(skb, ETH_HLEN)) {
+			err = -ENOMEM;
+			goto drop;
+		}
+		skb->protocol = eth_type_trans(skb, tun->dev);
 		break;
 	}
 
@@ -1966,9 +1969,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 	}
 
 	if (frags) {
+		u32 headlen;
+
 		/* Exercise flow dissector code path. */
-		u32 headlen = eth_get_headlen(tun->dev, skb->data,
-					      skb_headlen(skb));
+		skb_push(skb, ETH_HLEN);
+		headlen = eth_get_headlen(tun->dev, skb->data,
+					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
 			this_cpu_inc(tun->pcpu_stats->rx_dropped);
-- 
2.25.1

