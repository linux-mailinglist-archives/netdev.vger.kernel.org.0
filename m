Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08AD21D4F5
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgGML3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 07:29:11 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50208 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728714AbgGML3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 07:29:10 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 8014C60054;
        Mon, 13 Jul 2020 11:29:10 +0000 (UTC)
Received: from us4-mdac16-16.ut7.mdlocal (unknown [10.7.65.240])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7F2312009B;
        Mon, 13 Jul 2020 11:29:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.42])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id ED6F9220056;
        Mon, 13 Jul 2020 11:29:09 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A4915A40075;
        Mon, 13 Jul 2020 11:29:09 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 13 Jul
 2020 12:29:04 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 01/16] sfc: remove efx_ethtool_nway_reset()
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Message-ID: <0116aedb-57cc-904b-c93f-f4447d7297d2@solarflare.com>
Date:   Mon, 13 Jul 2020 12:29:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <dbd87499-161e-09f3-7dec-8b7c13ad02dd@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25538.003
X-TM-AS-Result: No-1.075700-8.000000-10
X-TMASE-MatchedRID: QtNN9W95DWv8XlijEAp3PsVbb3pjW5Mn7qPKKDEKjrLiRCPcinj8UqEF
        sAUWv0FPd/e1oYDeXOxQpiUwGXA626H2g9syPs888Kg68su2wyE/pOSL72dTfwdkFovAReUoilv
        Ab18i4hP65TDaYHP8l6ZY4q+T5VVFvi/XXOZZp4ogCPGiZqtI8H0tCKdnhB58vqq8s2MNhPCZMP
        CnTMzfOiq2rl3dzGQ1L/+/bHPzNDcXopMYO4l02U2A4S07Nvw7pQrvyg4ulFsILFf+nLXWwsK+I
        8WyktsPU9K7y0PBPRDltfuL95f14vE/nqZok8mLl0kb426sKbJDgw2OfwbhLKMa5OkNpiHkifsL
        +6CY4RnJZmo0UvMlsUMMprcbiest
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.075700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25538.003
X-MDID: 1594639750-cLOiANcu65ud
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An MDIO-based n-way restart does not make sense for any of the NICs
 supported by this driver, nor for the coming EF100.
Unlike on Falcon (which was already split off into a separate driver),
 the PHY on all of Siena, EF10 and EF100 is managed by MC firmware.
While Siena can talk to the PHY over MDIO, doing so for anything other
 than debugging purposes (mdio_mii_ioctl) is likely to confuse the
 firmware.
(According to the SFC firmware team, this support was originally added
 to the Siena driver early in the development of that product, before
 it was decided to have firmware manage the PHY.)

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool.c        | 1 -
 drivers/net/ethernet/sfc/ethtool_common.c | 8 --------
 drivers/net/ethernet/sfc/ethtool_common.h | 1 -
 3 files changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 9828516bd82d..038c08d2d7aa 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -232,7 +232,6 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.get_regs		= efx_ethtool_get_regs,
 	.get_msglevel		= efx_ethtool_get_msglevel,
 	.set_msglevel		= efx_ethtool_set_msglevel,
-	.nway_reset		= efx_ethtool_nway_reset,
 	.get_link		= ethtool_op_get_link,
 	.get_coalesce		= efx_ethtool_get_coalesce,
 	.set_coalesce		= efx_ethtool_set_coalesce,
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index e9a5a66529bf..fb06097b70d8 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -173,14 +173,6 @@ void efx_ethtool_self_test(struct net_device *net_dev,
 		test->flags |= ETH_TEST_FL_FAILED;
 }
 
-/* Restart autonegotiation */
-int efx_ethtool_nway_reset(struct net_device *net_dev)
-{
-	struct efx_nic *efx = netdev_priv(net_dev);
-
-	return mdio45_nway_restart(&efx->mdio);
-}
-
 void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 				struct ethtool_pauseparam *pause)
 {
diff --git a/drivers/net/ethernet/sfc/ethtool_common.h b/drivers/net/ethernet/sfc/ethtool_common.h
index 3f3aaa92fbb5..0c0ea9ac4d08 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.h
+++ b/drivers/net/ethernet/sfc/ethtool_common.h
@@ -19,7 +19,6 @@ u32 efx_ethtool_get_msglevel(struct net_device *net_dev);
 void efx_ethtool_set_msglevel(struct net_device *net_dev, u32 msg_enable);
 void efx_ethtool_self_test(struct net_device *net_dev,
 			   struct ethtool_test *test, u64 *data);
-int efx_ethtool_nway_reset(struct net_device *net_dev);
 void efx_ethtool_get_pauseparam(struct net_device *net_dev,
 				struct ethtool_pauseparam *pause);
 int efx_ethtool_set_pauseparam(struct net_device *net_dev,

