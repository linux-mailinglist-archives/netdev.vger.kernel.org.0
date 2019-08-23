Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E709B6DF
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 21:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391035AbfHWTPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 15:15:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42061 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728512AbfHWTPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 15:15:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id p3so6253955pgb.9
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 12:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zvOSdMyhtRmw2YL7s3jreDfz/v+KU4hoknfu2SKboac=;
        b=nzzxJLkopVdkLZHs34K5AQJIqTM/CnLO+tGEEufZZUlBtMg/Xn6gEZQMQrae663xbQ
         bJPWsH9MIiOl3EnbjNU47DDotxjnH6ujmNKXuyUtQAZ9U/WitSg4ZyDX0sxEbt7DeNgf
         enXr4BqPSzAp+/Qh3Fb1NbyGtscKcgIU/iuY8DUVtXB99Ke/kJHZFgcXUcvWCNM9i6Oe
         aj9jlIo5tqS2EXggt1dDE3zbUdnvVrTRb5q8EPLQprXhlQYNKsYK2U3iX8/lS/TtTbbh
         EZvI9NRpJxSDfFBkJZ7nqoiDxM9NxNbj8SNoqG3gCELmnQedqZHkGV288UAX1KLAN4BJ
         VGqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zvOSdMyhtRmw2YL7s3jreDfz/v+KU4hoknfu2SKboac=;
        b=YEXmN8uCeqONyCQwSJ+LaFfkUsRw6tHCZ7YemOU1J77gkWPozX1M9NndYqON88Drr+
         EuxgY3gJtEJRO8gasEBa6FQhYBaCOjzcVGqeGX29VpiuoqBMUlUpFnOm+szNYHARzMHs
         n+X5twAw2hYB/d728YwaVHuIW/jfJQGQsukYcrQPU/HLNqCkQxPqEAPhA4mu/4oZajIE
         a7M2Eg6XoFy0RhZCDHFgRXjkOIYRed8rzBSIHd/uAlsok1YMD8ugmFr6+7NJw7K5hGTl
         4QJHw83lrh2tXbNjJ6MhAM66CofHSuw1qjFpFjHotDwSlmbDdDB3XUeeOU9P1Io3Nim/
         xnaw==
X-Gm-Message-State: APjAAAWF9jljzPz8IwRdJ44i1V1PNaZyS7ynq8hMbzUA3OzJj0uDPZF4
        A8MLnQlh64oMdM9klGKomsTHCRhW2ew=
X-Google-Smtp-Source: APXvYqz9Wak3CX3GJFdwlCrEJUq4O/mmLp4DhKk3x+DkYU+l6vL+9NzXVyi593cCY2kH/VZR660DKw==
X-Received: by 2002:a17:90b:14c:: with SMTP id em12mr7087431pjb.28.1566587699729;
        Fri, 23 Aug 2019 12:14:59 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id i6sm3146252pfo.16.2019.08.23.12.14.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 23 Aug 2019 12:14:59 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>, Tom Herbert <tom@herbertland.com>
Subject: [PATCH v4 net-next 2/7] ipeh: Move generic EH functions to exthdrs_common.c
Date:   Fri, 23 Aug 2019 12:13:58 -0700
Message-Id: <1566587643-16594-3-git-send-email-tom@herbertland.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566587643-16594-1-git-send-email-tom@herbertland.com>
References: <1566587643-16594-1-git-send-email-tom@herbertland.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@quantonium.net>

Move generic functions in exthdrs.c to new exthdrs_common.c so that
exthdrs.c only contains functions that are specific to IPv6 processing,
and exthdrs_common.c contains functions that are generic. These
functions include those that will be used with IPv4 extension headers.
Generic extension header related functions are prefixed by ipeh_.

