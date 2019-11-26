Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3863109C0D
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfKZKMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:12:13 -0500
Received: from mx1.rus.uni-stuttgart.de ([129.69.192.1]:34836 "EHLO
        mx1.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727745AbfKZKMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:12:13 -0500
X-Greylist: delayed 321 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2019 05:12:12 EST
Received: from localhost (localhost [127.0.0.1])
        by mx1.rus.uni-stuttgart.de (Postfix) with ESMTP id 4E3D127;
        Tue, 26 Nov 2019 11:06:50 +0100 (CET)
X-Virus-Scanned: USTUTT mailrelay AV services at mx1.rus.uni-stuttgart.de
Received: from mx1.rus.uni-stuttgart.de ([127.0.0.1])
        by localhost (mx1.rus.uni-stuttgart.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id prHrsgx-Flwb; Tue, 26 Nov 2019 11:06:48 +0100 (CET)
Received: from nks-bu01.rus.uni-stuttgart.de (unknown [IPv6:2001:7c0:7c0:111:b049:9ba6:92a3:7e6d])
        by mx1.rus.uni-stuttgart.de (Postfix) with ESMTP;
        Tue, 26 Nov 2019 11:06:48 +0100 (CET)
From:   "=?UTF-8?q?Stefan=20B=C3=BChler?=" 
        <stefan.buehler@tik.uni-stuttgart.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?q?Stefan=20B=C3=BChler?= <source@stbuehler.de>
Subject: [PATCH] cfg80211: fix double-free after changing network namespace
Date:   Tue, 26 Nov 2019 11:05:44 +0100
Message-Id: <20191126100543.782023-1-stefan.buehler@tik.uni-stuttgart.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Bühler <source@stbuehler.de>

If wdev->wext.keys was initialized it didn't get reset to NULL on
unregister (and it doesn't get set in cfg80211_init_wdev either), but
wdev is reused if unregister was triggered through
cfg80211_switch_netns.

The next unregister (for whatever reason) will try to free
wdev->wext.keys again.

Signed-off-by: Stefan Bühler <source@stbuehler.de>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 350513744575..3e25229a059d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1102,6 +1102,7 @@ static void __cfg80211_unregister_wdev(struct wireless_dev *wdev, bool sync)
 
 #ifdef CONFIG_CFG80211_WEXT
 	kzfree(wdev->wext.keys);
+	wdev->wext.keys = NULL;
 #endif
 	/* only initialized if we have a netdev */
 	if (wdev->netdev)
-- 
2.24.0

