Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656291CD0FA
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 06:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgEKEqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 00:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgEKEp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 00:45:57 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ED5C061A0C;
        Sun, 10 May 2020 21:45:57 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jY0KB-005jIn-S0; Mon, 11 May 2020 04:45:55 +0000
From:   Al Viro <viro@ZenIV.linux.org.uk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/19] get rid of compat_mc_setsockopt()
Date:   Mon, 11 May 2020 05:45:47 +0100
Message-Id: <20200511044553.1365660-13-viro@ZenIV.linux.org.uk>
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

not used anymore

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/net/compat.h |  4 ---
 net/compat.c         | 90 ----------------------------------------------------
 2 files changed, 94 deletions(-)

diff --git a/include/net/compat.h b/include/net/compat.h
index b6043e759cde..2de4dfcdc11f 100644
--- a/include/net/compat.h
+++ b/include/net/compat.h
@@ -49,10 +49,6 @@ int put_cmsg_compat(struct msghdr*, int, int, int, void *);
 int cmsghdr_from_user_compat_to_kern(struct msghdr *, struct sock *,
 				     unsigned char *, int);
 
-int compat_mc_setsockopt(struct sock *, int, int, char __user *, unsigned int,
-			 int (*)(struct sock *, int, int, char __user *,
-				 unsigned int));
-
 struct compat_group_req {
 	__u32				 gr_interface;
 	struct __kernel_sockaddr_storage gr_group
diff --git a/net/compat.c b/net/compat.c
index 6191481b5ef0..a47ce3a6e7af 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -447,96 +447,6 @@ COMPAT_SYSCALL_DEFINE5(getsockopt, int, fd, int, level, int, optname,
 	return __compat_sys_getsockopt(fd, level, optname, optval, optlen);
 }
 
-#define __COMPAT_GF0_SIZE (sizeof(struct compat_group_filter) - \
-			sizeof(struct __kernel_sockaddr_storage))
-
-int compat_mc_setsockopt(struct sock *sock, int level, int optname,
-	char __user *optval, unsigned int optlen,
-	int (*setsockopt)(struct sock *, int, int, char __user *, unsigned int))
-{
-	char __user	*koptval = optval;
-	int		koptlen = optlen;
-
-	switch (optname) {
-	case MCAST_JOIN_GROUP:
-	case MCAST_LEAVE_GROUP:
-	{
-		struct compat_group_req __user *gr32 = (void __user *)optval;
-		struct group_req __user *kgr =
-			compat_alloc_user_space(sizeof(struct group_req));
-		u32 interface;
-
-		if (!access_ok(gr32, sizeof(*gr32)) ||
-		    !access_ok(kgr, sizeof(struct group_req)) ||
-		    __get_user(interface, &gr32->gr_interface) ||
-		    __put_user(interface, &kgr->gr_interface) ||
-		    copy_in_user(&kgr->gr_group, &gr32->gr_group,
-				sizeof(kgr->gr_group)))
-			return -EFAULT;
-		koptval = (char __user *)kgr;
-		koptlen = sizeof(struct group_req);
-		break;
-	}
-	case MCAST_JOIN_SOURCE_GROUP:
-	case MCAST_LEAVE_SOURCE_GROUP:
-	case MCAST_BLOCK_SOURCE:
-	case MCAST_UNBLOCK_SOURCE:
-	{
-		struct compat_group_source_req __user *gsr32 = (void __user *)optval;
-		struct group_source_req __user *kgsr = compat_alloc_user_space(
-			sizeof(struct group_source_req));
-		u32 interface;
-
-		if (!access_ok(gsr32, sizeof(*gsr32)) ||
-		    !access_ok(kgsr,
-			sizeof(struct group_source_req)) ||
-		    __get_user(interface, &gsr32->gsr_interface) ||
-		    __put_user(interface, &kgsr->gsr_interface) ||
-		    copy_in_user(&kgsr->gsr_group, &gsr32->gsr_group,
-				sizeof(kgsr->gsr_group)) ||
-		    copy_in_user(&kgsr->gsr_source, &gsr32->gsr_source,
-				sizeof(kgsr->gsr_source)))
-			return -EFAULT;
-		koptval = (char __user *)kgsr;
-		koptlen = sizeof(struct group_source_req);
-		break;
-	}
-	case MCAST_MSFILTER:
-	{
-		struct compat_group_filter __user *gf32 = (void __user *)optval;
-		struct group_filter __user *kgf;
-		u32 interface, fmode, numsrc;
-
-		if (!access_ok(gf32, __COMPAT_GF0_SIZE) ||
-		    __get_user(interface, &gf32->gf_interface) ||
-		    __get_user(fmode, &gf32->gf_fmode) ||
-		    __get_user(numsrc, &gf32->gf_numsrc))
-			return -EFAULT;
-		koptlen = optlen + sizeof(struct group_filter) -
-				sizeof(struct compat_group_filter);
-		if (koptlen < GROUP_FILTER_SIZE(numsrc))
-			return -EINVAL;
-		kgf = compat_alloc_user_space(koptlen);
-		if (!access_ok(kgf, koptlen) ||
-		    __put_user(interface, &kgf->gf_interface) ||
-		    __put_user(fmode, &kgf->gf_fmode) ||
-		    __put_user(numsrc, &kgf->gf_numsrc) ||
-		    copy_in_user(&kgf->gf_group, &gf32->gf_group,
-				sizeof(kgf->gf_group)) ||
-		    (numsrc && copy_in_user(kgf->gf_slist, gf32->gf_slist,
-				numsrc * sizeof(kgf->gf_slist[0]))))
-			return -EFAULT;
-		koptval = (char __user *)kgf;
-		break;
-	}
-
-	default:
-		break;
-	}
-	return setsockopt(sock, level, optname, koptval, koptlen);
-}
-EXPORT_SYMBOL(compat_mc_setsockopt);
-
 /* Argument list sizes for compat_sys_socketcall */
 #define AL(x) ((x) * sizeof(u32))
 static unsigned char nas[21] = {
-- 
2.11.0

