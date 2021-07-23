Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883B33D33EA
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 07:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhGWE3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 00:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhGWE3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 00:29:11 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BADEC061575;
        Thu, 22 Jul 2021 22:09:45 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id f1so1900994plt.7;
        Thu, 22 Jul 2021 22:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PH147XuCWyb6h3MTkLRYNAK5eXqhCfzzFLL0PdUER9M=;
        b=u+TQD/HHf+RGmWW2Eo+Bg0J0+rKaYoZSUaRklxLTVgr6ecH123Vki37uyvvDDQ/ZDC
         3xsfcSk5oTX8+v3xbifKToSCfyfWVFuah/cKT5oZ2roERRD+FR4O8ZDQbAMghJXKqFAV
         pyOUB8hC5+H+kfbOwGdHZrmjm8eTraCtlGkL/a8dqRa6swmwOLOcLabxqaCHgg+E605C
         eY38aRwleVJsac6lXdqMdB1YlOyUuUunnvU+v/zavTaKSx7njtHWM5+qiLETs8HqRlyM
         kf0zZv1xIjxgYmzE3HetFwJHkNfT6uvhMXer+hqMFGwVfMvOVAk7zJyuQg89RH9LBYN8
         TCvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PH147XuCWyb6h3MTkLRYNAK5eXqhCfzzFLL0PdUER9M=;
        b=YIbs7MiqRwcooXaY2Z7utx3muS8jSsB6vJe1LVw6yJr5DwTRScCZjjA7PP3IL8r8yW
         rFOVKZ1wr5jyA/TcgUDdAekWWgpQq9JEumaPevC4DlC8es0KWkUDPGJKBWigYNcoaAvq
         j6fdh8TO+JCfSSB/06s07AJEflacWChKlzcmtH3uZ0qoEwFnR3UBAg7/WBm9j51+oXAQ
         ASFjx5M7wDaNffqTNOVWm8RXqiYTCQgYOl+86Qzw1RQ+y6XfpDz5CwHFoIYn2j2NDubl
         6CwMA0ESO1GyqS+/xFVMSZ0gf4h2uc2b793wkk3LLd1z0iuy5BgWK6Assu7kCONhwttz
         GZQQ==
X-Gm-Message-State: AOAM530PPeRhFzEhVjwDuUAdxlr18T1RN+ZKnpMcWTrzCbZzDAUxtc+w
        6wfmJWPGQHI+bBTGdsDGXrI=
X-Google-Smtp-Source: ABdhPJxZi4QW2uiefQyknp3u4VnPLC6l95TEgpMpYcsGOoYx7Q5jBBz91jAOB88oF+BoR4HvsK//zw==
X-Received: by 2002:a17:902:ed95:b029:ee:aa46:547a with SMTP id e21-20020a170902ed95b02900eeaa46547amr2511805plj.27.1627016984441;
        Thu, 22 Jul 2021 22:09:44 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.166])
        by smtp.gmail.com with ESMTPSA id s193sm32917483pfc.183.2021.07.22.22.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 22:09:43 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: free the object allocated in wiphy_apply_custom_regulatory
Date:   Fri, 23 Jul 2021 13:09:14 +0800
Message-Id: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit beee24695157 ("cfg80211: Save the regulatory domain when
setting custom regulatory") forgets to free the newly allocated regd
object.

Fix this by freeing the regd object in the error handling code and
deletion function - mac80211_hwsim_del_radio.

Reported-by: syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com
Fixes: beee24695157 ("cfg80211: Save the regulatory domain when setting custom regulatory")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ffa894f7312a..20b870af6356 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3404,6 +3404,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	debugfs_remove_recursive(data->debugfs);
 	ieee80211_unregister_hw(data->hw);
 failed_hw:
+	if (param->regd)
+		kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
 	device_release_driver(data->dev);
 failed_bind:
 	device_unregister(data->dev);
@@ -3454,6 +3456,8 @@ static void mac80211_hwsim_del_radio(struct mac80211_hwsim_data *data,
 {
 	hwsim_mcast_del_radio(data->idx, hwname, info);
 	debugfs_remove_recursive(data->debugfs);
+	if (data->regd)
+		kfree_rcu(get_wiphy_regdom(data->hw->wiphy));
 	ieee80211_unregister_hw(data->hw);
 	device_release_driver(data->dev);
 	device_unregister(data->dev);
-- 
2.25.1

