Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18AC636D3C
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 09:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfFFHVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 03:21:37 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:59639 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfFFHVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 03:21:36 -0400
Received: from glumotte.dev.6wind.com. (unknown [10.16.0.195])
        by proxy.6wind.com (Postfix) with ESMTP id D03492C603B;
        Thu,  6 Jun 2019 09:15:39 +0200 (CEST)
From:   Olivier Matz <olivier.matz@6wind.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [PATCH net 2/2] ipv6: fix EFAULT on sendto with icmpv6 and hdrincl
Date:   Thu,  6 Jun 2019 09:15:19 +0200
Message-Id: <20190606071519.5841-3-olivier.matz@6wind.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190606071519.5841-1-olivier.matz@6wind.com>
References: <20190606071519.5841-1-olivier.matz@6wind.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following code returns EFAULT (Bad address):

  s = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
  setsockopt(s, SOL_IPV6, IPV6_HDRINCL, 1);
  sendto(ipv6_icmp6_packet, addr);   /* returns -1, errno = EFAULT */

The IPv4 equivalent code works. A workaround is to use IPPROTO_RAW
instead of IPPROTO_ICMPV6.

The failure happens because 2 bytes are eaten from the msghdr by
rawv6_probe_proto_opt() starting from commit 19e3c66b52ca ("ipv6
equivalent of "ipv4: Avoid reading user iov twice after
raw_probe_proto_opt""), but at that time it was not a problem because
IPV6_HDRINCL was not yet introduced.

Only eat these 2 bytes if hdrincl == 0.

Fixes: 715f504b1189 ("ipv6: add IPV6_HDRINCL option for raw sockets")
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
---
 net/ipv6/raw.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index af2f9a833c4e..1bb88b4b677b 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -895,11 +895,14 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	opt = ipv6_fixup_options(&opt_space, opt);
 
 	fl6.flowi6_proto = proto;
-	rfv.msg = msg;
-	rfv.hlen = 0;
-	err = rawv6_probe_proto_opt(&rfv, &fl6);
-	if (err)
-		goto out;
+
+	if (!hdrincl) {
+		rfv.msg = msg;
+		rfv.hlen = 0;
+		err = rawv6_probe_proto_opt(&rfv, &fl6);
+		if (err)
+			goto out;
+	}
 
 	if (!ipv6_addr_any(daddr))
 		fl6.daddr = *daddr;
-- 
2.11.0

