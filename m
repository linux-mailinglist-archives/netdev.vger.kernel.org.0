Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D998C8C93A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfHNCMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbfHNCMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:12:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A9EE20842;
        Wed, 14 Aug 2019 02:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748760;
        bh=rL229EiVdHJ9uYzZvBHPwLKzwBdqrgjYJeNuBTGV+qM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Koda1McQTgvN4XPgkgczWZXqKlzx1fddw9Z6rvnnw3wJmdIu/v9gJdj1Rzg73QxE+
         H7GmJ0iKdcKYJknIfo+Qq4pyf39LL7YyhJa6ZiZTNsZY6bzGYUdos7KukRlbPY+SJ8
         rw7vgH284iYN+1aibSS71ruwTnnZIdGpb0xLaEvI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 053/123] mac80211_hwsim: Fix possible null-pointer dereferences in hwsim_dump_radio_nl()
Date:   Tue, 13 Aug 2019 22:09:37 -0400
Message-Id: <20190814021047.14828-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit b55f3b841099e641bdb2701d361a4c304e2dbd6f ]

In hwsim_dump_radio_nl(), when genlmsg_put() on line 3617 fails, hdr is
assigned to NULL. Then hdr is used on lines 3622 and 3623:
    genl_dump_check_consistent(cb, hdr);
    genlmsg_end(skb, hdr);

Thus, possible null-pointer dereferences may occur.

To fix these bugs, hdr is used here when it is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20190729082332.28895-1-baijiaju1990@gmail.com
[put braces on all branches]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 1c699a9fa8661..faec05ab42754 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3615,10 +3615,12 @@ static int hwsim_dump_radio_nl(struct sk_buff *skb,
 		hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid,
 				  cb->nlh->nlmsg_seq, &hwsim_genl_family,
 				  NLM_F_MULTI, HWSIM_CMD_GET_RADIO);
-		if (!hdr)
+		if (hdr) {
+			genl_dump_check_consistent(cb, hdr);
+			genlmsg_end(skb, hdr);
+		} else {
 			res = -EMSGSIZE;
-		genl_dump_check_consistent(cb, hdr);
-		genlmsg_end(skb, hdr);
+		}
 	}
 
 done:
-- 
2.20.1

