Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DF3348647
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbhCYBMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239548AbhCYBMJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34B5D61A23;
        Thu, 25 Mar 2021 01:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634729;
        bh=LwjQ3fWWVDGxr02YqLA6dfhtrvstH3EUV5Luh6ZVRGQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNxpk2kPbX0TgOf1jGAnJv5973NNLvvdJDulq6+TNI8E78Hs964z7hD1SNFOASjoI
         nLxp6/paMRtOypNyP/CmoLAepO9qQX4K0QG+09m+xTi1GBasQaWBAxUpQwWSzAx0Vu
         RxGW+koelyVYenmfieEV0jHberfCGVTHpYHoVMVLxz3rvDn62gQDTf5sGlwjrsNXXy
         KwgI3uXFX+pX/MRfPLFioH9olChDsSAeigqkKtsPX5tcgzbmp3tjI2SLH7N+nVTStG
         FdcoUZxjIBh5pLV5yYKYdBTEwrMGEgDcBq8XZTEOY0+i25YeWF24dCy6sOCOs7ixji
         ZVeAYamItQtCw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/6] ethtool: fec: sanitize ethtool_fecparam->reserved
Date:   Wed, 24 Mar 2021 18:11:57 -0700
Message-Id: <20210325011200.145818-4-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325011200.145818-1-kuba@kernel.org>
References: <20210325011200.145818-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 2 +-
 net/ethtool/ioctl.c          | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 36bf435d232c..9e2682a67460 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1376,15 +1376,15 @@ struct ethtool_per_queue_op {
 };
 
 /**
  * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
  * @active_fec: FEC mode which is active on the port
  * @fec: Bitmask of supported/configured FEC modes
- * @rsvd: Reserved for future extensions. i.e FEC bypass feature.
+ * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
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

