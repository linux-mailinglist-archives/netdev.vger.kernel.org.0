Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C6E1DC410
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbgEUAio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727958AbgEUAhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:24 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26294C061A0E;
        Wed, 20 May 2020 17:37:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZD8-00Cgdn-Ch; Thu, 21 May 2020 00:37:22 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/19] set_mcast_msfilter(): take the guts of setsockopt(MCAST_MSFILTER) into a helper
Date:   Thu, 21 May 2020 01:37:07 +0100
Message-Id: <20200521003721.3023783-5-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
References: <20200521003657.GE23230@ZenIV.linux.org.uk>
 <20200521003721.3023783-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv4/ip_sockglue.c | 73 +++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 65a30e7672ff..cc0441157b02 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -587,6 +587,43 @@ static bool setsockopt_needs_rtnl(int optname)
 	return false;
 }
 
+static int set_mcast_msfilter(struct sock *sk, int ifindex,
+			      int numsrc, int fmode,
+			      struct sockaddr_storage *group,
+			      struct sockaddr_storage *list)
+{
+	int msize = IP_MSFILTER_SIZE(numsrc);
+	struct ip_msfilter *msf;
+	struct sockaddr_in *psin;
+	int err, i;
+
+	msf = kmalloc(msize, GFP_KERNEL);
+	if (!msf)
+		return -ENOBUFS;
+
+	psin = (struct sockaddr_in *)group;
+	if (psin->sin_family != AF_INET)
+		goto Eaddrnotavail;
+	msf->imsf_multiaddr = psin->sin_addr.s_addr;
+	msf->imsf_interface = 0;
+	msf->imsf_fmode = fmode;
+	msf->imsf_numsrc = numsrc;
+	for (i = 0; i < numsrc; ++i) {
+		psin = (struct sockaddr_in *)&list[i];
+
+		if (psin->sin_family != AF_INET)
+			goto Eaddrnotavail;
+		msf->imsf_slist[i] = psin->sin_addr.s_addr;
+	}
+	err = ip_mc_msfilter(sk, msf, ifindex);
+	kfree(msf);
+	return err;
+
+Eaddrnotavail:
+	kfree(msf);
+	return -EADDRNOTAVAIL;
+}
+
 static int do_ip_setsockopt(struct sock *sk, int level,
 			    int optname, char __user *optval, unsigned int optlen)
 {
@@ -1079,10 +1116,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	}
 	case MCAST_MSFILTER:
 	{
-		struct sockaddr_in *psin;
-		struct ip_msfilter *msf = NULL;
 		struct group_filter *gsf = NULL;
-		int msize, i, ifindex;
 
 		if (optlen < GROUP_FILTER_SIZE(0))
 			goto e_inval;
@@ -1095,7 +1129,6 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 			err = PTR_ERR(gsf);
 			break;
 		}
-
 		/* numsrc >= (4G-140)/128 overflow in 32 bits */
 		if (gsf->gf_numsrc >= 0x1ffffff ||
 		    gsf->gf_numsrc > net->ipv4.sysctl_igmp_max_msf) {
@@ -1106,36 +1139,10 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 			err = -EINVAL;
 			goto mc_msf_out;
 		}
-		msize = IP_MSFILTER_SIZE(gsf->gf_numsrc);
-		msf = kmalloc(msize, GFP_KERNEL);
-		if (!msf) {
-			err = -ENOBUFS;
-			goto mc_msf_out;
-		}
-		ifindex = gsf->gf_interface;
-		psin = (struct sockaddr_in *)&gsf->gf_group;
-		if (psin->sin_family != AF_INET) {
-			err = -EADDRNOTAVAIL;
-			goto mc_msf_out;
-		}
-		msf->imsf_multiaddr = psin->sin_addr.s_addr;
-		msf->imsf_interface = 0;
-		msf->imsf_fmode = gsf->gf_fmode;
-		msf->imsf_numsrc = gsf->gf_numsrc;
-		err = -EADDRNOTAVAIL;
-		for (i = 0; i < gsf->gf_numsrc; ++i) {
-			psin = (struct sockaddr_in *)&gsf->gf_slist[i];
-
-			if (psin->sin_family != AF_INET)
-				goto mc_msf_out;
-			msf->imsf_slist[i] = psin->sin_addr.s_addr;
-		}
-		kfree(gsf);
-		gsf = NULL;
-
-		err = ip_mc_msfilter(sk, msf, ifindex);
+		err = set_mcast_msfilter(sk, gsf->gf_interface,
+					 gsf->gf_numsrc, gsf->gf_fmode,
+					 &gsf->gf_group, gsf->gf_slist);
 mc_msf_out:
-		kfree(msf);
 		kfree(gsf);
 		break;
 	}
-- 
2.11.0

