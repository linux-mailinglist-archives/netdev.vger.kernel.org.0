Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0F631960CA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgC0WAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:00:51 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:35896 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727705AbgC0WAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:00:49 -0400
Received: by mail-qv1-f68.google.com with SMTP id z13so5738654qvw.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fCg/RdysBS5w+ur9baZV6J5MuHsrRSRrCABTiaijh24=;
        b=N8cagdzEXRl7kYrjA/X7ZBAEmYh7Dscge8lwYvIANsvsMyP7E/OGS/E2YnjtF0HWn6
         thZKZgOWmJ0W0c5+X9UNLpuISNlx5OB1NPRs2oyaVIGNCmoqI2CXKZ6rwAIa+ATgkKMQ
         TfCVuXoab/gzjvQlEJD+ib0IMdo3x6pE0/ejhuXZGbyYHdKjBv/GaOpkKPXYmtgdKfq3
         8h3ftQEZv5GECXFXJDVxnb+BaDTxp4+N89uaLHSRStIP/JdzloPq1xErkF2k4qKm4LR7
         PruJ7jrG07UMChk/76auoBA/iM1ikDql0+qGa2XpTkfOXJzdt97m59Jkknj2bXDatuo5
         bQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fCg/RdysBS5w+ur9baZV6J5MuHsrRSRrCABTiaijh24=;
        b=fH/hadhxjckDirrJngOcsevWT+RxhW8HoA+Tnl0D0tuJlb8TDG81TTIQZ4sdR+1wzC
         KgyvQTYR5Cc8OvWyzJUHJmKEqXuAsZmjisK4FSSenFPrQI+Fd6lxbjDC5qGFTJ0wdlKB
         RqEPKD/AHeWz9xG55HcJDj7nRSrG4XIvCDCDIiJp3of91acuGsLo/RCYXBM3LhcfkTud
         aIUgM5nNF99In2v+ntu017hg1COWb+veOQvYMJYLdLFVJgkvIYYngj4Y3aN5VWCGTh1m
         FN3p50kM2aUtgfGFT8SBz/nH8GuD87IUW7DMis/uAV8OfHwZ/oHIeHGBUfGOCw/OWP49
         z5ng==
X-Gm-Message-State: ANhLgQ2qBuLWvgqWWSzTIpZJk+OXyAEI5ZxGbrozUIZnPfOg3M1EXKy+
        ITm/wjN92z4jMj73ZNsJu6o=
X-Google-Smtp-Source: ADFU+vtrdUBbCrwYmi1KJbFaDpjb+otsO0xN4Av4A6VbsSzzK+Z+jJxDFdoZ8wCo9Ml7GCN9JcJhZQ==
X-Received: by 2002:a05:6214:1412:: with SMTP id n18mr1421008qvx.219.1585346448410;
        Fri, 27 Mar 2020 15:00:48 -0700 (PDT)
Received: from localhost.localdomain ([45.72.142.47])
        by smtp.gmail.com with ESMTPSA id v20sm5073659qth.10.2020.03.27.15.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:00:48 -0700 (PDT)
From:   Alexander Aring <alex.aring@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        dav.lebrun@gmail.com, mcr@sandelman.ca, stefan@datenfreihafen.org,
        kai.beckmann@hs-rm.de, martin.gergeleit@hs-rm.de,
        robert.kaiser@hs-rm.de, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>
Subject: [PATCHv3 net-next 3/5] net: ipv6: add support for rpl sr exthdr
Date:   Fri, 27 Mar 2020 18:00:20 -0400
Message-Id: <20200327220022.15220-4-alex.aring@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200327220022.15220-1-alex.aring@gmail.com>
References: <20200327220022.15220-1-alex.aring@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds rpl source routing receive handling. Everything works
only if sysconf "rpl_seg_enabled" and source routing is enabled. Mostly
the same behaviour as IPv6 segmentation routing. To handle compression
and uncompression a rpl.c file is created which contains the necessary
functionality. The receive handling will also care about IPv6
encapsulated so far it's specified as possible nexthdr in RFC 6554.

