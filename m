Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED0DE64C6
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 19:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbfJ0SE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 14:04:58 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36887 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfJ0SE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 14:04:57 -0400
Received: by mail-io1-f65.google.com with SMTP id 1so7933043iou.4;
        Sun, 27 Oct 2019 11:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ZgPLmfyNIkVaXxK74nO6qdkfwCHUd5zoiXZjg6l83+w=;
        b=cZAKZIsWbPh32OM0h6otiUzaq72/BpOhPBLluF28+cMo4kAoZ0z8/+Mjdg/uuWOj5e
         2qX4JZe9Y6xRgc2JfjnpDVV5/YYhf+5brcklcgWkbQz40YrbKj46zlZ9sJo2mReA2DwQ
         TwfQRLizNviq9N/DYTuydwBHdwNQH2N7SNg0ONE6lBUZUrenLf/8Mnhk2a5kJ+i8MJIk
         2gfrC6q++ctKDAzjF1KCvPUymM+k/4bDv9XXXCi/ZyKrfadfiqF11Vh4iao0zI5WNq58
         pQveJs1YM2AINg4PvPJGgeuvBSpayepA0YHTzOJp27mdTqr6lVaqrkFaB4k4qmJGQ81r
         oQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZgPLmfyNIkVaXxK74nO6qdkfwCHUd5zoiXZjg6l83+w=;
        b=qbx4cYwcaZ9aVCTB9C49Pq5WnGS8qbIYZz+9NVZKNZ+KMrtpCjfYTOx5CBUzpY8/nk
         lOH9oLk829AfbhfM4sKCjB/PcK7EvS4esvYTtcg0mS+mi+gkpRJZA0T54P58tFeAZqNX
         0g5vHJvtm6k8PGTTpXlV/mKucUgMI6bBcWluL3SCBP58ojhhryLx6T3ULfqiHAdQNpWV
         6LO9y4yaAPzv3Xdpq1LAgV48vmDu2Jo2GxTnYCx+K089Vd0S5Ku2Luocw3sY83gbY6TN
         l8iYEs9tQMoFc1FOCW8bpKbt10BsB3u2SZIiOx+I4Srf2z5DbNk40yXmRh9FQbYUq3Wg
         OkCQ==
X-Gm-Message-State: APjAAAVZw1hwpCVqfCMRZgSV4SPbP/bk8dX0OXBlURiDbyn1d+BlPLg6
        ULkZ5lvcOfy70PNL+vU7mkE=
X-Google-Smtp-Source: APXvYqyB9tqMh+WJwV5Yh+pGw2kkndK5g88beOl9fn2P4jM+tU/iweK2BeOp3oboTaiy/jUfTbpnQQ==
X-Received: by 2002:a6b:d104:: with SMTP id l4mr14218413iob.50.1572199496693;
        Sun, 27 Oct 2019 11:04:56 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id 9sm1187754ilt.16.2019.10.27.11.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 11:04:56 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: Fix memory leak in cfg80211_inform_single_bss_data
Date:   Sun, 27 Oct 2019 13:04:46 -0500
Message-Id: <20191027180447.8998-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of cfg80211_inform_single_bss_data() the allocated
memory for ies is leaked in case of an error. Release ies if
cfg80211_bss_update() fails.

Fixes: 06aa7afaaa21 ("cfg80211: add cfg80211_inform_bss")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index aef240fdf8df..686eb227bcc3 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1437,8 +1437,10 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	signal_valid = abs(data->chan->center_freq - channel->center_freq) <=
 		wiphy->max_adj_channel_rssi_comp;
 	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid, ts);
-	if (!res)
+	if (!res) {
+		kfree(ies);
 		return NULL;
+	}
 
 	if (channel->band == NL80211_BAND_60GHZ) {
 		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
-- 
2.17.1

