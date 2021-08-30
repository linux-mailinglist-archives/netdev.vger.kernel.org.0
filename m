Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC73FB6BA
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 15:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhH3NHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 09:07:13 -0400
Received: from smtpbg126.qq.com ([106.55.201.22]:32742 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhH3NHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 09:07:13 -0400
X-QQ-mid: bizesmtp34t1630328753t2e56dzr
Received: from localhost.localdomain (unknown [171.223.99.71])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 30 Aug 2021 21:05:52 +0800 (CST)
X-QQ-SSF: 01000000004000C0D000B00A0000000
X-QQ-FEAT: tc6S58rF1JAWTi8uE0WstgfmSWYoacx5MpqcEQL0gJM+EEXKxm6nBJGii/fwI
        1EIuEkDyURX6Q68j/etgS4RvKD9IL0aYVD8o3BQ3306+Hr6fcRJqCUCh+DO0ykISoP9Ybfc
        UdiU/LXUW/HaIPHgn7w5Du83MaxbyGgE2ZZD2k6zFFR59YRyOnjcmatbb2T/NN80rPh5GBA
        zzQuQgW6F3MDolm685WQuhKSOdnNnlB3IBl2GdLrTX2gv7TLe3I/z+/GSFp3zLQxG+ae96u
        wvtrG1lc5JWzudryxvVJHDXfTPo8gTv6IylLmWY7eK4uqdM8Lwkl94M5Hc7Ois7rpwzpWFh
        LfrXDtd3PAjjsQlY00CZ8Q/gNK9dw==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     ioana.ciornei@nxp.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] dpaa2-eth: Replace strlcpy with strscpy
Date:   Mon, 30 Aug 2021 21:05:31 +0800
Message-Id: <20210830130531.12429-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlcpy should not be used because it doesn't limit the source
length. As linus says, it's a completely useless function if you
can't implicitly trust the source string - but that is almost always
why people think they should use it! All in all the BSD function
will lead some potential bugs.

But the strscpy doesn't require reading memory from the src string
beyond the specified "count" bytes, and since the return value is
easier to error-check than strlcpy()'s. In addition, the implementation
is robust to the string changing out from underneath it, unlike the
current strlcpy() implementation.

Thus, We prefer using strscpy instead of strlcpy.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
index ad5e374eeccf..2da5f881f630 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ethtool.c
@@ -72,12 +72,12 @@ static void dpaa2_eth_get_drvinfo(struct net_device *net_dev,
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 
-	strlcpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
+	strscpy(drvinfo->driver, KBUILD_MODNAME, sizeof(drvinfo->driver));
 
 	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
 		 "%u.%u", priv->dpni_ver_major, priv->dpni_ver_minor);
 
-	strlcpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
+	strscpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
 		sizeof(drvinfo->bus_info));
 }
 
@@ -191,11 +191,11 @@ static void dpaa2_eth_get_strings(struct net_device *netdev, u32 stringset,
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < DPAA2_ETH_NUM_STATS; i++) {
-			strlcpy(p, dpaa2_ethtool_stats[i], ETH_GSTRING_LEN);
+			strscpy(p, dpaa2_ethtool_stats[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		for (i = 0; i < DPAA2_ETH_NUM_EXTRA_STATS; i++) {
-			strlcpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
+			strscpy(p, dpaa2_ethtool_extras[i], ETH_GSTRING_LEN);
 			p += ETH_GSTRING_LEN;
 		}
 		if (dpaa2_eth_has_mac(priv))
-- 
2.33.0