Signed-off-by: Alexander Aring <alex.aring@gmail.com>
---
 include/linux/ipv6.h      |   1 +
 include/net/rpl.h         |  34 +++++++
 include/uapi/linux/ipv6.h |   2 +
 net/ipv6/Makefile         |   2 +-
 net/ipv6/addrconf.c       |  10 ++
 net/ipv6/exthdrs.c        | 201 +++++++++++++++++++++++++++++++++++++-
 net/ipv6/rpl.c            | 123 +++++++++++++++++++++++
 7 files changed, 370 insertions(+), 3 deletions(-)
 create mode 100644 include/net/rpl.h
 create mode 100644 net/ipv6/rpl.c

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index ea7c7906591e..2cb445a8fc9e 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -74,6 +74,7 @@ struct ipv6_devconf {
 	__u32		addr_gen_mode;
 	__s32		disable_policy;
 	__s32           ndisc_tclass;
+	__s32		rpl_seg_enabled;
 
 	struct ctl_table_header *sysctl_header;
 };
diff --git a/include/net/rpl.h b/include/net/rpl.h
new file mode 100644
index 000000000000..d694d49a61db
--- /dev/null
+++ b/include/net/rpl.h
@@ -0,0 +1,34 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  RPL implementation
+ *
+ *  Author:
+ *  (C) 2020 Alexander Aring <alex.aring@gmail.com>
+ */
+
+#ifndef _NET_RPL_H
+#define _NET_RPL_H
+
+#include <linux/rpl.h>
+
+/* Worst decompression memory usage ipv6 address (16) + pad 7 */
+#define IPV6_RPL_SRH_WORST_SWAP_SIZE (sizeof(struct in6_addr) + 7)
+
+static inline size_t ipv6_rpl_srh_alloc_size(unsigned char n)
+{
+	return sizeof(struct ipv6_rpl_sr_hdr) +
+		((n + 1) * sizeof(struct in6_addr));
+}
+
+size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
+			 unsigned char cmpre);
+
+void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
+			     const struct ipv6_rpl_sr_hdr *inhdr,
+			     const struct in6_addr *daddr, unsigned char n);
+
+void ipv6_rpl_srh_compress(struct ipv6_rpl_sr_hdr *outhdr,
+			   const struct ipv6_rpl_sr_hdr *inhdr,
+			   const struct in6_addr *daddr, unsigned char n);
+
+#endif /* _NET_RPL_H */
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index 9c0f4a92bcff..13e8751bf24a 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -40,6 +40,7 @@ struct in6_ifreq {
 #define IPV6_SRCRT_STRICT	0x01	/* Deprecated; will be removed */
 #define IPV6_SRCRT_TYPE_0	0	/* Deprecated; will be removed */
 #define IPV6_SRCRT_TYPE_2	2	/* IPv6 type 2 Routing Header	*/
+#define IPV6_SRCRT_TYPE_3	3	/* RPL Segment Routing with IPv6 */
 #define IPV6_SRCRT_TYPE_4	4	/* Segment Routing with IPv6 */
 
 /*
@@ -187,6 +188,7 @@ enum {
 	DEVCONF_DISABLE_POLICY,
 	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
 	DEVCONF_NDISC_TCLASS,
+	DEVCONF_RPL_SEG_ENABLED,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 8ccf35514015..9d3e9bd2334f 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -10,7 +10,7 @@ ipv6-objs :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udplite.o \
 		raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
-		udp_offload.o seg6.o fib6_notifier.o
+		udp_offload.o seg6.o fib6_notifier.o rpl.o
 
 ipv6-offload :=	ip6_offload.o tcpv6_offload.o exthdrs_offload.o
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 594963a7e1ec..a11fd4d67832 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -236,6 +236,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
 	.enhanced_dad           = 1,
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
+	.rpl_seg_enabled	= 0,
 };
 
 static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
@@ -290,6 +291,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
 	.enhanced_dad           = 1,
 	.addr_gen_mode		= IN6_ADDR_GEN_MODE_EUI64,
 	.disable_policy		= 0,
+	.rpl_seg_enabled	= 0,
 };
 
 /* Check if link is ready: is it up and is a valid qdisc available */
@@ -5520,6 +5522,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_ADDR_GEN_MODE] = cnf->addr_gen_mode;
 	array[DEVCONF_DISABLE_POLICY] = cnf->disable_policy;
 	array[DEVCONF_NDISC_TCLASS] = cnf->ndisc_tclass;
+	array[DEVCONF_RPL_SEG_ENABLED] = cnf->rpl_seg_enabled;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -6900,6 +6903,13 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.extra1		= (void *)SYSCTL_ZERO,
 		.extra2		= (void *)&two_five_five,
 	},
