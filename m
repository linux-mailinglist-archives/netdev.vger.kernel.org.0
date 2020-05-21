Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C311DC40A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 02:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgEUAi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 20:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgEUAhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 20:37:24 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DD3C05BD43;
        Wed, 20 May 2020 17:37:24 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jbZD9-00Cge8-0y; Thu, 21 May 2020 00:37:23 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 08/19] ipv6: do compat setsockopt for MCAST_MSFILTER directly
Date:   Thu, 21 May 2020 01:37:10 +0100
Message-Id: <20200521003721.3023783-8-viro@ZenIV.linux.org.uk>
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

similar to the ipv4 counterpart of that patch - the same
trick used to align the tail array properly.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv6/ipv6_sockglue.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 7d3ecc0e69d1..2b5029df8f1e 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -980,9 +980,55 @@ int compat_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
 	case MCAST_UNBLOCK_SOURCE:
-	case MCAST_MSFILTER:
 		return compat_mc_setsockopt(sk, level, optname, optval, optlen,
 			ipv6_setsockopt);
+	case MCAST_MSFILTER:
+	{
+		const int size0 = offsetof(struct compat_group_filter, gf_slist);
+		struct compat_group_filter *gf32;
+		void *p;
+		int n;
+
+		if (optlen < size0)
+			return -EINVAL;
+		if (optlen > sysctl_optmem_max - 4)
+			return -ENOBUFS;
+
+		p = kmalloc(optlen + 4, GFP_KERNEL);
+		if (!p)
+			return -ENOMEM;
+
+		gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
+		if (copy_from_user(gf32, optval, optlen)) {
+			err = -EFAULT;
+			goto mc_msf_out;
+		}
+
+		n = gf32->gf_numsrc;
+		/* numsrc >= (4G-140)/128 overflow in 32 bits */
+		if (n >= 0x1ffffffU ||
+		    n > sysctl_mld_max_msf) {
+			err = -ENOBUFS;
+			goto mc_msf_out;
+		}
+		if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen) {
+			err = -EINVAL;
+			goto mc_msf_out;
+		}
+
+		rtnl_lock();
+		lock_sock(sk);
+		err = ip6_mc_msfilter(sk, &(struct group_filter){
+				.gf_interface = gf32->gf_interface,
+				.gf_group = gf32->gf_group,
+				.gf_fmode = gf32->gf_fmode,
+				.gf_numsrc = gf32->gf_numsrc}, gf32->gf_slist);
+		release_sock(sk);
+		rtnl_unlock();
+mc_msf_out:
+		kfree(p);
+		return err;
+	}
 	}
 
 	err = do_ipv6_setsockopt(sk, level, optname, optval, optlen);
-- 
2.11.0

