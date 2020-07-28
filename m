Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94AC230FF7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgG1Qiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731572AbgG1Qit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:38:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B2DC0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 09:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=yXMcL+ra3vBBuVzVAgz4rYmEow+dYVzRxJVgNHWE/q4=; b=nrrE2ExLI4CbCS935VzxwwxC6v
        c67TEW6dBa3avC3633LkHmbwL+qBo8ilB1caBt4G2MfJgSVLdQBXDJmpxQjM1Ywwf1kJ4Gsthg2Xc
        LUN1kxFs+9j6NTkIrr4tS99iPl+5gGqMR1iW9L8EGn3N4CNXTOBRR99tW2jYqI5h0Dd/we1k3WNWc
        ENO06MdwEXyhgS6l8XlEulQ9bJEDMjF6IWFx1OHdHpy8MA7BiTOyBsGN7+p4ZXlYC70Bz9VNXiyIn
        l3xP893oTyyom6k3R262zlaQ+FYx3OjmhCtZMP3ghjRAHIxaOamFsaGCGP8RRy2kjpsF7MPqrBFVV
        fr6AzkYw==;
Received: from [2001:4bb8:180:6102:fd04:50d8:4827:5508] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0Sck-0007Wg-3W; Tue, 28 Jul 2020 16:38:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jan Engelhardt <jengelh@inai.de>, Ido Schimmel <idosch@idosch.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Laight <David.Laight@ACULAB.COM>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH 3/4] net: remove sockptr_advance
Date:   Tue, 28 Jul 2020 18:38:35 +0200
Message-Id: <20200728163836.562074-4-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200728163836.562074-1-hch@lst.de>
References: <20200728163836.562074-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sockptr_advance never properly worked.  Replace it with _offset variants
of copy_from_sockptr and copy_to_sockptr.

Fixes: ba423fdaa589 ("net: add a new sockptr_t type")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reported-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Tested-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/crypto/chelsio/chtls/chtls_main.c | 12 +++++-----
 include/linux/sockptr.h                   | 27 +++++++++++------------
 net/dccp/proto.c                          |  5 ++---
 net/ipv4/netfilter/arp_tables.c           |  8 +++----
 net/ipv4/netfilter/ip_tables.c            |  8 +++----
 net/ipv4/tcp.c                            |  5 +++--
 net/ipv6/ip6_flowlabel.c                  | 11 ++++-----
 net/ipv6/netfilter/ip6_tables.c           |  8 +++----
 net/netfilter/x_tables.c                  |  7 +++---
 net/tls/tls_main.c                        |  6 ++---
 10 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_main.c b/drivers/crypto/chelsio/chtls/chtls_main.c
index c3058dcdb33c5c..66d247efd5615b 100644
--- a/drivers/crypto/chelsio/chtls/chtls_main.c
+++ b/drivers/crypto/chelsio/chtls/chtls_main.c
@@ -525,9 +525,9 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 		/* Obtain version and type from previous copy */
 		crypto_info[0] = tmp_crypto_info;
 		/* Now copy the following data */
