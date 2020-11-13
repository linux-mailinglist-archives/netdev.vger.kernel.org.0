Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D012B140D
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgKMB5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:57:10 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21381 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgKMB5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 20:57:10 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605232587; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=cE/zjhqIjOtsft6Go7fHfjm16fy9+nxi32iC0oewRU/iWkBASeaiyZcwKQDPutZYEG5+rc8P9j5mjbflBT6pI0cNkvH9HJjWMF2YWPqHmiji/5XfqrKHT2VXJ3nRNsA73IQdfoFvzwjQGbeTmuZjCfyOXhMH2F+y7e80finHR3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605232587; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=T5prT0BABI/QuQhPbsmcydX0m5wxxZiAdwXji4+37Rc=; 
        b=jUBuAP8xRo/cLYZQDXRxkvZbSkCzcjReLXc8+SaO5BUApJeEso/XhvaE87UZE90sP1hHUKgc6gFCQKnBpeQ107FK36mzG776xsr+rbNhU87FsV9zLtz5YEScQ5IrM8es4SvpaguILCkaiE9vjP5LuEhKHSNWuRGErGh55cpHbKA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605232587;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=T5prT0BABI/QuQhPbsmcydX0m5wxxZiAdwXji4+37Rc=;
        b=MFUcmFeivFozOFFIFnBfOBHFS8icZG89wy5ISPSwaQ8Lx3UtRqH+YxZpvXzb1e8+
        9dyUYt0Q8rFn9ubHrWyxnY/9XmzYsaxOwVQfZcZye/YqQKaGqLqV0Gjcj9vscoAumX+
        hVFMyBuF6QOuh+7R3vhEmKlVlVGIrFfKxNAGT+Tc=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605232580135412.02866135223985; Fri, 13 Nov 2020 02:56:20 +0100 (CET)
Date:   Fri, 13 Nov 2020 02:56:20 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "kuba" <kuba@kernel.org>, "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
In-Reply-To: <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net> <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
Subject: [PATCH net-next V4] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Variable SLAAC: SLAAC with prefixes of arbitrary length in PIO (randomly
generated hostID or stable privacy + privacy extensions).
The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
SLAAC is required so that downstream interfaces can be further subnetted.
Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, and
assigns /72 to VNF-Firewall, /72 to WIFI, /72 to VNF-Router, /72 to
Load-Balancer and /72 to wired connected devices.
IETF document that defines problem statement:
draft-mishra-v6ops-variable-slaac-problem-stmt
IETF document that specifies variable slaac:
draft-mishra-6man-variable-slaac

Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
---
diff -rupN net-next-5.10.0-rc2/include/net/if_inet6.h net-next-patch-5.10.0-rc2/include/net/if_inet6.h
--- net-next-5.10.0-rc2/include/net/if_inet6.h	2020-11-10 08:46:00.195180579 +0100
+++ net-next-patch-5.10.0-rc2/include/net/if_inet6.h	2020-11-11 18:11:05.627550135 +0100
@@ -22,6 +22,12 @@
 #define IF_RS_SENT	0x10
 #define IF_READY	0x80000000
 
+/* Variable SLAAC (Contact: Dmytro Shytyi)
+ * draft-mishra-6man-variable-slaac
+ * draft-mishra-v6ops-variable-slaac-problem-stmt
+ */
+#define IF_RA_VAR_PLEN	0x08
+
 /* prefix flags */
 #define IF_PREFIX_ONLINK	0x01
 #define IF_PREFIX_AUTOCONF	0x02
