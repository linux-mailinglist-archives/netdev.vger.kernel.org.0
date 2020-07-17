Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA5F2233F7
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgGQGZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgGQGYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0FAC061755;
        Thu, 16 Jul 2020 23:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=j6gd4Pw6hNpVEHfOF2IcEGR8joZO+dN7+wdCSBqFWjw=; b=TlVmg/K9KqvbS9luWHYPdSlF+l
        IcakB40GrVEKZU1uOXxCMHY2uiRi5CPgQsFlRmxCIWfSu8v9JpryhcQTQ7ddwbqY1BLqFIdFnla/0
        2yiO0R39cliys55aKmgvAGAEZh3eTUgdy+bn3FaBXvQBMRzB/jmuHJd5PvC8Z1SCazEqL3YFqWadF
        FeOIAyjwWhg4kYInkSG4P0pUQbXrtwcAc3e5AkQrZoMKITl15xLX8UjXxTx2YnZXruvjFIIrl1mI4
        YnVS6v8LNWj8ottBkTWh310+p6myZ4LOFZVTTtAB7oAITAgs2I5hAFcShk4dMrkvRiewZDX0XYENX
        wxNZb2tw==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJn9-00054j-2U; Fri, 17 Jul 2020 06:24:19 +0000
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
Subject: [PATCH 15/22] net/ipv4: factor out MCAST_MSFILTER setsockopt helpers
Date:   Fri, 17 Jul 2020 08:23:24 +0200
Message-Id: <20200717062331.691152-16-hch@lst.de>
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

Factor out one helper each for setting the native and compat
version of the MCAST_MSFILTER option.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv4/ip_sockglue.c | 162 ++++++++++++++++++++++-------------------
 1 file changed, 86 insertions(+), 76 deletions(-)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 70d32c9476a2e3..b587dee006f882 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -722,6 +722,90 @@ static int do_mcast_group_source(struct sock *sk, int optname,
 	return ip_mc_source(add, omode, sk, &mreqs, greqs->gsr_interface);
 }
 
