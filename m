Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A67A285FA4
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgJGNAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:00:25 -0400
Received: from aer-iport-4.cisco.com ([173.38.203.54]:48265 "EHLO
        aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgJGNAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 09:00:25 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Oct 2020 09:00:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1196; q=dns/txt; s=iport;
  t=1602075624; x=1603285224;
  h=from:to:cc:subject:date:message-id;
  bh=q+RDdyoKEmH4RG7jaJGxDqUmZUkoDoq7nlSoy8t/5Vc=;
  b=XEF5Eu8Wd6e0IXioUCD54CjXf/s4w8YRQAsHpxLBrDqLWmsi+Y4ZlknQ
   9tKAYSZWINpjRM4x+SkNpEjNTTzlGJDCpUjAnBOyEFOzXhvnYI+kh/+NA
   f0Im7GiFq1kHosuhP4kx3xGDZTKQ8vh4SqBgC2xNTRBPK/APG0F+FHv2P
   g=;
X-IronPort-AV: E=Sophos;i="5.77,346,1596499200"; 
   d="scan'208";a="30112568"
Received: from aer-iport-nat.cisco.com (HELO aer-core-1.cisco.com) ([173.38.203.22])
  by aer-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 07 Oct 2020 12:53:14 +0000
Received: from rdbuild16.cisco.com.rd.cisco.com (rdbuild16.cisco.com [10.47.15.16])
        by aer-core-1.cisco.com (8.15.2/8.15.2) with ESMTP id 097CrELr014863;
        Wed, 7 Oct 2020 12:53:14 GMT
From:   Georg Kohmann <geokohma@cisco.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, Georg Kohmann <geokohma@cisco.com>
Subject: [PATCH net] net:ipv6: Discard next-hop MTU less than minimum link MTU
Date:   Wed,  7 Oct 2020 14:53:02 +0200
Message-Id: <20201007125302.2833-1-geokohma@cisco.com>
X-Mailer: git-send-email 2.10.2
X-Outbound-SMTP-Client: 10.47.15.16, rdbuild16.cisco.com
X-Outbound-Node: aer-core-1.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a ICMPV6_PKT_TOOBIG report a next-hop MTU that is less than the IPv6
minimum link MTU, the estimated path MTU is reduced to the minimum link
MTU. This behaviour breaks TAHI IPv6 Core Conformance Test v6LC4.1.6:
Packet Too Big Less than IPv6 MTU.

Referring to RFC 8201 section 4: "If a node receives a Packet Too Big
message reporting a next-hop MTU that is less than the IPv6 minimum link
MTU, it must discard it. A node must not reduce its estimate of the Path
MTU below the IPv6 minimum link MTU on receipt of a Packet Too Big
message."

Drop the path MTU update if reported MTU is less than the minimum link MTU.

Signed-off-by: Georg Kohmann <geokohma@cisco.com>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index fb075d9..27430d6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2745,7 +2745,8 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 	if (confirm_neigh)
 		dst_confirm_neigh(dst, daddr);
 
-	mtu = max_t(u32, mtu, IPV6_MIN_MTU);
+	if (mtu < IPV6_MIN_MTU)
+		return;
 	if (mtu >= dst_mtu(dst))
 		return;
 
-- 
2.10.2

