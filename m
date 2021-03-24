Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF05347BC7
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbhCXPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:10:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45737 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236491AbhCXPJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:09:57 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lP58o-000209-D7; Wed, 24 Mar 2021 15:09:50 +0000
From:   Colin King <colin.king@canonical.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: bridge: Fix missing return assignment from br_vlan_replay_one call
Date:   Wed, 24 Mar 2021 15:09:50 +0000
Message-Id: <20210324150950.253698-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to br_vlan_replay_one is returning an error return value but
this is not being assigned to err and the following check on err is
currently always false because err was initialized to zero. Fix this
by assigning err.

Addresses-Coverity: ("'Constant' variable guards dead code")
Fixes: 22f67cdfae6a ("net: bridge: add helper to replay VLANs installed on port")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/bridge/br_vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index ca8daccff217..7422691230b1 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1815,7 +1815,7 @@ int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 		if (!br_vlan_should_use(v))
 			continue;
 
-		br_vlan_replay_one(nb, dev, &vlan, extack);
+		err = br_vlan_replay_one(nb, dev, &vlan, extack);
 		if (err)
 			return err;
 	}
-- 
2.30.2

