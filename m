Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706AD349F54
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhCZCHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:50762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhCZCHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 318C961A46;
        Fri, 26 Mar 2021 02:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724455;
        bh=xr4wdKqvt3LlM8CGlrjdWm5U5X39X5Dj2+0QKh5YAA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hE2+7B5CSnRFYqZaj7JkJf/CFqpemsZua9He1uDqcfHXN56JtEvnua0/AuCd68XrY
         cTH99V3rpZAumNiop8J0TvYF1KXZ3eEtGpEDGS57QMgeOAiGntAxCGJBK5r1Q3pJoD
         SAuHFmp8MRIUm+a2vnSX2CZKq5qWjgNaZ5rRyh2jxI0EnSXizZpHO+8tLNuwjdylfV
         T9Tgj30MZemqO5i4GFJCk89Gf/BeFFETPLcVgoj4LPgKRHnQMoAFoT83HA4RNq4BeP
         d1yePk+TC6JngmGts2jw22CBZNTuv1Wd51gHS2t1OBb8NKREaoS2ucWG3NYtZYAU3N
         tzlx5tIcxCNKA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 3/6] ethtool: fec: sanitize ethtool_fecparam->reserved
Date:   Thu, 25 Mar 2021 19:07:24 -0700
Message-Id: <20210326020727.246828-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326020727.246828-1-kuba@kernel.org>
References: <20210326020727.246828-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ethtool_fecparam::reserved is never looked at by the core.
Make sure it's actually 0. Unfortunately we can't return an error
because old ethtool doesn't zero-initialize the structure for SET.
On GET we can be more verbose, there are no in tree (ab)users.

Fix up the kdoc on the structure. Remove the mention of FEC
bypass. Seems like a niche thing to configure in the first
place.

v2: - also mention the zero-init-on-SET kerfuffle in kdoc

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 6 +++++-
 net/ethtool/ioctl.c          | 5 +++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 36bf435d232c..39a7d285b32b 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1376,15 +1376,19 @@ struct ethtool_per_queue_op {
 };
 
 /**
  * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
  * @active_fec: FEC mode which is active on the port
  * @fec: Bitmask of supported/configured FEC modes
- * @rsvd: Reserved for future extensions. i.e FEC bypass feature.
+ * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
+ *
+ * Note that @reserved was never validated on input and ethtool user space
+ * left it uninitialized when calling SET. Hence going forward it can only be
+ * used to return a value to userspace with GET.
  */
 struct ethtool_fecparam {
 	__u32   cmd;
 	/* bitmask of FEC modes */
 	__u32   active_fec;
 	__u32   fec;
 	__u32   reserved;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 0788cc3b3114..be3549023d89 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2564,14 +2564,17 @@ static int ethtool_get_fecparam(struct net_device *dev, void __user *useraddr)
 	if (!dev->ethtool_ops->get_fecparam)
 		return -EOPNOTSUPP;
 
 	rc = dev->ethtool_ops->get_fecparam(dev, &fecparam);
 	if (rc)
 		return rc;
 
+	if (WARN_ON_ONCE(fecparam.reserved))
+		fecparam.reserved = 0;
+
 	if (copy_to_user(useraddr, &fecparam, sizeof(fecparam)))
 		return -EFAULT;
 	return 0;
 }
 
 static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 {
@@ -2579,14 +2582,16 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
 	if (!dev->ethtool_ops->set_fecparam)
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
 		return -EFAULT;
 
+	fecparam.reserved = 0;
+
 	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
 }
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
 int dev_ethtool(struct net *net, struct ifreq *ifr)
 {
-- 
2.30.2

