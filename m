Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6336B52BA4F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiERM1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiERM1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499FA111BBA;
        Wed, 18 May 2022 05:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0DB3B81F40;
        Wed, 18 May 2022 12:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43623C34117;
        Wed, 18 May 2022 12:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876845;
        bh=m80PVdEZX1lH4vWt6edcuHR6RqQ39qIO0Eig5ttw22Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYPQmPHzLGui8T3MJo2wjId5UWBDdl5Jceo1HBaBBzw2yBVaCNpzYzTpIENWOPTR4
         h8AYbLmNAW/ZIOxSTGgZhrsH7y2WeFD/cPDFLJNa+Rqe04lyXX4OUk9BpvrWKjMlTn
         cHtRuLlBKwz5UPL3LzbR7UpJoiiT+tKv6+myxuCKy9JobSQYxrQ44NedoWjQc7JjMO
         sfJoPMewIViw9LdU3/EN6RuPhHW+riF7REzvN6xIgHBXcpoZacMY9dTvFdPoCC1+aj
         65EkVPbMAAmTTaLvxCqCB3efYOr+ztIGSyflIV14KrGLtwXA+cZfURP33XpBxnTNFC
         8CI58uBGUgxAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 15/23] nl80211: fix locking in nl80211_set_tx_bitrate_mask()
Date:   Wed, 18 May 2022 08:26:28 -0400
Message-Id: <20220518122641.342120-15-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122641.342120-1-sashal@kernel.org>
References: <20220518122641.342120-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f971e1887fdb3ab500c9bebf4b98f62d49a20655 ]

This accesses the wdev's chandef etc., so cannot safely
be used without holding the lock.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://lore.kernel.org/r/20220506102136.06b7205419e6.I2a87c05fbd8bc5e565e84d190d4cfd2e92695a90@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 06a35f1bec23..0c20df052db3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11573,18 +11573,23 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	struct cfg80211_bitrate_mask mask;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	if (!rdev->ops->set_bitrate_mask)
 		return -EOPNOTSUPP;
 
+	wdev_lock(wdev);
 	err = nl80211_parse_tx_bitrate_mask(info, info->attrs,
 					    NL80211_ATTR_TX_RATES, &mask,
 					    dev, true);
 	if (err)
-		return err;
+		goto out;
 
-	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
+	err = rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
+out:
+	wdev_unlock(wdev);
+	return err;
 }
 
 static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
-- 
2.35.1

