Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944591F30BB
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 03:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbgFIBCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 21:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbgFHXH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6BB22087E;
        Mon,  8 Jun 2020 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657676;
        bh=j6UMYv/Uq7h+aGYlgoZS4ffwA3i/V3dW4llsla38PK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoU4TOGqd9y6w5CHHhFk7Nosj9PVPdRo+E3YBgEmKF8cW/Tex2XKuyQOBRmSXz9aA
         vi6fRLFdJ4sWgZhkugrhJRwBn3hklab5/l1Ndud/HIbN3ahYd3WIK/QQnoFMyICPqK
         /lIiSsHUttdCitVY0VsrAlJKJUUJzr7Pd5gRo4BM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 084/274] tun: correct header offsets in napi frags mode
Date:   Mon,  8 Jun 2020 19:02:57 -0400
Message-Id: <20200608230607.3361041-84-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
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
index 44889eba1dbc..b984733c6c31 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1871,8 +1871,11 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
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
 
@@ -1929,9 +1932,12 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
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

