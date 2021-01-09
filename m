Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CBC2EFC82
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 01:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAIAyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 19:54:46 -0500
Received: from linux.microsoft.com ([13.77.154.182]:41740 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbhAIAyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 19:54:46 -0500
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id D4F8D20B6C42; Fri,  8 Jan 2021 16:54:05 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D4F8D20B6C42
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1610153645;
        bh=a9mYqRWHBtW/4GhoIGv+qIDowOAzSYAjrMOFelGtva8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cwsd1IsSZqOe3XwG/mwVPmC5GeHuXrqadX+yHNOpLA3qSE5bdKKTOrIuQM8QJi5yT
         YAzSRkXQ7jg65PIZgogPcSCNNNsL77XAHhz6xj8alQgSV8eUvc0g3plKotOuFkpekK
         4NxIBAdFDgiXp596sUOsiYx2imNS1fAS4ARjsHpQ=
From:   Long Li <longli@linuxonhyperv.com>
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Long Li <longli@microsoft.com>
Subject: [PATCH v2 3/3] hv_netvsc: Process NETDEV_GOING_DOWN on VF hot remove
Date:   Fri,  8 Jan 2021 16:53:43 -0800
Message-Id: <1610153623-17500-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
References: <1610153623-17500-1-git-send-email-longli@linuxonhyperv.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

On VF hot remove, NETDEV_GOING_DOWN is sent to notify the VF is about to
go down. At this time, the VF is still sending/receiving traffic and we
request the VSP to switch datapath.

On completion, the datapath is switched to synthetic and we can proceed
with VF hot remove.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/netvsc_drv.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 64ae5f4e974e..75b4d6703cf1 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2382,12 +2382,15 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
  * During hibernation, if a VF NIC driver (e.g. mlx5) preserves the network
  * interface, there is only the CHANGE event and no UP or DOWN event.
  */
-static int netvsc_vf_changed(struct net_device *vf_netdev)
+static int netvsc_vf_changed(struct net_device *vf_netdev, unsigned long event)
 {
 	struct net_device_context *net_device_ctx;
 	struct netvsc_device *netvsc_dev;
 	struct net_device *ndev;
-	bool vf_is_up = netif_running(vf_netdev);
+	bool vf_is_up = false;
+
+	if (event != NETDEV_GOING_DOWN)
+		vf_is_up = netif_running(vf_netdev);
 
 	ndev = get_netvsc_byref(vf_netdev);
 	if (!ndev)
@@ -2716,7 +2719,8 @@ static int netvsc_netdev_event(struct notifier_block *this,
 	case NETDEV_UP:
 	case NETDEV_DOWN:
 	case NETDEV_CHANGE:
-		return netvsc_vf_changed(event_dev);
+	case NETDEV_GOING_DOWN:
+		return netvsc_vf_changed(event_dev, event);
 	default:
 		return NOTIFY_DONE;
 	}
-- 
2.27.0

