Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09D1E1A5A88
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgDKXn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728294AbgDKXGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38914215A4;
        Sat, 11 Apr 2020 23:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646371;
        bh=ZatDQ1rEEBooTMuQQpjYWUonkIy+8ABGIqmyk1GU6+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdJ/f3mz5Yg/opnxhi5FsxwlymLqLM0clqAzsbnJD9fvZHLxdUgPjqspsz5JBc0L4
         PIacM2cA9s8VHlPLyxRRVBae+RU/4GM2gIFthlIJXsvWuUrGsMHf3m5alp8REt5/sB
         wSyXCCfyZ60atscYI/9DHYsoKtrFLhUIMeYBzch4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 114/149] xfrm: add prep for esp beet mode offload
Date:   Sat, 11 Apr 2020 19:03:11 -0400
Message-Id: <20200411230347.22371-114-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 308491755f36c461ee67290af159fdba6be0169d ]

Like __xfrm_transport/mode_tunnel_prep(), this patch is to add
__xfrm_mode_beet_prep() to fix the transport_header for gso
segments, and reset skb mac_len, and pull skb data to the
proto inside esp.

This patch also fixes a panic, reported by ltp:

  # modprobe esp4_offload
  # runltp -f net_stress.ipsec_tcp

  [ 2452.780511] kernel BUG at net/core/skbuff.c:109!
  [ 2452.799851] Call Trace:
  [ 2452.800298]  <IRQ>
  [ 2452.800705]  skb_push.cold.98+0x14/0x20
  [ 2452.801396]  esp_xmit+0x17b/0x270 [esp4_offload]
  [ 2452.802799]  validate_xmit_xfrm+0x22f/0x2e0
  [ 2452.804285]  __dev_queue_xmit+0x589/0x910
  [ 2452.806264]  __neigh_update+0x3d7/0xa50
  [ 2452.806958]  arp_process+0x259/0x810
  [ 2452.807589]  arp_rcv+0x18a/0x1c

It was caused by the skb going to esp_xmit with a wrong transport
header.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index e2db468cf50ee..6cc7f7f1dd68c 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -46,6 +46,25 @@ static void __xfrm_mode_tunnel_prep(struct xfrm_state *x, struct sk_buff *skb,
 	pskb_pull(skb, skb->mac_len + x->props.header_len);
 }
 
+static void __xfrm_mode_beet_prep(struct xfrm_state *x, struct sk_buff *skb,
+				  unsigned int hsize)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	int phlen = 0;
+
+	if (xo->flags & XFRM_GSO_SEGMENT)
+		skb->transport_header = skb->network_header + hsize;
+
+	skb_reset_mac_len(skb);
+	if (x->sel.family != AF_INET6) {
+		phlen = IPV4_BEET_PHMAXLEN;
+		if (x->outer_mode.family == AF_INET6)
+			phlen += sizeof(struct ipv6hdr) - sizeof(struct iphdr);
+	}
+
+	pskb_pull(skb, skb->mac_len + hsize + (x->props.header_len - phlen));
+}
+
 /* Adjust pointers into the packet when IPsec is done at layer2 */
 static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 {
@@ -66,9 +85,16 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 			return __xfrm_transport_prep(x, skb,
 						     sizeof(struct ipv6hdr));
 		break;
+	case XFRM_MODE_BEET:
+		if (x->outer_mode.family == AF_INET)
+			return __xfrm_mode_beet_prep(x, skb,
+						     sizeof(struct iphdr));
+		if (x->outer_mode.family == AF_INET6)
+			return __xfrm_mode_beet_prep(x, skb,
+						     sizeof(struct ipv6hdr));
+		break;
 	case XFRM_MODE_ROUTEOPTIMIZATION:
 	case XFRM_MODE_IN_TRIGGER:
-	case XFRM_MODE_BEET:
 		break;
 	}
 }
-- 
2.20.1

