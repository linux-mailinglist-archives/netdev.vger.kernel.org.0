Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7644877A2
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 13:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbiAGMiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 07:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiAGMiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 07:38:54 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC46C061245
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:38:54 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m21so21837053edc.0
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 04:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xEZJrwz9CO8YKGb3XiRJoVKpsJ6d0ghK+GRPW5TCouo=;
        b=r2tzmQQC0aonZDnvnnr9H1SuGa2ovraiSGF+GQiTjF4E8nDnI23k6p+kGdwcDtlUQW
         GAlryR6xm8mXWoQvyi4eLK3TAT63absS33lW+bIcL8p7Kx8Vtp8hEfurdi2otUDHor5O
         joFkYTUwAIWFZzVXL/JUOusuUGdXPIIwnPMH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xEZJrwz9CO8YKGb3XiRJoVKpsJ6d0ghK+GRPW5TCouo=;
        b=GvtxBnHOUZSlFwokJ7T52f7hyN87KlW0S5E/zb8g9xYEL06ph98Q3SaJbQ2NyWDtOF
         NMcrSnWzBsY6e+zq4TLibteZolleWQ04qgfripf/bv6HWL4eTXBz3JDlbiI+3ghHVxyd
         Nx2K6Tpvlmg3aODArhL/R8ytqcF84ZuQW1wKvnBe0OlV3qET/7M3I5zPimDiAEywMo3I
         iVCz/27nuDM6theArxyTwMk3qMR4Tkl1OMd3+e0NLhezn3AXuSCI2vtzpxv6RoMFhe27
         a8LYQQZQSMadvdB7c6f0uZsPbNpgVHlqB25uyrMPHlVeR5YmF32mCqPA4x5nBLQ+xBy/
         DXgA==
X-Gm-Message-State: AOAM533blR3S6/Ln9Z1NdXWb6DFOnVnOjjN6GCFqjRsF8YELHBFpelYd
        bokGuftqY/zEb/Jj0OdsBpfIwS6XaqnqhQ==
X-Google-Smtp-Source: ABdhPJzcRABWRJ2acImoYJS7DouUrv7woBMLGdZqzbLqwj2Wqu5o413akPZhDbziFh6Rj8nfJC968A==
X-Received: by 2002:a17:907:6d82:: with SMTP id sb2mr4450496ejc.334.1641559132552;
        Fri, 07 Jan 2022 04:38:52 -0800 (PST)
Received: from localhost.localdomain ([198.41.152.153])
        by smtp.gmail.com with ESMTPSA id a1sm1996481edu.17.2022.01.07.04.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 04:38:52 -0800 (PST)
From:   Ignat Korchagin <ignat@cloudflare.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     kernel-team@cloudflare.com, Ignat Korchagin <ignat@cloudflare.com>,
        Amir Razmjou <arazmjou@cloudflare.com>
Subject: [PATCH] sit: allow encapsulated IPv6 traffic to be delivered locally
Date:   Fri,  7 Jan 2022 12:38:42 +0000
Message-Id: <20220107123842.211335-1-ignat@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While experimenting with FOU encapsulation Amir noticed that encapsulated IPv6
traffic fails to be delivered, if the peer IP address is configured locally.

It can be easily verified by creating a sit interface like below:

$ sudo ip link add name fou_test type sit remote 127.0.0.1 encap fou encap-sport auto encap-dport 1111
$ sudo ip link set fou_test up

and sending some IPv4 and IPv6 traffic to it

$ ping -I fou_test -c 1 1.1.1.1
$ ping6 -I fou_test -c 1 fe80::d0b0:dfff:fe4c:fcbc

"tcpdump -i any udp dst port 1111" will confirm that only the first IPv4 ping
was encapsulated and attempted to be delivered.

This seems like a limitation: for example, in a cloud environment the "peer"
service may be arbitrarily scheduled on any server within the cluster, where all
nodes are trying to send encapsulated traffic. And the unlucky node will not be
able to. Moreover, delivering encapsulated IPv4 traffic locally is allowed.

But I may not have all the context about this restriction and this code predates
the observable git history.

Reported-by: Amir Razmjou <arazmjou@cloudflare.com>
Signed-off-by: Ignat Korchagin <ignat@cloudflare.com>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 8a3618a30632..72968d4188b9 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -956,7 +956,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		dst_cache_set_ip4(&tunnel->dst_cache, &rt->dst, fl4.saddr);
 	}
 
-	if (rt->rt_type != RTN_UNICAST) {
+	if (rt->rt_type != RTN_UNICAST && rt->rt_type != RTN_LOCAL) {
 		ip_rt_put(rt);
 		dev->stats.tx_carrier_errors++;
 		goto tx_error_icmp;
-- 
2.20.1

