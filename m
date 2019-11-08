Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13604F4AE1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbfKHMME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:12:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732900AbfKHLiw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6472421D7E;
        Fri,  8 Nov 2019 11:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213132;
        bh=FBFUnT8LQXED72+Al9YJaWDfbqJLi+M8khoAEx+dqV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZmDKTrDoBezHLCwqndpJSKwjhacobY4wp7n1k913Pm4bSucRTkQLL3eHkr9WmBS3
         wTHMCicaqSF/bj7nhTwuAsjpLpBTo8keLJF8jbx9n1KwmPGTWqff81BojjEgtYab9m
         sLGMTIO6k6oZrTrpOOXjzZW1uoJITm9fXosqhuvE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Patryk=20Ma=C5=82ek?= <patryk.malek@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 050/205] i40evf: Don't enable vlan stripping when rx offload is turned on
Date:   Fri,  8 Nov 2019 06:35:17 -0500
Message-Id: <20191108113752.12502-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patryk Małek <patryk.malek@intel.com>

[ Upstream commit 3bd77e2ae1477d6f87fc3f542c737119d5decf9f ]

With current implementation of i40evf_set_features when user sets
any offload via ethtool we set I40EVF_FLAG_AQ_ENABLE_VLAN_STRIPPING
as a required aq which triggers driver to call
i40evf_enable_vlan_stripping. This shouldn't take place.
This patches fixes it by setting the flag only when VLAN offload
is turned on.

Signed-off-by: Patryk Małek <patryk.malek@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index bc4fa9df6da3e..3fc46d2adc087 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -3097,18 +3097,19 @@ static int i40evf_set_features(struct net_device *netdev,
 {
 	struct i40evf_adapter *adapter = netdev_priv(netdev);
 
-	/* Don't allow changing VLAN_RX flag when VLAN is set for VF
-	 * and return an error in this case
+	/* Don't allow changing VLAN_RX flag when adapter is not capable
+	 * of VLAN offload
 	 */
-	if (VLAN_ALLOWED(adapter)) {
+	if (!VLAN_ALLOWED(adapter)) {
+		if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX)
+			return -EINVAL;
+	} else if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
 			adapter->aq_required |=
 				I40EVF_FLAG_AQ_ENABLE_VLAN_STRIPPING;
 		else
 			adapter->aq_required |=
 				I40EVF_FLAG_AQ_DISABLE_VLAN_STRIPPING;
-	} else if ((netdev->features ^ features) & NETIF_F_HW_VLAN_CTAG_RX) {
-		return -EINVAL;
 	}
 
 	return 0;
-- 
2.20.1

