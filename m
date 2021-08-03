Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDC73DECE4
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhHCLox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:35206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236158AbhHCLo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E27060F92;
        Tue,  3 Aug 2021 11:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991055;
        bh=i90K1F3cN9255PTEE8cgq6ze8clGUsHG29sCiNHzhOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHNESZrHQslD2oHwUZw/xIVJfzMZa1KRBNQd/dwvM37b0lP0QSBYoV+KPRhBxuIPm
         lNihb89dJclrLrlTY9kjZfAIAYO5FKTJw5QfGRHoVl3LZXT9rkt9WjaQcDR1ReLttf
         uKaxvrsGmC4+eVJfvNBp5XxmbgM7GWjAQ49ro+Ragosq4bYzjkTCwli0ZfECwju77u
         zh3yZpn0kL4bEYdEKZv0Oq4T/KKiDBXZCwziFsk9Pcce+ZR0O7jt7debi+/OeI/h+o
         iUYpaO/6bssGYyDeY7sQkJUtjLpVaUUOUJnpkIHm0EYgazFCVwFzMvUaNAaOI7jsxd
         IHi9+x2cGU0ZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 5/9] net: qede: Fix end of loop tests for list_for_each_entry
Date:   Tue,  3 Aug 2021 07:44:04 -0400
Message-Id: <20210803114408.2252713-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114408.2252713-1-sashal@kernel.org>
References: <20210803114408.2252713-1-sashal@kernel.org>
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

