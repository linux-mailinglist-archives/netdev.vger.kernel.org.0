Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848893BC492
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 03:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbhGFBSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 21:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhGFBSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 21:18:38 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E289FC061760
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 18:16:00 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 478ED806B7;
        Tue,  6 Jul 2021 13:15:56 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1625534156;
        bh=R6VdAkpVGhWXkSQcBU7A2PlMs3pkDJzD1jm4yvlPUho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HSC/FnlHfNmQSnEJXBtVxY1Z5gjLdj8/CWmegKS76h0yXEkrx/Hkdc9XiWAmyia9f
         tcasnPCU74T7Lo6XGhVebZf0o9+qcX60H7UNLbDmIVYC2d7GGy1c69wWpim3GHzXsc
         JAsahmxf6k7IoQvYRWAYGaTZ7nfufbTj0eRxkD/oCcN3OyUeZm1jl0yoy+V++jLrNr
         apmkqGg+b+bwDUiS+EGeRrUJvlI94dwt/DIYyQxKOS00j1wD7daC8mFaoDRFch2Ozr
         RGMHIXCXs7wu7q73BhR30L3mMVfC7mt1ZeJ8uP0CKA+U/ftW5LxOWSJlsdB+O/19Bz
         RcnEtKBHclocw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60e3aecc0000>; Tue, 06 Jul 2021 13:15:56 +1200
Received: from callums-dl.ws.atlnz.lc (callums-dl.ws.atlnz.lc [10.33.22.16])
        by pat.atlnz.lc (Postfix) with ESMTP id 1A73113EE58;
        Tue,  6 Jul 2021 13:15:56 +1200 (NZST)
Received: by callums-dl.ws.atlnz.lc (Postfix, from userid 1764)
        id 16EFFA028D; Tue,  6 Jul 2021 13:15:56 +1200 (NZST)
From:   Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
To:     dsahern@kernel.org, nikolay@nvidia.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linus.luessing@c0d3.blue,
        Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
Subject: [PATCH] net: Allow any address multicast join for IP sockets
Date:   Tue,  6 Jul 2021 13:15:48 +1200
Message-Id: <20210706011548.2201-2-callum.sinclair@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>
References: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=e_q4qTt1xDgA:10 a=fNiwAx1GhbFK_hs55oYA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For an application to receive all multicast packets in a range such as
224.0.0.1 - 239.255.255.255 each multicast IP address has to be joined
explicitly one at a time.

Allow the any address to be passed to the IP_ADD_MEMBERSHIP and
IPV6_ADD_MEMBERSHIP socket option per interface. By joining the any
address the socket will receive all multicast packets that are received
on the interface. This allows any IP socket to be used for IGMP or MLD
snooping.

Signed-off-by: Callum Sinclair <callum.sinclair@alliedtelesis.co.nz>
---
 net/ipv4/igmp.c  | 40 ++++++++++++++++++++++++++++++++--------
 net/ipv6/mcast.c | 20 ++++++++++++++------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6b3c558a4f23..3978c9f2d1c5 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1413,6 +1413,25 @@ static void ip_mc_hash_remove(struct in_device *in=
_dev,
 	*mc_hash =3D im->next_hash;
 }
