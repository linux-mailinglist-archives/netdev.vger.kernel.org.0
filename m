Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6D526FC30
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgIRMLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:11:53 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:40919 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIRMLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:11:53 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 08:11:49 EDT
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MVNEv-1jsbl63FgN-00SLtH; Fri, 18 Sep 2020 14:05:47 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/2] ethtool: improve compat ioctl handling
Date:   Fri, 18 Sep 2020 14:05:18 +0200
Message-Id: <20200918120536.1464804-1-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:9603rvWeIIU7wH7aODCGTKsrkhxmWKtjqNReOVpZrNtjzZBORYp
 uuCn8MZq0gS2ZpWWlPAb0R5Bb8CXbQ4KKOMARJ5QRUtJ21TDFWJYSgB4TbRfbWEgk6ONGbF
 lxpsG2MDdxjX7RQ4Xh53bjK9EqUCtQ0J0LVSSOfx2TyIp0R72BbzxLHybR9tHJeDtJ0F/gG
 tQfa+3lH0F8cCk79qoIKQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Oug5PeTwLxU=:Y9JJsKZL8QeEVvEWxFB7Nu
 eC/0/Sp24m4FOOc7XKQ6ItHamyd+NPJcWBQiEtAJT8JZngIewQ8UoI0ANj5UmX1BUlU3SL6wG
 KuYXJjrBc5hBBXfljb2X732wFgOzoUrCF3ulPR0E3oRjpVf8iVjtj2C945Dkc35m19NQoxt4h
 QlHfED4AG3ksHpmMJeNLxl4pK8+lgnjoBqPd+pjKSP1/bfYrhhJPvLvkTrNVpkHYuu3dFdMO1
 zYbkUv32LAdfJqegG5gpMi+eBjfpB+MnP8u5k/zdQHPZ1+R9RwsXKFnqnhJgDjmxh+CN3w+62
 MfHw4FgaiYANt/8zIU6fJOLyDkb2TJbTWkVIiCbpe4B+34+QLIOHrQeVEqtEWT115IPrQPEmB
 mEOLL0mNywg3BHzOsihlro5JaqEOuW255FHSlnBV3BaTDnhZv+Lwx9Uad6SLoiIPiSkRKiSOl
 Vt5Ggutjvq87LAnd4H2MANtnd27lNQ+IIrJyDbc9PSRLz/rGCFMxgCVujgfFuP5zPQMzPr5ft
 ENQJg5MP4puMYCqgJxPNVihgQW4TZgDt9XsV928pEigIwzsgcR1vURSTEF0hMVUq70E9VIVUm
 FfVWOchFEI12Wlo9EKcsXvkqHpqXrMWFlor0v1yZWiIttV7SzdWW7x+VQ9UQU70uF4RQ5w4Ym
 n7fy1kilWyuen1KtZernAj8Z3qlf7T4SVB8+J0Z25hneiooxiJxVdjjH4NVUTx2wTe7oHb9ne
 BldT39pJq5ck9FYIfVALM5NOUmNZ0TM4IkvZXpXww+qk0ziM/EC5+P7X7nz+kAie87D/K0K+B
 TSAbxhL3alw5JjQJtx2dOGGXL+h3MIjdxUTwdoMLy6vleHhrl6/FFLF5e3gNEQ3qDq4XXBe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ethtool compat ioctl handling is hidden away in net/socket.c,
which introduces a couple of minor oddities:

