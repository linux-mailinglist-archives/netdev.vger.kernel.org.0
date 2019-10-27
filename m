Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06F6CE64CD
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 19:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfJ0SQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 14:16:09 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45741 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfJ0SQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 14:16:09 -0400
Received: by mail-io1-f65.google.com with SMTP id s17so819492iol.12;
        Sun, 27 Oct 2019 11:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EqTKYGxwRtgKou170QTjCapfCQnW5veBmjxT9IVfvCE=;
        b=MfuI91WKKqXR97ZU9J9jt2dh1Z65+IKMClcwi0TkJ2wvdYZx+Er7goJsODxQWJNXIY
         npSrebR5opDlXtLiiGqJ0gL2+kQbGDaXzI7ozEnsrspa9cV/ESQhBWlk10A3DepJTAAn
         ATxiziWlnMse+DR5gQVx7+iSK8uJCMYeI/qbBfc/UmvvVjbiPyHl+sR7HCQGG0xQwhmQ
         moOwNhbi/WDBxhyZritiE5Y4qYuxt7bHzevwLAb0r+NRg6ItntbyOJSEWcQfR3KfrDHF
         f+0pCaNgRkFCyUUX9wpP+Nln5Yl8bu2BE8vcMxOczB5JxZPL+9cWlLvKJ0EoiXF2eg3L
         M8Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EqTKYGxwRtgKou170QTjCapfCQnW5veBmjxT9IVfvCE=;
        b=D1zWZwvOiQCnItiT5QrH0FR1FtC5ThXklW5KIRI23blmf+PM5LZ902OQsQxEd/aWW/
         KCYWkOqShcSkUc7wzUx2Ab9T35/eUXABLnSu4d7D5/mgINE9mVibeq8BJncUA9QbNUmz
         OhP0YYxtqm9idBqj4VZo/y2dXosRpzjOhwpwPVZln4maj1YphjQQDtkmaVK8Usxlo7+G
         BC73o0+ivpbk6SSwEvxpOczrqVC/3ebErTvX0Icq4digb7Qn+zf9tv+9LzJd5i3uQp9f
         QJ3aCHOdvRp8O9oaRa7T5UlcaMYJ4ehm7R7KAp9xq/paLlh78m24KUZYKs3UjNMBqsTg
         PGgQ==
X-Gm-Message-State: APjAAAUGBXg7Sr1SEAmXKJilQtwLg9ms6olBBX0x6NSuI7nTrmzvX36F
        VV0vmtsPLWWuk+MAFXLBt9o=
X-Google-Smtp-Source: APXvYqzWPE2pA6JCuu+MmemrSKfrvLtp4hSCnODwCRO+642Ahn7R0MCo38lHNFUzEigDE0ZFt44wIQ==
X-Received: by 2002:a02:3541:: with SMTP id y1mr13912734jae.65.1572200168642;
        Sun, 27 Oct 2019 11:16:08 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id i17sm326316ioj.21.2019.10.27.11.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 11:16:08 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, smccaman@umn.edu, kjlu@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: Fix memory leak in cfg80211_inform_single_bss_frame_data
Date:   Sun, 27 Oct 2019 13:15:59 -0500
Message-Id: <20191027181600.11149-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of cfg80211_inform_single_bss_frame_data() the
allocated memory for ies is leaked in case of an error. Release ies if
cfg80211_bss_update() fails.

Fixes: 2a5193119269 ("cfg80211/nl80211: scanning (and mac80211 update to use it)")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index aef240fdf8df..fae5af24f668 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1856,8 +1856,10 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 		wiphy->max_adj_channel_rssi_comp;
 	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid,
 				  jiffies);
-	if (!res)
+	if (!res) {
+		kfree(ies);
 		return NULL;
+	}
 
 	if (channel->band == NL80211_BAND_60GHZ) {
 		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
-- 
2.17.1

