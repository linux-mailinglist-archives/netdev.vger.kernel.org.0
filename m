Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C7D34864A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239581AbhCYBMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:12:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:52454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239551AbhCYBMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:12:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1757161A29;
        Thu, 25 Mar 2021 01:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634732;
        bh=VW1f9o/6lWkZzQO7qx0eu6Q6tMeCokEFqcxcMqwoE5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDWdmOzkSIN3IrH4G7hQr2aXLniVD2sZjSR+dt3RVDxDOZPVxNqXdxAeOWtnRcM0f
         /MLnvJM1XQ63cN1v32iPfWrlvqDperyoG4W+rg9L50t/pHBmJdw/bKoQ0tybaOK4G5
         oVFwJOXwgtOm+wAya/Yexhzo8O5ZffnIlgtaoszOJVo5QGm3Ov7QFa3MvhHD/050X8
         Kujp0AtO2N/WgBw5iRWhpjlIDDS3CyxVICCoirb0maxNcf9kxkOl73UHszLjfRpF+e
         Fbybf0tAnm/PLNydnLK306uIdA5qHYLSsU/gG57gLtOJoBQo0nuV//y80hR6vvveNn
         Qvp43S3Ic8ALQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ecree.xilinx@gmail.com,
        michael.chan@broadcom.com, damian.dybek@intel.com,
        paul.greenwalt@intel.com, rajur@chelsio.com,
        jaroslawx.gawin@intel.com, vkochan@marvell.com, alobakin@pm.me,
        snelson@pensando.io, shayagr@amazon.com, ayal@nvidia.com,
        shenjian15@huawei.com, saeedm@nvidia.com, mkubecek@suse.cz,
        andrew@lunn.ch, roopa@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] ethtool: clarify the ethtool FEC interface
Date:   Wed, 24 Mar 2021 18:12:00 -0700
Message-Id: <20210325011200.145818-7-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210325011200.145818-1-kuba@kernel.org>
References: <20210325011200.145818-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/ethtool.h | 37 +++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 517b68c5fcec..f6ef7d42c7a1 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1372,35 +1372,58 @@ struct ethtool_per_queue_op {
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
+ * @ETHTOOL_FEC_NONE: FEC mode configuration is not supported. Should not
+ *		      be used together with other bits. GET only.
+ * @ETHTOOL_FEC_AUTO: Select default/best FEC mode automatically, usually based
+ *		      link mode and SFP parameters read from module's EEPROM.
+ *		      This bit does _not_ mean autonegotiation.
  * @ETHTOOL_FEC_OFF: No FEC Mode
- * @ETHTOOL_FEC_RS: Reed-Solomon Forward Error Detection mode
- * @ETHTOOL_FEC_BASER: Base-R/Reed-Solomon Forward Error Detection mode
+ * @ETHTOOL_FEC_RS: Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_BASER: Base-R/Reed-Solomon FEC Mode
+ * @ETHTOOL_FEC_LLRS: Low Latency Reed Solomon FEC Mode (25G/50G Ethernet
+ *		      Consortium)
  */
 enum ethtool_fec_config_bits {
 	ETHTOOL_FEC_NONE_BIT,
 	ETHTOOL_FEC_AUTO_BIT,
 	ETHTOOL_FEC_OFF_BIT,
 	ETHTOOL_FEC_RS_BIT,
 	ETHTOOL_FEC_BASER_BIT,
-- 
2.30.2

