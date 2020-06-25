Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE9420A85B
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 00:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406962AbgFYWoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 18:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403795AbgFYWoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 18:44:38 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3A0C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 15:44:38 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dp18so7521303ejc.8
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 15:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=36Ewkg1mv9XvTlzZ+77QZqJ+TD5rKjXGP64wG8j7MjM=;
        b=TMUh+awWs+WOxr87QqNuPt7HS7X4vm+Gee7GdLsvxKvUYbeLOpE8erQMi36vVAzUvu
         pUWhSVjCfI7nmh8IKi4TJXbs58dL0d/vr3fESc4FzfcPZENFKB+beKP+QQmv69+gvlnM
         1196eQOLtrKhrl/BmPXoHctOzazj/FU4SW9zxQ1SVkZBrokwEqiSQEOMfCKrR6qf9b8I
         gvs+n0yizu+tuoz3GTesuDg451G5g0f+L1KrYY4NY/X18BI8mINJ32dd/UDZ9LVCmEqW
         kmmg5lNnneOcec7YkGQ1LUng9VnBwiA/IrkF+fcMX/z14S/CNXpg+YA0alt+H0/F3ogQ
         dtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=36Ewkg1mv9XvTlzZ+77QZqJ+TD5rKjXGP64wG8j7MjM=;
        b=PdX23KWLreP4THBv9gzFbsm4F8ZlZNo7TOsB48vjLWQpnivn4R5t+OOmbgTeSWhm4K
         LIlWjbHi1snRgZQqFYKxmV+yb8TdN70wlKRYNrY3pphZOqKU9E9NcYKiZ9l/P8Z8PEu8
         MYZQecAbUJMdBzvc/CmXtJZDrFSY9hpVo7osI/DoBhi+mK7TukfLrkKeTTksGD4ZTmXb
         WwgdjOExKQgMzp/UpPgOgpwGd3/ah7Rb7feHihhAVn0SAlvNrovSzjXSy61zFIsgBR1w
         tiXILEcB6QLE4eXvn/bTnCgDE9qydEhF+VZ17Q72zoeXuP7BcxbyNsoahn67OnLeFJHT
         8ysg==
X-Gm-Message-State: AOAM5338l2Mt2i1uNyMhAe5QXJe31Cnc3jdwS95VMfVYU42DOPjY6D8H
        5+Qs1yqYj0GcQMdHfpkHdJsmiHcIElbd3g==
X-Google-Smtp-Source: ABdhPJxQdTaYkPk82Z6k9+cSSZfm4AxY03IoYbr0naW9cIgyKHZxAZQBsO52a0TK8OUi5A8ObYXlYA==
X-Received: by 2002:a17:906:494a:: with SMTP id f10mr48135ejt.428.1593125076937;
        Thu, 25 Jun 2020 15:44:36 -0700 (PDT)
Received: from tws ([2a0f:6480:3:1:e96f:c7f:ef7f:cae1])
        by smtp.gmail.com with ESMTPSA id s1sm13074629edy.1.2020.06.25.15.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 15:44:36 -0700 (PDT)
Date:   Fri, 26 Jun 2020 00:44:35 +0200
From:   Oliver Herms <oliver.peter.herms@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Subject: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
Message-ID: <20200625224435.GA2325089@tws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The calculation of the effective tunnel mtu, that is used to create
mtu exceptions if necessary, is currently not done correctly. This
leads to unnecessary entries in the IPv6 route cache for any
packet send through the tunnel.

The root cause is, that "dev->hard_header_len" is subtracted from the
tunnel destionations path mtu. Thus subtracting too much, if
dev->hard_header_len is filled in. This is that case for SIT tunnels
where hard_header_len is the underlyings dev hard_header_len (e.g. 14
for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).

However, the MTU of the path is exclusive of the ethernet header
and the 20 bytes for the IP header are being subtracted separately
already. Thus hard_header_len is removed from this calculation.

For IPIP and GRE tunnels this doesn't change anything as hard_header_len
is zero in those cases anyways.

This patch also corrects the calculation of the payload's packet size.

Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
---
 net/ipv4/ip_tunnel.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index f4f1d11eab50..66565647122d 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -492,11 +492,10 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 	int mtu;
 
 	tunnel_hlen = md ? tunnel_hlen : tunnel->hlen;
-	pkt_size = skb->len - tunnel_hlen - dev->hard_header_len;
+	pkt_size = skb->len - tunnel_hlen;
 
 	if (df)
-		mtu = dst_mtu(&rt->dst) - dev->hard_header_len
-					- sizeof(struct iphdr) - tunnel_hlen;
+		mtu = dst_mtu(&rt->dst) - sizeof(struct iphdr) - tunnel_hlen;
 	else
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
-- 
2.25.1