diff -rupN net-next-5.10.0-rc2/include/uapi/linux/icmpv6.h net-next-patch-5.10.0-rc2/include/uapi/linux/icmpv6.h
--- net-next-5.10.0-rc2/include/uapi/linux/icmpv6.h	2020-11-10 08:46:00.351849525 +0100
+++ net-next-patch-5.10.0-rc2/include/uapi/linux/icmpv6.h	2020-11-11 18:11:05.627550135 +0100
@@ -42,7 +42,9 @@ struct icmp6hdr {
                 struct icmpv6_nd_ra {
 			__u8		hop_limit;
 #if defined(__LITTLE_ENDIAN_BITFIELD)
-			__u8		reserved:3,
+			__u8		reserved:1,
+					slaac_var_plen:1,
+					proxy:1,
 					router_pref:2,
 					home_agent:1,
 					other:1,
@@ -53,7 +55,9 @@ struct icmp6hdr {
 					other:1,
 					home_agent:1,
 					router_pref:2,
-					reserved:3;
+					proxy:1,
+					slaac_var_plen:1,
+					reserved:1;
 #else
 #error	"Please fix <asm/byteorder.h>"
 #endif
@@ -78,9 +82,9 @@ struct icmp6hdr {
 #define icmp6_addrconf_other	icmp6_dataun.u_nd_ra.other
 #define icmp6_rt_lifetime	icmp6_dataun.u_nd_ra.rt_lifetime
 #define icmp6_router_pref	icmp6_dataun.u_nd_ra.router_pref
+#define icmp6_slaac_var_plen	icmp6_dataun.u_nd_ra.slaac_var_plen
 };
 
-
 #define ICMPV6_ROUTER_PREF_LOW		0x3
 #define ICMPV6_ROUTER_PREF_MEDIUM	0x0
 #define ICMPV6_ROUTER_PREF_HIGH		0x1
diff -rupN net-next-5.10.0-rc2/net/ipv6/addrconf.c net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c
--- net-next-5.10.0-rc2/net/ipv6/addrconf.c	2020-11-10 08:46:01.075193379 +0100
+++ net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c	2020-11-13 02:30:25.552724864 +0100
@@ -11,6 +11,8 @@
 /*
  *	Changes:
  *
+ *	Dmytro Shytyi			:	Variable SLAAC: SLAAC with
+ *	<dmytro@shytyi.net>			prefixes of arbitrary length.
  *	Janos Farkas			:	delete timer on ifdown
  *	<chexum@bankinf.banki.hu>
  *	Andi Kleen			:	kill double kfree on module
@@ -142,7 +144,12 @@ static int ipv6_count_addresses(const st
 static int ipv6_generate_stable_address(struct in6_addr *addr,
 					u8 dad_count,
 					const struct inet6_dev *idev);
-
+static int ipv6_generate_address_variable_plen(struct in6_addr *address,
+					       u8 dad_count,
+					       const struct inet6_dev *idev,
+					       unsigned int rcvd_prfx_len,
+					       bool stable_privacy_mode);
+static void ipv6_plen_to_mask(int plen, struct in6_addr *net_mask);
 #define IN6_ADDR_HSIZE_SHIFT	8
 #define IN6_ADDR_HSIZE		(1 << IN6_ADDR_HSIZE_SHIFT)
 /*
@@ -1315,10 +1322,14 @@ static int ipv6_create_tempaddr(struct i
 	struct ifa6_config cfg;
 	long max_desync_factor;
 	struct in6_addr addr;
-	int ret = 0;
+	int ret;
+	struct in6_addr net_mask;
+	struct in6_addr temp;
+	struct in6_addr ipv6addr;
+	int i;
 
 	write_lock_bh(&idev->lock);
-
+	ret = 0;
 retry:
 	in6_dev_hold(idev);
 	if (idev->cnf.use_tempaddr <= 0) {
@@ -1340,9 +1351,26 @@ retry:
 		goto out;
 	}
 	in6_ifa_hold(ifp);
-	memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
-	ipv6_gen_rnd_iid(&addr);
 
+	if (ifp->prefix_len == 64) {
+		memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
+		ipv6_gen_rnd_iid(&addr);
+	} else if (ifp->prefix_len > 0 && ifp->prefix_len <= 128) {
+		memcpy(addr.s6_addr32, ifp->addr.s6_addr, 16);
+		get_random_bytes(temp.s6_addr32, 16);
+
+		/* tranfrom prefix len into mask */
+		ipv6_plen_to_mask(ifp->prefix_len, &net_mask);
+
+		for (i = 0; i < 4; i++) {
+			/* network prefix */
+			ipv6addr.s6_addr32[i] = addr.s6_addr32[i] & net_mask.s6_addr32[i];
+			/* host id */
+			ipv6addr.s6_addr32[i] |= temp.s6_addr32[i] & ~net_mask.s6_addr32[i];
+		}
+
+		memcpy(addr.s6_addr, ipv6addr.s6_addr32, 16);
+	}
 	age = (now - ifp->tstamp) / HZ;
 
 	regen_advance = idev->cnf.regen_max_retry *
@@ -2576,9 +2604,57 @@ int addrconf_prefix_rcv_add_addr(struct
 				 u32 addr_flags, bool sllao, bool tokenized,
 				 __u32 valid_lft, u32 prefered_lft)
 {
-	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+	struct inet6_ifaddr *ifp = NULL;
 	int create = 0;
 
+	if ((in6_dev->if_flags & IF_RA_VAR_PLEN) == IF_RA_VAR_PLEN &&
+	    in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY) {
+		struct inet6_ifaddr *result = NULL;
+		struct inet6_ifaddr *result_base = NULL;
+		struct in6_addr net_mask;
+		struct in6_addr net_prfx;
+		struct in6_addr curr_net_prfx;
+		bool prfxs_equal;
+		int i;
+
+		result_base = result;
+		rcu_read_lock();
+		list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
+			if (!net_eq(dev_net(ifp->idev->dev), net))
+				continue;
+
+			/* tranfrom prefix len into mask */
+			ipv6_plen_to_mask(pinfo->prefix_len, &net_mask);
+			/* Prepare network prefixes */
+			for (i = 0; i < 4; i++) {
+				/* Received/new network prefix */
+				net_prfx.s6_addr32[i] =
+					pinfo->prefix.s6_addr32[i] & net_mask.s6_addr32[i];
+				/* Configured/old IPv6 prefix */
+				curr_net_prfx.s6_addr32[i] =
+					ifp->addr.s6_addr32[i] & net_mask.s6_addr32[i];
+			}
+			/* Compare network prefixes */
+			prfxs_equal = 1;
+			for (i = 0; i < 4; i++) {
+				if ((net_prfx.s6_addr32[i] ^ curr_net_prfx.s6_addr32[i]) != 0)
+					prfxs_equal = 0;
+			}
+			if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) {
+				result = ifp;
+				in6_ifa_hold(ifp);
+				break;
+			}
+		}
+		rcu_read_unlock();
+		if (result_base != result)
+			ifp = result;
+		else
+			ifp = NULL;
+	} else {
+		ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+	}
+
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
 		struct ifa6_config cfg = {
@@ -2781,9 +2857,35 @@ void addrconf_prefix_rcv(struct net_devi
 				dev_addr_generated = true;
 			}
 			goto ok;
+		goto put;
+		} else if (((in6_dev->if_flags & IF_RA_VAR_PLEN) == IF_RA_VAR_PLEN) &&
+			  pinfo->prefix_len > 0 && pinfo->prefix_len <= 128) {
+			/* SLAAC with prefixes of arbitrary length (Variable SLAAC).
+			 * draft-mishra-6man-variable-slaac
+			 * draft-mishra-v6ops-variable-slaac-problem-stmt
+			 * Contact: Dmytro Shytyi.
+			 */
+			memcpy(&addr, &pinfo->prefix, 16);
+			if (in6_dev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY) {
+				if (!ipv6_generate_address_variable_plen(&addr,
+									 0,
+									 in6_dev,
+									 pinfo->prefix_len,
+									 true)) {
+					addr_flags |= IFA_F_STABLE_PRIVACY;
+					goto ok;
+			}
+			} else if (!ipv6_generate_address_variable_plen(&addr,
+									0,
+									in6_dev,
+									pinfo->prefix_len,
+									false)) {
+				goto ok;
+			}
+		} else {
+			net_dbg_ratelimited("IPv6: Prefix with unexpected length %d\n",
+					    pinfo->prefix_len);
 		}
-		net_dbg_ratelimited("IPv6 addrconf: prefix with wrong length %d\n",
-				    pinfo->prefix_len);
 		goto put;
 
 ok:
@@ -3264,6 +3366,118 @@ retry:
 	return 0;
 }
 
