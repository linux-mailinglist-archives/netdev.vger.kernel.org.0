Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387C01CD107
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgEKErN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728030AbgEKEp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:56 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE5C061A0E;
        Sun, 10 May 2020 21:45:56 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KA-005jHy-GI; Mon, 11 May 2020 04:45:54 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/19] ipv4: do compat setsockopt for MCAST_MSFILTER directly
Date:   Mon, 11 May 2020 05:45:40 +0100
Message-Id: <20200511044553.1365660-6-viro@ZenIV.linux.org.uk>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
References: <20200511044328.GP23230@ZenIV.linux.org.uk>
 <20200511044553.1365660-1-viro@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Parallel to what the native setsockopt() does, except that unlike
the native setsockopt() we do not use memdup_user() - we want
the sockaddr_storage fields properly aligned, so we allocate
4 bytes more and copy compat_group_filter at the offset 4,
which yields the proper alignments.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/ipv4/ip_sockglue.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 8c14a474870d..dc1f5276be4e 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1286,9 +1286,55 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 	case MCAST_LEAVE_SOURCE_GROUP:
 	case MCAST_BLOCK_SOURCE:
 	case MCAST_UNBLOCK_SOURCE:
-	case MCAST_MSFILTER:
 		return compat_mc_setsockopt(sk, level, optname, optval, optlen,
 			ip_setsockopt);
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
+		gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
+		if (copy_from_user(gf32, optval, optlen)) {
+			err = -EFAULT;
+			goto mc_msf_out;
+		}
+
+		n = gf32->gf_numsrc;
+		/* numsrc >= (4G-140)/128 overflow in 32 bits */
+		if (n >= 0x1ffffff) {
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
+		/* numsrc >= (4G-140)/128 overflow in 32 bits */
+		if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+			err = -ENOBUFS;
+		else
+			err = set_mcast_msfilter(sk, gf32->gf_interface,
+						 n, gf32->gf_fmode,
+						 &gf32->gf_group, gf32->gf_slist);
+		release_sock(sk);
+		rtnl_unlock();
+mc_msf_out:
+		kfree(p);
+		return err;
+	}
 	}
 
 	err = do_ip_setsockopt(sk, level, optname, optval, optlen);
-- 
2.11.0

