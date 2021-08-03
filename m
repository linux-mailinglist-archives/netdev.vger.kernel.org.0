Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CAB3DECF2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhHCLop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235870AbhHCLoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2891D60F56;
        Tue,  3 Aug 2021 11:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991039;
        bh=i90K1F3cN9255PTEE8cgq6ze8clGUsHG29sCiNHzhOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2tNyk3pPWUNaKJGAo+ZOU+KuQHhRmIvGFwC7171ksjeR3kq4N1lDQyhCLO39RoCN
         7+C2RmQ+9MRme0DkGhxicRQ+QAJAXdiZFA+vn5NGv2QKFbvQmSjgJ7+Lglkw+/Zxru
         V+rwvZJpA+nEzQ7gZo5r2LnEugtsaErlyCF0daDE8hRD/pgWuoPmazxhuYKErA4Y+I
         iARaw24rMqL0EKrUvvKC3cdIpOQTjB1Z42Aut92aaL5GU8353OSmaIkU4RS2UKZw1J
         v1AiULFQ7Ufg4/w7ji964hfCrtR9PVFPa6b7c9nanW9QGJciexwUpPwVPBHVwUJ9fp
         5Khj2gpcze6WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 05/11] net: qede: Fix end of loop tests for list_for_each_entry
Date:   Tue,  3 Aug 2021 07:43:46 -0400
Message-Id: <20210803114352.2252544-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114352.2252544-1-sashal@kernel.org>
References: <20210803114352.2252544-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harshvardhan Jha <harshvardhan.jha@oracle.com>

[ Upstream commit 795e3d2ea68e489ee7039ac29e98bfea0e34a96c ]

The list_for_each_entry() iterator, "vlan" in this code, can never be
NULL so the warning will never be printed.

Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index c59b72c90293..a2e4dfb5cb44 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -831,7 +831,7 @@ int qede_configure_vlan_filters(struct qede_dev *edev)
 int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	struct qede_vlan *vlan = NULL;
+	struct qede_vlan *vlan;
 	int rc = 0;
 
 	DP_VERBOSE(edev, NETIF_MSG_IFDOWN, "Removing vlan 0x%04x\n", vid);
@@ -842,7 +842,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 		if (vlan->vid == vid)
 			break;
 
-	if (!vlan || (vlan->vid != vid)) {
+	if (list_entry_is_head(vlan, &edev->vlan_list, list)) {
 		DP_VERBOSE(edev, (NETIF_MSG_IFUP | NETIF_MSG_IFDOWN),
 			   "Vlan isn't configured\n");
 		goto out;
-- 
2.30.2

