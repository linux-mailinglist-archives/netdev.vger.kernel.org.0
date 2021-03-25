Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0F2348648
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbhCYBMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239549AbhCYBMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52A7261A0A;
        Thu, 25 Mar 2021 01:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634730;
        bh=vjHHuOcIYUWeM7cgt0LJMNjhI8c6YLJazfEC6WJooJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsDp4EoOT1ay8CnyjL1GGTBjo2t+RHx5auA2WRWYB9Gz5jYHK0Sb5wFU7+z9YNCNX
         m2O7+nb68AO2ovuf+o8mn92WpyHWDgLV5VdtSqsqMjx9xUVP8ce3YckWpHeAtilhuK
         Q/R+VUYq0UPT1k4SUFilSb0TZS1BxUnjrI2s0qgK7sIBeaybyvagftQ8BXatNHroDp
         AThfba9Ztg9aoFgvQG2By1OPlpO52DX/b3dTxTBsc5wH6eT/stYvxgU6MwByIH+9Q9
         R3HtCaGU8A53UuUKVgwswHa6pYf/+/Wjuejxe/RaHLK+7y0ksRZvJO/N1GyEPwnZhq
         VWC5d0ZKGHmAA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/6] ethtool: fec: sanitize ethtool_fecparam->active_fec
Date:   Wed, 24 Mar 2021 18:11:58 -0700
Message-Id: <20210325011200.145818-5-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325011200.145818-1-kuba@kernel.org>
References: <20210325011200.145818-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ethtool_fecparam::active_fec is a GET-only field,
all in-tree drivers correctly ignore it on SET. Clear
the field on SET to avoid any confusion. Again, we can't
reject non-zero now since ethtool user space does not
zero-init the param correctly.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 2 +-
 net/ethtool/ioctl.c          | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9e2682a67460..517b68c5fcec 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1374,15 +1374,15 @@ struct ethtool_per_queue_op {
 	__u32	queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
 	char	data[];
 };
 
 /**
  * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
- * @active_fec: FEC mode which is active on the port
+ * @active_fec: FEC mode which is active on the port, GET only.
  * @fec: Bitmask of supported/configured FEC modes
  * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
  */
 struct ethtool_fecparam {
 	__u32   cmd;
 	/* bitmask of FEC modes */
 	__u32   active_fec;
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index be3549023d89..237ffe5440ef 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2582,14 +2582,15 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
 	if (!dev->ethtool_ops->set_fecparam)
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
 		return -EFAULT;
 
+	fecparam.active_fec = 0;
 	fecparam.reserved = 0;
 
 	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
 }
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
-- 
2.30.2