+static int ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
+		int optlen)
+{
+	struct group_filter *gsf = NULL;
+	int err;
+
+	if (optlen < GROUP_FILTER_SIZE(0))
+		return -EINVAL;
+	if (optlen > sysctl_optmem_max)
+		return -ENOBUFS;
+
+	gsf = memdup_user(optval, optlen);
+	if (IS_ERR(gsf))
+		return PTR_ERR(gsf);
+
+	/* numsrc >= (4G-140)/128 overflow in 32 bits */
+	err = -ENOBUFS;
+	if (gsf->gf_numsrc >= 0x1ffffff ||
+	    gsf->gf_numsrc > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+		goto out_free_gsf;
+
+	err = -EINVAL;
+	if (GROUP_FILTER_SIZE(gsf->gf_numsrc) > optlen)
+		goto out_free_gsf;
+
+	err = set_mcast_msfilter(sk, gsf->gf_interface, gsf->gf_numsrc,
+				 gsf->gf_fmode, &gsf->gf_group, gsf->gf_slist);
+out_free_gsf:
+	kfree(gsf);
+	return err;
+}
+
+#ifdef CONFIG_COMPAT
+static int compat_ip_set_mcast_msfilter(struct sock *sk, void __user *optval,
+		int optlen)
+{
+	const int size0 = offsetof(struct compat_group_filter, gf_slist);
+	struct compat_group_filter *gf32;
+	unsigned int n;
+	void *p;
+	int err;
+
+	if (optlen < size0)
+		return -EINVAL;
+	if (optlen > sysctl_optmem_max - 4)
+		return -ENOBUFS;
+
+	p = kmalloc(optlen + 4, GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+	gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
+
+	err = -EFAULT;
+	if (copy_from_user(gf32, optval, optlen))
+		goto out_free_gsf;
+
+	/* numsrc >= (4G-140)/128 overflow in 32 bits */
+	n = gf32->gf_numsrc;
+	err = -ENOBUFS;
+	if (n >= 0x1ffffff)
+		goto out_free_gsf;
+
+	err = -EINVAL;
+	if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen)
+		goto out_free_gsf;
+
+	rtnl_lock();
+	lock_sock(sk);
+
+	/* numsrc >= (4G-140)/128 overflow in 32 bits */
+	err = -ENOBUFS;
+	if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+		goto out_unlock;
+	err = set_mcast_msfilter(sk, gf32->gf_interface, n, gf32->gf_fmode,
+				 &gf32->gf_group, gf32->gf_slist);
+out_unlock:
+	release_sock(sk);
+	rtnl_unlock();
+out_free_gsf:
+	kfree(p);
+	return err;
+}
+#endif
+
 static int do_ip_setsockopt(struct sock *sk, int level,
 			    int optname, char __user *optval, unsigned int optlen)
 {
@@ -1167,37 +1251,8 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 		break;
 	}
 	case MCAST_MSFILTER:
-	{
-		struct group_filter *gsf = NULL;
-
-		if (optlen < GROUP_FILTER_SIZE(0))
-			goto e_inval;
-		if (optlen > sysctl_optmem_max) {
-			err = -ENOBUFS;
-			break;
-		}
-		gsf = memdup_user(optval, optlen);
-		if (IS_ERR(gsf)) {
-			err = PTR_ERR(gsf);
-			break;
-		}
-		/* numsrc >= (4G-140)/128 overflow in 32 bits */
-		if (gsf->gf_numsrc >= 0x1ffffff ||
-		    gsf->gf_numsrc > net->ipv4.sysctl_igmp_max_msf) {
-			err = -ENOBUFS;
-			goto mc_msf_out;
-		}
-		if (GROUP_FILTER_SIZE(gsf->gf_numsrc) > optlen) {
-			err = -EINVAL;
-			goto mc_msf_out;
-		}
-		err = set_mcast_msfilter(sk, gsf->gf_interface,
-					 gsf->gf_numsrc, gsf->gf_fmode,
-					 &gsf->gf_group, gsf->gf_slist);
-mc_msf_out:
-		kfree(gsf);
+		err = ip_set_mcast_msfilter(sk, optval, optlen);
 		break;
-	}
 	case IP_MULTICAST_ALL:
 		if (optlen < 1)
 			goto e_inval;
@@ -1391,52 +1446,7 @@ int compat_ip_setsockopt(struct sock *sk, int level, int optname,
 		return err;
 	}
 	case MCAST_MSFILTER:
-	{
-		const int size0 = offsetof(struct compat_group_filter, gf_slist);
-		struct compat_group_filter *gf32;
-		unsigned int n;
-		void *p;
-
-		if (optlen < size0)
-			return -EINVAL;
-		if (optlen > sysctl_optmem_max - 4)
-			return -ENOBUFS;
-
-		p = kmalloc(optlen + 4, GFP_KERNEL);
-		if (!p)
-			return -ENOMEM;
-		gf32 = p + 4; /* we want ->gf_group and ->gf_slist aligned */
-		if (copy_from_user(gf32, optval, optlen)) {
-			err = -EFAULT;
-			goto mc_msf_out;
-		}
-
-		n = gf32->gf_numsrc;
-		/* numsrc >= (4G-140)/128 overflow in 32 bits */
-		if (n >= 0x1ffffff) {
-			err = -ENOBUFS;
-			goto mc_msf_out;
-		}
-		if (offsetof(struct compat_group_filter, gf_slist[n]) > optlen) {
-			err = -EINVAL;
-			goto mc_msf_out;
-		}
-
-		rtnl_lock();
-		lock_sock(sk);
-		/* numsrc >= (4G-140)/128 overflow in 32 bits */
-		if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
-			err = -ENOBUFS;
-		else
-			err = set_mcast_msfilter(sk, gf32->gf_interface,
-						 n, gf32->gf_fmode,
-						 &gf32->gf_group, gf32->gf_slist);
-		release_sock(sk);
-		rtnl_unlock();
-mc_msf_out:
-		kfree(p);
-		return err;
-	}
+		return compat_ip_set_mcast_msfilter(sk, optval, optlen);
 	}
 
 	err = do_ip_setsockopt(sk, level, optname, optval, optlen);
-- 
2.27.0

