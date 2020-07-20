Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2201D225F33
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgGTMsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbgGTMsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 08:48:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F94C061794;
        Mon, 20 Jul 2020 05:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=mHiWtESnfpmKOGnGR9J/VvKy447qDpvbyAZDADMp9hY=; b=PEIxnuYKVsyL4VbGipt5/qeMxh
        hdLo1McwTpyeTRwLfRW8ZgnD8c7KxJu0KZ/qM4WKOnDjX1k53poojoKl8WDY9mRYwM12pb/UJH4Ua
        CjyNfvuUsmPtIdMkbXPySDCjC9omPKaUZTa4ecBGlbbyDsIipip7l9Xd+wV4Z2UN9foVgIgX+4hsa
        KANIuyKJjP0qKJA+oPLGsnhL2kIOPH9R7JhwnddXENJ3aLzrcjP+UlS8SO64LU6yvSOrerU+9833A
        Vh5Nitqyj536Ahxvaz9eEXy0pVwRw0YrrEuyg//N9bEQT+EfyRUcSOFTCy0UWfNW7ClrBPHCvB1de
        bSeAcmkA==;
Received: from [2001:4bb8:105:4a81:2a8f:15b1:2c3:7be7] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxVDd-0004cd-10; Mon, 20 Jul 2020 12:48:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: [PATCH 19/24] net/ipv6: factor out a ipv6_set_opt_hdr helper
Date:   Mon, 20 Jul 2020 14:47:32 +0200
Message-Id: <20200720124737.118617-20-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720124737.118617-1-hch@lst.de>
References: <20200720124737.118617-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factour out a helper to set the IPv6 option headers from
do_ipv6_setsockopt.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/ipv6/ipv6_sockglue.c | 150 +++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 75 deletions(-)

diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 3897fb55372d38..90442c8366dff2 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -315,6 +315,80 @@ static int compat_ipv6_mcast_join_leave(struct sock *sk, int optname,
 	return ipv6_sock_mc_drop(sk, gr32.gr_interface, &psin6->sin6_addr);
 }
 
+static int ipv6_set_opt_hdr(struct sock *sk, int optname, void __user *optval,
+		int optlen)
+{
+	struct ipv6_pinfo *np = inet6_sk(sk);
+	struct ipv6_opt_hdr *new = NULL;
+	struct net *net = sock_net(sk);
+	struct ipv6_txoptions *opt;
+	int err;
+
+	/* hop-by-hop / destination options are privileged option */
+	if (optname != IPV6_RTHDR && !ns_capable(net->user_ns, CAP_NET_RAW))
+		return -EPERM;
+
+	/* remove any sticky options header with a zero option
+	 * length, per RFC3542.
+	 */
+	if (optlen > 0) {
+		if (!optval)
+			return -EINVAL;
+		if (optlen < sizeof(struct ipv6_opt_hdr) ||
+		    optlen & 0x7 ||
+		    optlen > 8 * 255)
+			return -EINVAL;
+
+		new = memdup_user(optval, optlen);
+		if (IS_ERR(new))
+			return PTR_ERR(new);
+		if (unlikely(ipv6_optlen(new) > optlen)) {
+			kfree(new);
+			return -EINVAL;
+		}
+	}
+
+	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
+	opt = ipv6_renew_options(sk, opt, optname, new);
+	kfree(new);
+	if (IS_ERR(opt))
+		return PTR_ERR(opt);
+
+	/* routing header option needs extra check */
+	err = -EINVAL;
+	if (optname == IPV6_RTHDR && opt && opt->srcrt) {
+		struct ipv6_rt_hdr *rthdr = opt->srcrt;
+		switch (rthdr->type) {
+#if IS_ENABLED(CONFIG_IPV6_MIP6)
+		case IPV6_SRCRT_TYPE_2:
+			if (rthdr->hdrlen != 2 || rthdr->segments_left != 1)
+				goto sticky_done;
+			break;
+#endif
+		case IPV6_SRCRT_TYPE_4:
+		{
+			struct ipv6_sr_hdr *srh =
+				(struct ipv6_sr_hdr *)opt->srcrt;
+
+			if (!seg6_validate_srh(srh, optlen, false))
+				goto sticky_done;
+			break;
+		}
+		default:
+			goto sticky_done;
+		}
+	}
+
+	err = 0;
+	opt = ipv6_update_options(sk, opt);
+sticky_done:
+	if (opt) {
+		atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
+		txopt_put(opt);
+	}
+	return err;
+}
+
 static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 		    char __user *optval, unsigned int optlen)
 {
@@ -580,82 +654,8 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 	case IPV6_RTHDRDSTOPTS:
 	case IPV6_RTHDR:
 	case IPV6_DSTOPTS:
-	{
-		struct ipv6_txoptions *opt;
-		struct ipv6_opt_hdr *new = NULL;
-
-		/* hop-by-hop / destination options are privileged option */
-		retv = -EPERM;
-		if (optname != IPV6_RTHDR && !ns_capable(net->user_ns, CAP_NET_RAW))
-			break;
-
-		/* remove any sticky options header with a zero option
-		 * length, per RFC3542.
-		 */
-		if (optlen == 0)
-			optval = NULL;
-		else if (!optval)
-			goto e_inval;
-		else if (optlen < sizeof(struct ipv6_opt_hdr) ||
-			 optlen & 0x7 || optlen > 8 * 255)
-			goto e_inval;
-		else {
-			new = memdup_user(optval, optlen);
-			if (IS_ERR(new)) {
-				retv = PTR_ERR(new);
-				break;
-			}
-			if (unlikely(ipv6_optlen(new) > optlen)) {
-				kfree(new);
-				goto e_inval;
-			}
-		}
-
-		opt = rcu_dereference_protected(np->opt,
-						lockdep_sock_is_held(sk));
-		opt = ipv6_renew_options(sk, opt, optname, new);
-		kfree(new);
-		if (IS_ERR(opt)) {
-			retv = PTR_ERR(opt);
-			break;
-		}
-
-		/* routing header option needs extra check */
-		retv = -EINVAL;
-		if (optname == IPV6_RTHDR && opt && opt->srcrt) {
-			struct ipv6_rt_hdr *rthdr = opt->srcrt;
-			switch (rthdr->type) {
-#if IS_ENABLED(CONFIG_IPV6_MIP6)
-			case IPV6_SRCRT_TYPE_2:
-				if (rthdr->hdrlen != 2 ||
-				    rthdr->segments_left != 1)
-					goto sticky_done;
-
-				break;
-#endif
-			case IPV6_SRCRT_TYPE_4:
-			{
-				struct ipv6_sr_hdr *srh = (struct ipv6_sr_hdr *)
-							  opt->srcrt;
-
-				if (!seg6_validate_srh(srh, optlen, false))
-					goto sticky_done;
-				break;
-			}
-			default:
-				goto sticky_done;
-			}
-		}
-
-		retv = 0;
-		opt = ipv6_update_options(sk, opt);
-sticky_done:
-		if (opt) {
-			atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
-			txopt_put(opt);
-		}
+		retv = ipv6_set_opt_hdr(sk, optname, optval, optlen);
 		break;
-	}
 
 	case IPV6_PKTINFO:
 	{
-- 
2.27.0

