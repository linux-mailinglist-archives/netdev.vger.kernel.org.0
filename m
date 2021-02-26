Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBF33269A0
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 22:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBZVgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 16:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhBZVgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 16:36:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9544C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:35:31 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v15so9944007wrx.4
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 13:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=svObjMrcN22PBcmuOZmLx1uraCKg2eMVORpWVmd2BuU=;
        b=XHpBamBEXOK9XTO+R/YEMLY57CFTCXcc35qWTZ2DDLPNIqsidh8gXRCzGZytuffWpQ
         TuFqavehgBb9sSO35Scv9IUHP1y/Fn8MM5QN8WVtPNbJUO1jZQnHFKvaqY2OLvvCQFkC
         ATbFnQKtyYEX20scfm/ZHFsrfsQi1DV0sSRMUaa4gROQ9aWcfAzkgcmxR1Gx1iawqRDj
         mM6kq5KzGMARHRuZR5xaxJk6QljLLklc4fGUnIF2uQURQ/nhqdKvdmVSiXmIyiaukeNy
         7IM9TVxAwFNJh5P+lVeRLR4YDKpfg2dRGn7hUKoJdIKpAtgvKs9MctZZbR9KkNGPvyyC
         vjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=svObjMrcN22PBcmuOZmLx1uraCKg2eMVORpWVmd2BuU=;
        b=j5je+oU7sVGoaePaJxQo54N9OTy3EuOtsjdz5EdNEp1NfpKd4uIbjO9zx1uNTLdutH
         qRCqEL3Y+CqKhf21OBdKq6xGyKofNTWPFezN+3D1VzEzohWXUh8HjWhNpc5mbF2VFh0W
         kDb61AXYXjUqfHC+L0Ed/ZRkrMBr9dk2jmUsrdg05q5t34qg7lMRCxbUAK5kIq4NEW6l
         OBpqMCYi6Uf8s1YvImZw8uyVUe86uf1IAJaWcIGUOOScJ9Y6qMORx9SDVsLaisi2x8c9
         BYyZuGtjF2MMKOKyk7OvTCzuXv+VZj2yi3LOT/F+hdWZMcwHIkyIoE979ZneB+3blK3/
         yS/g==
X-Gm-Message-State: AOAM532Hh7I4ckOyQX9qDxNwyXrSSdY2vf/lOenU0VhCe6yCzKM9uD1Q
        0Tmbvx8Ebm1oYdbxIJTdQZE=
X-Google-Smtp-Source: ABdhPJw+6h6U8QclJbQQ9UxaxGi7eE7HhGIu740UEG4CGASz3EUNADkWKrXIct2EUIA5EtIc5GHlFQ==
X-Received: by 2002:a5d:430a:: with SMTP id h10mr5364048wrq.162.1614375330356;
        Fri, 26 Feb 2021 13:35:30 -0800 (PST)
Received: from localhost.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id z11sm17587241wrm.72.2021.02.26.13.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 13:35:29 -0800 (PST)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, bram-yvahk@mail.wizbit.be,
        sd@queasysnail.net, Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH ipsec 1/2] vti: fix ipv4 pmtu check to honor ip header df
Date:   Fri, 26 Feb 2021 23:35:05 +0200
Message-Id: <20210226213506.506799-2-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210226213506.506799-1-eyal.birger@gmail.com>
References: <20210226213506.506799-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Frag needed should only be sent if the header enables DF.

This fix allows packets larger than MTU to pass the vti interface
and be fragmented after encapsulation, aligning behavior with
non-vti xfrm.

Fixes: d6af1a31cc72 ("vti: Add pmtu handling to vti_xmit.")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 net/ipv4/ip_vti.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index abc171e79d3e..613741384490 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -218,7 +218,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	if (dst->flags & DST_XFRM_QUEUE)
-		goto queued;
+		goto xmit;
 
 	if (!vti_state_check(dst->xfrm, parms->iph.daddr, parms->iph.saddr)) {
 		dev->stats.tx_carrier_errors++;
@@ -238,6 +238,8 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (skb->len > mtu) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 		if (skb->protocol == htons(ETH_P_IP)) {
+			if (!(ip_hdr(skb)->frag_off & htons(IP_DF)))
+				goto xmit;
 			icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 				  htonl(mtu));
 		} else {
@@ -251,7 +253,7 @@ static netdev_tx_t vti_xmit(struct sk_buff *skb, struct net_device *dev,
 		goto tx_error;
 	}
 
-queued:
+xmit:
 	skb_scrub_packet(skb, !net_eq(tunnel->net, dev_net(dev)));
 	skb_dst_set(skb, dst);
 	skb->dev = skb_dst(skb)->dev;
-- 
2.25.1

