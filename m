Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F31B3F9554
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 09:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244477AbhH0HtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 03:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244473AbhH0HtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 03:49:09 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAF4C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 00:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=63O27sl2HS63Jmx4LYCPIUAUX94ppQodjW+AkMmfKFw=; t=1630050501; x=1631260101; 
        b=ENVjqCUHGe7Jm1NXlvSOQ/DB90rnxOzR3CD4aEN9XuryV6z5iAU3J6rCCsNQ7zyNZ17nkaSa084
        WNmbtUva0ZqHamD+/UcIKH/zhO96KHgPhUpz41UMtRVZJE4inXAGysWg2I1NGksFIqxqb+jAXy43d
        dpzz7tNUjPOfj4rgTyfXNx4VpLroFx6mEqpD+ohdjTVBYoFcvKzpgttxeyQpfc89ffjnEvb+XcQ9X
        a+Zz/0pXXYGEswg3qIld+PcrmwwYWdarfuUCYWPaF+Xfxc885B87Zoz0Mjh/dD2aryQadvttzoxtS
        f0hGunL9nopmglkSAn043dNZlg6tpKAxwYKw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mJWaz-00GWYE-3D; Fri, 27 Aug 2021 09:48:13 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-um@lists.infradead.org, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net-next] um: vector: adjust to coalesce API changes
Date:   Fri, 27 Aug 2021 09:48:04 +0200
Message-Id: <20210827094759.f3ab06684bd0.I985181cc00fe017cfe6413d9e1bb720cbe852e6d@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

The API changes were propagated to most drivers, but clearly
arch/um/drivers/ was missed, perhaps due to looking only at
the drivers/ folder. Fix that.

Fixes: f3ccfda19319 ("ethtool: extend coalesce setting uAPI with CQE mode")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 arch/um/drivers/vector_kern.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index d27a2a9faf3e..cde6db184c26 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1488,7 +1488,9 @@ static void vector_get_ethtool_stats(struct net_device *dev,
 }
 
 static int vector_get_coalesce(struct net_device *netdev,
-					struct ethtool_coalesce *ec)
+			       struct ethtool_coalesce *ec,
+			       struct kernel_ethtool_coalesce *kernel_coal,
+			       struct netlink_ext_ack *extack)
 {
 	struct vector_private *vp = netdev_priv(netdev);
 
@@ -1497,7 +1499,9 @@ static int vector_get_coalesce(struct net_device *netdev,
 }
 
 static int vector_set_coalesce(struct net_device *netdev,
-					struct ethtool_coalesce *ec)
+			       struct ethtool_coalesce *ec,
+			       struct kernel_ethtool_coalesce *kernel_coal,
+			       struct netlink_ext_ack *extack)
 {
 	struct vector_private *vp = netdev_priv(netdev);
 
-- 
2.31.1

