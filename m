Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96C0FF1EA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfKPPrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:47:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728873AbfKPPrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:11 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DB672084F;
        Sat, 16 Nov 2019 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919231;
        bh=AiDrupa0ElEL9BkwztZdJMc2ifNPMRDNGjY+TvtGWtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1vuHA5iGl2VusWw1xB2iY7A6eR7ZR5Jt7GQNm9jwmvwg8z+jRdHQW23oyTkECq9i
         6B5KVnBrejixsfqFlmCTG9OlSOT5wEGVnRIvY5vBf3weIEd7oof1ri8Jskm3wqciZQ
         NqkDxMVePrNWM7BkkEuVmI57DH0DbR7bYR8vMIDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 236/237] ipv6: Fix handling of LLA with VRF and sockets bound to VRF
Date:   Sat, 16 Nov 2019 10:41:11 -0500
Message-Id: <20191116154113.7417-236-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

[ Upstream commit c2027d1e17582903e368abf5d4838b22a98f2b7b ]

A recent commit allows sockets bound to a VRF to receive ipv6 link local
packets. However, it only works for UDP and worse TCP connection attempts
to the LLA with the only listener bound to the VRF just hang where as
before the client gets a reset and connection refused. Fix by adjusting
ir_iif for LL addresses and packets received through a device enslaved
to a VRF.

Fixes: 6f12fa775530 ("vrf: mark skb for multicast or link-local as enslaved to VRF")
Reported-by: Donald Sharp <sharpd@cumulusnetworks.com>
Cc: Mike Manning <mmanning@vyatta.att-mail.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e7cdfa92c3820..9a117a79af659 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -734,6 +734,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
+	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct ipv6_pinfo *np = inet6_sk(sk_listener);
 
@@ -741,7 +742,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 
 	/* So that link locals have meaning */
-	if (!sk_listener->sk_bound_dev_if &&
+	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = tcp_v6_iif(skb);
 
-- 
2.20.1

