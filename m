Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3196145AF95
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 23:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhKWW7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhKWW73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 17:59:29 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFD6C061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:56:20 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id s137so394735pgs.5
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 14:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TUyE6dLyu9qc5nIOtEH7fklZgUubd0BKwrm94PzurhE=;
        b=cPgyWHfTr+GlHY1i7bWPsxQ+v5QXxgi0Fg9OapTYSUZsKE4QZtdEXfr9InntRM0jKl
         2uDwOM6R2LVJ6Ewc+0+bvN2i+aITOB/A/h5Ti6CnVXrp9NGDr4/lJtZ6vpRdU3juQYsF
         evdWdeRMAoJISE/iUawREFAbKMaW1PjFbih4EgvAzFJF2F6HsWbXBZA5CsQM+SKpRnCT
         jpKqE+txw6SbRBmv78FQwd+DTIzkm+VuuBAgIrepG/F9Mv6+b8ikZtuTVvlgI2mAzex9
         ezJcX/LFAbT0ej9YJ6ndPhq80Fqz42dgtdnQLCgUF+TBC+xo2WW1/rmyKfOKX68+fBsq
         Yhtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TUyE6dLyu9qc5nIOtEH7fklZgUubd0BKwrm94PzurhE=;
        b=IibQOKE7K64oNJY6//5jMDOgMOct2M6w1XOiA17BkSEg4q4ri3iMcodHrZK8dhWVqd
         3ZlFPSgDCIuMg79r75qDsC0px8AaLZA7qmZDQ/MMI4i4X23c/Pfa8GhjuDDYYUJLei17
         0xSWQ21lnOd52hTOjUbQiXL/wZ6DCP2pV9vfI5fyF70Dtmu11PatjTjTkX+InXquQoof
         k4AO8f2us2FwXITf13WL3MX9u0J3V/XAsFKFbEPI7gnbuXIWcL2edWW2VFwNypSdC6aS
         my9Ga7TR+3AxcrkgZEOEUdzW0a1XCWB+kW3ekAuqf4VBv3AegO5OpnTHvHO41g1MWBps
         9x2g==
X-Gm-Message-State: AOAM530wp3hg5zdjgz/4LTe0XrodfqiSdpkk0K/TN97FR6lAsAXhR1R6
        4FC1S7R81A//OBki4DsKmko=
X-Google-Smtp-Source: ABdhPJxJkOTaO2O/63lf+vhhamU6zaF6I5lwbOvRd2e3ThWD4/gG3v6mdUe+LKVXMq9Y9F2nDHph8g==
X-Received: by 2002:a63:6a0a:: with SMTP id f10mr6427213pgc.163.1637708179877;
        Tue, 23 Nov 2021 14:56:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8b31:9924:47bf:5e47])
        by smtp.gmail.com with ESMTPSA id u6sm14342185pfg.157.2021.11.23.14.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 14:56:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] gro: remove rcu_read_lock/rcu_read_unlock from gro_complete handlers
Date:   Tue, 23 Nov 2021 14:56:08 -0800
Message-Id: <20211123225608.2155163-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211123225608.2155163-1-eric.dumazet@gmail.com>
References: <20211123225608.2155163-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

All gro_complete() handlers are called from napi_gro_complete()
while rcu_read_lock() has been called.

There is no point stacking more rcu_read_lock()

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/geneve.c   |  3 ---
 net/8021q/vlan_core.c  |  2 --
 net/ethernet/eth.c     |  2 --
 net/ipv4/af_inet.c     |  7 ++-----
 net/ipv4/fou.c         | 13 ++++---------
 net/ipv4/gre_offload.c |  3 ---
 net/ipv4/udp_offload.c |  2 --
 net/ipv6/ip6_offload.c |  8 ++------
 8 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 9caff2e01d19751bbd4a05bf5e204a16dde8a779..c1fdd721a730d7122a84079e7a96e6902c14f1fe 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -545,13 +545,10 @@ static int geneve_gro_complete(struct sock *sk, struct sk_buff *skb,
 	gh_len = geneve_hlen(gh);
 	type = gh->proto_type;
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = ptype->callbacks.gro_complete(skb, nhoff + gh_len);
 
-	rcu_read_unlock();
-
 	skb_set_inner_mac_header(skb, nhoff + gh_len);
 
 	return err;
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index 534eebb5a2e6d10b8ecd893f0ed5e1dc2113f036..acf8c791f3207bc86fc3d61bfde53e1857d43a28 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -513,14 +513,12 @@ static int vlan_gro_complete(struct sk_buff *skb, int nhoff)
 	struct packet_offload *ptype;
 	int err = -ENOENT;
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
 					 ipv6_gro_complete, inet_gro_complete,
 					 skb, nhoff + sizeof(*vhdr));
 