+	{
+		.procname	= "rpl_seg_enabled",
+		.data		= &ipv6_devconf.rpl_seg_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index bcb9f5e62808..5a8bbcdcaf2b 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -48,6 +48,7 @@
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
 #endif
+#include <net/rpl.h>
 
 #include <linux/uaccess.h>
 
@@ -468,6 +469,195 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 	return -1;
 }
 
+static int ipv6_rpl_srh_rcv(struct sk_buff *skb)
+{
+	struct ipv6_rpl_sr_hdr *hdr, *ohdr, *chdr;
+	struct inet6_skb_parm *opt = IP6CB(skb);
+	struct net *net = dev_net(skb->dev);
+	struct inet6_dev *idev;
+	struct ipv6hdr *oldhdr;
+	struct in6_addr addr;
+	unsigned char *buf;
+	int accept_rpl_seg;
+	int i, err;
+	u64 n = 0;
+	u32 r;
+
+	idev = __in6_dev_get(skb->dev);
+
+	accept_rpl_seg = net->ipv6.devconf_all->rpl_seg_enabled;
+	if (accept_rpl_seg > idev->cnf.rpl_seg_enabled)
+		accept_rpl_seg = idev->cnf.rpl_seg_enabled;
+
+	if (!accept_rpl_seg) {
+		kfree_skb(skb);
+		return -1;
+	}
+
+looped_back:
+	hdr = (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
+
+	if (hdr->segments_left == 0) {
+		if (hdr->nexthdr == NEXTHDR_IPV6) {
+			int offset = (hdr->hdrlen + 1) << 3;
+
+			skb_postpull_rcsum(skb, skb_network_header(skb),
+					   skb_network_header_len(skb));
+
+			if (!pskb_pull(skb, offset)) {
+				kfree_skb(skb);
+				return -1;
+			}
+			skb_postpull_rcsum(skb, skb_transport_header(skb),
+					   offset);
+
+			skb_reset_network_header(skb);
+			skb_reset_transport_header(skb);
+			skb->encapsulation = 0;
+
+			__skb_tunnel_rx(skb, skb->dev, net);
+
+			netif_rx(skb);
+			return -1;
+		}
+
+		opt->srcrt = skb_network_header_len(skb);
+		opt->lastopt = opt->srcrt;
+		skb->transport_header += (hdr->hdrlen + 1) << 3;
+		opt->nhoff = (&hdr->nexthdr) - skb_network_header(skb);
+
+		return 1;
+	}
+
+	if (!pskb_may_pull(skb, sizeof(*hdr))) {
+		kfree_skb(skb);
+		return -1;
+	}
+
+	n = (hdr->hdrlen << 3) - hdr->pad - (16 - hdr->cmpre);
+	r = do_div(n, (16 - hdr->cmpri));
+	/* checks if calculation was without remainder and n fits into
+	 * unsigned char which is segments_left field. Should not be
+	 * higher than that.
+	 */
+	if (r || (n + 1) > 255) {
+		kfree_skb(skb);
+		return -1;
+	}
+
+	if (hdr->segments_left > n + 1) {
+		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD,
+				  ((&hdr->segments_left) -
+				   skb_network_header(skb)));
+		return -1;
+	}
+
+	if (skb_cloned(skb)) {
+		if (pskb_expand_head(skb, IPV6_RPL_SRH_WORST_SWAP_SIZE, 0,
+				     GFP_ATOMIC)) {
+			__IP6_INC_STATS(net, ip6_dst_idev(skb_dst(skb)),
+					IPSTATS_MIB_OUTDISCARDS);
+			kfree_skb(skb);
+			return -1;
+		}
+	} else {
+		err = skb_cow_head(skb, IPV6_RPL_SRH_WORST_SWAP_SIZE);
+		if (unlikely(err)) {
+			kfree_skb(skb);
+			return -1;
+		}
+	}
+
+	hdr = (struct ipv6_rpl_sr_hdr *)skb_transport_header(skb);
+
+	if (!pskb_may_pull(skb, ipv6_rpl_srh_size(n, hdr->cmpri,
+						  hdr->cmpre))) {
+		kfree_skb(skb);
+		return -1;
+	}
+
+	hdr->segments_left--;
+	i = n - hdr->segments_left;
+
+	buf = kzalloc(ipv6_rpl_srh_alloc_size(n + 1) * 2, GFP_ATOMIC);
+	if (unlikely(!buf)) {
+		kfree_skb(skb);
+		return -1;
+	}
+
+	ohdr = (struct ipv6_rpl_sr_hdr *)buf;
+	ipv6_rpl_srh_decompress(ohdr, hdr, &ipv6_hdr(skb)->daddr, n);
+	chdr = (struct ipv6_rpl_sr_hdr *)(buf + ((ohdr->hdrlen + 1) << 3));
+
+	if ((ipv6_addr_type(&ipv6_hdr(skb)->daddr) & IPV6_ADDR_MULTICAST) ||
+	    (ipv6_addr_type(&ohdr->rpl_segaddr[i]) & IPV6_ADDR_MULTICAST)) {
+		kfree_skb(skb);
+		kfree(buf);
+		return -1;
+	}
+
+	err = ipv6_chk_rpl_srh_loop(net, ohdr->rpl_segaddr, n + 1);
+	if (err) {
+		icmpv6_send(skb, ICMPV6_PARAMPROB, 0, 0);
+		kfree_skb(skb);
+		kfree(buf);
+		return -1;
+	}
+
+	addr = ipv6_hdr(skb)->daddr;
+	ipv6_hdr(skb)->daddr = ohdr->rpl_segaddr[i];
+	ohdr->rpl_segaddr[i] = addr;
+
+	ipv6_rpl_srh_compress(chdr, ohdr, &ipv6_hdr(skb)->daddr, n);
+
+	oldhdr = ipv6_hdr(skb);
+
+	skb_pull(skb, ((hdr->hdrlen + 1) << 3));
+	skb_postpull_rcsum(skb, oldhdr,
+			   sizeof(struct ipv6hdr) + ((hdr->hdrlen + 1) << 3));
+	skb_push(skb, ((chdr->hdrlen + 1) << 3) + sizeof(struct ipv6hdr));
+	skb_reset_network_header(skb);
+	skb_mac_header_rebuild(skb);
+	skb_set_transport_header(skb, sizeof(struct ipv6hdr));
+
+	memmove(ipv6_hdr(skb), oldhdr, sizeof(struct ipv6hdr));
+	memcpy(skb_transport_header(skb), chdr, (chdr->hdrlen + 1) << 3);
+
+	ipv6_hdr(skb)->payload_len = htons(skb->len - sizeof(struct ipv6hdr));
+	skb_postpush_rcsum(skb, ipv6_hdr(skb),
+			   sizeof(struct ipv6hdr) + ((chdr->hdrlen + 1) << 3));
+
+	kfree(buf);
+
+	skb_dst_drop(skb);
+
+	ip6_route_input(skb);
+
+	if (skb_dst(skb)->error) {
+		dst_input(skb);
+		return -1;
+	}
+
+	if (skb_dst(skb)->dev->flags & IFF_LOOPBACK) {
+		if (ipv6_hdr(skb)->hop_limit <= 1) {
+			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+			icmpv6_send(skb, ICMPV6_TIME_EXCEED,
+				    ICMPV6_EXC_HOPLIMIT, 0);
+			kfree_skb(skb);
+			return -1;
+		}
+		ipv6_hdr(skb)->hop_limit--;
+
+		skb_pull(skb, sizeof(struct ipv6hdr));
+		goto looped_back;
+	}
+
+	dst_input(skb);
+
+	return -1;
+}
+
 /********************************
   Routing header.
  ********************************/
