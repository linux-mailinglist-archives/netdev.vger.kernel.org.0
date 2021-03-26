Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 380F6349F56
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhCZCHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhCZCHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:07:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A2861A48;
        Fri, 26 Mar 2021 02:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724456;
        bh=lfa5bdk6rqYx74iXCKJE0oS6OQbbIs4QqRRFaizEddg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4MEl23rQJb9a3s72ckjSD1vLcSwtDnKqp6c/MW0x2DZkx48YhYEFkQoutvGzGpjk
         Ojr3Ce0cJMaCL1zUJDJqjuV/v7AUecwbKr7E3xpft9dqORzcQZkSy8ePk100mh6+uR
         d696VKWlsMCg1+I5XGX98c6TGhRPpy0rruRcDYhuo3J27vxfA5HI1rXT5hqevx53iL
         DnIEePuwcfEUMwBoFevInGD0I/DDrw8N5QBqxeL4naw1oUOxpab+AloSZfx83NjfhB
         t8NWmrwM/pAc9Wz9YH51N8dOazjUVWHQIHXHv+u88P/7jbH0/Izjl+i8k5hBoHEF4l
         QiexCXx/YU/Vg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/6] ethtool: fec: sanitize ethtool_fecparam->active_fec
Date:   Thu, 25 Mar 2021 19:07:25 -0700
Message-Id: <20210326020727.246828-5-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326020727.246828-1-kuba@kernel.org>
References: <20210326020727.246828-1-kuba@kernel.org>
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
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 include/uapi/linux/ethtool.h | 2 +-
 net/ethtool/ioctl.c          | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 39a7d285b32b..78027aa0161a 100644
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
  *
  * Note that @reserved was never validated on input and ethtool user space
  * left it uninitialized when calling SET. Hence going forward it can only be
  * used to return a value to userspace with GET.
  */
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

