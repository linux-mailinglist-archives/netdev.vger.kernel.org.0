Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235C4EA72
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 20:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbfD2SrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 14:47:06 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40859 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729106AbfD2Sqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 14:46:44 -0400
Received: by mail-io1-f65.google.com with SMTP id m9so3534723iok.7
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 11:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hAj0kqmai0y0EXSiNLbJqJt1e4EmwfMuX+PW7YER1s8=;
        b=ldmIdxZrg+ll29Ufsfqg5Ofatz3uYWfGtUx0THWxqaeL7OhS3iPEkbBwzZblDljqJ/
         7OGJ111Yh+/vE3BPejmIW0wlkl1gDzo/uWAte8/c0Mj1HppyHY2OBsiXor+arqSMB0k5
         jRf56UAPNAmGNpoIw8wP+OQllrl/klujU6EZ/GPgiF+2rQx5bnUzQ33nq43CIYZv1kzo
         p9ij0T7MRK2oS4PAQllaKhI48YqfvWciepUGf3a3bDrOuJk2Py6ld2Glaylb2KvibK/P
         4EXJcQhrS+ZT3kdSgy9EF2Xn5g98UBnnO44+KKwSWqcch3fYA+P1z2OInTxHEVmBA5VF
         aLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hAj0kqmai0y0EXSiNLbJqJt1e4EmwfMuX+PW7YER1s8=;
        b=laoTJZmsFqlVOD+y/B/CsbPAnDWKvnH6ugJ1N4wqQI+oSvsxte0Ajg23soQsFp9cw6
         /EDz3YDUczj9M/mnFOPhliPI3zgYWFVTOXcyLULcZyOp0goMTurObdRE+BgAfTJyxKJK
         99B4r6GFUpjarxHovAcbIfQDfUOmJYZlN5BXn0Fzrc0jtsYBn+F4xP2OBZG+VtYgyjKY
         J850kZSFIbrJVRjxH1TySDhfQWo442DgT0SOpCc30ynUkmj3y3A9wbnpk2Xo10WCobLp
         vEDwrrTA40K5Is6g10MfZ8pWrPf0nmHvZ8RNI5nZ0SzqCQ5hqksi63qrjW7vhv5ClVmg
         dIVg==
X-Gm-Message-State: APjAAAWl2bTSxaboA4JXEErPs+/iEEVKuRwppjRgzq/TX7nf5OXmFGhI
        BhNO7pPgupVewlxr1tDvb2bqWw==
X-Google-Smtp-Source: APXvYqxAWHPg+inTgcpU4MQ7jkeFfMfX9+WdKtur5QtrTsf7sFDfOJ6jJcCOJUg3c/bipQaA9TRIDw==
X-Received: by 2002:a5d:8b97:: with SMTP id p23mr26531638iol.83.1556563602967;
        Mon, 29 Apr 2019 11:46:42 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id f129sm181645itf.4.2019.04.29.11.46.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 29 Apr 2019 11:46:42 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH v7 net-next 2/6] exthdrs: Move generic EH functions to exthdrs_common.c
Date:   Mon, 29 Apr 2019 11:46:12 -0700
Message-Id: <1556563576-31157-3-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556563576-31157-1-git-send-email-tom@quantonium.net>
References: <1556563576-31157-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move generic functions in exthdrs.c to new exthdrs_common.c so that
exthdrs.c only contains functions that are specific to IPv6 processing,
and exthdrs_common.c contains functions that are generic. These
functions include those that will be used with IPv4 extension headers.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/Kconfig          |   4 ++
 net/ipv6/Makefile         |   1 +
 net/ipv6/exthdrs.c        | 138 --------------------------------------------
 net/ipv6/exthdrs_common.c | 144 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+), 138 deletions(-)
 create mode 100644 net/ipv6/exthdrs_common.c

diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index 613282c..c88fc9b 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -2,9 +2,13 @@
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
index 72bd775..22438ca 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_IPV6_SIT) += sit.o
 obj-$(CONFIG_IPV6_TUNNEL) += ip6_tunnel.o
 obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
 obj-$(CONFIG_IPV6_FOU) += fou6.o
+obj-$(CONFIG_EXTHDRS) += exthdrs_common.o
 
 obj-y += addrconf_core.o exthdrs_core.o ip6_checksum.o ip6_icmp.o
 obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 55ca778..6dbacf1 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -788,144 +788,6 @@ void ipv6_push_frag_opts(struct sk_buff *skb, struct ipv6_txoptions *opt, u8 *pr
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
index 0000000..179861c
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
+ipv6_dup_options(struct sock *sk, struct ipv6_txoptions *opt)
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
+EXPORT_SYMBOL_GPL(ipv6_dup_options);
+
+static void ipv6_renew_option(int renewtype,
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
+ * ipv6_renew_options - replace a specific ext hdr with a new one.
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
+ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
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
+	ipv6_renew_option(IPV6_HOPOPTS, &opt2->hopopt,
+			  (opt ? opt->hopopt : NULL),
+			  newopt, newtype, &p);
+	ipv6_renew_option(IPV6_RTHDRDSTOPTS, &opt2->dst0opt,
+			  (opt ? opt->dst0opt : NULL),
+			  newopt, newtype, &p);
+	ipv6_renew_option(IPV6_RTHDR,
+			  (struct ipv6_opt_hdr **)&opt2->srcrt,
+			  (opt ? (struct ipv6_opt_hdr *)opt->srcrt : NULL),
+			  newopt, newtype, &p);
+	ipv6_renew_option(IPV6_DSTOPTS, &opt2->dst1opt,
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
+EXPORT_SYMBOL(ipv6_renew_options);
+
+struct ipv6_txoptions *ipv6_fixup_options(struct ipv6_txoptions *opt_space,
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
+EXPORT_SYMBOL_GPL(ipv6_fixup_options);
-- 
2.7.4

