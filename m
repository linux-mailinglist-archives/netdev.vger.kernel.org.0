Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C534D41F01B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 16:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354608AbhJAO5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 10:57:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:65084 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354686AbhJAO5j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 10:57:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="225113128"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="225113128"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 07:50:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="565045013"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 01 Oct 2021 07:50:52 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 31A2729D; Fri,  1 Oct 2021 17:50:57 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jose M. Guisado Gomez" <guigom@riseup.net>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 net-next 1/1] net: Mark possible unused variables on stack with __maybe_unused
Date:   Fri,  1 Oct 2021 17:50:56 +0300
Message-Id: <20211001145056.12184-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When compile with COMPILE_TEST=y the -Werror is implied.
If we run `make W=1` the first level warnings will become
the build errors. Some of them related to possible unused
variables. Hence, to allow clean build in such case, mark
them with __maybe_unused.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 net/ipv4/netfilter/nf_reject_ipv4.c | 2 +-
 net/ipv6/ip6_fib.c                  | 3 ++-
 net/ipv6/netfilter/nf_reject_ipv6.c | 2 +-
 net/socket.c                        | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4eed5afca392..52d943426705 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -239,7 +239,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 {
 	struct net_device *br_indev __maybe_unused;
 	struct sk_buff *nskb;
-	struct iphdr *niph;
+	struct iphdr __maybe_unused *niph;
 	const struct tcphdr *oth;
 	struct tcphdr _oth;
 
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0371d2c14145..8783e49a5465 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1374,7 +1374,8 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 	     struct nl_info *info, struct netlink_ext_ack *extack)
 {
 	struct fib6_table *table = rt->fib6_table;
-	struct fib6_node *fn, *pn = NULL;
+	struct fib6_node *fn;
+	struct fib6_node __maybe_unused *pn = NULL;
 	int err = -ENOMEM;
 	int allow_create = 1;
 	int replace_required = 0;
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index dffeaaaadcde..69b98a6183b3 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -284,7 +284,7 @@ void nf_send_reset6(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	const struct tcphdr *otcph;
 	unsigned int otcplen, hh_len;
 	const struct ipv6hdr *oip6h = ipv6_hdr(oldskb);
-	struct ipv6hdr *ip6h;
+	struct ipv6hdr __maybe_unused *ip6h;
 	struct dst_entry *dst = NULL;
 	struct flowi6 fl6;
 
diff --git a/net/socket.c b/net/socket.c
index 7f64a6eccf63..fbb442adf27f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2199,7 +2199,7 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 {
 	int err, fput_needed;
 	struct socket *sock;
-	int max_optlen;
+	int __maybe_unused max_optlen;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
-- 
2.33.0

