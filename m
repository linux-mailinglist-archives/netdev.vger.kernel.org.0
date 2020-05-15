Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AEF1D478E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgEOIAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:00:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgEOIAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:00:19 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7429205CB;
        Fri, 15 May 2020 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589529618;
        bh=Lrg29hVRGlCPrHHmbYcVcsFCxxxwqFtQRLOD6b5xnYo=;
        h=From:To:Cc:Subject:Date:From;
        b=NVL1ClV+Sf8z/LLTyPfAPgLsrbfvrui0OPb0oiN0r2sFmT2HTGCY9ZL41659B+T+Z
         g1Mkjy4xPFqndZ2U7GrGhq1Y9IlERJv+KJC8Eq+sMIWnW5nMTdKiLGgIoke92hUkJJ
         MA7S8k5YVMBd7HLwxBJz/0zxW6YevjCAcu4te5Wk=
Received: by pali.im (Postfix)
        id A01805F0; Fri, 15 May 2020 10:00:16 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Cathy Luo <cluo@marvell.com>,
        Avinash Patil <patila@marvell.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Fix memory corruption in dump_station
Date:   Fri, 15 May 2020 09:59:24 +0200
Message-Id: <20200515075924.13841-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mwifiex_cfg80211_dump_station() uses static variable for iterating
over a linked list of all associated stations (when the driver is in UAP
role). This has a race condition if .dump_station is called in parallel
for multiple interfaces. This corruption can be triggered by registering
multiple SSIDs and calling, in parallel for multiple interfaces
    iw dev <iface> station dump

[16750.719775] Unable to handle kernel paging request at virtual address dead000000000110
...
[16750.899173] Call trace:
[16750.901696]  mwifiex_cfg80211_dump_station+0x94/0x100 [mwifiex]
[16750.907824]  nl80211_dump_station+0xbc/0x278 [cfg80211]
[16750.913160]  netlink_dump+0xe8/0x320
[16750.916827]  netlink_recvmsg+0x1b4/0x338
[16750.920861]  ____sys_recvmsg+0x7c/0x2b0
[16750.924801]  ___sys_recvmsg+0x70/0x98
[16750.928564]  __sys_recvmsg+0x58/0xa0
[16750.932238]  __arm64_sys_recvmsg+0x28/0x30
[16750.936453]  el0_svc_common.constprop.3+0x90/0x158
[16750.941378]  do_el0_svc+0x74/0x90
[16750.944784]  el0_sync_handler+0x12c/0x1a8
[16750.948903]  el0_sync+0x114/0x140
[16750.952312] Code: f9400003 f907f423 eb02007f 54fffd60 (b9401060)
[16750.958583] ---[ end trace c8ad181c2f4b8576 ]---

This patch drops the use of the static iterator, and instead every time
the function is called iterates to the idx-th position of the
linked-list.

It would be better to convert the code not to use linked list for
associated stations storage (since the chip has a limited number of
associated stations anyway - it could just be an array). Such a change
may be proposed in the future. In the meantime this patch can backported
into stable kernels in this simple form.

Fixes: 8baca1a34d4c ("mwifiex: dump station support in uap mode")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 1566d2197906..12bfd653a405 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -1496,7 +1496,8 @@ mwifiex_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 			      int idx, u8 *mac, struct station_info *sinfo)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
-	static struct mwifiex_sta_node *node;
+	struct mwifiex_sta_node *node;
+	int i;
 
 	if ((GET_BSS_ROLE(priv) == MWIFIEX_BSS_ROLE_STA) &&
 	    priv->media_connected && idx == 0) {
@@ -1506,13 +1507,10 @@ mwifiex_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 		mwifiex_send_cmd(priv, HOST_CMD_APCMD_STA_LIST,
 				 HostCmd_ACT_GEN_GET, 0, NULL, true);
 
-		if (node && (&node->list == &priv->sta_list)) {
-			node = NULL;
-			return -ENOENT;
-		}
-
-		node = list_prepare_entry(node, &priv->sta_list, list);
-		list_for_each_entry_continue(node, &priv->sta_list, list) {
+		i = 0;
+		list_for_each_entry(node, &priv->sta_list, list) {
+			if (i++ != idx)
+				continue;
 			ether_addr_copy(mac, node->mac_addr);
 			return mwifiex_dump_station_info(priv, node, sinfo);
 		}
-- 
2.20.1