- The implementation may end up diverging, as seen in the RXNFC
  extension in commit 84a1d9c48200 ("net: ethtool: extend RXNFC
  API to support RSS spreading of filter matches") that does not work
  in compat mode.

- Most architectures do not need the compat handling at all
  because u64 and compat_u64 have the same alignment.

- On x86, the conversion is done for both x32 and i386 user space,
  but it's actually wrong to do it for x32 and cannot work there.

- On 32-bit Arm, it never worked for compat oabi user space, since
  that needs to do the same conversion but does not.

- It would be nice to get rid of both compat_alloc_user_space()
  and copy_in_user() throughout the kernel.

None of these actually seems to be a serious problem that real
users are likely to encounter, but fixing all of them actually
leads to code that is both shorter and more readable.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/ethtool.h |   4 --
 net/ethtool/ioctl.c     | 129 +++++++++++++++++++++++++++++++++++-----
 net/socket.c            | 125 +-------------------------------------
 3 files changed, 114 insertions(+), 144 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 969a80211df6..283987123022 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -17,8 +17,6 @@
 #include <linux/compat.h>
 #include <uapi/linux/ethtool.h>
 
-#ifdef CONFIG_COMPAT
-
 struct compat_ethtool_rx_flow_spec {
 	u32		flow_type;
 	union ethtool_flow_union h_u;
@@ -38,8 +36,6 @@ struct compat_ethtool_rxnfc {
 	u32				rule_locs[];
 };
 
-#endif /* CONFIG_COMPAT */
-
 #include <linux/rculist.h>
 
 /**
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 441794e0034f..38ae16f095a5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -7,6 +7,7 @@
  * the information ethtool needs.
  */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/capability.h>
@@ -807,6 +808,113 @@ static noinline_for_stack int ethtool_get_sset_info(struct net_device *dev,
 	return ret;
 }
 
+static inline bool ethtool_translate_compat(void)
+{
+#ifdef CONFIG_X86_64
+	/* On x86, translation is needed for i386 but not x32 */
+	return in_ia32_syscall();
+#elif defined(CONFIG_ARM)
+	/* On 32-bit Arm, translation is needed for OABI only */
+	return in_oabi_syscall();
+#else
+	BUILD_BUG_ON(sizeof(struct compat_ethtool_rxnfc) !=
+		     sizeof(struct ethtool_rxnfc));
+#endif
+
+	return 0;
+}
+
+static int ethtool_rxnfc_copy_from_user(struct ethtool_rxnfc *rxnfc,
+			const struct compat_ethtool_rxnfc __user *useraddr,
+			size_t size)
+{
+	/* We expect there to be holes between fs.m_ext and
+	 * fs.ring_cookie and at the end of fs, but nowhere else.
+	 */
+	BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.m_ext) +
+		     sizeof(useraddr->fs.m_ext) !=
+		     offsetof(struct ethtool_rxnfc, fs.m_ext) +
+		     sizeof(rxnfc->fs.m_ext));
+	BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.location) -
+		     offsetof(struct compat_ethtool_rxnfc, fs.ring_cookie) !=
+		     offsetof(struct ethtool_rxnfc, fs.location) -
+		     offsetof(struct ethtool_rxnfc, fs.ring_cookie));
+
+	if (ethtool_translate_compat()) {
+		struct compat_ethtool_rxnfc crxnfc = {};
+
+		if (copy_from_user(&crxnfc, useraddr,
+				   min(size, sizeof(crxnfc))))
+			return -EFAULT;
+
+		*rxnfc = (struct ethtool_rxnfc) {
+			.cmd		= crxnfc.cmd,
+			.flow_type	= crxnfc.flow_type,
+			.data		= crxnfc.data,
+			.fs		= {
+				.flow_type	= crxnfc.fs.flow_type,
+				.h_u		= crxnfc.fs.h_u,
+				.h_ext		= crxnfc.fs.h_ext,
+				.m_u		= crxnfc.fs.m_u,
+				.m_ext		= crxnfc.fs.m_ext,
+				.ring_cookie	= crxnfc.fs.ring_cookie,
+				.location	= crxnfc.fs.location,
+			},
+			.rule_cnt	= crxnfc.rule_cnt,
+		};
+	} else {
+		if (copy_from_user(&rxnfc, useraddr, size))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
+static int ethtool_rxnfc_copy_to_user(void __user *useraddr,
+			const struct ethtool_rxnfc *rxnfc,
+			size_t size, const u32 *rule_buf)
+{
+	int ret;
+
+	if (ethtool_translate_compat()) {
+		struct compat_ethtool_rxnfc crxnfc;
+
+		memset(&crxnfc, 0, sizeof(crxnfc));
+		crxnfc = (struct compat_ethtool_rxnfc) {
+			.cmd		= rxnfc->cmd,
+			.flow_type	= rxnfc->flow_type,
+			.data		= rxnfc->data,
+			.fs		= {
+				.flow_type	= rxnfc->fs.flow_type,
+				.h_u		= rxnfc->fs.h_u,
+				.h_ext		= rxnfc->fs.h_ext,
+				.m_u		= rxnfc->fs.m_u,
+				.m_ext		= rxnfc->fs.m_ext,
+				.ring_cookie	= rxnfc->fs.ring_cookie,
+				.location	= rxnfc->fs.location,
+			},
+			.rule_cnt	= rxnfc->rule_cnt,
+		};
+
+		ret = copy_to_user(useraddr, &crxnfc, min(size, sizeof(crxnfc)));
+		useraddr += offsetof(struct compat_ethtool_rxnfc, rule_locs);
+	} else {
+		ret = copy_to_user(useraddr, &rxnfc, size);
+		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
+	}
+
+	if (ret)
+		return -EFAULT;
+
+	if (rule_buf) {
+		if (copy_to_user(useraddr, rule_buf,
+				 rxnfc->rule_cnt * sizeof(u32)))
+			return -EFAULT;
+	}
+
+	return 0;
+}
+
 static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 						u32 cmd, void __user *useraddr)
 {
@@ -825,7 +933,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		info_size = (offsetof(struct ethtool_rxnfc, data) +
 			     sizeof(info.data));
 
-	if (copy_from_user(&info, useraddr, info_size))
+	if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
 		return -EFAULT;
 
 	rc = dev->ethtool_ops->set_rxnfc(dev, &info);
@@ -833,7 +941,7 @@ static noinline_for_stack int ethtool_set_rxnfc(struct net_device *dev,
 		return rc;
 
 	if (cmd == ETHTOOL_SRXCLSRLINS &&
-	    copy_to_user(useraddr, &info, info_size))
+	    ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, NULL))
 		return -EFAULT;
 
 	return 0;
