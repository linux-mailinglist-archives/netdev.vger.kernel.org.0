Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135DEA9986
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 06:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731101AbfIEE2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 00:28:43 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6673 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729941AbfIEE2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 00:28:42 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4BD539422B7EA727F921;
        Thu,  5 Sep 2019 12:28:40 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Sep 2019 12:28:32 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <zhongjiang@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfg80211: Do not compare with boolean in nl80211_common_reg_change_event
Date:   Thu, 5 Sep 2019 12:25:37 +0800
Message-ID: <1567657537-65472-1-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the help of boolinit.cocci, we use !nl80211_reg_change_event_fill
instead of (nl80211_reg_change_event_fill == false). Meanwhile, Clean
up the code.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/wireless/nl80211.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3e30e18..0c7fa60 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14997,12 +14997,10 @@ void nl80211_common_reg_change_event(enum nl80211_commands cmd_id,
 		return;
 
 	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd_id);
-	if (!hdr) {
-		nlmsg_free(msg);
-		return;
-	}
+	if (!hdr)
+		goto nla_put_failure;
 
-	if (nl80211_reg_change_event_fill(msg, request) == false)
+	if (!nl80211_reg_change_event_fill(msg, request))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
-- 
1.7.12.4

