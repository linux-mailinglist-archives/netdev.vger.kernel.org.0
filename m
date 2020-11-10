Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F59E2ADD4A
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730894AbgKJRqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:46:22 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21367 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729183AbgKJRqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:46:22 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605030334; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=KgCcrHJFffdIrq95qoxxMIfqwnapRjlQSO+k1qQVu39O+zn1aE+irbpDG8TgvUhGmMuYTk0O5NiWXSk4/3I0ZXYnHAGmZWAtUlU5k7M7rM7hCt/LGyhBcSKz9i7e5Ow4sD0N8P/DvA9YQWvst7HxQ8pWiXFBobs9/X9fgCbhKYQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605030334; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=SgkCXERQ4OHMND1UX17F8adqAfB9Ze0VA10WlJUJ1Cg=; 
        b=hzz8poUNOj4RDiVc1CcbcM2FcjYA57o3jaCT2OCeeELZ0kkADbv3wg04oR1nmkyRjPI6LewFUS0Xf8cpaZlG0bfmwduC13D/hU7HQMFneBl9ZaIBxlp7D0Vn/XAphQGa2nY6RUbMqNmBkqPPkK92TwooTMtsucJYDnEeDS7wb+I=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605030334;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=SgkCXERQ4OHMND1UX17F8adqAfB9Ze0VA10WlJUJ1Cg=;
        b=cBazENHfHzTgF/g7U0kdrX1Wu/ExOYslisY8PcwwyA0d3MGKekAqJ+vX92HHgo8U
        yaFRO3KdZ7aDiodeYEMff0GBRbJC3xRLkDYyzsKPhCHRcPlamKm+fEGKtpN7STwJbb3
        b1kzXBMkJpf/HcK+zjhcOHcJzbgqBCoaOHENlIpI=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605030328911921.8939858496824; Tue, 10 Nov 2020 18:45:28 +0100 (CET)
