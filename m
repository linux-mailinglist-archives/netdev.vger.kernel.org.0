Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F08D8AAB0
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 00:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfHLWqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 18:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfHLWqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 18:46:05 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9443A30BCB85;
        Mon, 12 Aug 2019 22:46:05 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 865E8842A2;
        Mon, 12 Aug 2019 22:46:03 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Hangbin Liu <haliu@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Subject: [PATCH net] ipv6: Fix return value of ipv6_mc_may_pull() for malformed packets
Date:   Tue, 13 Aug 2019 00:46:01 +0200
Message-Id: <dc0d0b1bc3c67e2a1346b0dd1f68428eb956fbb7.1565649789.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Mon, 12 Aug 2019 22:46:05 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and
ipv6_mc_check_mld() calls") replaces direct calls to pskb_may_pull()
in br_ipv6_multicast_mld2_report() with calls to ipv6_mc_may_pull(),
that returns -EINVAL on buffers too short to be valid IPv6 packets,
while maintaining the previous handling of the return code.

This leads to the direct opposite of the intended effect: if the
packet is malformed, -EINVAL evaluates as true, and we'll happily
proceed with the processing.

Return 0 if the packet is too short, in the same way as this was
fixed for IPv4 by commit 083b78a9ed64 ("ip: fix ip_mc_may_pull()
return value").

I don't have a reproducer for this, unlike the one referred to by
the IPv4 commit, but this is clearly broken.

Fixes: ba5ea614622d ("bridge: simplify ip_mc_check_igmp() and ipv6_mc_check_mld() calls")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/addrconf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index becdad576859..3f62b347b04a 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -206,7 +206,7 @@ static inline int ipv6_mc_may_pull(struct sk_buff *skb,
 				   unsigned int len)
 {
 	if (skb_transport_offset(skb) + ipv6_transport_len(skb) < len)
-		return -EINVAL;
+		return 0;
 
 	return pskb_may_pull(skb, len);
 }
-- 
2.20.1

