Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1726718C56A
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 03:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCTCjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 22:39:33 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35575 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgCTCjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 22:39:32 -0400
Received: by mail-qk1-f193.google.com with SMTP id d8so5527731qka.2
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 19:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FOZXWzhWSTQ3R2hosTKfNYQJIi901j/gYEbBrXgNPjo=;
        b=M4Xulj/0RN6z9hxlDPu3vZmFuPWOBaXaGz18ys4DiR/BFft5kB65MEOzXwh8Fq9ZFl
         6Mouo3nWjZYxakPLmM62Tvjd9m5pOblc1oW5E8nWa++0HJtJQry7EXni1h73Uq6nJvKK
         Lg5NmPGP6mVbDAoXBMWl3E+AfbJyqC3nCMP/A1waqSPHXLOFzn/T/f8efW/OrL71qhbR
         GNy60vwdzWzoJxjfTeDx0RLOeS3eqOw970Sc5Dr5wY1cUpT1bKIv9GRCTiGAIfSI5FQP
         KIWLHdKUIGKsBFbyzUlmC2xTrX3qq+5+bi/1psnmukNi2BXbOy2h3chmNsG9vaTwIkrJ
         wzng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FOZXWzhWSTQ3R2hosTKfNYQJIi901j/gYEbBrXgNPjo=;
        b=jWw6znE0QxL4ruCh9X2HRF5OOxNveP25SFHu8fBRq27QP4R0uR60/0wd8jCligQgzb
         4yyWnsiaTYXyI+HI7+l9GQdbQTFnyrCAP7sQAWsvP/ENDma3sK21JDE2JkUQ7MC3nmcn
         +SjlkJ9TrEuUqRAYG/1698WK2ezey/+ogxnQ9J5M6VFe5bENJEmvxmyoysnLOGoVBL4t
         ZRHa4bcsy0nglbWvgJt+IETh3YeK7CTQxtOBi/35jJ3+9kQF2wKt9s0EG7slSHEOy63F
         VHQjsVxOxsVcgNTHAtnHhHBAiHcqqVgNKP/TziXrIIkHwqksp6hLj7EZeBfZ0wqLW54B
         5NEg==
X-Gm-Message-State: ANhLgQ1iNbAm2Lp6zc9PaOYCECBE5OCgeg+nPvharLR0y+JOUGA9Nph+
        0OsE8nhi8etaW4acwV7hff8=
X-Google-Smtp-Source: ADFU+vuJh+YI8etyYr3ai6DT2jDQqROneyrex2R43qJBoaFxmnQ4GQDu5MzzSj5Cr2dXkyMLGzxvow==
X-Received: by 2002:ae9:e014:: with SMTP id m20mr6157520qkk.434.1584671967142;
        Thu, 19 Mar 2020 19:39:27 -0700 (PDT)
Received: from localhost.localdomain (69-196-128-153.dsl.teksavvy.com. [69.196.128.153])
        by smtp.gmail.com with ESMTPSA id d9sm2979465qth.34.2020.03.19.19.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 19:39:26 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv2 net-next 5/5] net: ipv6: add rpl sr tunnel
Date:   Thu, 19 Mar 2020 22:39:01 -0400
Message-Id: <20200320023901.31129-6-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200320023901.31129-1-alex.aring@gmail.com>
References: <20200320023901.31129-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds functionality to configure routes for RPL source routing
functionality. There is no IPIP functionality yet implemented which can
be added later when the cases when to use IPv6 encapuslation comes more
clear.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 include/net/rpl.h                 |  12 +
 include/uapi/linux/lwtunnel.h     |   1 +
 include/uapi/linux/rpl_iptunnel.h |  21 ++
 net/core/lwtunnel.c               |   2 +
 net/ipv6/Kconfig                  |  10 +
 net/ipv6/Makefile                 |   1 +
 net/ipv6/af_inet6.c               |   7 +
 net/ipv6/rpl_iptunnel.c           | 380 ++++++++++++++++++++++++++++++
 8 files changed, 434 insertions(+)
 create mode 100644 include/uapi/linux/rpl_iptunnel.h
 create mode 100644 net/ipv6/rpl_iptunnel.c

diff --git a/include/net/rpl.h b/include/net/rpl.h
index 16739c10cea7..67b4266770e0 100644
--- a/include/net/rpl.h
+++ b/include/net/rpl.h
@@ -11,6 +11,18 @@
 
 #include <linux/rpl.h>
 
