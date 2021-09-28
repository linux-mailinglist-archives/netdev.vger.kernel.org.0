Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDE041B7CE
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242594AbhI1TzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:55:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242492AbhI1TzN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 15:55:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EAC561139;
        Tue, 28 Sep 2021 19:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632858813;
        bh=e6MtrjsgtQPw9bfe+NcBnbhVfsOEoU0GU4nhflE6ch8=;
        h=Date:From:To:Cc:Subject:From;
        b=NCQ9+jzB5f6pisllAQXlnmIvPZYIPhCkeQidb19IDqRI7VPivuLARbfSI3v1X3qj4
         lpxGvQBONpAsPAnitBBzeTXLroMxTdq2s+Fml0gMY/8Dl37RJb9vSMFLVcS76yIXoB
         p+551u+4+32fJcT7vDOfTAIW9MfoodTg1dtwX1/0ACbd2Qi7spsokUFC6L7QNpVv8K
         uqGLNkrXp4eJwBmXcrcITbib6mky9QV0M/gtVV12lVJcoMELKUIVHSArSx7YQBoAtE
         Qf6ifuU4uYe5FIKnsvd2YAPsmgAek96+5Za9YBaGyhy1XDhFZZcRXoZm8Ri/zqwdxR
         e4neogR1a8UTQ==
Date:   Tue, 28 Sep 2021 14:57:35 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][net-next] ethtool: ioctl: Use array_size() helper in
 copy_{from,to}_user()
Message-ID: <20210928195735.GA264809@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use array_size() helper instead of the open-coded version in
copy_{from,to}_user().  These sorts of multiplication factors
need to be wrapped in array_size().

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/ethtool/ioctl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 999e2a6bed13..bf6e8c2f9bf7 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -89,7 +89,8 @@ static int ethtool_get_features(struct net_device *dev, void __user *useraddr)
 	if (copy_to_user(useraddr, &cmd, sizeof(cmd)))
 		return -EFAULT;
 	useraddr += sizeof(cmd);
-	if (copy_to_user(useraddr, features, copy_size * sizeof(*features)))
+	if (copy_to_user(useraddr, features,
+			 array_size(copy_size, sizeof(*features))))
 		return -EFAULT;
 
 	return 0;
@@ -799,7 +800,7 @@ static noinline_for_stack int ethtool_get_sset_info(struct net_device *dev,
 		goto out;
 
 	useraddr += offsetof(struct ethtool_sset_info, data);
-	if (copy_to_user(useraddr, info_buf, idx * sizeof(u32)))
+	if (copy_to_user(useraddr, info_buf, array_size(idx, sizeof(u32))))
 		goto out;
 
 	ret = 0;
@@ -1022,7 +1023,7 @@ static int ethtool_copy_validate_indir(u32 *indir, void __user *useraddr,
 {
 	int i;
 
-	if (copy_from_user(indir, useraddr, size * sizeof(indir[0])))
+	if (copy_from_user(indir, useraddr, array_size(size, sizeof(indir[0]))))
 		return -EFAULT;
 
 	/* Validate ring indices */
@@ -1895,7 +1896,7 @@ static int ethtool_self_test(struct net_device *dev, char __user *useraddr)
 	if (copy_to_user(useraddr, &test, sizeof(test)))
 		goto out;
 	useraddr += sizeof(test);
-	if (copy_to_user(useraddr, data, test.len * sizeof(u64)))
+	if (copy_to_user(useraddr, data, array_size(test.len, sizeof(u64))))
 		goto out;
 	ret = 0;
 
@@ -1937,7 +1938,8 @@ static int ethtool_get_strings(struct net_device *dev, void __user *useraddr)
 		goto out;
 	useraddr += sizeof(gstrings);
 	if (gstrings.len &&
-	    copy_to_user(useraddr, data, gstrings.len * ETH_GSTRING_LEN))
+	    copy_to_user(useraddr, data,
+			 array_size(gstrings.len, ETH_GSTRING_LEN)))
 		goto out;
 	ret = 0;
 
-- 
2.27.0

