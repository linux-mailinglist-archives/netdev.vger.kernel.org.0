Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C9D1E6E3E
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436817AbgE1V54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436721AbgE1V5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:57:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505CFC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 14:57:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p192so556331ybc.12
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 14:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PwAreH5SQuJPwGk3yd/r+wT2xNfFYOOuu2m1SM7DXKI=;
        b=M7tkZnUjA6xIsqxNH1HkaccS5CYKbL/B3IZr09S5se7Ck+lK5+94I7WJQES7o7cdiz
         fRTgsk7VpEsW5/GIvn+TiM+bajcd93re1RMRXyBoeH9gWQhuYbLlCUpteh6R11wcdqOY
         GTZb1YuTM22QaegU1xBN6NEYzIB/AnyvR1kzYhHQaLUHJLA17z3C9EeGd6I4af4z+6qM
         AgFbE/JU6xoLVX3KpE6AdxfhHKbB8jCCXca76OuGUOX/LRN6SVq2B+Url/fLnT7DVTFG
         P/q5TuAkVI1UdfWGxVf7Z02+W4C/usnie73nQoznWvAcFzpTn4o+51e9e3p7UqYtlGH0
         QzxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PwAreH5SQuJPwGk3yd/r+wT2xNfFYOOuu2m1SM7DXKI=;
        b=oGiOG89klRaHXgh2vDdzThlLZhHEqxgnoqJA17xzdUP7lyPo+1DIVGE+bI7SU8b8/Q
         HYmE0BPw5RLKvWKT44mRhdJljS+ZQmYRsJMHQG8DKnk6RyuyHYMWjknyO96DciJ7cQi6
         R6D78njc9bo+Ta39TPrKfbK88jmil6ictk9Ps7tEA7zUOdHM85UAKsaPrjZS0qoIxm99
         GzmxJ9KsaM7XOn+uQzYqGgRK2AzUbkOg9sy0ricllG/8vzSQL8nE4QkjgwVlDnVX13Sz
         SABXt2Iz1ocJEW7lz8Gl5lAQ+50Q70J0GhC8qt2OwrjrhFVlVdhx+CjRTGTZBEWfl/U6
         vpxg==
X-Gm-Message-State: AOAM5314m6tEZHBvJEgVPWAQWQ+rR8qJezMHrNPEMJB9tJEShoXoDeIm
        JvKVn5m41ojXRAl79SROh48yl5aIZOu1Pw==
X-Google-Smtp-Source: ABdhPJyvMROTFDHP1+ov6gOXzHeni6HhHPf9AKPWifVIlZKVP+1VTgAoWEX+z+8MV6/rnT5N0oOEEBswyglCnw==
X-Received: by 2002:a25:257:: with SMTP id 84mr8704172ybc.397.1590703070444;
 Thu, 28 May 2020 14:57:50 -0700 (PDT)
Date:   Thu, 28 May 2020 14:57:47 -0700
Message-Id: <20200528215747.45306-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.rc2.251.g90737beb825-goog
Subject: [PATCH net] net: be more gentle about silly gso requests coming from user
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent change in virtio_net_hdr_to_skb() broke some packetdrill tests.

When --mss=XXX option is set, packetdrill always provide gso_type & gso_size
for its inbound packets, regardless of packet size.

	if (packet->tcp && packet->mss) {
		if (packet->ipv4)
			gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
		else
			gso.gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
		gso.gso_size = packet->mss;
	}

Since many other programs could do the same, relax virtio_net_hdr_to_skb()
to no longer return an error, but instead ignore gso settings.

This keeps Willem intent to make sure no malicious packet could
reach gso stack.

Note that TCP stack has a special logic in tcp_set_skb_tso_segs()
to clear gso_size for small packets.

Fixes: 6dd912f82680 ("net: check untrusted gso_size at kernel entry")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 include/linux/virtio_net.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 88997022a4b5ba7542f00e5a0706e48f5264281d..e8a924eeea3d01c86c40766445c5661c395bce6c 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -109,16 +109,17 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
 
 	if (hdr->gso_type != VIRTIO_NET_HDR_GSO_NONE) {
 		u16 gso_size = __virtio16_to_cpu(little_endian, hdr->gso_size);
+		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		if (skb->len - p_off <= gso_size)
-			return -EINVAL;
+		/* Too small packets are not really GSO ones. */
+		if (skb->len - p_off > gso_size) {
+			shinfo->gso_size = gso_size;
+			shinfo->gso_type = gso_type;
 
-		skb_shinfo(skb)->gso_size = gso_size;
-		skb_shinfo(skb)->gso_type = gso_type;
-
-		/* Header must be checked, and gso_segs computed. */
-		skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
-		skb_shinfo(skb)->gso_segs = 0;
+			/* Header must be checked, and gso_segs computed. */
+			shinfo->gso_type |= SKB_GSO_DODGY;
+			shinfo->gso_segs = 0;
+		}
 	}
 
 	return 0;
-- 
2.27.0.rc2.251.g90737beb825-goog

