Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118451824ED
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731316AbgCKWdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729799AbgCKWdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:33:11 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735BA20749;
        Wed, 11 Mar 2020 22:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583965991;
        bh=Ued7EGKHT81xnPQ6g15WMPl0Y7k+whns0tHker0BHKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XC+bBuJLOw4Xbvr2aI+JwdIFSmlwEi6JLKO0KVKOg255kTWWLSwb4bJH6RO9XlAPw
         w2f4MPXYeK0DkIKyhFYD7862gmfz8XniDBl+ftNNwnKqaHaUyD3aLsF6M0lZJxiGP5
         U+OlsnTYLp/14unauy7b90T7u8wn1Um9HQE6/teE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz,
        sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        madalin.bucur@nxp.com, fugang.duan@nxp.com, claudiu.manoil@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/15] net: be2net: reject unsupported coalescing params
Date:   Wed, 11 Mar 2020 15:32:48 -0700
Message-Id: <20200311223302.2171564-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200311223302.2171564-1-kuba@kernel.org>
References: <20200311223302.2171564-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver did not previously reject unsupported parameters.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 3 +++
 include/linux/ethtool.h                        | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index 9d9f0545fbfe..d6ed1d943762 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1408,6 +1408,9 @@ static int be_set_priv_flags(struct net_device *netdev, u32 flags)
 }
 
 const struct ethtool_ops be_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE |
+				     ETHTOOL_COALESCE_USECS_LOW_HIGH,
 	.get_drvinfo = be_get_drvinfo,
 	.get_wol = be_get_wol,
 	.set_wol = be_set_wol,
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 9efeebde3514..acfce915a02b 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -211,6 +211,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ)
 #define ETHTOOL_COALESCE_USE_ADAPTIVE					\
 	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX | ETHTOOL_COALESCE_USE_ADAPTIVE_TX)
+#define ETHTOOL_COALESCE_USECS_LOW_HIGH					\
+	(ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_TX_USECS_LOW | \
+	 ETHTOOL_COALESCE_RX_USECS_HIGH | ETHTOOL_COALESCE_TX_USECS_HIGH)
 #define ETHTOOL_COALESCE_PKT_RATE_RX_USECS				\
 	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX |				\
 	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
-- 
2.24.1

