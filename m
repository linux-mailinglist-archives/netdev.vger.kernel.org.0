Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0009F349F58
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbhCZCHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhCZCHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 22:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4D261A4C;
        Fri, 26 Mar 2021 02:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616724458;
        bh=V88BEhJjkfaIrGW+HlYxTPDKj05lPfEZYnA1T5CxPGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiP1eqHOORio9bcn+S7A8Dv0fvyUlToKVXdRn2AH23Jrm9KJH1cWQZemHm0xLS+Kt
         gI2AveQEumWAI8aYLSFa7lUAmlZSHC866eDmBvWVsqr9SvVpEYoUu1r3H2jpE/APg6
         oo6nvnKnfhQPS4ZNk0tUNKR/s7AIutQk8jHk8Ta6NBvtCv5R666BFtV8NLxF/XkO1E
         H6YLeBknZ9CwliscOAoItqImiAnyBUB/X0GqW9/JRqU8L7uLhVXLgS+2gms+1ebVaI
         1e8++MGEASqz8vyLNlmhOyvL659utxKkTURMa2Xbgpg3jajIqhyGDHDKOW+O7iUurB
         3tOE6ncfrecOw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, paul.greenwalt@intel.com,
        rajur@chelsio.com, jaroslawx.gawin@intel.com, vkochan@marvell.com,
        alobakin@pm.me, snelson@pensando.io, shayagr@amazon.com,
        ayal@nvidia.com, shenjian15@huawei.com, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch, roopa@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 6/6] ethtool: clarify the ethtool FEC interface
Date:   Thu, 25 Mar 2021 19:07:27 -0700
Message-Id: <20210326020727.246828-7-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326020727.246828-1-kuba@kernel.org>
References: <20210326020727.246828-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The definition of the FEC driver interface is quite unclear.
Improve the documentation.

This is based on current driver and user space code, as well
as the discussions about the interface:

RFC v1 (24 Oct 2016): https://lore.kernel.org/netdev/1477363849-36517-1-git-send-email-vidya@cumulusnetworks.com/
 - this version has the autoneg field
 - no active_fec field
 - none vs off confusion is already present

RFC v2 (10 Feb 2017): https://lore.kernel.org/netdev/1486727004-11316-1-git-send-email-vidya@cumulusnetworks.com/
 - autoneg removed
 - active_fec added

v1 (10 Feb 2017): https://lore.kernel.org/netdev/1486751311-42019-1-git-send-email-vidya@cumulusnetworks.com/
 - no changes in the code

v1 (24 Jun 2017):  https://lore.kernel.org/netdev/1498331985-8525-1-git-send-email-roopa@cumulusnetworks.com/
 - include in tree user

v2 (27 Jul 2017): https://lore.kernel.org/netdev/1501199248-24695-1-git-send-email-roopa@cumulusnetworks.com/

v2: - make enum kdoc reference bits

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 39 ++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 78027aa0161a..868b513d4f54 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1372,39 +1372,62 @@ struct ethtool_per_queue_op {
 	__u32	cmd;
 	__u32	sub_command;
 	__u32	queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
 	char	data[];
 };
 
 /**
- * struct ethtool_fecparam - Ethernet forward error correction(fec) parameters
+ * struct ethtool_fecparam - Ethernet Forward Error Correction parameters
  * @cmd: Command number = %ETHTOOL_GFECPARAM or %ETHTOOL_SFECPARAM
- * @active_fec: FEC mode which is active on the port, GET only.
- * @fec: Bitmask of supported/configured FEC modes
+ * @active_fec: FEC mode which is active on the port, single bit set, GET only.
+ * @fec: Bitmask of configured FEC modes.
  * @reserved: Reserved for future extensions, ignore on GET, write 0 for SET.
  *
  * Note that @reserved was never validated on input and ethtool user space
  * left it uninitialized when calling SET. Hence going forward it can only be
  * used to return a value to userspace with GET.
+ *
+ * FEC modes supported by the device can be read via %ETHTOOL_GLINKSETTINGS.
+ * FEC settings are configured by link autonegotiation whenever it's enabled.
+ * With autoneg on %ETHTOOL_GFECPARAM can be used to read the current mode.
+ *
+ * When autoneg is disabled %ETHTOOL_SFECPARAM controls the FEC settings.
+ * It is recommended that drivers only accept a single bit set in @fec.
+ * When multiple bits are set in @fec drivers may pick mode in an implementation
+ * dependent way. Drivers should reject mixing %ETHTOOL_FEC_AUTO_BIT with other
+ * FEC modes, because it's unclear whether in this case other modes constrain
+ * AUTO or are independent choices.
+ * Drivers must reject SET requests if they support none of the requested modes.
+ *
+ * If device does not support FEC drivers may use %ETHTOOL_FEC_NONE instead
+ * of returning %EOPNOTSUPP from %ETHTOOL_GFECPARAM.
+ *
+ * See enum ethtool_fec_config_bits for definition of valid bits for both
+ * @fec and @active_fec.
  */
 struct ethtool_fecparam {
 	__u32   cmd;
 	/* bitmask of FEC modes */
 	__u32   active_fec;
 	__u32   fec;
 	__u32   reserved;
 };
 
 /**
  * enum ethtool_fec_config_bits - flags definition of ethtool_fec_configuration
- * @ETHTOOL_FEC_NONE: FEC mode configuration is not supported
- * @ETHTOOL_FEC_AUTO: Default/Best FEC mode provided by driver
- * @ETHTOOL_FEC_OFF: No FEC Mode
- * @ETHTOOL_FEC_RS: Reed-Solomon Forward Error Detection mode
- * @ETHTOOL_FEC_BASER: Base-R/Reed-Solomon Forward Error Detection mode
+ * @ETHTOOL_FEC_NONE_BIT: FEC mode configuration is not supported. Should not
+ *			be used together with other bits. GET only.
+ * @ETHTOOL_FEC_AUTO_BIT: Select default/best FEC mode automatically, usually
+ *			based link mode and SFP parameters read from module's
+ *			EEPROM. This bit does _not_ mean autonegotiation.
+ * @ETHTOOL_FEC_OFF_BIT: No FEC Mode
+ * @ETHTOOL_FEC_RS_BIT: Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_BASER_BIT: Base-R/Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_LLRS_BIT: Low Latency Reed Solomon FEC Mode (25G/50G Ethernet
+ *			Consortium)
  */
 enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_NONE_BIT,
 	ETHTOOL_FEC_AUTO_BIT,
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
-- 
2.30.2

