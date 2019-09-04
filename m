Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24E10A8C77
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732750AbfIDQN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 12:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbfIDP7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39EA922CED;
        Wed,  4 Sep 2019 15:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612794;
        bh=VIVGQW933409S6l5xD/IZ/Cjm0sBXwCF9l4GLmhsxcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=scwpC+SLvAS3/qxGlIVvFne7/hr0amSHB73j8upv3gX+RNODqJlVkCvz8GMkjDQAj
         28n9A09bhUmo0J3cKqs4zJTzMloytppIqPVtmGTR7wNHXcrAEpEx854JWeMSQZCzjq
         LDhQPN9iuTCw2bevcZskOVIiQz8+OAyFApccJyMo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 88/94] net: aquantia: fix limit of vlan filters
Date:   Wed,  4 Sep 2019 11:57:33 -0400
Message-Id: <20190904155739.2816-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 392349f60110dc2c3daf86464fd926afc53d6143 ]

Fix a limit condition of vlans on the interface before setting vlan
promiscuous mode

Fixes: 48dd73d08d4dd ("net: aquantia: fix vlans not working over bridged network")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 11d7385babb07..3dbf3ff1c4506 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -844,7 +844,7 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 		return err;
 
 	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (hweight < AQ_VLAN_MAX_FILTERS && hweight > 0) {
+		if (hweight <= AQ_VLAN_MAX_FILTERS && hweight > 0) {
 			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw,
 				!(aq_nic->packet_filter & IFF_PROMISC));
 			aq_nic->aq_nic_cfg.is_vlan_force_promisc = false;
-- 
2.20.1

