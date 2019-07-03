Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED8A5DE5D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 09:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfGCHBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 03:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfGCHBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 03:01:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48EE621880;
        Wed,  3 Jul 2019 07:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562137304;
        bh=qplk9YmgW1eH6/vdUpFgi4YZtVS/L1o4YIEX8UeSj5A=;
        h=Date:From:To:Cc:Subject:From;
        b=K5+6aVCInNHn+DVUmnS/w/roklMiBF+1d7sN9vilgihhwF9qX4jIrrrCakCuZ9W7e
         rpVp6qgf+dO9kH6XfrUcsyOgG3rypKDd5qVHY3P0PLgrYo9HCSAkm7ZgA9NvFDacKn
         44F8OCOVx84koh4Yc0qYANxlTTAb9HM/j/KAbQPk=
Date:   Wed, 3 Jul 2019 09:01:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] wireless: core: no need to check return value of
 debugfs_create functions
Message-ID: <20190703070142.GA29993@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling debugfs functions, there is no need to ever check the
return value.  The function can work or not, but the code logic should
never do something different based on this.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 037816163e70..339b0ccb3241 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -142,12 +142,10 @@ int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 	if (result)
 		return result;
 
-	if (rdev->wiphy.debugfsdir &&
-	    !debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
-			    rdev->wiphy.debugfsdir,
-			    rdev->wiphy.debugfsdir->d_parent,
-			    newname))
-		pr_err("failed to rename debugfs dir to %s!\n", newname);
+	if (rdev->wiphy.debugfsdir)
+		debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
+			       rdev->wiphy.debugfsdir,
+			       rdev->wiphy.debugfsdir->d_parent, newname);
 
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
 
@@ -886,11 +884,8 @@ int wiphy_register(struct wiphy *wiphy)
 	cfg80211_rdev_list_generation++;
 
 	/* add to debugfs */
-	rdev->wiphy.debugfsdir =
-		debugfs_create_dir(wiphy_name(&rdev->wiphy),
-				   ieee80211_debugfs_dir);
-	if (IS_ERR(rdev->wiphy.debugfsdir))
-		rdev->wiphy.debugfsdir = NULL;
+	rdev->wiphy.debugfsdir = debugfs_create_dir(wiphy_name(&rdev->wiphy),
+						    ieee80211_debugfs_dir);
 
 	cfg80211_debugfs_rdev_add(rdev);
 	nl80211_notify_wiphy(rdev, NL80211_CMD_NEW_WIPHY);
-- 
2.22.0

