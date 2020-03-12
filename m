Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9540183A3B
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 21:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgCLUHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 16:07:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:45110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727059AbgCLUHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 16:07:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C3C0FAC52;
        Thu, 12 Mar 2020 20:07:43 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 757EFE0C79; Thu, 12 Mar 2020 21:07:43 +0100 (CET)
Message-Id: <0c49efc15415f6fc2cba940d34495c52cb3e6532.1584043144.git.mkubecek@suse.cz>
In-Reply-To: <cover.1584043144.git.mkubecek@suse.cz>
References: <cover.1584043144.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v2 02/15] ethtool: update mapping of features to
 legacy ioctl requests
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Date:   Thu, 12 Mar 2020 21:07:43 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Legacy ioctl request like ETHTOOL_GTXCSUM are still used by ethtool utility
to get values of legacy flags (which rather work as feature groups). These
are calculated from values of actual features and request to set them is
implemented as an attempt to set all features mapping to them but there are
two inconsistencies:

- tx-checksum-fcoe-crc is shown under tx-checksumming but NETIF_F_FCOE_CRC
  is not included in ETHTOOL_GTXCSUM/ETHTOOL_STXCSUM
- tx-scatter-gather-fraglist is shown under scatter-gather but
  NETIF_F_FRAGLIST is not included in ETHTOOL_GSG/ETHTOOL_SSG

As the mapping in ethtool output is more correct from logical point of
view, fix ethtool_get_feature_mask() to match it.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 net/ethtool/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index b2684ffa26de..ae97c82c7052 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -198,13 +198,14 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		return NETIF_F_CSUM_MASK | NETIF_F_SCTP_CRC;
+		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC_BIT |
+		       NETIF_F_SCTP_CRC;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
 		return NETIF_F_RXCSUM;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		return NETIF_F_SG;
+		return NETIF_F_SG | NETIF_F_FRAGLIST;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
 		return NETIF_F_ALL_TSO;
-- 
2.25.1