Signed-off-by: Tom Herbert <tom@herbertland.com>
---
 include/net/ipeh.h        |  12 ++++
 include/net/ipv6.h        |   9 ---
 net/dccp/ipv6.c           |   2 +-
 net/ipv6/Kconfig          |   4 ++
 net/ipv6/Makefile         |   1 +
 net/ipv6/calipso.c        |   6 +-
 net/ipv6/exthdrs.c        | 138 --------------------------------------------
 net/ipv6/exthdrs_common.c | 144 ++++++++++++++++++++++++++++++++++++++++++++++
 net/ipv6/ipv6_sockglue.c  |   2 +-
 net/ipv6/raw.c            |   2 +-
 net/ipv6/tcp_ipv6.c       |   2 +-
 net/ipv6/udp.c            |   2 +-
 net/l2tp/l2tp_ip6.c       |   2 +-
 net/sctp/ipv6.c           |   2 +-
 14 files changed, 171 insertions(+), 157 deletions(-)
 create mode 100644 net/ipv6/exthdrs_common.c

diff --git a/include/net/ipeh.h b/include/net/ipeh.h
index ec2d186..3b24831 100644
--- a/include/net/ipeh.h
+++ b/include/net/ipeh.h
@@ -19,4 +19,16 @@ struct tlvtype_proc {
 extern const struct tlvtype_proc tlvprocdestopt_lst[];
 extern const struct tlvtype_proc tlvprochopopt_lst[];
 
+struct ipv6_txoptions;
+struct ipv6_opt_hdr;
+
+struct ipv6_txoptions *ipeh_dup_options(struct sock *sk,
+					struct ipv6_txoptions *opt);
+struct ipv6_txoptions *ipeh_renew_options(struct sock *sk,
+					  struct ipv6_txoptions *opt,
+					  int newtype,
+					  struct ipv6_opt_hdr *newopt);
+struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
+					  struct ipv6_txoptions *opt);
+
 #endif /* _NET_IPEH_H */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index ec10fca..1c6878b 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -429,15 +429,6 @@ int ip6_ra_control(struct sock *sk, int sel);
 
 int ipv6_parse_hopopts(struct sk_buff *skb);
 
-struct ipv6_txoptions *ipv6_dup_options(struct sock *sk,
-					struct ipv6_txoptions *opt);
-struct ipv6_txoptions *ipv6_renew_options(struct sock *sk,
-					  struct ipv6_txoptions *opt,
-					  int newtype,
-					  struct ipv6_opt_hdr *newopt);
-struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
-					  struct ipv6_txoptions *opt);
-
 bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 		       const struct inet6_skb_parm *opt);
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 1b7381f..0b83a04 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -514,7 +514,7 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	if (!opt)
 		opt = rcu_dereference(np->opt);
 	if (opt) {
-		opt = ipv6_dup_options(newsk, opt);
+		opt = ipeh_dup_options(newsk, opt);
 		RCU_INIT_POINTER(newnp->opt, opt);
 	}
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index ae1344e..700fcea 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -3,9 +3,13 @@
 # IPv6 configuration
 #
 
+config EXTHDRS
+	bool
+
 #   IPv6 as module will cause a CRASH if you try to unload it
 menuconfig IPV6
 	tristate "The IPv6 protocol"
+	select EXTHDRS
 	default y
 	---help---
 	  Support for IP version 6 (IPv6).
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index df3919b..0bcab81 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -44,6 +44,7 @@ obj-$(CONFIG_IPV6_SIT) += sit.o
 obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
 obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
 obj-$(CONFIG_IPV6_FOU) += fou6.o
