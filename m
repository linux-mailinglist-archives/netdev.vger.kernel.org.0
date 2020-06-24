Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CA3207282
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 13:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbgFXLs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 07:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403784AbgFXLsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 07:48:55 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EDA2C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 04:48:55 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id m21so1235426eds.13
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 04:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:mime-version:content-disposition;
        bh=ygINlFvlzwSYWDEuktJnSH0OhM4jrm+FMY0AUkegtZI=;
        b=n1tlBYONpD8bmTEuj7dLZzeFnUiM3hHaKUoT84u/7/IaVmwWewBbgugOcJojDNy6Ju
         hBhwRbJJwXZtdwB9NkAv3+xFvJsjPX0tLJFSlEt1NfvtKAP0fVMIOBlVDYLCpkIbJCum
         sxLwNzRch1E8IGTEDhpcQy/8h+nsl5V6aMUamyCc9D+momjVVEtMDHE6V92yQQg5tewU
         NhMA1ni4JoDzKllhhbs0FhX1esQUhRXDbo1wYOttNz/7O4xTN6olPWwg+UI5sP6iQmn5
         TJHljViGyyjUel5uVnCiiaJNdBqIG1m6Thm8xiVksca8JldznZTFof+4k5NfoieIcV55
         Qb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ygINlFvlzwSYWDEuktJnSH0OhM4jrm+FMY0AUkegtZI=;
        b=iFTjo8d6H7BEwLJSyiQg3J2+0psvVzTTpXpm7imMnwaMEAz/YhStcVHGOdbz+HishB
         gJ1zXx2mv2pYdceWkOxWcijVO828jotmuOKfWjhUZH0UkMR49USk0cEw1ewtAvEXb8XT
         KIHQqjYvX6spAGea5IvSOU50HgeLDE81QD8HxwXeR9NeV+q35UAzNQfShArJmYlODSot
         k4fDLmtpYU94Dpwi92xZwkfPkhJJOpOVwHOw/Pcrl4tIsLu+jBOJGMlfdARNhowIDlaN
         VqW0VEF6IMsx6CxUSIDqE2+D3esdBsG3RBlcGYS6OHm0BESkrtrmWbRzW52IPANRHO/G
         3YLw==
X-Gm-Message-State: AOAM533zXKSTYgc9avC4nlnMujDBKoxYEOXTrdOpkltteCkBzFEh7MHR
        JzgcnE8SNy9yZ9y4yE8JEoQ=
X-Google-Smtp-Source: ABdhPJwzccli6JDFNj1XSIzKndXHg3+aZiz7BNW1KPQ0V5+VeKBXiy7b/WDxdMEhrIThuUG4gBqMog==
X-Received: by 2002:aa7:ccc2:: with SMTP id y2mr25653876edt.97.1592999334143;
        Wed, 24 Jun 2020 04:48:54 -0700 (PDT)
Received: from tws ([2a0f:6480:3:1:e96f:c7f:ef7f:cae1])
        by smtp.gmail.com with ESMTPSA id g14sm9829156ejx.77.2020.06.24.04.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 04:48:53 -0700 (PDT)
From:   Oliver Herms <oliver.peter.herms@gmail.com>
X-Google-Original-From: Oliver Herms <oliver.herms@exaring.de>
Date:   Wed, 24 Jun 2020 13:48:52 +0200
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH] IPv4: Tunnel: Fix effective path mtu calculation
Message-ID: <20200624114852.GA153778@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calculation of the effective tunnel mtu, that is used to create
mtu exceptions if necessary, is currently not done correctly. This
leads to unnecessary entries in the IPv6 route cache for any packet
to be sent through the tunnel.

The root cause is, that "dev->hard_header_len" is subtracted from the
tunnel destinations path mtu. Thus subtracting too much, if
dev->hard_header_len is filled in. This is that case for SIT tunnels
where hard_header_len is the underlyings dev's hard_header_len (e.g. 14
for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).

However, the MTU of the path is exclusive of the ethernet header
and the 20 bytes for the IP header are being subtracted separately
already. Thus hard_header_len is removed from this calculation.

For IPIP and GRE tunnels this doesn't change anything as hard_header_len
is zero in those cases anyways.

Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv4/ip_tunnel.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..871d28bd29fa 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -495,8 +495,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
 
 	if (df)
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
-					- sizeof(struct iphdr) - tunnel_hlen;
+		mtu = dst_mtu(&rt->dst) - sizeof(struct iphdr) - tunnel_hlen;
 	else
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
-- 
2.25.1