-	rcu_read_unlock();
 	return err;
 }
 
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index d4fa2f152efcbd7faf98ba4364e65cad8619ec1f..ebcc812735a4c13f104f5ed3e86b15fda4aef148 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -466,14 +466,12 @@ int eth_gro_complete(struct sk_buff *skb, int nhoff)
 	if (skb->encapsulation)
 		skb_set_inner_mac_header(skb, nhoff);
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype != NULL)
 		err = INDIRECT_CALL_INET(ptype->callbacks.gro_complete,
 					 ipv6_gro_complete, inet_gro_complete,
 					 skb, nhoff + sizeof(*eh));
 
-	rcu_read_unlock();
 	return err;
 }
 EXPORT_SYMBOL(eth_gro_complete);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 7afd8c8b25e043b6cb6638b74f715ab65254da64..c82a455c1e89e199865e673715d73b3ee389a94f 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1612,10 +1612,9 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 	csum_replace2(&iph->check, iph->tot_len, newlen);
 	iph->tot_len = newlen;
 
-	rcu_read_lock();
 	ops = rcu_dereference(inet_offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	/* Only need to add sizeof(*iph) to get to the next hdr below
 	 * because any hdr with option will have been flushed in
@@ -1625,9 +1624,7 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
 			      tcp4_gro_complete, udp4_gro_complete,
 			      skb, nhoff + sizeof(*iph));
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return err;
 }
 
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index 6ebc345e6001c2b76926576acd6377ea6abeefbe..0d085cc8d96cbd9cac0769fbb830791359a81c72 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -266,19 +266,16 @@ static int fou_gro_complete(struct sock *sk, struct sk_buff *skb,
 	const struct net_offload *ops;
 	int err = -ENOSYS;
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	err = ops->callbacks.gro_complete(skb, nhoff);
 
 	skb_set_inner_mac_header(skb, nhoff);
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return err;
 }
 
@@ -480,18 +477,16 @@ static int gue_gro_complete(struct sock *sk, struct sk_buff *skb, int nhoff)
 		return err;
 	}
 
-	rcu_read_lock();
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	err = ops->callbacks.gro_complete(skb, nhoff + guehlen);
 
 	skb_set_inner_mac_header(skb, nhoff + guehlen);
 
-out_unlock:
-	rcu_read_unlock();
+out:
 	return err;
 }
 
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index c6b5d327e3e14de1a0a77dbb6c53acced157bcfb..07073fa35205ef80882c854c6a7b3eebe746f365 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -253,13 +253,10 @@ static int gre_gro_complete(struct sk_buff *skb, int nhoff)
 	if (greh->flags & GRE_CSUM)
 		grehlen += GRE_HEADER_SECTION;
 
-	rcu_read_lock();
 	ptype = gro_find_complete_by_type(type);
 	if (ptype)
 		err = ptype->callbacks.gro_complete(skb, nhoff + grehlen);
 
-	rcu_read_unlock();
-
 	skb_set_inner_mac_header(skb, nhoff + grehlen);
 
 	return err;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 3be5c083879d98a6c100b05635d0818c328ced31..6d1a4bec2614df4f8b9ec5e6c387ab154d1f8d89 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -667,7 +667,6 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 
 	uh->len = newlen;
 
-	rcu_read_lock();
 	sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
 				udp4_lib_lookup_skb, skb, uh->source, uh->dest);
 	if (sk && udp_sk(sk)->gro_complete) {
@@ -688,7 +687,6 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
 	} else {
 		err = udp_gro_complete_segment(skb);
 	}
-	rcu_read_unlock();
 
 	if (skb->remcsum_offload)
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TUNNEL_REMCSUM;
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 67b9ba5e159c3a83207310d2d0b7a42557da895b..48674888f2dcb68aa5b4786b252e5ab5bad4b9ba 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -327,18 +327,14 @@ INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 
 	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
 
-	rcu_read_lock();
-
 	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-		goto out_unlock;
+		goto out;
 
 	err = INDIRECT_CALL_L4(ops->callbacks.gro_complete, tcp6_gro_complete,
 			       udp6_gro_complete, skb, nhoff);
 
-out_unlock:
-	rcu_read_unlock();
-
+out:
 	return err;
 }
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

