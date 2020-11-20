Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716EE2BA615
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 10:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbgKTJ0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 04:26:51 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21381 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgKTJ0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 04:26:49 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605864367; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DfwoevSeLwJHUFoHlc2BIDBj1x0PTsfCvenuoueT2wGSRXGI8s7YPmdmhjIX9DhL66RVhQ9gIu1JjtAkc4AK2j8A37t6+RpGChpH/+31ipIXivv7fVRLlo+RCJrOB6vf+PVQwRs3+7pTpij8BYSvGfxE+enFAUuS+FLZ7qUuDMc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605864367; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Q1Z7u3/19piKh5TPP33XogbleV1eFFi1/M1BOUwPw0M=; 
        b=Gd3oqU3Qa6ysNlnDdFd2DdvEpYa+LAVQiDtZEmQdPLgRKw4+l96hxS8vWYJKm6punKGGShjm5HfxBYLSWdxiSzzxRn6TlshjwJMXKbzXhHcVJ3VWbJtuDZ7EgGfAAoYr9zgixpsd5Jw11qEzR3Eo99s5IgtKUSwNfG8KrKTtp5s=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605864367;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=Q1Z7u3/19piKh5TPP33XogbleV1eFFi1/M1BOUwPw0M=;
        b=TnOkOS3VB2Tr+kyM1vZSOinWvy6eKVQoZ4w+U91UW/5Mc+BZxq66kzNsAMWvEqS8
        kQj2/+kY+tJEu5YHSPf8xhTNv1bMZfmLvjpJkjoiLgwzgmeZaoHptZmNjSwlLfsevUr
        O7TxKzWcT7OtM3DtdsoLK1EA6/FmR8p76EXRYnjg=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605864361499137.62084601263723; Fri, 20 Nov 2020 10:26:01 +0100 (CET)