+#if IS_ENABLED(CONFIG_IPV6_RPL_LWTUNNEL)
+extern int rpl_init(void);
+extern void rpl_exit(void);
+#else
+static inline int rpl_init(void)
+{
+	return 0;
+}
+
+static inline void rpl_exit(void) {}
+#endif
+
 /* Worst decompression memory usage ipv6 address (16) + pad 7 */
 #define IPV6_RPL_SRH_WORST_SWAP_SIZE (sizeof(struct in6_addr) + 7)
 
diff --git a/include/uapi/linux/lwtunnel.h b/include/uapi/linux/lwtunnel.h
index f6035f737193..568a4303ccce 100644
--- a/include/uapi/linux/lwtunnel.h
+++ b/include/uapi/linux/lwtunnel.h
@@ -13,6 +13,7 @@ enum lwtunnel_encap_types {
 	LWTUNNEL_ENCAP_SEG6,
 	LWTUNNEL_ENCAP_BPF,
 	LWTUNNEL_ENCAP_SEG6_LOCAL,
+	LWTUNNEL_ENCAP_RPL,
 	__LWTUNNEL_ENCAP_MAX,
 };
 
diff --git a/include/uapi/linux/rpl_iptunnel.h b/include/uapi/linux/rpl_iptunnel.h
new file mode 100644
index 000000000000..f4eed1f92baa
--- /dev/null
+++ b/include/uapi/linux/rpl_iptunnel.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ *  IPv6 RPL-SR implementation
+ *
+ *  Author:
+ *  (C) 2020 Alexander Aring <alex.aring@gmail.com>
+ */
+
+#ifndef _UAPI_LINUX_RPL_IPTUNNEL_H
+#define _UAPI_LINUX_RPL_IPTUNNEL_H
+
+enum {
+	RPL_IPTUNNEL_UNSPEC,
+	RPL_IPTUNNEL_SRH,
+	__RPL_IPTUNNEL_MAX,
+};
+#define RPL_IPTUNNEL_MAX (__RPL_IPTUNNEL_MAX - 1)
+
+#define RPL_IPTUNNEL_SRH_SIZE(srh) (((srh)->hdrlen + 1) << 3)
+
+#endif
diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 4cd03955fa32..8ec7d13d2860 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -41,6 +41,8 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 		return "BPF";
 	case LWTUNNEL_ENCAP_SEG6_LOCAL:
 		return "SEG6LOCAL";
+	case LWTUNNEL_ENCAP_RPL:
+		return "RPL";
 	case LWTUNNEL_ENCAP_IP6:
 	case LWTUNNEL_ENCAP_IP:
 	case LWTUNNEL_ENCAP_NONE:
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index ae1344e4cec5..2ccaee98fddb 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -303,4 +303,14 @@ config IPV6_SEG6_BPF
 	depends on IPV6_SEG6_LWTUNNEL
 	depends on IPV6 = y
 
+config IPV6_RPL_LWTUNNEL
+	bool "IPv6: RPL Source Routing Header support"
+	depends on IPV6
+	select LWTUNNEL
+	---help---
+	  Support for RFC6554 RPL Source Routing Header using the lightweight
+	  tunnels mechanism.
+
+	  If unsure, say N.
+
 endif # IPV6
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 9d3e9bd2334f..cf7b47bdb9b3 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -26,6 +26,7 @@ ipv6-$(CONFIG_SYN_COOKIES) += syncookies.o
 ipv6-$(CONFIG_NETLABEL) += calipso.o
 ipv6-$(CONFIG_IPV6_SEG6_LWTUNNEL) += seg6_iptunnel.o seg6_local.o
 ipv6-$(CONFIG_IPV6_SEG6_HMAC) += seg6_hmac.o
+ipv6-$(CONFIG_IPV6_RPL_LWTUNNEL) += rpl_iptunnel.o
 
 ipv6-objs += $(ipv6-y)
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index d727c3b41495..345baa0a754f 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -59,6 +59,7 @@
 #endif
 #include <net/calipso.h>
 #include <net/seg6.h>
+#include <net/rpl.h>
 
 #include <linux/uaccess.h>
 #include <linux/mroute6.h>
@@ -1114,6 +1115,10 @@ static int __init inet6_init(void)
 	if (err)
 		goto seg6_fail;
 
+	err = rpl_init();
+	if (err)
+		goto rpl_fail;
+
 	err = igmp6_late_init();
 	if (err)
 		goto igmp6_late_err;
