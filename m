Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17792EB782
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 02:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbhAFBRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 20:17:00 -0500
Received: from linux.microsoft.com ([13.77.154.182]:54186 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbhAFBQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 20:16:59 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 092F020B7192; Tue,  5 Jan 2021 17:16:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 092F020B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1609895779;
        bh=zm8eC3xF7Hbpi33J1Uuo/TnBL28HOT6rtMl6r25E81M=;
        h=From:To:Cc:Subject:Date:From;
        b=MBn80HGVHCr1Ovb9MezP70/Ql/+s95GPGjaeYslojxb2Hg6bL+Vhsy+2pyquLvUtN
         hge5GGxTETUHWOBgZ+rrCITkM9s60SxT4zqqsnqwFNKTYQBWpDxTv/gvP/MwCTyXPA
         y//rZkafgJ+8++58Njdda9ETIymD+2ZI4bmcxr+c=
From:   Long Li <longli@linuxonhyperv.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH 1/3] hv_netvsc: Check VF datapath when sending traffic to VF
Date:   Tue,  5 Jan 2021 17:15:51 -0800
Message-Id: <1609895753-30445-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

The driver needs to check if the datapath has been switched to VF before
sending traffic to VF.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f32f28311d57..5dd4f37afa3d 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -539,7 +539,8 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 	 */
 	vf_netdev = rcu_dereference_bh(net_device_ctx->vf_netdev);
 	if (vf_netdev && netif_running(vf_netdev) &&
-	    netif_carrier_ok(vf_netdev) && !netpoll_tx_running(net))
+	    netif_carrier_ok(vf_netdev) && !netpoll_tx_running(net) &&
+	    net_device_ctx->data_path_is_vf)
 		return netvsc_vf_xmit(net, vf_netdev, skb);
 
 	/* We will atmost need two pages to describe the rndis
-- 
2.27.0