+obj-$(CONFIG_EXTHDRS) += exthdrs_common.o
 
 obj-y += addrconf_core.o exthdrs_core.o ip6_checksum.o ip6_icmp.o
 obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 221c81f..9c84848 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -785,7 +785,7 @@ static int calipso_opt_update(struct sock *sk, struct ipv6_opt_hdr *hop)
 {
 	struct ipv6_txoptions *old = txopt_get(inet6_sk(sk)), *txopts;
 
-	txopts = ipv6_renew_options(sk, old, IPV6_HOPOPTS, hop);
+	txopts = ipeh_renew_options(sk, old, IPV6_HOPOPTS, hop);
 	txopt_put(old);
 	if (IS_ERR(txopts))
 		return PTR_ERR(txopts);
@@ -1207,7 +1207,7 @@ static int calipso_req_setattr(struct request_sock *req,
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
-	txopts = ipv6_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
+	txopts = ipeh_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
 
 	kfree(new);
 
@@ -1244,7 +1244,7 @@ static void calipso_req_delattr(struct request_sock *req)
 	if (calipso_opt_del(req_inet->ipv6_opt->hopopt, &new))
 		return; /* Nothing to do */
 
-	txopts = ipv6_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
+	txopts = ipeh_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
 
 	if (!IS_ERR(txopts)) {
 		txopts = xchg(&req_inet->ipv6_opt, txopts);
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 664491e..e12d3a5 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -784,144 +784,6 @@ void ipv6_push_frag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt, u8 *pr
 }
 EXPORT_SYMBOL(ipv6_push_frag_opts);
 
-struct ipv6_txoptions *
-ipv6_dup_options(struct sock *sk, struct ipv6_txoptions *opt)
-{
-	struct ipv6_txoptions *opt2;
-
-	opt2 = sock_kmalloc(sk, opt->tot_len, GFP_ATOMIC);
-	if (opt2) {
-		long dif = (char *)opt2 - (char *)opt;
-		memcpy(opt2, opt, opt->tot_len);
-		if (opt2->hopopt)
-			*((char **)&opt2->hopopt) += dif;
-		if (opt2->dst0opt)
-			*((char **)&opt2->dst0opt) += dif;
-		if (opt2->dst1opt)
-			*((char **)&opt2->dst1opt) += dif;
-		if (opt2->srcrt)
-			*((char **)&opt2->srcrt) += dif;
-		refcount_set(&opt2->refcnt, 1);
-	}
-	return opt2;
-}
-EXPORT_SYMBOL_GPL(ipv6_dup_options);
-
-static void ipv6_renew_option(int renewtype,
-			      struct ipv6_opt_hdr **dest,
-			      struct ipv6_opt_hdr *old,
-			      struct ipv6_opt_hdr *new,
-			      int newtype, char **p)
-{
-	struct ipv6_opt_hdr *src;
-
-	src = (renewtype == newtype ? new : old);
-	if (!src)
-		return;
-
-	memcpy(*p, src, ipv6_optlen(src));
-	*dest = (struct ipv6_opt_hdr *)*p;
-	*p += CMSG_ALIGN(ipv6_optlen(*dest));
-}
-
-/**
- * ipv6_renew_options - replace a specific ext hdr with a new one.
- *
- * @sk: sock from which to allocate memory
- * @opt: original options
- * @newtype: option type to replace in @opt
- * @newopt: new option of type @newtype to replace (user-mem)
- * @newoptlen: length of @newopt
- *
- * Returns a new set of options which is a copy of @opt with the
- * option type @newtype replaced with @newopt.
- *
- * @opt may be NULL, in which case a new set of options is returned
- * containing just @newopt.
- *
- * @newopt may be NULL, in which case the specified option type is
- * not copied into the new set of options.
- *
- * The new set of options is allocated from the socket option memory
- * buffer of @sk.
- */
-struct ipv6_txoptions *
-ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
-		   int newtype, struct ipv6_opt_hdr *newopt)
-{
-	int tot_len = 0;
-	char *p;
-	struct ipv6_txoptions *opt2;
-
-	if (opt) {
-		if (newtype != IPV6_HOPOPTS && opt->hopopt)
-			tot_len += CMSG_ALIGN(ipv6_optlen(opt->hopopt));
-		if (newtype != IPV6_RTHDRDSTOPTS && opt->dst0opt)
-			tot_len += CMSG_ALIGN(ipv6_optlen(opt->dst0opt));
-		if (newtype != IPV6_RTHDR && opt->srcrt)
-			tot_len += CMSG_ALIGN(ipv6_optlen(opt->srcrt));
-		if (newtype != IPV6_DSTOPTS && opt->dst1opt)
-			tot_len += CMSG_ALIGN(ipv6_optlen(opt->dst1opt));
-	}
-
-	if (newopt)
-		tot_len += CMSG_ALIGN(ipv6_optlen(newopt));
-
-	if (!tot_len)
-		return NULL;
-
-	tot_len += sizeof(*opt2);
-	opt2 = sock_kmalloc(sk, tot_len, GFP_ATOMIC);
-	if (!opt2)
-		return ERR_PTR(-ENOBUFS);
-
-	memset(opt2, 0, tot_len);
-	refcount_set(&opt2->refcnt, 1);
-	opt2->tot_len = tot_len;
-	p = (char *)(opt2 + 1);
-
-	ipv6_renew_option(IPV6_HOPOPTS, &opt2->hopopt,
-			  (opt ? opt->hopopt : NULL),
-			  newopt, newtype, &p);
-	ipv6_renew_option(IPV6_RTHDRDSTOPTS, &opt2->dst0opt,
-			  (opt ? opt->dst0opt : NULL),
-			  newopt, newtype, &p);
-	ipv6_renew_option(IPV6_RTHDR,
-			  (struct ipv6_opt_hdr **)&opt2->srcrt,
-			  (opt ? (struct ipv6_opt_hdr *)opt->srcrt : NULL),
-			  newopt, newtype, &p);
-	ipv6_renew_option(IPV6_DSTOPTS, &opt2->dst1opt,
-			  (opt ? opt->dst1opt : NULL),
-			  newopt, newtype, &p);
-
-	opt2->opt_nflen = (opt2->hopopt ? ipv6_optlen(opt2->hopopt) : 0) +
-			  (opt2->dst0opt ? ipv6_optlen(opt2->dst0opt) : 0) +
-			  (opt2->srcrt ? ipv6_optlen(opt2->srcrt) : 0);
-	opt2->opt_flen = (opt2->dst1opt ? ipv6_optlen(opt2->dst1opt) : 0);
-
-	return opt2;
-}
-
-struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
-					  struct ipv6_txoptions *opt)
-{
-	/*
-	 * ignore the dest before srcrt unless srcrt is being included.
-	 * --yoshfuji
-	 */
-	if (opt && opt->dst0opt && !opt->srcrt) {
-		if (opt_space != opt) {
-			memcpy(opt_space, opt, sizeof(*opt_space));
-			opt = opt_space;
-		}
-		opt->opt_nflen -= ipv6_optlen(opt->dst0opt);
-		opt->dst0opt = NULL;
-	}
-
-	return opt;
-}
-EXPORT_SYMBOL_GPL(ipv6_fixup_options);
-
 /**
  * fl6_update_dst - update flowi destination address with info given
  *                  by srcrt option, if any.
diff --git a/net/ipv6/exthdrs_common.c b/net/ipv6/exthdrs_common.c
new file mode 100644
index 0000000..2c68184
--- /dev/null
+++ b/net/ipv6/exthdrs_common.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Extension header and TLV library code that is not specific to IPv6. */
+#include <linux/export.h>
+#include <net/ipv6.h>
+
+struct ipv6_txoptions *
+ipeh_dup_options(struct sock *sk, struct ipv6_txoptions *opt)
+{
+	struct ipv6_txoptions *opt2;
+
+	opt2 = sock_kmalloc(sk, opt->tot_len, GFP_ATOMIC);
+	if (opt2) {
+		long dif = (char *)opt2 - (char *)opt;
+
+		memcpy(opt2, opt, opt->tot_len);
+		if (opt2->hopopt)
+			*((char **)&opt2->hopopt) += dif;
+		if (opt2->dst0opt)
+			*((char **)&opt2->dst0opt) += dif;
+		if (opt2->dst1opt)
+			*((char **)&opt2->dst1opt) += dif;
+		if (opt2->srcrt)
+			*((char **)&opt2->srcrt) += dif;
+		refcount_set(&opt2->refcnt, 1);
+	}
+	return opt2;
+}
+EXPORT_SYMBOL_GPL(ipeh_dup_options);
+
+static void ipeh_renew_option(int renewtype,
+			      struct ipv6_opt_hdr **dest,
+			      struct ipv6_opt_hdr *old,
+			      struct ipv6_opt_hdr *new,
+			      int newtype, char **p)
+{
+	struct ipv6_opt_hdr *src;
+
+	src = (renewtype == newtype ? new : old);
+	if (!src)
+		return;
+
+	memcpy(*p, src, ipv6_optlen(src));
+	*dest = (struct ipv6_opt_hdr *)*p;
+	*p += CMSG_ALIGN(ipv6_optlen(*dest));
+}
+
+/**
+ * ipeh_renew_options - replace a specific ext hdr with a new one.
+ *
+ * @sk: sock from which to allocate memory
+ * @opt: original options
+ * @newtype: option type to replace in @opt
+ * @newopt: new option of type @newtype to replace (user-mem)
+ * @newoptlen: length of @newopt
+ *
+ * Returns a new set of options which is a copy of @opt with the
+ * option type @newtype replaced with @newopt.
+ *
+ * @opt may be NULL, in which case a new set of options is returned
+ * containing just @newopt.
+ *
+ * @newopt may be NULL, in which case the specified option type is
+ * not copied into the new set of options.
+ *
+ * The new set of options is allocated from the socket option memory
+ * buffer of @sk.
+ */
+struct ipv6_txoptions *
+ipeh_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
+		   int newtype, struct ipv6_opt_hdr *newopt)
+{
+	int tot_len = 0;
+	char *p;
+	struct ipv6_txoptions *opt2;
+
+	if (opt) {
+		if (newtype != IPV6_HOPOPTS && opt->hopopt)
+			tot_len += CMSG_ALIGN(ipv6_optlen(opt->hopopt));
+		if (newtype != IPV6_RTHDRDSTOPTS && opt->dst0opt)
+			tot_len += CMSG_ALIGN(ipv6_optlen(opt->dst0opt));
+		if (newtype != IPV6_RTHDR && opt->srcrt)
+			tot_len += CMSG_ALIGN(ipv6_optlen(opt->srcrt));
+		if (newtype != IPV6_DSTOPTS && opt->dst1opt)
+			tot_len += CMSG_ALIGN(ipv6_optlen(opt->dst1opt));
+	}
+
+	if (newopt)
+		tot_len += CMSG_ALIGN(ipv6_optlen(newopt));
+
+	if (!tot_len)
+		return NULL;
+
+	tot_len += sizeof(*opt2);
+	opt2 = sock_kmalloc(sk, tot_len, GFP_ATOMIC);
+	if (!opt2)
+		return ERR_PTR(-ENOBUFS);
+
+	memset(opt2, 0, tot_len);
+	refcount_set(&opt2->refcnt, 1);
+	opt2->tot_len = tot_len;
+	p = (char *)(opt2 + 1);
+
+	ipeh_renew_option(IPV6_HOPOPTS, &opt2->hopopt,
+			  (opt ? opt->hopopt : NULL),
+			  newopt, newtype, &p);
+	ipeh_renew_option(IPV6_RTHDRDSTOPTS, &opt2->dst0opt,
+			  (opt ? opt->dst0opt : NULL),
+			  newopt, newtype, &p);
+	ipeh_renew_option(IPV6_RTHDR,
+			  (struct ipv6_opt_hdr **)&opt2->srcrt,
+			  (opt ? (struct ipv6_opt_hdr *)opt->srcrt : NULL),
+			  newopt, newtype, &p);
+	ipeh_renew_option(IPV6_DSTOPTS, &opt2->dst1opt,
+			  (opt ? opt->dst1opt : NULL),
+			  newopt, newtype, &p);
+
+	opt2->opt_nflen = (opt2->hopopt ? ipv6_optlen(opt2->hopopt) : 0) +
+			  (opt2->dst0opt ? ipv6_optlen(opt2->dst0opt) : 0) +
+			  (opt2->srcrt ? ipv6_optlen(opt2->srcrt) : 0);
+	opt2->opt_flen = (opt2->dst1opt ? ipv6_optlen(opt2->dst1opt) : 0);
+
+	return opt2;
+}
+EXPORT_SYMBOL(ipeh_renew_options);
+
+struct ipv6_txoptions *ipeh_fixup_options(struct ipv6_txoptions *opt_space,
+					  struct ipv6_txoptions *opt)
+{
+	/* ignore the dest before srcrt unless srcrt is being included.
+	 * --yoshfuji
+	 */
+	if (opt && opt->dst0opt && !opt->srcrt) {
+		if (opt_space != opt) {
+			memcpy(opt_space, opt, sizeof(*opt_space));
+			opt = opt_space;
+		}
+		opt->opt_nflen -= ipv6_optlen(opt->dst0opt);
+		opt->dst0opt = NULL;
+	}
+
+	return opt;
+}
+EXPORT_SYMBOL_GPL(ipeh_fixup_options);
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 264c292..8755ecc 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -427,7 +427,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 
 		opt = rcu_dereference_protected(np->opt,
 						lockdep_sock_is_held(sk));
