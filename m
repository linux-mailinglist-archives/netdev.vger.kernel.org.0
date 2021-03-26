Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4598C34B01E
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 21:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhCZUXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 16:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229957AbhCZUW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 16:22:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A619D61A26;
        Fri, 26 Mar 2021 20:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616790148;
        bh=QHjnw3KqPF5iOeQnEXEE+suiSKyU0v8PKHJRx8TGUWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geekgQiMcZgXe0Q5pdvbrrSwzG+uBNNlqjgcrx8Aaw5Z9qUaB5amjzO1O5vQZFY+v
         3ABepfnWO+7/Vf2dMchBgJA6rOEWDUGtJiH03SdI9sP/SGZwVoh1mL26dyHysQGsds
         ojhF15ddbwFlJOL3dY9tThS+jJFa0ZQ0pbH05QFKydgbIxhvk1xcgKl4pY0NnMKO/Z
         nT5yXICwyEUpRCGiBQPOGt0erBfwSrYWkpRb3A43k0AUxQOAo/rK6oorMCERqbNXKb
         1so1hX5ptPUCi+910bKaPqcYRWPiIVE679zVXQtgiMWj+4VSfar2Nz3H8HKlTdAwSH
         MwVE0VKsr6Mjg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 2/3] ethtool: fec: fix FEC_NONE check
Date:   Fri, 26 Mar 2021 13:22:22 -0700
Message-Id: <20210326202223.302085-3-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326202223.302085-1-kuba@kernel.org>
References: <20210326202223.302085-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan points out we need to use the mask not the bit (which is 0).

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 42ce127d9864 ("ethtool: fec: sanitize ethtool_fecparam->fec")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 8797533ddc4b..26b3e7086075 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2586,7 +2586,7 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 	if (copy_from_user(&fecparam, useraddr, sizeof(fecparam)))
 		return -EFAULT;
 
-	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE_BIT)
+	if (!fecparam.fec || fecparam.fec & ETHTOOL_FEC_NONE)
 		return -EINVAL;
 
 	fecparam.active_fec = 0;
-- 
2.30.2

