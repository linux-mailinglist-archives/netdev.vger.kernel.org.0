Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D327713F483
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437053AbgAPSuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389259AbgAPRJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F3C5217F4;
        Thu, 16 Jan 2020 17:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194547;
        bh=+FFA+G3tdJcrZvilavAYlGhlcqAn30vwrIjSwb1Q3/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LlrqPvhuYB7w8CKqmliz5ujcV3kVFN601TdQxJDYDvxlf1GviztcrNxnJeaeV993J
         zj7Twia11u0HWH1fxG7rQ6o2II2sHkxBmuDANh8JG2eLYLFci8lLhM8PKmeaPtlFlw
         vNFfx4Sc2GLQ4r1vzpXZNWxiIUjrkJKlSpmjXGN4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 431/671] ip6_fib: Don't discard nodes with valid routing information in fib6_locate_1()
Date:   Thu, 16 Jan 2020 12:01:09 -0500
Message-Id: <20200116170509.12787-168-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefano Brivio <sbrivio@redhat.com>

[ Upstream commit 40cb35d5dc04e7f89cbc7b1fc9b4b48d9f1e5343 ]

When we perform an inexact match on FIB nodes via fib6_locate_1(), longer
prefixes will be preferred to shorter ones. However, it might happen that
a node, with higher fn_bit value than some other, has no valid routing
information.

In this case, we'll pick that node, but it will be discarded by the check
on RTN_RTINFO in fib6_locate(), and we might miss nodes with valid routing
information but with lower fn_bit value.

This is apparent when a routing exception is created for a default route:
 # ip -6 route list
 fc00:1::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fc00:2::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 pref medium
 fe80::/64 dev veth_A-R1 proto kernel metric 256 pref medium
 fe80::/64 dev veth_A-R2 proto kernel metric 256 pref medium
 default via fc00:1::2 dev veth_A-R1 metric 1024 pref medium
 # ip -6 route list cache
 fc00:4::1 via fc00:2::2 dev veth_A-R2 metric 1024 expires 593sec mtu 1500 pref medium
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 593sec mtu 1500 pref medium
 # ip -6 route flush cache    # node for default route is discarded
 Failed to send flush request: No such process
 # ip -6 route list cache
 fc00:3::1 via fc00:1::2 dev veth_A-R1 metric 1024 expires 586sec mtu 1500 pref medium

Check right away if the node has a RTN_RTINFO flag, before replacing the
'prev' pointer, that indicates the longest matching prefix found so far.

Fixes: 38fbeeeeccdb ("ipv6: prepare fib6_locate() for exception table")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index bbb5ffb3397d..7091568b9f63 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1529,7 +1529,8 @@ static struct fib6_node *fib6_locate_1(struct fib6_node *root,
 		if (plen == fn->fn_bit)
 			return fn;
 
-		prev = fn;
+		if (fn->fn_flags & RTN_RTINFO)
+			prev = fn;
 
 next:
 		/*
-- 
2.20.1

