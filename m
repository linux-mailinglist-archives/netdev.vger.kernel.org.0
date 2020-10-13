Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F0728C93E
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 09:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390118AbgJMH2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 03:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390091AbgJMH2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 03:28:07 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73517C0613D0;
        Tue, 13 Oct 2020 00:28:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c20so5583517pfr.8;
        Tue, 13 Oct 2020 00:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=NWswMQFNrJpmgSXJFGyvzsyral3mRo2RUwnr9RHwTGk=;
        b=tnF0u66XkMUCpMqTv/lo2ZASpfMhbzQuTZlibftVepVKx90bSGM2RaH9p5ZOGL9UXB
         E5JRRiq9oKcjqUcr+VM/XRC3dmzTLI89N2l9ds2jEIqn+Pp+u2OPvM8K4DaJ5IYv4QcW
         u8wNEGNBHp9NYIMz56Pn+CgE+ibA3hiJp8CipQH/gUteaUbY3pQJZZ7hm8V3IGAkWfAd
         ad5elQvn9rtXNUUb/OGB+b0XhyM1KG+84cmCUDNkCKTn8OI5gTLrHrRQ07umBGp32Cqg
         oTnctiTL25byLYkkRU9kRbRhdF7YftZaMDpAkX4ZDu8RhjsoaoJxpjuGusRaMg1M19yP
         WxOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=NWswMQFNrJpmgSXJFGyvzsyral3mRo2RUwnr9RHwTGk=;
        b=XLm6XTghM2UApdHDGWKzvPwfpOfRBGHvBMln1kdoGMxucYgaEZBdTH8Bxj7JjB+Bc0
         V6qjhvShHPQiyiSQjlBPY2Ave1NsSOAjJg4UC4yEd6OWk+o0jTx8EmTO1cauTy+irfvd
         IkH69JAEar9/4EtMx6Zcjtta6XAfEPdVdkm/bmEgguonmOR2iltO1yqroDsRpzS+3aLd
         E1fku3pbilCCtH0Nj97zxk6fcvvwEQWmUK3CPE+wH4HpP0n5dOfvyy8eQ3l6Ewic7t1K
         Qg2Lr8PtpYNSPzABgKigVsUhPHHiJkFP4YuwhW3VTyCgP2c4Q6E8NbF1C657gMYOxaQ4
         GMCQ==
X-Gm-Message-State: AOAM532wK/obz6pC6YD6p379iMmUotEJ7Mbctinp1qK0f0U0S2DfWwG/
        wXmUjfnAtfTQBm266fkmrZ9nWDWBTz0=
X-Google-Smtp-Source: ABdhPJxsBuuPGPwOcn2kRAcT9ypKhMS+ulT07OyGafhplNMQAcjIiH/D2wykJGZw5ivYjwPZwg9pAg==
X-Received: by 2002:a62:88ca:0:b029:156:2594:23c7 with SMTP id l193-20020a6288ca0000b0290156259423c7mr7632048pfd.12.1602574086769;
        Tue, 13 Oct 2020 00:28:06 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l2sm27442296pjy.6.2020.10.13.00.28.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 00:28:06 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net,
        gnault@redhat.com, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
Subject: [PATCHv3 net-next 02/16] udp6: move the mss check after udp gso tunnel processing
Date:   Tue, 13 Oct 2020 15:27:27 +0800
Message-Id: <c01a9a09096cb1b292d461aa5a1e72aae2ca942a.1602574012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
 <fae9c57767447c4fd97476807b9e029e8fda607a.1602574012.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602574012.git.lucien.xin@gmail.com>
References: <cover.1602574012.git.lucien.xin@gmail.com>
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