@@ -1136,6 +1141,8 @@ static int __init inet6_init(void)
 	igmp6_late_cleanup();
 #endif
 igmp6_late_err:
+	rpl_exit();
+rpl_fail:
 	seg6_exit();
 seg6_fail:
 	calipso_exit();
diff --git a/net/ipv6/rpl_iptunnel.c b/net/ipv6/rpl_iptunnel.c
new file mode 100644
index 000000000000..d4070890e79e
--- /dev/null
+++ b/net/ipv6/rpl_iptunnel.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/**
+ * Authors:
+ * (C) 2020 Alexander Aring <alex.aring@gmail.com>
+ */
+
+#include <linux/rpl_iptunnel.h>
+
+#include <net/dst_cache.h>
+#include <net/ip6_route.h>
+#include <net/lwtunnel.h>
+#include <net/ipv6.h>
+#include <net/rpl.h>
+
+struct rpl_iptunnel_encap {
+	struct ipv6_rpl_sr_hdr srh[0];
+};
+
+struct rpl_lwt {
+	struct dst_cache cache;
+	struct rpl_iptunnel_encap tuninfo;
+};
+
+static inline struct rpl_lwt *rpl_lwt_lwtunnel(struct lwtunnel_state *lwt)
+{
+	return (struct rpl_lwt *)lwt->data;
+}
+
+static inline struct rpl_iptunnel_encap *
+rpl_encap_lwtunnel(struct lwtunnel_state *lwt)
+{
+	return &rpl_lwt_lwtunnel(lwt)->tuninfo;
+}
+
+static const struct nla_policy rpl_iptunnel_policy[RPL_IPTUNNEL_MAX + 1] = {
+	[RPL_IPTUNNEL_SRH]	= { .type = NLA_BINARY },
+};
+
+static bool rpl_validate_srh(struct net *net, struct ipv6_rpl_sr_hdr *srh,
+			     size_t seglen)
+{
+	int err;
+
+	if ((srh->hdrlen << 3) != seglen)
+		return false;
+
+	/* check at least one segment and seglen fit with segments_left */
+	if (!srh->segments_left ||
+	    (srh->segments_left * sizeof(struct in6_addr)) != seglen)
+		return false;
+
+	if (srh->cmpri || srh->cmpre)
+		return false;
+
+	err = ipv6_chk_rpl_srh_loop(net, srh->rpl_segaddr,
+				    srh->segments_left);
+	if (err)
+		return false;
+
+	if (ipv6_addr_type(&srh->rpl_segaddr[srh->segments_left - 1]) &
+	    IPV6_ADDR_MULTICAST)
+		return false;
+
+	return true;
+}
+
+static int rpl_build_state(struct net *net, struct nlattr *nla,
+			   unsigned int family, const void *cfg,
+			   struct lwtunnel_state **ts,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RPL_IPTUNNEL_MAX + 1];
+	struct lwtunnel_state *newts;
+	struct ipv6_rpl_sr_hdr *srh;
+	struct rpl_lwt *rlwt;
+	int err, srh_len;
+
+	if (family != AF_INET6)
+		return -EINVAL;
+
+	err = nla_parse_nested_deprecated(tb, RPL_IPTUNNEL_MAX, nla,
+					  rpl_iptunnel_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[RPL_IPTUNNEL_SRH])
+		return -EINVAL;
+
+	srh = nla_data(tb[RPL_IPTUNNEL_SRH]);
+	srh_len = nla_len(tb[RPL_IPTUNNEL_SRH]);
+
+	if (srh_len < sizeof(*srh))
+		return -EINVAL;
+
+	/* verify that SRH is consistent */
+	if (!rpl_validate_srh(net, srh, srh_len - sizeof(*srh)))
+		return -EINVAL;
+
+	newts = lwtunnel_state_alloc(srh_len + sizeof(*rlwt));
+	if (!newts)
+		return -ENOMEM;
+
+	rlwt = rpl_lwt_lwtunnel(newts);
+
+	err = dst_cache_init(&rlwt->cache, GFP_ATOMIC);
+	if (err) {
+		kfree(newts);
+		return err;
+	}
+
+	memcpy(&rlwt->tuninfo.srh, srh, srh_len);
+
+	newts->type = LWTUNNEL_ENCAP_RPL;
+	newts->flags |= LWTUNNEL_STATE_INPUT_REDIRECT;
+	newts->flags |= LWTUNNEL_STATE_OUTPUT_REDIRECT;
+
+	*ts = newts;
+
+	return 0;
+}
+
+static void rpl_destroy_state(struct lwtunnel_state *lwt)
+{
+	dst_cache_destroy(&rpl_lwt_lwtunnel(lwt)->cache);
+}
+
+static int rpl_do_srh_inline(struct sk_buff *skb, const struct rpl_lwt *rlwt,
+			     const struct ipv6_rpl_sr_hdr *srh)
+{
+	struct ipv6_rpl_sr_hdr *isrh, *csrh;
+	const struct ipv6hdr *oldhdr;
+	struct ipv6hdr *hdr;
+	unsigned char *buf;
+	size_t hdrlen;
+	int err;
+
+	oldhdr = ipv6_hdr(skb);
+
+	buf = kzalloc(ipv6_rpl_srh_alloc_size(srh->segments_left - 1) * 2,
+		      GFP_ATOMIC);
+	if (!buf)
+		return -ENOMEM;
+
+	isrh = (struct ipv6_rpl_sr_hdr *)buf;
+	csrh = (struct ipv6_rpl_sr_hdr *)(buf + ((srh->hdrlen + 1) << 3));
+
+	memcpy(isrh, srh, sizeof(*isrh));
+	memcpy(isrh->rpl_segaddr, &srh->rpl_segaddr[1],
+	       (srh->segments_left - 1) * 16);
+	isrh->rpl_segaddr[srh->segments_left - 1] = oldhdr->daddr;
+
+	ipv6_rpl_srh_compress(csrh, isrh, &srh->rpl_segaddr[0],
+			      isrh->segments_left - 1);
+
+	hdrlen = ((csrh->hdrlen + 1) << 3);
+
+	err = skb_cow_head(skb, hdrlen + skb->mac_len);
+	if (unlikely(err))
+		return err;
+
+	skb_pull(skb, sizeof(struct ipv6hdr));
+	skb_postpull_rcsum(skb, skb_network_header(skb),
+			   sizeof(struct ipv6hdr));
+
+	skb_push(skb, sizeof(struct ipv6hdr) + hdrlen);
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+
+	hdr = ipv6_hdr(skb);
+	memmove(hdr, oldhdr, sizeof(*hdr));
+	isrh = (void *)hdr + sizeof(*hdr);
+	memcpy(isrh, csrh, hdrlen);
+
+	isrh->nexthdr = hdr->nexthdr;
+	hdr->nexthdr = NEXTHDR_ROUTING;
+	hdr->daddr = srh->rpl_segaddr[0];
+
+	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+
+	skb_postpush_rcsum(skb, hdr, sizeof(struct ipv6hdr) + hdrlen);
+
+	kfree(buf);
+
+	return 0;
+}
+
+static int rpl_do_srh(struct sk_buff *skb, const struct rpl_lwt *rlwt)
+{
+	struct dst_entry *dst = skb_dst(skb);
+	struct rpl_iptunnel_encap *tinfo;
+	int err = 0;
+
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return -EINVAL;
+
+	tinfo = rpl_encap_lwtunnel(dst->lwtstate);
+
+	err = rpl_do_srh_inline(skb, rlwt, tinfo->srh);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+static int rpl_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct dst_entry *dst = NULL;
+	struct rpl_lwt *rlwt;
+	int err = -EINVAL;
+
+	rlwt = rpl_lwt_lwtunnel(orig_dst->lwtstate);
+
+	err = rpl_do_srh(skb, rlwt);
+	if (unlikely(err))
+		goto drop;
+
+	preempt_disable();
+	dst = dst_cache_get(&rlwt->cache);
+	preempt_enable();
+
+	if (unlikely(!dst)) {
+		struct ipv6hdr *hdr = ipv6_hdr(skb);
+		struct flowi6 fl6;
+
+		memset(&fl6, 0, sizeof(fl6));
+		fl6.daddr = hdr->daddr;
+		fl6.saddr = hdr->saddr;
+		fl6.flowlabel = ip6_flowinfo(hdr);
+		fl6.flowi6_mark = skb->mark;
+		fl6.flowi6_proto = hdr->nexthdr;
+
+		dst = ip6_route_output(net, NULL, &fl6);
+		if (dst->error) {
+			err = dst->error;
+			dst_release(dst);
+			goto drop;
+		}
+
+		preempt_disable();
+		dst_cache_set_ip6(&rlwt->cache, dst, &fl6.saddr);
+		preempt_enable();
+	}
+
+	skb_dst_drop(skb);
+	skb_dst_set(skb, dst);
+
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
+	if (unlikely(err))
+		goto drop;
+
+	return dst_output(net, sk, skb);
+
+drop:
+	kfree_skb(skb);
+	return err;
+}
+
+static int rpl_input(struct sk_buff *skb)
+{
+	struct dst_entry *orig_dst = skb_dst(skb);
+	struct dst_entry *dst = NULL;
+	struct rpl_lwt *rlwt;
+	int err;
+
+	rlwt = rpl_lwt_lwtunnel(orig_dst->lwtstate);
+
+	err = rpl_do_srh(skb, rlwt);
+	if (unlikely(err)) {
+		kfree_skb(skb);
+		return err;
+	}
+
+	preempt_disable();
+	dst = dst_cache_get(&rlwt->cache);
+	preempt_enable();
+
+	skb_dst_drop(skb);
+
+	if (!dst) {
+		ip6_route_input(skb);
+		dst = skb_dst(skb);
+		if (!dst->error) {
+			preempt_disable();
+			dst_cache_set_ip6(&rlwt->cache, dst,
+					  &ipv6_hdr(skb)->saddr);
+			preempt_enable();
+		}
+	} else {
+		skb_dst_set(skb, dst);
+	}
+
+	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
+	if (unlikely(err))
+		return err;
+
+	return dst_input(skb);
+}
+
+static int nla_put_rpl_srh(struct sk_buff *skb, int attrtype,
+			   struct rpl_iptunnel_encap *tuninfo)
+{
+	struct rpl_iptunnel_encap *data;
+	struct nlattr *nla;
+	int len;
+
+	len = RPL_IPTUNNEL_SRH_SIZE(tuninfo->srh);
+
+	nla = nla_reserve(skb, attrtype, len);
+	if (!nla)
+		return -EMSGSIZE;
+
+	data = nla_data(nla);
+	memcpy(data, tuninfo->srh, len);
+
+	return 0;
+}
+
+static int rpl_fill_encap_info(struct sk_buff *skb,
+			       struct lwtunnel_state *lwtstate)
+{
+	struct rpl_iptunnel_encap *tuninfo = rpl_encap_lwtunnel(lwtstate);
+
+	if (nla_put_rpl_srh(skb, RPL_IPTUNNEL_SRH, tuninfo))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int rpl_encap_nlsize(struct lwtunnel_state *lwtstate)
+{
+	struct rpl_iptunnel_encap *tuninfo = rpl_encap_lwtunnel(lwtstate);
+
+	return nla_total_size(RPL_IPTUNNEL_SRH_SIZE(tuninfo->srh));
+}
+
+static int rpl_encap_cmp(struct lwtunnel_state *a, struct lwtunnel_state *b)
+{
+	struct rpl_iptunnel_encap *a_hdr = rpl_encap_lwtunnel(a);
+	struct rpl_iptunnel_encap *b_hdr = rpl_encap_lwtunnel(b);
+	int len = RPL_IPTUNNEL_SRH_SIZE(a_hdr->srh);
+
+	if (len != RPL_IPTUNNEL_SRH_SIZE(b_hdr->srh))
+		return 1;
+
+	return memcmp(a_hdr, b_hdr, len);
+}
+
+static const struct lwtunnel_encap_ops rpl_ops = {
+	.build_state	= rpl_build_state,
+	.destroy_state	= rpl_destroy_state,
+	.output		= rpl_output,
+	.input		= rpl_input,
+	.fill_encap	= rpl_fill_encap_info,
+	.get_encap_size	= rpl_encap_nlsize,
+	.cmp_encap	= rpl_encap_cmp,
+	.owner		= THIS_MODULE,
+};
+
+int __init rpl_init(void)
+{
+	int err;
+
+	err = lwtunnel_encap_add_ops(&rpl_ops, LWTUNNEL_ENCAP_RPL);
+	if (err)
+		goto out;
+
+	pr_info("RPL Segment Routing with IPv6\n");
+
+	return 0;
+
+out:
+	return err;
+}
+
+void rpl_exit(void)
+{
+	lwtunnel_encap_del_ops(&rpl_ops, LWTUNNEL_ENCAP_RPL);
+}
-- 
2.20.1

