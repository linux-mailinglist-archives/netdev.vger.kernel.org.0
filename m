Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4FE292734
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgJSM0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726249AbgJSMZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:25:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD7C0613D0;
        Mon, 19 Oct 2020 05:25:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b26so5929841pff.3;
        Mon, 19 Oct 2020 05:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=IdTDU779pNNOm5wxZz9V3KNfPGoQtUmsqw2exJTyJ+c=;
        b=J9Q9jqCMhovbCCI1aDAnpO3Ogj5p+DdkNb1buBK2uGHFoOmMzSPQUiEk2/vFve3XjP
         HVGPn+0b0e8w/OREV26T43oAwE8/xwm0GE8l8OWal513asEnt8oKOAIMnpnmf6obt9oo
         fmq0N41BMG3VqYzkHEwUq7iguVMoEC3qxlTkQ/J9kb/WobSbeSpYVST/rQ04znyuUnTJ
         EJueRWcD+AGyvbiD0qz8JaL7ubSvbUQKWXO0T+BHiDMjbQXXK6FFzf+AaOiZbr15Cfk2
         mNNAa1XFVVyGebrkCX6O0NEKsSDW1MnzTuB0fQ51XOzXA66gRrK8yM85qGayWddv5+fA
         MFGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=IdTDU779pNNOm5wxZz9V3KNfPGoQtUmsqw2exJTyJ+c=;
        b=kZGkha2uVZpq+fja/bax8NNhab6M3gQsTEf1UibEZ7gqD8I3J/Szt7y0frR/7REm9O
         aCJEhuf4n0TD+9KShSsy/D3vdaUAD5CON8VEnzQs2K5IV9bzIfSf6OYrXBoMsICh9KJ/
         F0kPQpsUe7kLZTGUByGScwZygHTKYFDnWihX6kdoR6Z4KE090TOSYzUtokRsFLz9dCh5
         E+9A4+kEmcpnSNeIENS0qocwc1V6vHBX+dpbnImW+Qzf0SwWhXLraXdqy0fqPFlzfdMy
         pGie7/Gj/PPXPgzTKy2dRvEn5qJ1cg00SeoQ6nBaPg4Et1xdKkGRUQVHA0gyamemL7Tl
         EZJg==
X-Gm-Message-State: AOAM532DvIg61bKGL8sNRjc0+732akjZcNW3o9Vz7bAjrQ+Nay9SeqVh
        xM0t4AkJZF+Q1CdZLthyjZeD3NCikH0=
X-Google-Smtp-Source: ABdhPJyx6G1DMspy4Pec4rHEzyBVN4VkT0vTUHKqwqFkHdlSRcXQl0hc/YTDUknZ8xBkhoSXix+klQ==
X-Received: by 2002:a65:5a0f:: with SMTP id y15mr13658326pgs.395.1603110358702;
        Mon, 19 Oct 2020 05:25:58 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y1sm4979468pjl.12.2020.10.19.05.25.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Oct 2020 05:25:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv4 net-next 02/16] udp6: move the mss check after udp gso tunnel processing
Date:   Mon, 19 Oct 2020 20:25:19 +0800
Message-Id: <de3a89ece8f3abd0dca08064d9fc4d36ca7ddba2.1603110316.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
 <71b3af0fb347f27b5c3bf846dbd34485d9f80af0.1603110316.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1603110316.git.lucien.xin@gmail.com>
References: <cover.1603110316.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
gso_size. When using UDP to encapsulate its packet, it will
return error in udp6_ufo_fragment() as skb->len < gso_size,
and it will never go to the gso tunnel processing.

So we should move this check after udp gso tunnel processing,
the same as udp4_ufo_fragment() does.

v1->v2:
  - no change.
v2->v3:
  - not do any cleanup.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/udp_offload.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a..aa602af 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -28,10 +28,6 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 	int tnl_hlen;
 	int err;
 
-	mss = skb_shinfo(skb)->gso_size;
-	if (unlikely(skb->len <= mss))
-		goto out;
-
 	if (skb->encapsulation && skb_shinfo(skb)->gso_type &
 	    (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
 		segs = skb_udp_tunnel_segment(skb, features, true);
@@ -48,6 +44,10 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
 			return __udp_gso_segment(skb, features);
 
+		mss = skb_shinfo(skb)->gso_size;
+		if (unlikely(skb->len <= mss))
+			goto out;
+
 		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
 		 * do checksum of UDP packets sent as multiple IP fragments.
 		 */
-- 
2.1.0