Date:   Fri, 20 Nov 2020 10:26:01 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "kuznet" <kuznet@ms2.inr.ac.ru>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
In-Reply-To: <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net> <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
Subject: [PATCH net-next V7] net: Variable SLAAC: SLAAC with prefixes of
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
diff -rupN net-next-5.10.0-rc2/net/ipv6/addrconf.c net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c
--- net-next-5.10.0-rc2/net/ipv6/addrconf.c	2020-11-10 08:46:01.075193379 +0100
+++ net-next-patch-5.10.0-rc2/net/ipv6/addrconf.c	2020-11-19 21:26:39.770872898 +0100
@@ -142,7 +142,6 @@ static int ipv6_count_addresses(const st
 static int ipv6_generate_stable_address(struct in6_addr *addr,
 					u8 dad_count,
 					const struct inet6_dev *idev);
-
 #define IN6_ADDR_HSIZE_SHIFT	8
 #define IN6_ADDR_HSIZE		(1 << IN6_ADDR_HSIZE_SHIFT)
 /*
@@ -1315,6 +1314,7 @@ static int ipv6_create_tempaddr(struct i
 	struct ifa6_config cfg;
 	long max_desync_factor;
 	struct in6_addr addr;
+	struct in6_addr temp;
 	int ret = 0;
 
 	write_lock_bh(&idev->lock);
@@ -1340,9 +1340,16 @@ retry:
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
+		ipv6_addr_prefix_copy(&temp, &addr, ifp->prefix_len);
+		memcpy(addr.s6_addr, temp.s6_addr, 16);
+	}
 	age = (now - ifp->tstamp) / HZ;
 
 	regen_advance = idev->cnf.regen_max_retry *
@@ -2569,6 +2576,41 @@ static bool is_addr_mode_generate_stable
 	       idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_RANDOM;
 }
 
+static struct inet6_ifaddr *ipv6_cmp_rcvd_prsnt_prfxs(struct inet6_ifaddr *ifp,
+						      struct inet6_dev *in6_dev,
+						      struct net *net,
+						      const struct prefix_info *pinfo)
+{
+	struct inet6_ifaddr *result_base = NULL;
+	struct inet6_ifaddr *result = NULL;
+	struct in6_addr curr_net_prfx;
+	struct in6_addr net_prfx;
+	bool prfxs_equal;
+
+	result_base = result;
+	rcu_read_lock();
+	list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) {
+		if (!net_eq(dev_net(ifp->idev->dev), net))
+			continue;
+		ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo->prefix_len);
+		ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinfo->prefix_len);
+		prfxs_equal =
+			ipv6_prefix_equal(&net_prfx, &curr_net_prfx, pinfo->prefix_len);
+		if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) {
+			result = ifp;
+			in6_ifa_hold(ifp);
+			break;
+		}
+	}
+	rcu_read_unlock();
+	if (result_base != result)
+		ifp = result;
+	else
+		ifp = NULL;
+
+	return ifp;
+}
+
 int addrconf_prefix_rcv_add_addr(struct net *net, struct net_device *dev,
 				 const struct prefix_info *pinfo,
 				 struct inet6_dev *in6_dev,
@@ -2576,9 +2618,16 @@ int addrconf_prefix_rcv_add_addr(struct
 				 u32 addr_flags, bool sllao, bool tokenized,
 				 __u32 valid_lft, u32 prefered_lft)
 {
-	struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+	struct inet6_ifaddr *ifp = NULL;
+	int plen = pinfo->prefix_len;
 	int create = 0;
 
+	if (plen > 0 && plen <= 128 && plen != 64 &&
+	    in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY)
+		ifp = ipv6_cmp_rcvd_prsnt_prfxs(ifp, in6_dev, net, pinfo);
+	else
+		ifp = ipv6_get_ifaddr(net, addr, dev, 1);
+
 	if (!ifp && valid_lft) {
 		int max_addresses = in6_dev->cnf.max_addresses;
 		struct ifa6_config cfg = {
@@ -2657,6 +2706,91 @@ int addrconf_prefix_rcv_add_addr(struct
 }
 EXPORT_SYMBOL_GPL(addrconf_prefix_rcv_add_addr);
 
+static bool ipv6_reserved_interfaceid(struct in6_addr address)
+{
+	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
+		return true;
+
+	if (address.s6_addr32[2] == htonl(0x02005eff) &&
+	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
+		return true;
+
+	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
+	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
+		return true;
+
+	return false;
+}
+
+static int ipv6_gen_addr_var_plen(struct in6_addr *address,
+				  u8 dad_count,
+				  const struct inet6_dev *idev,
+				  unsigned int rcvd_prfx_len,
+				  bool stable_privacy_mode)
+{
+	static union {
+		char __data[SHA1_BLOCK_SIZE];
+		struct {
+			struct in6_addr secret;
+			__be32 prefix[2];
+			unsigned char hwaddr[MAX_ADDR_LEN];
+			u8 dad_count;
+		} __packed;
+	} data;
+	static __u32 workspace[SHA1_WORKSPACE_WORDS];
+	static __u32 digest[SHA1_DIGEST_WORDS];
+	struct net *net = dev_net(idev->dev);
+	static DEFINE_SPINLOCK(lock);
+	struct in6_addr secret;
+	struct in6_addr temp;
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
+	ipv6_addr_prefix_copy(&temp, address, rcvd_prfx_len);
+	*address = temp;
+	return 0;
+}
+
 void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 {
 	struct prefix_info *pinfo;
@@ -2781,9 +2915,33 @@ void addrconf_prefix_rcv(struct net_devi
 				dev_addr_generated = true;
 			}
 			goto ok;
+		} else if (pinfo->prefix_len != 64 &&
+			   pinfo->prefix_len > 0 && pinfo->prefix_len <= 128) {
+			/* SLAAC with prefixes of arbitrary length (Variable SLAAC).
+			 * draft-mishra-6man-variable-slaac
+			 * draft-mishra-v6ops-variable-slaac-problem-stmt
+			 */
+			memcpy(&addr, &pinfo->prefix, 16);
+			if (in6_dev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_STABLE_PRIVACY) {
+				if (!ipv6_gen_addr_var_plen(&addr,
+							    0,
+							    in6_dev,
+							    pinfo->prefix_len,
+							    true)) {
+					addr_flags |= IFA_F_STABLE_PRIVACY;
+					goto ok;
+				}
+			} else if (!ipv6_gen_addr_var_plen(&addr,
+							   0,
+							   in6_dev,
+							   pinfo->prefix_len,
+							   false)) {
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
@@ -3186,22 +3344,6 @@ void addrconf_add_linklocal(struct inet6
 }
 EXPORT_SYMBOL_GPL(addrconf_add_linklocal);
 
-static bool ipv6_reserved_interfaceid(struct in6_addr address)
-{
-	if ((address.s6_addr32[2] | address.s6_addr32[3]) == 0)
-		return true;
-
-	if (address.s6_addr32[2] == htonl(0x02005eff) &&
-	    ((address.s6_addr32[3] & htonl(0xfe000000)) == htonl(0xfe000000)))
-		return true;
-
-	if (address.s6_addr32[2] == htonl(0xfdffffff) &&
-	    ((address.s6_addr32[3] & htonl(0xffffff80)) == htonl(0xffffff80)))
-		return true;
-
-	return false;
-}
-
 static int ipv6_generate_stable_address(struct in6_addr *address,
 					u8 dad_count,
 					const struct inet6_dev *idev)