-		sockptr_advance(optval, sizeof(*crypto_info));
-		rc = copy_from_sockptr((char *)crypto_info + sizeof(*crypto_info),
-				optval,
+		rc = copy_from_sockptr_offset((char *)crypto_info +
+				sizeof(*crypto_info),
+				optval, sizeof(*crypto_info),
 				sizeof(struct tls12_crypto_info_aes_gcm_128)
 				- sizeof(*crypto_info));
 
@@ -542,9 +542,9 @@ static int do_chtls_setsockopt(struct sock *sk, int optname,
 	}
 	case TLS_CIPHER_AES_GCM_256: {
 		crypto_info[0] = tmp_crypto_info;
-		sockptr_advance(optval, sizeof(*crypto_info));
-		rc = copy_from_sockptr((char *)crypto_info + sizeof(*crypto_info),
-				    optval,
+		rc = copy_from_sockptr_offset((char *)crypto_info +
+				sizeof(*crypto_info),
+				optval, sizeof(*crypto_info),
 				sizeof(struct tls12_crypto_info_aes_gcm_256)
 				- sizeof(*crypto_info));
 
diff --git a/include/linux/sockptr.h b/include/linux/sockptr.h
index b13ea1422f93a5..9e6c81d474cba8 100644
--- a/include/linux/sockptr.h
+++ b/include/linux/sockptr.h
@@ -69,19 +69,26 @@ static inline bool sockptr_is_null(sockptr_t sockptr)
 	return !sockptr.user;
 }
 
-static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
+static inline int copy_from_sockptr_offset(void *dst, sockptr_t src,
+		size_t offset, size_t size)
 {
 	if (!sockptr_is_kernel(src))
-		return copy_from_user(dst, src.user, size);
-	memcpy(dst, src.kernel, size);
+		return copy_from_user(dst, src.user + offset, size);
+	memcpy(dst, src.kernel + offset, size);
 	return 0;
 }
 
-static inline int copy_to_sockptr(sockptr_t dst, const void *src, size_t size)
+static inline int copy_from_sockptr(void *dst, sockptr_t src, size_t size)
+{
+	return copy_from_sockptr_offset(dst, src, 0, size);
+}
+
+static inline int copy_to_sockptr_offset(sockptr_t dst, size_t offset,
+		const void *src, size_t size)
 {
 	if (!sockptr_is_kernel(dst))
-		return copy_to_user(dst.user, src, size);
-	memcpy(dst.kernel, src, size);
+		return copy_to_user(dst.user + offset, src, size);
+	memcpy(dst.kernel + offset, src, size);
 	return 0;
 }
 
@@ -112,14 +119,6 @@ static inline void *memdup_sockptr_nul(sockptr_t src, size_t len)
 	return p;
 }
 
-static inline void sockptr_advance(sockptr_t sockptr, size_t len)
-{
-	if (sockptr_is_kernel(sockptr))
-		sockptr.kernel += len;
-	else
-		sockptr.user += len;
-}
-
 static inline long strncpy_from_sockptr(char *dst, sockptr_t src, size_t count)
 {
 	if (sockptr_is_kernel(src)) {
diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 2e9e8449698fb4..d148ab1530e57b 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -426,9 +426,8 @@ static int dccp_setsockopt_service(struct sock *sk, const __be32 service,
 			return -ENOMEM;
 
 		sl->dccpsl_nr = optlen / sizeof(u32) - 1;
-		sockptr_advance(optval, sizeof(service));
-		if (copy_from_sockptr(sl->dccpsl_list, optval,
-				      optlen - sizeof(service)) ||
+		if (copy_from_sockptr_offset(sl->dccpsl_list, optval,
+				sizeof(service), optlen - sizeof(service)) ||
 		    dccp_list_has_service(sl, DCCP_SERVICE_INVALID_VALUE)) {
 			kfree(sl);
 			return -EFAULT;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 9a1567dbc022b6..d1e04d2b5170ec 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -971,8 +971,8 @@ static int do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
-	sockptr_advance(arg, sizeof(tmp));
-	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
+	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
+			tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
 	}
@@ -1267,8 +1267,8 @@ static int compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
-	sockptr_advance(arg, sizeof(tmp));
-	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
+	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
+			tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f2a9680303d8c0..f15bc21d730164 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1126,8 +1126,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
-	sockptr_advance(arg, sizeof(tmp));
-	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
+	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
+			tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
 	}
@@ -1508,8 +1508,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
-	sockptr_advance(arg, sizeof(tmp));
-	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
+	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
+			tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
 	}
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 27de9380ed140e..4afec552f211b9 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2801,12 +2801,13 @@ static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct tcp_repair_opt opt;
+	size_t offset = 0;
 
 	while (len >= sizeof(opt)) {
-		if (copy_from_sockptr(&opt, optbuf, sizeof(opt)))
+		if (copy_from_sockptr_offset(&opt, optbuf, offset, sizeof(opt)))
 			return -EFAULT;
 
-		sockptr_advance(optbuf, sizeof(opt));
+		offset += sizeof(opt);
 		len -= sizeof(opt);
 
 		switch (opt.opt_code) {
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 215b6f5e733ec9..2d655260dedc75 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -401,8 +401,8 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 		memset(fl->opt, 0, sizeof(*fl->opt));
 		fl->opt->tot_len = sizeof(*fl->opt) + olen;
 		err = -EFAULT;
-		sockptr_advance(optval, CMSG_ALIGN(sizeof(*freq)));
-		if (copy_from_sockptr(fl->opt + 1, optval, olen))
+		if (copy_from_sockptr_offset(fl->opt + 1, optval,
+				CMSG_ALIGN(sizeof(*freq)), olen))
 			goto done;
 
 		msg.msg_controllen = olen;
@@ -703,9 +703,10 @@ static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *freq,
 		goto recheck;
 
 	if (!freq->flr_label) {
-		sockptr_advance(optval,
-				offsetof(struct in6_flowlabel_req, flr_label));
-		if (copy_to_sockptr(optval, &fl->label, sizeof(fl->label))) {
+		size_t offset = offsetof(struct in6_flowlabel_req, flr_label);
+
+		if (copy_to_sockptr_offset(optval, offset, &fl->label,
+				sizeof(fl->label))) {
 			/* Intentionally ignore fault. */
 		}
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1d52957a413f4a..2e2119bfcf1373 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1143,8 +1143,8 @@ do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
-	sockptr_advance(arg, sizeof(tmp));
-	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
+	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
+			tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
 	}
@@ -1517,8 +1517,8 @@ compat_do_replace(struct net *net, sockptr_t arg, unsigned int len)
 		return -ENOMEM;
 
 	loc_cpu_entry = newinfo->entries;
-	sockptr_advance(arg, sizeof(tmp));
-	if (copy_from_sockptr(loc_cpu_entry, arg, tmp.size) != 0) {
+	if (copy_from_sockptr_offset(loc_cpu_entry, arg, sizeof(tmp),
+			tmp.size) != 0) {
 		ret = -EFAULT;
 		goto free_newinfo;
 	}
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b97eb4b538fd4e..91bf6635ea9ee4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1050,6 +1050,7 @@ EXPORT_SYMBOL_GPL(xt_check_target);
 void *xt_copy_counters(sockptr_t arg, unsigned int len,
 		       struct xt_counters_info *info)
 {
+	size_t offset;
 	void *mem;
 	u64 size;
 
@@ -1067,7 +1068,7 @@ void *xt_copy_counters(sockptr_t arg, unsigned int len,
 
 		memcpy(info->name, compat_tmp.name, sizeof(info->name) - 1);
 		info->num_counters = compat_tmp.num_counters;
-		sockptr_advance(arg, sizeof(compat_tmp));
+		offset = sizeof(compat_tmp);
 	} else
 #endif
 	{
@@ -1078,7 +1079,7 @@ void *xt_copy_counters(sockptr_t arg, unsigned int len,
 		if (copy_from_sockptr(info, arg, sizeof(*info)) != 0)
 			return ERR_PTR(-EFAULT);
 
-		sockptr_advance(arg, sizeof(*info));
+		offset = sizeof(*info);
 	}
 	info->name[sizeof(info->name) - 1] = '\0';
 
@@ -1092,7 +1093,7 @@ void *xt_copy_counters(sockptr_t arg, unsigned int len,
 	if (!mem)
 		return ERR_PTR(-ENOMEM);
 
-	if (copy_from_sockptr(mem, arg, len) == 0)
+	if (copy_from_sockptr_offset(mem, arg, offset, len) == 0)
 		return mem;
 
 	vfree(mem);
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index d77f7d821130db..bbc52b088d2968 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -522,9 +522,9 @@ static int do_tls_setsockopt_conf(struct sock *sk, sockptr_t optval,
 		goto err_crypto_info;
 	}
 
-	sockptr_advance(optval, sizeof(*crypto_info));
-	rc = copy_from_sockptr(crypto_info + 1, optval,
-			       optlen - sizeof(*crypto_info));
+	rc = copy_from_sockptr_offset(crypto_info + 1, optval,
+				      sizeof(*crypto_info),
+				      optlen - sizeof(*crypto_info));
 	if (rc) {
 		rc = -EFAULT;
 		goto err_crypto_info;
-- 
2.27.0

