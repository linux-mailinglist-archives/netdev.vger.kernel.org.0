Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E765052BAED
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbiERMdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 08:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiERMb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 08:31:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A0014CA3E;
        Wed, 18 May 2022 05:29:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F0B6B81FBC;
        Wed, 18 May 2022 12:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046FAC385A5;
        Wed, 18 May 2022 12:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652876940;
        bh=skf72eKnPydbXAD+C8AUVtvHd8SfUZDOivH4WGlXk9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q385eD66xD2DbuaHk6FjKY9QNGiV7zQUVhdcXw7GDYEBYJrJ22wI4vK+qcaNn9nVa
         WdOCogRlIg7znOUuwPnKB9vAh1NXsjre3XFxBY3ugedB8T4x6rHuTJgAH4dibD5Mqy
         cYTNjdzikJZ7cilRZM8q0qbl1Mx3yfYuLvdxLsBiO9rVQEUV79QTtQ/RZ6VAMUmIH5
         JcYNziMQi/9q8PHBAVVMcD0J4rHTK7gzPBErqBMKug54yG8oDA7fMFyTuQTweioJP0
         j12lUnGKThx5oK2/xdNqyiFWzMp78swBVtdd7VVDbXD/ZBPbbZ3U/BgmQQzJX3MfKH
         Y/ROKGrwVSnig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/13] nl80211: fix locking in nl80211_set_tx_bitrate_mask()
Date:   Wed, 18 May 2022 08:28:36 -0400
Message-Id: <20220518122844.343220-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220518122844.343220-1-sashal@kernel.org>
References: <20220518122844.343220-1-sashal@kernel.org>
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
index 283447df5fc6..f8d5f35cfc66 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11095,18 +11095,23 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
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
 					    dev);
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

