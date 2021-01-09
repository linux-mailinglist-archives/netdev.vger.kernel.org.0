Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977612EFC87
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbhAIAyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:54:41 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41704 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAIAyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:54:41 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 796A920B6C40; Fri,  8 Jan 2021 16:54:00 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 796A920B6C40
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1610153640;
        bh=nEuRwFOdEnGfRfNfwrOA/fu41ZxQZ2FqFk6gkuksdSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmSv3Jg7n5NFLuIimbRfsV4En1Jbx1RLuEIEm61xCDBuoPTQ+KN1CRn1xd3IvU/iO
         proSToQ7X0bJE2u+STE8HoRJcYQlIBullo9GVk4iRWeTypzuXXwqJngNjTTmHDlgun
         NxuD9Uk+Eh/FnYKvbsBYnUqHVpRcrehIk3HuOgXE=
From:   Long Li <longli@linuxonhyperv.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH v2 1/3] hv_netvsc: Check VF datapath when sending traffic to VF
Date:   Fri,  8 Jan 2021 16:53:41 -0800
Message-Id: <1610153623-17500-2-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
References: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

The driver needs to check if the datapath has been switched to VF before
sending traffic to VF.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
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