@@ -506,9 +696,16 @@ static int ipv6_rthdr_rcv(struct sk_buff *skb)
 		return -1;
 	}
 
-	/* segment routing */
-	if (hdr->type == IPV6_SRCRT_TYPE_4)
+	switch (hdr->type) {
+	case IPV6_SRCRT_TYPE_4:
+		/* segment routing */
 		return ipv6_srh_rcv(skb);
+	case IPV6_SRCRT_TYPE_3:
+		/* rpl segment routing */
+		return ipv6_rpl_srh_rcv(skb);
+	default:
+		break;
+	}
 
 looped_back:
 	if (hdr->segments_left == 0) {
diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
new file mode 100644
index 000000000000..dc4f20e23bf7
--- /dev/null
+++ b/net/ipv6/rpl.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/**
+ * Authors:
+ * (C) 2020 Alexander Aring <alex.aring@gmail.com>
+ */
+
+#include <net/ipv6.h>
+#include <net/rpl.h>
+
+#define IPV6_PFXTAIL_LEN(x) (sizeof(struct in6_addr) - (x))
+
+static void ipv6_rpl_addr_decompress(struct in6_addr *dst,
+				     const struct in6_addr *daddr,
+				     const void *post, unsigned char pfx)
+{
+	memcpy(dst, daddr, pfx);
+	memcpy(&dst->s6_addr[pfx], post, IPV6_PFXTAIL_LEN(pfx));
+}
+
+static void ipv6_rpl_addr_compress(void *dst, const struct in6_addr *addr,
+				   unsigned char pfx)
+{
+	memcpy(dst, &addr->s6_addr[pfx], IPV6_PFXTAIL_LEN(pfx));
+}
+
+static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
+{
+	return (void *)&hdr->rpl_segdata[i * IPV6_PFXTAIL_LEN(hdr->cmpri)];
+}
+
+size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
+			 unsigned char cmpre)
+{
+	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+}
+
+void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
+			     const struct ipv6_rpl_sr_hdr *inhdr,
+			     const struct in6_addr *daddr, unsigned char n)
+{
+	int i;
+
+	outhdr->nexthdr = inhdr->nexthdr;
+	outhdr->hdrlen = (((n + 1) * sizeof(struct in6_addr)) >> 3);
+	outhdr->pad = 0;
+	outhdr->type = inhdr->type;
+	outhdr->segments_left = inhdr->segments_left;
+	outhdr->cmpri = 0;
+	outhdr->cmpre = 0;
+
+	for (i = 0; i <= n; i++)
+		ipv6_rpl_addr_decompress(&outhdr->rpl_segaddr[i], daddr,
+					 ipv6_rpl_segdata_pos(inhdr, i),
+					 inhdr->cmpri);
+
+	ipv6_rpl_addr_decompress(&outhdr->rpl_segaddr[n], daddr,
+				 ipv6_rpl_segdata_pos(inhdr, n),
+				 inhdr->cmpre);
+}
+
+static unsigned char ipv6_rpl_srh_calc_cmpri(const struct ipv6_rpl_sr_hdr *inhdr,
+					     const struct in6_addr *daddr,
+					     unsigned char n)
+{
+	unsigned char plen;
+	int i;
+
+	for (plen = 0; plen < sizeof(*daddr); plen++) {
+		for (i = 0; i <= n; i++) {
+			if (daddr->s6_addr[plen] !=
+			    inhdr->rpl_segaddr[i].s6_addr[plen])
+				return plen;
+		}
+	}
+
+	return plen;
+}
+
+static unsigned char ipv6_rpl_srh_calc_cmpre(const struct in6_addr *daddr,
+					     const struct in6_addr *last_segment)
+{
+	unsigned int plen;
+
+	for (plen = 0; plen < sizeof(*daddr); plen++) {
+		if (daddr->s6_addr[plen] != last_segment->s6_addr[plen])
+			break;
+	}
+
+	return plen;
+}
+
+void ipv6_rpl_srh_compress(struct ipv6_rpl_sr_hdr *outhdr,
+			   const struct ipv6_rpl_sr_hdr *inhdr,
+			   const struct in6_addr *daddr, unsigned char n)
+{
+	unsigned char cmpri, cmpre;
+	size_t seglen;
+	int i;
+
+	cmpri = ipv6_rpl_srh_calc_cmpri(inhdr, daddr, n);
+	cmpre = ipv6_rpl_srh_calc_cmpre(daddr, &inhdr->rpl_segaddr[n]);
+
+	outhdr->nexthdr = inhdr->nexthdr;
+	seglen = (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+	outhdr->hdrlen = seglen >> 3;
+	if (seglen & 0x7) {
+		outhdr->hdrlen++;
+		outhdr->pad = 8 - (seglen & 0x7);
+	} else {
+		outhdr->pad = 0;
+	}
+	outhdr->type = inhdr->type;
+	outhdr->segments_left = inhdr->segments_left;
+	outhdr->cmpri = cmpri;
+	outhdr->cmpre = cmpre;
+
+	for (i = 0; i <= n; i++)
+		ipv6_rpl_addr_compress(ipv6_rpl_segdata_pos(outhdr, i),
+				       &inhdr->rpl_segaddr[i], cmpri);
+
+	ipv6_rpl_addr_compress(ipv6_rpl_segdata_pos(outhdr, n),
+			       &inhdr->rpl_segaddr[n], cmpre);
+}
-- 
2.20.1

