Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1549EFEEAF
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 16:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731267AbfKPPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 10:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbfKPPxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:53:32 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25AAF2168B;
        Sat, 16 Nov 2019 15:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919612;
        bh=B0Njg5yOngXhHDvGrWZ4jBKX4MpUpoK1cGw/PDSWp/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0PZek3q7sxS9Afet8LJCiI3GuvXHBOD26+gSGP7aLQnwt9ZqKd3CuV2ByvO8kO0/
         +I7inij3aj1upbU1WFaEMTrWTMqr1Mrs2eZ+spsEBHjVMdBmpntXxVo3snHJS4F5la
         HoGPyGGwzj49K6HEozWX+V6nMUeGko6Db+q3TdcU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Mike Manning <mmanning@vyatta.att-mail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 99/99] ipv6: Fix handling of LLA with VRF and sockets bound to VRF
Date:   Sat, 16 Nov 2019 10:51:02 -0500
Message-Id: <20191116155103.10971-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
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
index 4953466cf98f0..54e2557335c1c 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -693,6 +693,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 			    const struct sock *sk_listener,
 			    struct sk_buff *skb)
 {
+	bool l3_slave = ipv6_l3mdev_skb(TCP_SKB_CB(skb)->header.h6.flags);
 	struct inet_request_sock *ireq = inet_rsk(req);
 	const struct ipv6_pinfo *np = inet6_sk(sk_listener);
 
@@ -700,7 +701,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 
 	/* So that link locals have meaning */
-	if (!sk_listener->sk_bound_dev_if &&
+	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = tcp_v6_iif(skb);
 
-- 
2.20.1

