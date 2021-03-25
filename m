Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2D3348649
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhCYBMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239550AbhCYBML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D3A261A1F;
        Thu, 25 Mar 2021 01:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634730;
        bh=G7JCaY0dsYnbcF4Pf8DRquwTxCW+RvwNRBkdNGQHqoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C0hLikrXNV4qZr8CkhZLyD4T7vJS2DciqJ7JNi38DH7yxOBEd4D0tpYvibJCDhpIU
         8aIYvVMPJ8H2y0ajJUZayuMdOrZGVZDWFS6Te65PiHvVCkm5tL6dT7xEKpPQ8k3I64
         l9BaOZHpSjg1Xg9dZl18edtm1i9a3aWyTews1RqZBhyw/XEgbkfy6f8l4F8COS7djB
         xt6X1tBV9UZMP2m3LA1Nje2Iv2+o2TxnSGpsWq3DGFegRaC7s253GAaNdJ8VZ/uI04
         Pd2cihn4z0TZ+khNgXgoov6YlxUOZMadycU9/RTgZLjY7vIX0Oj+VjtFh2QYWudCeY
         S0a8aHoiqHFWw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 5/6] ethtool: fec: sanitize ethtool_fecparam->fec
Date:   Wed, 24 Mar 2021 18:11:59 -0700
Message-Id: <20210325011200.145818-6-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325011200.145818-1-kuba@kernel.org>
References: <20210325011200.145818-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reject NONE on set, this mode means device does not support
FEC so it's a little out of place in the set interface.

This should be safe to do - user space ethtool does not allow
the use of NONE on set. A few drivers treat it the same as OFF,
but none use it instead of OFF.

Similarly reject an empty FEC mask. The common user space tool
will not send such requests and most drivers correctly reject
it already.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 237ffe5440ef..8797533ddc4b 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2582,14 +2582,17 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
 	if (!dev->ethtool_ops->set_fecparam)
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
 		return -EFAULT;
 
+	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE_BIT)
+		return -EINVAL;
+
 	fecparam.active_fec = 0;
 	fecparam.reserved = 0;
 
 	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
 }
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
-- 
2.30.2