Date:   Tue, 10 Nov 2020 18:45:28 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "kuba" <kuba@kernel.org>, "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
In-Reply-To: <175b25d0c79.f8ce5734515834.1635475016968827598@shytyi.net>
References: <175b25d0c79.f8ce5734515834.1635475016968827598@shytyi.net>
Subject: Re: [PATCH net-next] net: Variable SLAAC: SLAAC with prefixes of
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
diff -rupN net-next-5.10.0-rc2/include/net/if_inet6.h net-next-patch-v2-5.10.0-rc2/include/net/if_inet6.h
--- net-next-5.10.0-rc2/include/net/if_inet6.h	2020-11-10 08:46:00.195180579 +0100
+++ net-next-patch-v2-5.10.0-rc2/include/net/if_inet6.h	2020-11-10 12:43:26.866166351 +0100
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
diff -rupN net-next-5.10.0-rc2/include/uapi/linux/icmpv6.h net-next-patch-v2-5.10.0-rc2/include/uapi/linux/icmpv6.h
--- net-next-5.10.0-rc2/include/uapi/linux/icmpv6.h	2020-11-10 08:46:00.351849525 +0100
+++ net-next-patch-v2-5.10.0-rc2/include/uapi/linux/icmpv6.h	2020-11-10 12:43:26.866166351 +0100
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
diff -rupN net-next-5.10.0-rc2/net/ipv6/addrconf.c net-next-patch-v2-5.10.0-rc2/net/ipv6/addrconf.c
--- net-next-5.10.0-rc2/net/ipv6/addrconf.c	2020-11-10 08:46:01.075193379 +0100
+++ net-next-patch-v2-5.10.0-rc2/net/ipv6/addrconf.c	2020-11-10 13:09:55.762384640 +0100
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
+unsigned char reverse_bits(unsigned char num);
 #define IN6_ADDR_HSIZE_SHIFT	8
 #define IN6_ADDR_HSIZE		(1 << IN6_ADDR_HSIZE_SHIFT)
 /*
@@ -1314,9 +1321,21 @@ static int ipv6_create_tempaddr(struct i
 	struct inet6_ifaddr *ift;
 	struct ifa6_config cfg;
 	long max_desync_factor;
-	struct in6_addr addr;
+
+	struct in6_addr temp, addr;
+
 	int ret = 0;
 
+	__int128 host_id;
+	__int128 net_prfx;
+	__int128 ipv6addr;
+	__int128 mask_128;
+	__int128 mask_host_id;
+	__int128 mask_net_prfx;
+	int i;
+	unsigned char mask_host_id_arr[128];
+
+	memset(&mask_128, 0xFF, 16);
 	write_lock_bh(&idev->lock);
 
 retry:
@@ -1340,9 +1359,30 @@ retry:
 		goto out;
 	}
 	in6_ifa_hold(ifp);
-	memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
-	ipv6_gen_rnd_iid(&addr);
 
+	if (ifp->prefix_len == 64) {
+		memcpy(addr.s6_addr, ifp->addr.s6_addr, 8);
+		ipv6_gen_rnd_iid(&addr);
+	} else if (ifp->prefix_len > 0 && ifp->prefix_len <= 128) {
+		memcpy(addr.s6_addr, ifp->addr.s6_addr, 16);
+		get_random_bytes(temp.s6_addr32, 16);
+
+		memcpy(&host_id, temp.s6_addr32, sizeof(host_id));
+		memcpy(&net_prfx, addr.s6_addr, sizeof(net_prfx));
+
+		mask_host_id = ifp->prefix_len != 128 ? (mask_128 << ifp->prefix_len) : 0x0;
+		memcpy(mask_host_id_arr, &mask_host_id, 16);
+		for (i = 0; i < 128; i++)
+			mask_host_id_arr[i] = reverse_bits(mask_host_id_arr[i]);
+		memcpy(&mask_host_id, mask_host_id_arr, 16);
+		host_id = host_id & mask_host_id;
+
+		mask_net_prfx = mask_128 ^ mask_host_id;
+		net_prfx = net_prfx & mask_net_prfx;
+
+		ipv6addr = net_prfx | host_id;
+		memcpy(addr.s6_addr, &ipv6addr, 16);
+	}
 	age = (now - ifp->tstamp) / HZ;
 
 	regen_advance = idev->cnf.regen_max_retry *
@@ -2576,9 +2616,61 @@ int addrconf_prefix_rcv_add_addr(struct
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
+		__int128 mask_128;
+		__int128 mask_net_prfx;
+		__int128 net_prfx;
+		__int128 curr_net_prfx;
+		int hostid_len;
+		int i;
+		unsigned char mask_host_id_arr[128];
+
+		memset(&mask_128, 0xFF, 16);
+		result_base = result;
+		rcu_read_lock();
+		list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
+			if (!net_eq(dev_net(ifp->idev->dev), net))
+				continue;
+			/* 128bit network prefix mask calculation */
+			hostid_len = 128 - pinfo->prefix_len;
+			mask_net_prfx = pinfo->prefix_len != 128 ? (mask_128 << pinfo->prefix_len) : 0x0;
+			mask_net_prfx = ~mask_net_prfx;
+			memcpy(mask_host_id_arr, &mask_net_prfx, 16);
+			for (i = 0; i < 128; i++)
+				mask_host_id_arr[i] = reverse_bits(mask_host_id_arr[i]);
+			memcpy(&mask_net_prfx, mask_host_id_arr, 16);
+
+			/* Received/new IPv6 prefix */
+			memcpy(&net_prfx, pinfo->prefix.s6_addr32, 16);
+			net_prfx &= mask_net_prfx;
+
+			/* Configured/old IPv6 prefix */
+			memcpy(&curr_net_prfx, ifp->addr.s6_addr32, 16);
+			curr_net_prfx &=  mask_net_prfx;
+
+			/* IPv6 prefixes comparison */
+			if ((net_prfx ^ curr_net_prfx) == 0 &&
+			    pinfo->prefix_len == ifp->prefix_len) {
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
@@ -2781,9 +2873,35 @@ void addrconf_prefix_rcv(struct net_devi
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
@@ -3264,6 +3382,119 @@ retry:
 	return 0;
 }
 
+unsigned char reverse_bits(unsigned char num)
+{
+	unsigned char count = sizeof(num) * 8 - 1;
+	unsigned char reverse_num = num;
+
+	num >>= 1;
+	while (num) {
+		reverse_num <<= 1;
+		reverse_num |= num & 1;
+		num >>= 1;
+		count--;
+	}
+	reverse_num <<= count;
+	return reverse_num;
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
+	struct in6_addr secret;
+	struct in6_addr temp;
+	struct net *net = dev_net(idev->dev);
+	__int128 host_id;
+	__int128 net_prfx;
+	__int128 ipv6addr;
+	__int128 mask_128;
+	__int128 mask_host_id;
+	__int128 mask_net_prfx;
+	int i;
+	unsigned char mask_host_id_arr[128];
+
+	memset(&mask_128, 0xFF, 16);
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
+	memcpy(&host_id, temp.s6_addr32, 16);
+	memcpy(&net_prfx, address->s6_addr32, 16);
+
+	mask_host_id = rcvd_prfx_len != 128 ? (mask_128 << rcvd_prfx_len) : 0x0;
+	memcpy(mask_host_id_arr, &mask_host_id, 16);
+	for (i = 0; i < 128; i++)
+		mask_host_id_arr[i] = reverse_bits(mask_host_id_arr[i]);
+	memcpy(&mask_host_id, mask_host_id_arr, 16);
+	host_id = host_id & mask_host_id;
+
+	mask_net_prfx = mask_128 ^ mask_host_id;
+	net_prfx = net_prfx & mask_net_prfx;
+
+	ipv6addr = net_prfx | host_id;
+	memcpy(temp.s6_addr32, &ipv6addr, 16);
+
+	*address = temp;
+
+	return 0;
+}
+
 static void ipv6_gen_mode_random_init(struct inet6_dev *idev)
 {
 	struct ipv6_stable_secret *s = &idev->cnf.stable_secret;
diff -rupN net-next-5.10.0-rc2/net/ipv6/ndisc.c net-next-patch-v2-5.10.0-rc2/net/ipv6/ndisc.c
--- net-next-5.10.0-rc2/net/ipv6/ndisc.c	2020-11-10 08:46:01.091860289 +0100
+++ net-next-patch-v2-5.10.0-rc2/net/ipv6/ndisc.c	2020-11-10 12:43:26.869499720 +0100
@@ -1244,6 +1244,8 @@ static void ndisc_router_discovery(struc
 		in6_dev->if_flags |= IF_RA_RCVD;
 	}
 
+	in6_dev->if_flags |= ra_msg->icmph.icmp6_slaac_var_plen ?
+					IF_RA_VAR_PLEN : 0;
 	/*
 	 * Remember the managed/otherconf flags from most recently
 	 * received RA message (RFC 2462) -- yoshfuji