=20
+static struct ip_mc_list *ip_mc_hash_lookup(struct ip_mc_list __rcu **mc=
_hash,
+					    __be32 mc_addr)
+{
+	struct ip_mc_list *im;
+	u32 hash;
+
+	if (mc_hash) {
+		hash =3D hash_32((__force u32)mc_addr, MC_HASH_SZ_LOG);
+		for (im =3D rcu_dereference(mc_hash[hash]);
+		     im !=3D NULL;
+		     im =3D rcu_dereference(im->next_hash)) {
+			if (im->multiaddr =3D=3D mc_addr)
+				break;
+			}
+	}
+
+	return im;
+}
+
=20
 /*
  *	A socket has joined a multicast group on device dev.
@@ -2166,7 +2185,7 @@ static int __ip_mc_join_group(struct sock *sk, stru=
ct ip_mreqn *imr,
=20
 	ASSERT_RTNL();
=20
-	if (!ipv4_is_multicast(addr))
+	if (!ipv4_is_multicast(addr) && addr !=3D htonl(INADDR_ANY))
 		return -EINVAL;
=20
 	in_dev =3D ip_mc_find_dev(net, imr);
@@ -2627,6 +2646,11 @@ int ip_mc_sf_allow(struct sock *sk, __be32 loc_add=
r, __be32 rmt_addr,
=20
 	rcu_read_lock();
 	for_each_pmc_rcu(inet, pmc) {
+		if (pmc->multi.imr_multiaddr.s_addr =3D=3D htonl(INADDR_ANY) &&
+		    pmc->multi.imr_ifindex =3D=3D dif) {
+			ret =3D 1;
+			goto unlock;
+		}
 		if (pmc->multi.imr_multiaddr.s_addr =3D=3D loc_addr &&
 		    (pmc->multi.imr_ifindex =3D=3D dif ||
 		     (sdif && pmc->multi.imr_ifindex =3D=3D sdif)))
@@ -2695,18 +2719,18 @@ int ip_check_mc_rcu(struct in_device *in_dev, __b=
e32 mc_addr, __be32 src_addr, u
=20
 	mc_hash =3D rcu_dereference(in_dev->mc_hash);
 	if (mc_hash) {
-		u32 hash =3D hash_32((__force u32)mc_addr, MC_HASH_SZ_LOG);
-
-		for (im =3D rcu_dereference(mc_hash[hash]);
-		     im !=3D NULL;
-		     im =3D rcu_dereference(im->next_hash)) {
-			if (im->multiaddr =3D=3D mc_addr)
-				break;
+		im =3D ip_mc_hash_lookup(mc_hash, mc_addr);
+		if (!im) {
+			if (ip_mc_hash_lookup(mc_hash, htonl(INADDR_ANY)))
+				return 1;
 		}
+
 	} else {
 		for_each_pmc_rcu(in_dev, im) {
 			if (im->multiaddr =3D=3D mc_addr)
 				break;
+			if (im->multiaddr =3D=3D htonl(INADDR_ANY))
+				return 1;
 		}
 	}
 	if (im && proto =3D=3D IPPROTO_IGMP) {
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 54ec163fbafa..7acf5b3cb435 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -177,7 +177,7 @@ static int __ipv6_sock_mc_join(struct sock *sk, int i=
findex,
=20
 	ASSERT_RTNL();
=20
-	if (!ipv6_addr_is_multicast(addr))
+	if (!ipv6_addr_is_multicast(addr) && !ipv6_addr_any(addr))
 		return -EINVAL;
=20
 	for_each_pmc_socklock(np, sk, mc_lst) {
@@ -254,7 +254,7 @@ int ipv6_sock_mc_drop(struct sock *sk, int ifindex, c=
onst struct in6_addr *addr)
=20
 	ASSERT_RTNL();
=20
-	if (!ipv6_addr_is_multicast(addr))
+	if (!ipv6_addr_is_multicast(addr) && !ipv6_addr_any(addr))
 		return -EINVAL;
=20
 	for (lnk =3D &np->ipv6_mc_list;
@@ -374,7 +374,7 @@ int ip6_mc_source(int add, int omode, struct sock *sk=
,
 	source =3D &((struct sockaddr_in6 *)&pgsr->gsr_source)->sin6_addr;
 	group =3D &((struct sockaddr_in6 *)&pgsr->gsr_group)->sin6_addr;
=20
-	if (!ipv6_addr_is_multicast(group))
+	if (!ipv6_addr_is_multicast(group) && !ipv6_addr_any(group))
 		return -EINVAL;
=20
 	idev =3D ip6_mc_find_dev_rtnl(net, group, pgsr->gsr_interface);
@@ -497,7 +497,7 @@ int ip6_mc_msfilter(struct sock *sk, struct group_fil=
ter *gsf,
=20
 	group =3D &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
=20
-	if (!ipv6_addr_is_multicast(group))
+	if (!ipv6_addr_is_multicast(group) && !ipv6_addr_any(group))
 		return -EINVAL;
 	if (gsf->gf_fmode !=3D MCAST_INCLUDE &&
 	    gsf->gf_fmode !=3D MCAST_EXCLUDE)
@@ -585,7 +585,7 @@ int ip6_mc_msfget(struct sock *sk, struct group_filte=
r *gsf,
=20
 	group =3D &((struct sockaddr_in6 *)&gsf->gf_group)->sin6_addr;
=20
-	if (!ipv6_addr_is_multicast(group))
+	if (!ipv6_addr_is_multicast(group) && !ipv6_addr_any(group))
 		return -EINVAL;
=20
 	/* changes to the ipv6_mc_list require the socket lock and
@@ -634,6 +634,10 @@ bool inet6_mc_check(struct sock *sk, const struct in=
6_addr *mc_addr,
 	for_each_pmc_rcu(np, mc) {
 		if (ipv6_addr_equal(&mc->addr, mc_addr))
 			break;
+		if (ipv6_addr_any(&mc->addr)) {
+			rcu_read_unlock();
+			return rv;
+		}
 	}
 	if (!mc) {
 		rcu_read_unlock();
@@ -1019,8 +1023,12 @@ bool ipv6_chk_mcast_addr(struct net_device *dev, c=
onst struct in6_addr *group,
 		for_each_mc_rcu(idev, mc) {
 			if (ipv6_addr_equal(&mc->mca_addr, group))
 				break;
+			if (ipv6_addr_any(&mc->mca_addr)) {
+				rv =3D true;
+				break;
+			}
 		}
-		if (mc) {
+		if (mc && !ipv6_addr_any(&mc->mca_addr)) {
 			if (src_addr && !ipv6_addr_any(src_addr)) {
 				struct ip6_sf_list *psf;
=20
--=20
2.32.0