@@ -859,7 +967,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 		info_size = (offsetof(struct ethtool_rxnfc, data) +
 			     sizeof(info.data));
 
-	if (copy_from_user(&info, useraddr, info_size))
+	if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
 		return -EFAULT;
 
 	/* If FLOW_RSS was requested then user-space must be using the
@@ -867,7 +975,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 	 */
 	if (cmd == ETHTOOL_GRXFH && info.flow_type & FLOW_RSS) {
 		info_size = sizeof(info);
-		if (copy_from_user(&info, useraddr, info_size))
+		if (ethtool_rxnfc_copy_from_user(&info, useraddr, info_size))
 			return -EFAULT;
 		/* Since malicious users may modify the original data,
 		 * we need to check whether FLOW_RSS is still requested.
@@ -893,18 +1001,7 @@ static noinline_for_stack int ethtool_get_rxnfc(struct net_device *dev,
 	if (ret < 0)
 		goto err_out;
 
-	ret = -EFAULT;
-	if (copy_to_user(useraddr, &info, info_size))
-		goto err_out;
-
-	if (rule_buf) {
-		useraddr += offsetof(struct ethtool_rxnfc, rule_locs);
-		if (copy_to_user(useraddr, rule_buf,
-				 info.rule_cnt * sizeof(u32)))
-			goto err_out;
-	}
-	ret = 0;
-
+	ret = ethtool_rxnfc_copy_to_user(useraddr, &info, info_size, rule_buf);
 err_out:
 	kfree(rule_buf);
 
diff --git a/net/socket.c b/net/socket.c
index dbbe8ea7d395..3fe30ba2a09a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3121,128 +3121,6 @@ static int compat_dev_ifconf(struct net *net, struct compat_ifconf __user *uifc3
 	return 0;
 }
 
-static int ethtool_ioctl(struct net *net, struct compat_ifreq __user *ifr32)
-{
-	struct compat_ethtool_rxnfc __user *compat_rxnfc;
-	bool convert_in = false, convert_out = false;
-	size_t buf_size = 0;
-	struct ethtool_rxnfc __user *rxnfc = NULL;
-	struct ifreq ifr;
-	u32 rule_cnt = 0, actual_rule_cnt;
-	u32 ethcmd;
-	u32 data;
-	int ret;
-
-	if (get_user(data, &ifr32->ifr_ifru.ifru_data))
-		return -EFAULT;
-
-	compat_rxnfc = compat_ptr(data);
-
-	if (get_user(ethcmd, &compat_rxnfc->cmd))
-		return -EFAULT;
-
-	/* Most ethtool structures are defined without padding.
-	 * Unfortunately struct ethtool_rxnfc is an exception.
-	 */
-	switch (ethcmd) {
-	default:
-		break;
-	case ETHTOOL_GRXCLSRLALL:
-		/* Buffer size is variable */
-		if (get_user(rule_cnt, &compat_rxnfc->rule_cnt))
-			return -EFAULT;
-		if (rule_cnt > KMALLOC_MAX_SIZE / sizeof(u32))
-			return -ENOMEM;
-		buf_size += rule_cnt * sizeof(u32);
-		fallthrough;
-	case ETHTOOL_GRXRINGS:
-	case ETHTOOL_GRXCLSRLCNT:
-	case ETHTOOL_GRXCLSRULE:
-	case ETHTOOL_SRXCLSRLINS:
-		convert_out = true;
-		fallthrough;
-	case ETHTOOL_SRXCLSRLDEL:
-		buf_size += sizeof(struct ethtool_rxnfc);
-		convert_in = true;
-		rxnfc = compat_alloc_user_space(buf_size);
-		break;
-	}
-
-	if (copy_from_user(&ifr.ifr_name, &ifr32->ifr_name, IFNAMSIZ))
-		return -EFAULT;
-
-	ifr.ifr_data = convert_in ? rxnfc : (void __user *)compat_rxnfc;
-
-	if (convert_in) {
-		/* We expect there to be holes between fs.m_ext and
-		 * fs.ring_cookie and at the end of fs, but nowhere else.
-		 */
-		BUILD_BUG_ON(offsetof(struct compat_ethtool_rxnfc, fs.m_ext) +
-			     sizeof(compat_rxnfc->fs.m_ext) !=
-			     offsetof(struct ethtool_rxnfc, fs.m_ext) +
-			     sizeof(rxnfc->fs.m_ext));
-		BUILD_BUG_ON(
-			offsetof(struct compat_ethtool_rxnfc, fs.location) -
-			offsetof(struct compat_ethtool_rxnfc, fs.ring_cookie) !=
-			offsetof(struct ethtool_rxnfc, fs.location) -
-			offsetof(struct ethtool_rxnfc, fs.ring_cookie));
-
-		if (copy_in_user(rxnfc, compat_rxnfc,
-				 (void __user *)(&rxnfc->fs.m_ext + 1) -
-				 (void __user *)rxnfc) ||
-		    copy_in_user(&rxnfc->fs.ring_cookie,
-				 &compat_rxnfc->fs.ring_cookie,
-				 (void __user *)(&rxnfc->fs.location + 1) -
-				 (void __user *)&rxnfc->fs.ring_cookie))
-			return -EFAULT;
-		if (ethcmd == ETHTOOL_GRXCLSRLALL) {
-			if (put_user(rule_cnt, &rxnfc->rule_cnt))
-				return -EFAULT;
-		} else if (copy_in_user(&rxnfc->rule_cnt,
-					&compat_rxnfc->rule_cnt,
-					sizeof(rxnfc->rule_cnt)))
-			return -EFAULT;
-	}
-
-	ret = dev_ioctl(net, SIOCETHTOOL, &ifr, NULL);
-	if (ret)
-		return ret;
-
-	if (convert_out) {
-		if (copy_in_user(compat_rxnfc, rxnfc,
-				 (const void __user *)(&rxnfc->fs.m_ext + 1) -
-				 (const void __user *)rxnfc) ||
-		    copy_in_user(&compat_rxnfc->fs.ring_cookie,
-				 &rxnfc->fs.ring_cookie,
-				 (const void __user *)(&rxnfc->fs.location + 1) -
-				 (const void __user *)&rxnfc->fs.ring_cookie) ||
-		    copy_in_user(&compat_rxnfc->rule_cnt, &rxnfc->rule_cnt,
-				 sizeof(rxnfc->rule_cnt)))
-			return -EFAULT;
-
-		if (ethcmd == ETHTOOL_GRXCLSRLALL) {
-			/* As an optimisation, we only copy the actual
-			 * number of rules that the underlying
-			 * function returned.  Since Mallory might
-			 * change the rule count in user memory, we
-			 * check that it is less than the rule count
-			 * originally given (as the user buffer size),
-			 * which has been range-checked.
-			 */
-			if (get_user(actual_rule_cnt, &rxnfc->rule_cnt))
-				return -EFAULT;
-			if (actual_rule_cnt < rule_cnt)
-				rule_cnt = actual_rule_cnt;
-			if (copy_in_user(&compat_rxnfc->rule_locs[0],
-					 &rxnfc->rule_locs[0],
-					 rule_cnt * sizeof(u32)))
-				return -EFAULT;
-		}
-	}
-
-	return 0;
-}
-
 static int compat_siocwandev(struct net *net, struct compat_ifreq __user *uifr32)
 {
 	compat_uptr_t uptr32;
@@ -3397,8 +3275,6 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return old_bridge_ioctl(argp);
 	case SIOCGIFCONF:
 		return compat_dev_ifconf(net, argp);
-	case SIOCETHTOOL:
-		return ethtool_ioctl(net, argp);
 	case SIOCWANDEV:
 		return compat_siocwandev(net, argp);
 	case SIOCGIFMAP:
@@ -3411,6 +3287,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 		return sock->ops->gettstamp(sock, argp, cmd == SIOCGSTAMP_OLD,
 					    !COMPAT_USE_64BIT_TIME);
 
+	case SIOCETHTOOL:
 	case SIOCBONDSLAVEINFOQUERY:
 	case SIOCBONDINFOQUERY:
 	case SIOCSHWTSTAMP:
-- 
2.27.0

