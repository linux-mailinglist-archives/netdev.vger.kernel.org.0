Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD1119A81B
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732064AbgDAJAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 05:00:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44271 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730333AbgDAJAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 05:00:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id b72so11784900pfb.11
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 01:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=JET1JJ67jtfxJTZ2zpzMEzG2KKdgD+Xu8R2XTU9c1Ek=;
        b=Z03qaR1DoSORo+mAUv265AEUjEYJ0oAy/5XzMWipqgrj3rzRBKm3fWfTbgbgOMo3vY
         DTpWp4ByzU7fAK5m+/ttODOzo2zBiCxoEUPmZAwTGxK9Z1ozm2y+R8ADEy5TI32mtd9m
         /tT5gZ/HTZqvzrw2E+HHZ37lzzZJQpi4FRYWoNr33I49qhTTPLJ2AB2eN9hQEPPKbeu6
         gky3dFOyVP0k17RgUEIF6cJRgpotjdHL4v4Z2BUXM2xlnO5Ln1Y/0KpNfj3MUuHBOhF/
         UJ2aJywvo2UJlwR+DOeedkaMFL0ZMAsQmVMD1i7G6Xbo1moPEPv8vgJR7kMNAcI7a2Zb
         Z7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=JET1JJ67jtfxJTZ2zpzMEzG2KKdgD+Xu8R2XTU9c1Ek=;
        b=Ei1zFzY6Jsu369DNe7q+jhXenk1c+/3cyx1I8yUjymkZIYTE7ABIDvR5ZOvwK7RZqf
         sDgRTCuLfUncPYC3/51fjlPzPq2eAVotQOFaGSJRiH+UHUgE9yIBvWP8etRmBOle2Yfp
         XhV4oximRjmSVk9+dUJfJY/IiaMGVaP3y5Zz75AIw3L5yrmHJJliDYQ0drKA8R79IlBX
         kAG5WfknsHVHb5Py3rLh5hUfb6/zgEvUFr5edCkCCj60djhMjey3+5iYQuPYCswW3hm/
         Xiid1eLbmSSFEivkOIaieaCqwI7j1m71jrd1dVoqACamT/rIA+M547dMZawKwSCcVNOv
         mVAA==
X-Gm-Message-State: AGi0PuaZCAFPpoWG2XNya5/MJN0TUKd9LBzQ8VHDtyjmy0YUPjl7ja5G
        sZC6YZkfDy3Bv5r2nB6IQjoFzQe/
X-Google-Smtp-Source: APiQypIgVkEE2V20RBG3jWJfsSq03MJCjOavXBwpcLbT8BtFf46EB787ZOIKXtK71/SrYRmj7HQs+w==
X-Received: by 2002:a63:7b1d:: with SMTP id w29mr7906328pgc.4.1585731599107;
        Wed, 01 Apr 2020 01:59:59 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ck3sm1113020pjb.44.2020.04.01.01.59.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Apr 2020 01:59:58 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 3/5] esp6: get the right proto for transport mode in esp6_gso_encap
Date:   Wed,  1 Apr 2020 16:59:23 +0800
Message-Id: <3f782f13de69081251addd3b7b37d155805feba2.1585731430.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <59aafccde155f156544d54db1145d54ecd018d74.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
 <c089597acfb559c70b1485ec84d01a78c8341bb3.1585731430.git.lucien.xin@gmail.com>
 <59aafccde155f156544d54db1145d54ecd018d74.1585731430.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
References: <cover.1585731430.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For transport mode, when ipv6 nexthdr is set, the packet format might
be like:

    ----------------------------------------------------
    |        | dest |     |     |      |  ESP    | ESP |
    | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
    ----------------------------------------------------

What it wants to get for x-proto in esp6_gso_encap() is the proto that
will be set in ESP nexthdr. So it should skip all ipv6 nexthdrs and
get the real transport protocol. Othersize, the wrong proto number
will be set into ESP nexthdr.

This patch is to skip all ipv6 nexthdrs by calling ipv6_skip_exthdr()
in esp6_gso_encap().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/esp6_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 8eab2c8..b828508 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -123,9 +123,16 @@ static void esp6_gso_encap(struct xfrm_state *x, struct sk_buff *skb)
 	struct ip_esp_hdr *esph;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	int proto = iph->nexthdr;
+	u8 proto = iph->nexthdr;
 
 	skb_push(skb, -skb_network_offset(skb));
+
+	if (x->outer_mode.encap == XFRM_MODE_TRANSPORT) {
+		__be16 frag;
+
+		ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag);
+	}
+
 	esph = ip_esp_hdr(skb);
 	*skb_mac_header(skb) = IPPROTO_ESP;
 
-- 
2.1.0

