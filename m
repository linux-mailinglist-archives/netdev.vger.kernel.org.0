Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AD0349F57
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhCZCHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230222AbhCZCHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A757C61A4A;
        Fri, 26 Mar 2021 02:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724457;
        bh=eRD9lHZNWDxxTBp3glA1bUjQj+ProQ4egt1py4UkulM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1c72ozrkpqXw7mVE203GDPazk+vK3E8JeLMg7vqmFCkKXkQLMhDLZdsKj4kfaCXs
         5l+3MAQ4msq1MS07dJ2Bf2wVcnx5N8B2EsADxP+xYJ5Fe60yl2czHA6uQ6wl1HqgA6
         S1LBqGto5PtrRj7aCiqmzdza46z6WjRI6958i1cPTEqtOtb8mU9mgBtv7qiqX22J9S
         N14fkocGGJXDbxLNM0xWb70698S90FcQ4rCuYcL6L1ftQiNitlHQ1KsI8EKFR6xZyZ
         mKsZRSsNpqHkD1JoVj9zGwEHNIBPXRgF69XpKgJ68QC5ALeh2ChtCarvuyA3E1Ps7A
         LAObgmcQxgSYQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/6] ethtool: fec: sanitize ethtool_fecparam->fec
Date:   Thu, 25 Mar 2021 19:07:26 -0700
Message-Id: <20210326020727.246828-6-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326020727.246828-1-kuba@kernel.org>
References: <20210326020727.246828-1-kuba@kernel.org>
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

v2: - use mask not bit pos

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 237ffe5440ef..26b3e7086075 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2582,14 +2582,17 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 
 	if (!dev->ethtool_ops->set_fecparam)
 		return -EOPNOTSUPP;
 
 	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
 		return -EFAULT;
 
+	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE)
+		return -EINVAL;
+
 	fecparam.active_fec = 0;
 	fecparam.reserved = 0;
 
 	return dev->ethtool_ops->set_fecparam(dev, &fecparam);
 }
 
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
-- 
2.30.2