-		opt = ipv6_renew_options(sk, opt, optname, new);
+		opt = ipeh_renew_options(sk, opt, optname, new);
 		kfree(new);
 		if (IS_ERR(opt)) {
 			retv = PTR_ERR(opt);
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 8a61319..5834ca4 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -888,7 +888,7 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 	if (flowlabel)
 		opt = fl6_merge_options(&opt_space, flowlabel, opt);
-	opt = ipv6_fixup_options(&opt_space, opt);
+	opt = ipeh_fixup_options(&opt_space, opt);
 
 	fl6.flowi6_proto = proto;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 87f44d3..6bbf24f 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1243,7 +1243,7 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	if (!opt)
 		opt = rcu_dereference(np->opt);
 	if (opt) {
-		opt = ipv6_dup_options(newsk, opt);
+		opt = ipeh_dup_options(newsk, opt);
 		RCU_INIT_POINTER(newnp->opt, opt);
 	}
 	inet_csk(newsk)->icsk_ext_hdr_len = 0;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 827fe73..02ab20e 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1384,7 +1384,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 	if (flowlabel)
 		opt = fl6_merge_options(&opt_space, flowlabel, opt);
-	opt = ipv6_fixup_options(&opt_space, opt);
+	opt = ipeh_fixup_options(&opt_space, opt);
 	ipc6.opt = opt;
 
 	fl6.flowi6_proto = sk->sk_protocol;
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 687e23a..bc4925c 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -590,7 +590,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	}
 	if (flowlabel)
 		opt = fl6_merge_options(&opt_space, flowlabel, opt);
-	opt = ipv6_fixup_options(&opt_space, opt);
+	opt = ipeh_fixup_options(&opt_space, opt);
 	ipc6.opt = opt;
 
 	fl6.flowi6_proto = sk->sk_protocol;
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index e5f2fc7..b5b1349 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -441,7 +441,7 @@ static void sctp_v6_copy_ip_options(struct sock *sk, struct sock *newsk)
 	rcu_read_lock();
 	opt = rcu_dereference(np->opt);
 	if (opt) {
-		opt = ipv6_dup_options(newsk, opt);
+		opt = ipeh_dup_options(newsk, opt);
 		if (!opt)
 			pr_err("%s: Failed to copy ip options\n", __func__);
 	}
-- 
2.7.4

