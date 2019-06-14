Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5F44552A
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 08:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfFNG7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 02:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbfFNG7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 02:59:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939C92063F;
        Fri, 14 Jun 2019 06:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560495577;
        bh=GE6kHlZhWjeir7ihj8EED4mH6wyPeJJCUgG+az2TV5k=;
        h=Date:From:To:Cc:Subject:From;
        b=1D7uYNsXWMLUv5stOEuz+G6hJ4eG6KlOl07Z79zO2ayNnSFn0OztQDnYNABmyldyI
         mSY5/Rk+IpihF/caIWfjXeTepLpJi3nLh3jle0uTBTeHqYvEmvI85XBGlbXeI9MwBc
         8Vg/3H1vye5FuuH0TbiFlghN/xnqbLWX0OYG1eoA=
Date:   Fri, 14 Jun 2019 08:59:34 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] mac80211: no need to check return value of debugfs_create
 functions
Message-ID: <20190614065934.GA23295@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.0 (2019-05-25)
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
 net/mac80211/debugfs_key.c    |  3 ---
 net/mac80211/debugfs_netdev.c | 10 +++-------
 net/mac80211/debugfs_sta.c    |  2 --
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index a2ef95f16f11..1a25de4e7e78 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -342,9 +342,6 @@ void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 	key->debugfs.dir = debugfs_create_dir(buf,
 					key->local->debugfs.keys);
 
-	if (!key->debugfs.dir)
-		return;
-
 	sta = key->sta;
 	if (sta) {
 		sprintf(buf, "../../netdev:%s/stations/%pM",
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index deb3faf08337..f6508cf67944 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -818,9 +818,8 @@ void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
 	sprintf(buf, "netdev:%s", sdata->name);
 	sdata->vif.debugfs_dir = debugfs_create_dir(buf,
 		sdata->local->hw.wiphy->debugfsdir);
-	if (sdata->vif.debugfs_dir)
-		sdata->debugfs.subdir_stations = debugfs_create_dir("stations",
-			sdata->vif.debugfs_dir);
+	sdata->debugfs.subdir_stations = debugfs_create_dir("stations",
+							sdata->vif.debugfs_dir);
 	add_files(sdata);
 }
 
@@ -845,8 +844,5 @@ void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
 		return;
 
 	sprintf(buf, "netdev:%s", sdata->name);
-	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
-		sdata_err(sdata,
-			  "debugfs: failed to rename debugfs dir to %s\n",
-			  buf);
+	debugfs_rename(dir->d_parent, dir, dir->d_parent, buf);
 }
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 8e921281e0d5..b2542bb2814e 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -960,8 +960,6 @@ void ieee80211_sta_debugfs_add(struct sta_info *sta)
 	 * dir might still be around.
 	 */
 	sta->debugfs_dir = debugfs_create_dir(mac, stations_dir);
-	if (!sta->debugfs_dir)
-		return;
 
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(aid);
-- 
2.22.0

