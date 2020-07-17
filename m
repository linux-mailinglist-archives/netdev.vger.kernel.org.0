Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3470E223407
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgGQGZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbgGQGY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00602C08C5C0;
        Thu, 16 Jul 2020 23:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=BxwV+i4M9dMYv3ix2RxTH/SE9PWeFAnJ7WfQx79PzsM=; b=HMWPgKy6ASCOQhneUeP8wL4gbq
        4sXtZndqI/NnrmJJETGgiAbydLY8svLFNzrDlvnm6W7hUUvsPHg8wGgmcXgsPbtzoIW6clQOI0Jfn
        uRkBl9hyjrr9dVbVszIoiMSe1wEPXQ1hjs8rQQMuk+jDaVC9hs6iH2RAqFAdZUmz0oYVSXlxFJibQ
        e9xyctjJ2Lqg3VeF8z1xJGu6ErG8rGosAQdMEQiqOljsCa7NsaoI1Y2JyjZPq0I5YR9Z7bB66obNE
        3/fiRv+uTl+7YhsefZujPhBh3+f7u2B6ErHptiTjsMdJE831BSrqgIcbiPvpXImGrQ1D46OPa8W6Q
        6GOaXnEw==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJn7-00054Y-ER; Fri, 17 Jul 2020 06:24:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 14/22] net/ipv4: factor out MCAST_MSFILTER getsockopt helpers
Date:   Fri, 17 Jul 2020 08:23:23 +0200
Message-Id: <20200717062331.691152-15-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out one helper each for getting the native and compat
version of the MCAST_MSFILTER option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ip_sockglue.c | 131 ++++++++++++++++++++++-------------------
 1 file changed, 70 insertions(+), 61 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 95f4248c6fc5ed..70d32c9476a2e3 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1468,6 +1468,74 @@ static bool getsockopt_needs_rtnl(int optname)
 	return false;
 }
 
+static int ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
+		int __user *optlen, int len)
+{
+	const int size0 = offsetof(struct group_filter, gf_slist);
+	struct group_filter __user *p = optval;
+	struct group_filter gsf;
+	int num;
+	int err;
+
+	if (len < size0)
+		return -EINVAL;
+	if (copy_from_user(&gsf, p, size0))
+		return -EFAULT;
+
+	num = gsf.gf_numsrc;
+	err = ip_mc_gsfget(sk, &gsf, p->gf_slist);
+	if (err)
+		return err;
+	if (gsf.gf_numsrc < num)
+		num = gsf.gf_numsrc;
+	if (put_user(GROUP_FILTER_SIZE(num), optlen) ||
+	    copy_to_user(p, &gsf, size0))
+		return -EFAULT;
+	return 0;
+}
+
+#ifdef CONFIG_COMPAT
+static int compat_ip_get_mcast_msfilter(struct sock *sk, void __user *optval,
+		int __user *optlen)
+{
+	const int size0 = offsetof(struct compat_group_filter, gf_slist);
+	struct compat_group_filter __user *p = optval;
+	struct compat_group_filter gf32;
+	struct group_filter gf;
+	int len, err;
+	int num;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+	if (len < size0)
+		return -EINVAL;
+
+	if (copy_from_user(&gf32, p, size0))
+		return -EFAULT;
+
+	gf.gf_interface = gf32.gf_interface;
+	gf.gf_fmode = gf32.gf_fmode;
+	num = gf.gf_numsrc = gf32.gf_numsrc;
+	gf.gf_group = gf32.gf_group;
+
+	rtnl_lock();
+	lock_sock(sk);
+	err = ip_mc_gsfget(sk, &gf, p->gf_slist);
+	release_sock(sk);
+	rtnl_unlock();
+	if (err)
+		return err;
+	if (gf.gf_numsrc < num)
+		num = gf.gf_numsrc;
+	len = GROUP_FILTER_SIZE(num) - (sizeof(gf) - sizeof(gf32));
+	if (put_user(len, optlen) ||
+	    put_user(gf.gf_fmode, &p->gf_fmode) ||
+	    put_user(gf.gf_numsrc, &p->gf_numsrc))
+		return -EFAULT;
+	return 0;
+}
+#endif
+
 static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, int __user *optlen, unsigned int flags)
 {
@@ -1626,31 +1694,8 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 		goto out;
 	}
 	case MCAST_MSFILTER:
-	{
-		struct group_filter __user *p = (void __user *)optval;
-		struct group_filter gsf;
-		const int size0 = offsetof(struct group_filter, gf_slist);
-		int num;
-
-		if (len < size0) {
-			err = -EINVAL;
-			goto out;
-		}
-		if (copy_from_user(&gsf, p, size0)) {
-			err = -EFAULT;
-			goto out;
-		}
-		num = gsf.gf_numsrc;
-		err = ip_mc_gsfget(sk, &gsf, p->gf_slist);
-		if (err)
-			goto out;
-		if (gsf.gf_numsrc < num)
-			num = gsf.gf_numsrc;
-		if (put_user(GROUP_FILTER_SIZE(num), optlen) ||
-		    copy_to_user(p, &gsf, size0))
-			err = -EFAULT;
+		err = ip_get_mcast_msfilter(sk, optval, optlen, len);
 		goto out;
-	}
 	case IP_MULTICAST_ALL:
 		val = inet->mc_all;
 		break;
@@ -1762,45 +1807,9 @@ int compat_ip_getsockopt(struct sock *sk, int level, int optname,
 	int err;
 
 	if (optname == MCAST_MSFILTER) {
-		const int size0 = offsetof(struct compat_group_filter, gf_slist);
-		struct compat_group_filter __user *p = (void __user *)optval;
-		struct compat_group_filter gf32;
-		struct group_filter gf;
-		int ulen, err;
-		int num;
-
 		if (level != SOL_IP)
 			return -EOPNOTSUPP;
-
-		if (get_user(ulen, optlen))
-			return -EFAULT;
-
-		if (ulen < size0)
-			return -EINVAL;
-
-		if (copy_from_user(&gf32, p, size0))
-			return -EFAULT;
-
-		gf.gf_interface = gf32.gf_interface;
-		gf.gf_fmode = gf32.gf_fmode;
-		num = gf.gf_numsrc = gf32.gf_numsrc;
-		gf.gf_group = gf32.gf_group;
-
-		rtnl_lock();
-		lock_sock(sk);
-		err = ip_mc_gsfget(sk, &gf, p->gf_slist);
-		release_sock(sk);
-		rtnl_unlock();
-		if (err)
-			return err;
-		if (gf.gf_numsrc < num)
-			num = gf.gf_numsrc;
-		ulen = GROUP_FILTER_SIZE(num) - (sizeof(gf) - sizeof(gf32));
-		if (put_user(ulen, optlen) ||
-		    put_user(gf.gf_fmode, &p->gf_fmode) ||
-		    put_user(gf.gf_numsrc, &p->gf_numsrc))
-			return -EFAULT;
-		return 0;
+		return compat_ip_get_mcast_msfilter(sk, optval, optlen);
 	}
 
 	err = do_ip_getsockopt(sk, level, optname, optval, optlen,
-- 
2.27.0

