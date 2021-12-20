Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6A947A6C0
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 10:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhLTJWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 04:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhLTJWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 04:22:51 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A94EC061574;
        Mon, 20 Dec 2021 01:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=58e2SN0o6X2CuxM+OfUP8YLLhaaSQn8qAvffw8Dsqsc=; t=1639992171; x=1641201771; 
        b=MT9tgauQjUUoikPpEIrRILRVP94y2PFnVZh8vb/702JWlTWeV0hNBZPmDD7nw/WVi1GR9mW14A4
        FsAq77jNMIaJpEqRdxMYQTGwHpargnQtr7OtptOQH1N1nkKvgPVxXsLvuCA6unMAVSiGCmaxmgl0G
        b6csCy/X51gttshYGjUAWyzmb7z7Vq54qwTcz+3KanrIaT2ETA/rPhKtn9Akfg5KFmg9akcycTA2K
        5+MOXfcGs1DwrINqSiXN/0BqRCPdhwb/M33armLw97Mpz2s85CytNqYRlKBrhdaGW33IrNUkjJmVZ
        22pRAoyUgB4rSGk1ACpEA+s1CWcNdiW3rQUw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mzEsX-00E2hF-Mi;
        Mon, 20 Dec 2021 10:22:45 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Subject: [PATCH net] mac80211: fix locking in ieee80211_start_ap error path
Date:   Mon, 20 Dec 2021 10:22:40 +0100
Message-Id: <20211220092240.12768-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

We need to hold the local->mtx to release the channel context,
as even encoded by the lockdep_assert_held() there. Fix it.

Cc: stable@vger.kernel.org
Fixes: 295b02c4be74 ("mac80211: Add FILS discovery support")
Reported-and-tested-by: syzbot+11c342e5e30e9539cabd@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20211220090836.cee3d59a1915.I36bba9b79dc2ff4d57c3c7aa30dff9a003fe8c5c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Jakub/Dave, could you please apply this directly? I have no
other things pending for net at the moment. Thanks!
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd3d3195097f..2d0dd69f9753 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1264,7 +1264,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 
 error:
+	mutex_lock(&local->mtx);
 	ieee80211_vif_release_channel(sdata);
+	mutex_unlock(&local->mtx);
+
 	return err;
 }
 
-- 
2.33.1

