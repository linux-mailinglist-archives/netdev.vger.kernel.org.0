Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3738B401088
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhIEPWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhIEPWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:22:15 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D303C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 08:21:12 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 62so1480311qvb.11
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z/6qzvt1EbO8NA+1KJVhUkw/d3R8brcF5cP9wTtURWc=;
        b=YImKaMDaMdc/hl5+Hc6737m+OOzLgY5bRtP+7R6LmXUBJOD1s0oyxBejpnqxGGf8ba
         jVZtCchv83j8DJ+jL9qzvZFR+TnbcfHI2TukoLcR9fR9rZaXIeHqaqboNUUnh2gKT0pJ
         E2Dz/hVhLfY5wMqNmDbhvfYKfZxcFV8IMVw0pZDL4yl5ypA3Si29OujH0X1PGyWlefvn
         LEawXlfAlWuI8wRTZVY7lhYXMJrEMH4IYhZpMVyzbooxI8TwQPyjxu5BqXvHZn3IsyVL
         AVvcVzGQSBl5huLl1TDJfY3oLZjon+9x3Yx6YHgtLUlFCCE9DW3cL5e5G7Kf6X7Nq5sC
         Bhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z/6qzvt1EbO8NA+1KJVhUkw/d3R8brcF5cP9wTtURWc=;
        b=B7z67MEaRFTsshNepo/7LAnEKWh4thSpmPouNhWUWBoZhHMoT6ft49bvUNCg4Zm2e1
         cc+fgE8S/sbt2Q3/xZeajeo+NccoHkFrMYsFMCNTlRbDYE6QNnEV3AeQHa2ngGmruav/
         CoJ/86Cwx7WHrf3AbJQKYiUCvmwbDbmoW9FOi3wr2f3gRX5iC7zfGcTdwWvKDt9LGWc4
         GozgvmhO90BprmrJpfBhcdnMcp9CBohPjA3RDN1OhO06+WPIB7SpGmmvc+uzWEiZxEBM
         liJiNNVQ4+8pejt3FfC09oIJnSDSVj39w9BoBsvsnr/mY3dQrvUHbqIqL1ORla8Sns9r
         p1jQ==
X-Gm-Message-State: AOAM530/cheP/m/l70tYX9JL+vkQgkeg5KB9nUG5/+A8yAzfQqVwWJvU
        ylpFNSWPOosWSeIyEJXtC/T6wpBQHB8=
X-Google-Smtp-Source: ABdhPJwUs7/ZWOXg2mZikDwr3lAhFRtUAWTzRfpo4ZuZJBIPbWHqAiE/MI4xOUH6HXMJLPpDZd8lLg==
X-Received: by 2002:a0c:b41d:: with SMTP id u29mr3218733qve.51.1630855271710;
        Sun, 05 Sep 2021 08:21:11 -0700 (PDT)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:943f:7af8:367e:2cf6])
        by smtp.gmail.com with ESMTPSA id y24sm4632163qkj.102.2021.09.05.08.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:21:11 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@idosch.org,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [PATCH net] ip_gre: validate csum_start only on pull
Date:   Sun,  5 Sep 2021 11:21:09 -0400
Message-Id: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

The GRE tunnel device can pull existing outer headers in ipge_xmit.
This is a rare path, apparently unique to this device. The below
commit ensured that pulling does not move skb->data beyond csum_start.

But it has a false positive if ip_summed is not CHECKSUM_PARTIAL and
thus csum_start is irrelevant.

Refine to exclude this. At the same time simplify and strengthen the
test.

Simplify, by moving the check next to the offending pull, making it
more self documenting and removing an unnecessary branch from other
code paths.

Strengthen, by also ensuring that the transport header is correct and
therefore the inner headers will be after skb_reset_inner_headers.
The transport header is set to csum_start in skb_partial_csum_set.

Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
Reported-by: Ido Schimmel <idosch@idosch.org>
Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/ip_gre.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 177d26d8fb9c..0fe6c936dc54 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -473,8 +473,6 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
-	if (csum && skb_checksum_start(skb) < skb->data)
-		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
@@ -632,15 +630,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
+		const int pull_len = tunnel->hlen + sizeof(struct iphdr);
+
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
 
+		if (pull_len > skb_transport_offset(skb))
+			goto free_skb;
+
 		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
 		 * to gre header.
 		 */
-		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
+		skb_pull(skb, pull_len);
 		skb_reset_mac_header(skb);
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom))
-- 
2.33.0.153.gba50c8fa24-goog

