Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB3C3DF54B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbhHCTSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:18:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238188AbhHCTSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 15:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2D4661037;
        Tue,  3 Aug 2021 19:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628018307;
        bh=Ls8CHkpBnIy6o43INUTkceCYHQjgavmnxsmD78va1Rk=;
        h=From:To:Cc:Subject:Date:From;
        b=kLqXMEY8C39pJI+Gt66lw/xI0qFymKayRjVKoOOi3ZjlWIAmesq8AYOgHYhiYv8pX
         bX8pIoE7SS3IQZczuX+d9/xSChaZKZjdp0qciy8FaJO/X4Q74UZCJvJo9vy/iqGx2Q
         ApR+kqdcbXB97ju0fYYYs+XtD803oe9yqk4Y3XwpzEtkIQJxrjjobbpTMs+QSOu5Gi
         05I3N5rOPrF+zVw17EKo69J0jHDtEulT+cXR8/uBkVydJqI6A0fA3sDSvPg1/BPsfp
         qfNNcWOCnUkcRYyLTsXbUhCxUtz22qB5cg3g8UzU0nm9i1k8DZnbTXFHD4trbumu2U
         vixkYquKjAEMw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] netfilter: ipset: Fix maximal range check in hash_ipportnet4_uadt()
Date:   Tue,  3 Aug 2021 12:18:13 -0700
Message-Id: <20210803191813.282980-1-nathan@kernel.org>
X-Mailer: git-send-email 2.33.0.rc0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

net/netfilter/ipset/ip_set_hash_ipportnet.c:249:29: warning: variable
'port_to' is uninitialized when used here [-Wuninitialized]
        if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
                                   ^~~~~~~
net/netfilter/ipset/ip_set_hash_ipportnet.c:167:45: note: initialize the
variable 'port_to' to silence this warning
        u32 ip = 0, ip_to = 0, p = 0, port, port_to;
                                                   ^
                                                    = 0
net/netfilter/ipset/ip_set_hash_ipportnet.c:249:39: warning: variable
'port' is uninitialized when used here [-Wuninitialized]
        if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
                                             ^~~~
net/netfilter/ipset/ip_set_hash_ipportnet.c:167:36: note: initialize the
variable 'port' to silence this warning
        u32 ip = 0, ip_to = 0, p = 0, port, port_to;
                                          ^
                                           = 0
2 warnings generated.

The range check was added before port and port_to are initialized.
Shuffle the check after the initialization so that the check works
properly.

Fixes: 7fb6c63025ff ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index b293aa1ff258..7df94f437f60 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -246,9 +246,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	port_to = port = ntohs(e.port);
 	if (tb[IPSET_ATTR_PORT_TO]) {
 		port_to = ip_set_get_h16(tb[IPSET_ATTR_PORT_TO]);
@@ -256,6 +253,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);

base-commit: 4d3fc8ead710a06c98d36f382777c6a843a83b7c
-- 
2.33.0.rc0

