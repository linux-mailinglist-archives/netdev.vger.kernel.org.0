Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AC7A8A91
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732508AbfIDP7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:59:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732495AbfIDP7x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F19022CF5;
        Wed,  4 Sep 2019 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612792;
        bh=n2926yFWZh0mBBiNvBFZd63smTpyjMh0h8bNLtb991U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tKiQYs11ZMpzqy331sm4dUX5c+5MVukboJCpG3vq6RDhg/YZDCxp67cUJDCiWTMDA
         m6B3yNsTEVS2OT5eqyZgQrq1z3ACNz8SCCc05vqr3ol5DzYMh9uyns8mbSOiEgLFvO
         9rg5q9Sc8CSefsLi0n7wbvZ4Edgz861AnpRUYEm8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 87/94] net: aquantia: fix removal of vlan 0
Date:   Wed,  4 Sep 2019 11:57:32 -0400
Message-Id: <20190904155739.2816-87-sashal@kernel.org>
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

[ Upstream commit 6fdc060d7476ef73c8029b652d252c1a7b4de948 ]

Due to absence of checking against the rx flow rule when vlan 0 is being
removed, the other rule could be removed instead of the rule with vlan 0

Fixes: 7975d2aff5afb ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 1fff462a4175e..11d7385babb07 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -431,7 +431,8 @@ int aq_del_fvlan_by_vlan(struct aq_nic_s *aq_nic, u16 vlan_id)
 		if (be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) == vlan_id)
 			break;
 	}
-	if (rule && be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) == vlan_id) {
+	if (rule && rule->type == aq_rx_filter_vlan &&
+	    be16_to_cpu(rule->aq_fsp.h_ext.vlan_tci) == vlan_id) {
 		struct ethtool_rxnfc cmd;
 
 		cmd.fs.location = rule->aq_fsp.location;
-- 
2.20.1

