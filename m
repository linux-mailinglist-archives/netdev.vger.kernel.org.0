Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBC362516B
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiKKDRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbiKKDRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:17:01 -0500
X-Greylist: delayed 450 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 10 Nov 2022 19:16:57 PST
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 961612B24C
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 19:16:57 -0800 (PST)
Received: from YC20090004.ad.ts.tri-ad.global ([103.175.111.222])
        by smtp.orange.fr with ESMTPA
        id tKPJoXPuTUoLVtKPpodQWK; Fri, 11 Nov 2022 04:09:25 +0100
X-ME-Helo: YC20090004.ad.ts.tri-ad.global
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Fri, 11 Nov 2022 04:09:25 +0100
X-ME-IP: 103.175.111.222
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Petr Machata <petrm@nvidia.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Amit Cohen <amcohen@nvidia.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        linux-kernel@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH] ethtool: doc: clarify what drivers can implement in their get_drvinfo()
Date:   Fri, 11 Nov 2022 12:08:38 +0900
Message-Id: <20221111030838.1059-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many of the drivers which implement ethtool_ops::get_drvinfo() will
prints the .driver, .version or .bus_info of struct ethtool_drvinfo.
To have a glance of current state, do:

  $ git grep -W "get_drvinfo(struct"

Printing in those three fields is useless because:

  - since [1], the driver version should be the kernel version (at
    least for upstream drivers). Arguably, out of tree drivers might
    still want to set it, but out of tree is not our focus.

  - since [2], the core is able to provide default values for .driver
    and .bus_info.

In summary, drivers may provide @fw_version and @erom_version, the
rest is expected to be done by the core. Update the doc to reflect the
facts.

Also update the dummy driver and simply remove the callback in order
not to confuse the newcomers: most of the drivers will not need this
callback function any more.

[1] commit 6a7e25c7fb48 ("net/core: Replace driver version to be
    kernel version")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6a7e25c7fb482dba3e80fec953f1907bcb24d52c

[2] commit edaf5df22cb8 ("ethtool: ethtool_get_drvinfo: populate
    drvinfo fields even if callback exits")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=edaf5df22cb8e7e849773ce69fcc9bc20ca92160

CC: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Arguably, dummy.c is code and not documentation, but for me, it makes
sense to treat it as documentation, thus I am putting everything in
one single patch.
---
 drivers/net/dummy.c          | 7 -------
 include/uapi/linux/ethtool.h | 6 +++---
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index aa0fc00faecb..c4b1b0aa438a 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -99,14 +99,7 @@ static const struct net_device_ops dummy_netdev_ops = {
 	.ndo_change_carrier	= dummy_change_carrier,
 };
 
-static void dummy_get_drvinfo(struct net_device *dev,
-			      struct ethtool_drvinfo *info)
-{
-	strscpy(info->driver, DRV_NAME, sizeof(info->driver));
-}
-
 static const struct ethtool_ops dummy_ethtool_ops = {
-	.get_drvinfo            = dummy_get_drvinfo,
 	.get_ts_info		= ethtool_op_get_ts_info,
 };
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index f341de2ae612..fcee5dbf6c06 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -180,9 +180,9 @@ static inline __u32 ethtool_cmd_speed(const struct ethtool_cmd *ep)
  * Users can use the %ETHTOOL_GSSET_INFO command to get the number of
  * strings in any string set (from Linux 2.6.34).
  *
- * Drivers should set at most @driver, @version, @fw_version and
- * @bus_info in their get_drvinfo() implementation.  The ethtool
- * core fills in the other fields using other driver operations.
+ * Drivers should set at most @fw_version and @erom_version in their
+ * get_drvinfo() implementation. The ethtool core fills in the other
+ * fields using other driver operations.
  */
 struct ethtool_drvinfo {
 	__u32	cmd;
-- 
2.35.1