+static void ipv6_plen_to_mask(int plen, struct in6_addr *net_mask)
+{
+	int i, plen_bytes;
+	char bit_array[7] = {0b10000000,
+			     0b11000000,
+			     0b11100000,
+			     0b11110000,
+			     0b11111000,
+			     0b11111100,
+			     0b11111110};
+
+	if (plen <= 0 || plen > 128)
+		pr_err("Unexpected plen: %d", plen);
+
+	memset(net_mask, 0x00, sizeof(*net_mask));
+
+	/* We set all bits == 1 of s6_addr[i] */
+	plen_bytes = plen / 8;
+	for (i = 0; i < plen_bytes; i++)
+		net_mask->s6_addr[i] = 0xff;
+
+	/* We add bits from the bit_array to
+	 * netmask starting from plen_bytes position
+	 */
+	if (plen % 8)
+		net_mask->s6_addr[plen_bytes] = bit_array[(plen % 8) - 1];
+	memcpy(net_mask->s6_addr32, net_mask->s6_addr, 16);
+}
+
+static int ipv6_generate_address_variable_plen(struct in6_addr *address,
+					       u8 dad_count,
+					       const struct inet6_dev *idev,
+					       unsigned int rcvd_prfx_len,
+					       bool stable_privacy_mode)
+{
+	static DEFINE_SPINLOCK(lock);
+	static __u32 digest[SHA1_DIGEST_WORDS];
+	static __u32 workspace[SHA1_WORKSPACE_WORDS];
+
+	static union {
+		char __data[SHA1_BLOCK_SIZE];
+		struct {
+			struct in6_addr secret;
+			__be32 prefix[2];
+			unsigned char hwaddr[MAX_ADDR_LEN];
+			u8 dad_count;
+		} __packed;
+	} data;
+
+	struct in6_addr ipv6_temp_addr;
+	struct in6_addr net_mask;
+	struct in6_addr secret;
+	struct in6_addr temp;
+	struct net *net = dev_net(idev->dev);
+	int i;
+
+	BUILD_BUG_ON(sizeof(data.__data) != sizeof(data));
+
+	if (stable_privacy_mode) {
+		if (idev->cnf.stable_secret.initialized)
+			secret = idev->cnf.stable_secret.secret;
+		else if (net->ipv6.devconf_dflt->stable_secret.initialized)
+			secret = net->ipv6.devconf_dflt->stable_secret.secret;
+		else
+			return -1;
+	}
+
+retry:
+	spin_lock_bh(&lock);
+	if (stable_privacy_mode) {
+		sha1_init(digest);
+		memset(&data, 0, sizeof(data));
+		memset(workspace, 0, sizeof(workspace));
+		memcpy(data.hwaddr, idev->dev->perm_addr, idev->dev->addr_len);
+		data.prefix[0] = address->s6_addr32[0];
+		data.prefix[1] = address->s6_addr32[1];
+		data.secret = secret;
+		data.dad_count = dad_count;
+
+		sha1_transform(digest, data.__data, workspace);
+
+		temp = *address;
+		temp.s6_addr32[0] = (__force __be32)digest[0];
+		temp.s6_addr32[1] = (__force __be32)digest[1];
+		temp.s6_addr32[2] = (__force __be32)digest[2];
+		temp.s6_addr32[3] = (__force __be32)digest[3];
+	} else {
+		temp = *address;
+		get_random_bytes(temp.s6_addr32, 16);
+	}
+	spin_unlock_bh(&lock);
+
+	if (ipv6_reserved_interfaceid(temp)) {
+		dad_count++;
+		if (dad_count > dev_net(idev->dev)->ipv6.sysctl.idgen_retries)
+			return -1;
+		goto retry;
+	}
+
+	/* convert plen to mask */
+	ipv6_plen_to_mask(rcvd_prfx_len, &net_mask);
+	for (i = 0; i < 4; i++) {
+		/* network prefix */
+		ipv6_temp_addr.s6_addr32[i] = address->s6_addr32[i] & net_mask.s6_addr32[i];
+		/* host id */
+		ipv6_temp_addr.s6_addr32[i] |= temp.s6_addr32[i] & ~net_mask.s6_addr32[i];
+	}
+
+	*address = ipv6_temp_addr;
+	return 0;
+}
+
 static void ipv6_gen_mode_random_init(struct inet6_dev *idev)
 {
 	struct ipv6_stable_secret *s = &idev->cnf.stable_secret;
diff -rupN net-next-5.10.0-rc2/net/ipv6/ndisc.c net-next-patch-5.10.0-rc2/net/ipv6/ndisc.c
--- net-next-5.10.0-rc2/net/ipv6/ndisc.c	2020-11-10 08:46:01.091860289 +0100
+++ net-next-patch-5.10.0-rc2/net/ipv6/ndisc.c	2020-11-11 18:11:05.630883513 +0100
@@ -1244,6 +1244,8 @@ static void ndisc_router_discovery(struc
 		in6_dev->if_flags |= IF_RA_RCVD;
 	}
 
+	in6_dev->if_flags |= ra_msg->icmph.icmp6_slaac_var_plen ?
+					IF_RA_VAR_PLEN : 0;
 	/*
 	 * Remember the managed/otherconf flags from most recently
 	 * received RA message (RFC 2462) -- yoshfuji
