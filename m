Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C00B23B26F
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729559AbgHDBnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729392AbgHDBnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 21:43:40 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7415CC06174A;
        Mon,  3 Aug 2020 18:43:40 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j19so21217057pgm.11;
        Mon, 03 Aug 2020 18:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YeiGHQyR4AqF4La/QUoG1J/KpGS+ZLk4viBcyvveCYY=;
        b=Xsgq+NmGgS4wI/ToaWfEfOuLC1eisyXE/YSZukldo5UrNj6TVErARg1VHjiFbupwBq
         WKf7xyoaKmDkwrl8pfSzNFndaEw+zuDr1eH4qNMjdq10SC43GCq/reD4M/iM8dknyhiA
         qrpqcz4o9T9steFQyWZps0p/mmVfNO+kPAECr8HHAnV2D5+jU4UHYczmiqWdz1RsHElL
         hQk6S+gLw+K6jk9V/mtOod7wIiJt1DF4EKAXiIF4mwCXKUCeEw0wkhuR1Mz782UmOP2q
         hH1kSsV87YVVtc+5TueHVPmkn5Ju1lyCYninnBLZcFjbq1OOMJEHffGTwfEK19RXbUsf
         n6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YeiGHQyR4AqF4La/QUoG1J/KpGS+ZLk4viBcyvveCYY=;
        b=LmfLanAyJfIXjQrpweRv4qotnlj4rg1ZlKEMJg1XQbHaSGKr0umB7Lj6bzsGpM6OFT
         6YW6DKuyH5SKYvWVMtcbGZNI7OM/j6EY6MHhU0vJ6adp0Jzj4U82+OMsP48pe2nhEczf
         AAwpm1B0iuse4DPSNncquDt1e2vgyKW0qkZ0Zqa8hRYr8H0pKhtS3+MtqutYUCqi1AJg
         okB+Pp+PzNjy3rxWI3J74i7c45zWD8tS9Z6ds7uNKV1JcYKaD456fEqkP2r+gF0XUVcE
         A5ljK9k+SPsFfnWTJHXjZScAuUql/kFS/sUq64++bJPeEVvSxlTjnXOK/CB0JlCxXm6I
         YguA==
X-Gm-Message-State: AOAM531sax+mr48DfI7OQb/WLLQ56bMR2tEmDjCiEeGbgsYWxlVGxx9O
        FOMGcjpOmVigP73w7MIm5aeHeW5/6WN8ig==
X-Google-Smtp-Source: ABdhPJwwtrMcik4jpETxInG+6qmH8KetRy1yQL0IAQVHR3fcvg8cLx9KjiVs+ArKB3Jn1Mm8hsIdYw==
X-Received: by 2002:a63:5509:: with SMTP id j9mr16859961pgb.195.1596505419874;
        Mon, 03 Aug 2020 18:43:39 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p127sm20473494pfb.17.2020.08.03.18.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 18:43:39 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Guillaume Nault <gnault@redhat.com>,
        Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Andreas Karis <akaris@redhat.com>, stable@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 2/2] vxlan: fix getting tos value from DSCP field
Date:   Tue,  4 Aug 2020 09:43:12 +0800
Message-Id: <20200804014312.549760-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200804014312.549760-1-liuhangbin@gmail.com>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
 <20200804014312.549760-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 71130f29979c ("vxlan: fix tos value before xmit") we strict
the vxlan tos value before xmit. But as IP tos field has been obsoleted
by RFC2474, and updated by RFC3168 later. We should use new DSCP field,
or we will lost the first 3 bits value when xmit.

Fixes: 71130f29979c ("vxlan: fix tos value before xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 drivers/net/vxlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a7c3939264b0..79488df4bc70 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2722,7 +2722,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		ndst = &rt->dst;
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_DSCP(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct iphdr),
 				      vni, md, flags, udp_sum);
@@ -2762,7 +2762,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 
 		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
 
-		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
+		tos = ip_tunnel_ecn_encap(RT_DSCP(tos), old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
 		skb_scrub_packet(skb, xnet);
 		err = vxlan_build_skb(skb, ndst, sizeof(struct ipv6hdr),
-- 
2.25.4

