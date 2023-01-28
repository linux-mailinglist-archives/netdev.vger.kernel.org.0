Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E68B967F7E2
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 13:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233518AbjA1M7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 07:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjA1M7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 07:59:02 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD016518DC
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:58:59 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id mg12so20369951ejc.5
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 04:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TGiVQCAPVenbpU4R0UlRE+cCXkPIO6idXxOzj44qmV0=;
        b=NOXp64PlL5aJZuCGG3Li4mElZSQPvkCcefvyvXKv9nPVd6S3pcAfkwiyzC+wIXY3uH
         jkjpScv813kZjRxrzQKJgJnRVuCFI9SeHPF0JSR6LbDmD7fyzD5jKtoZ+kMsGophMV2N
         dUKG2OsauDDEoZn2ACy4S+i+Hfd1A0U64rCjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TGiVQCAPVenbpU4R0UlRE+cCXkPIO6idXxOzj44qmV0=;
        b=mT3weRMQaodBELJSg54vGt6YUPJ1ron5o0s0YVbd/m7ujUkyRmJUKSjVsuE8Pq0c3C
         midTWM73WZ+o6HOISBkvJlJ3IqK1ATqB1B4o1sxmQby4isNMoxMWnTiDTSJxc+grfcDV
         DoP9KoCaMNY0+wzQriHGKyLG7YR3OiQ2k4gNHzAO56rM/DuX1dLMdDCTOrR3YHANooVR
         JKos+guihUFKQQ5lkWZf96tQczDGQAVFDc3C8SzLgHK36glVytW/l84buojsWeoI0LBC
         U7VPEpPemeaLXvN7EXavcn1IVpLM8bTLfD+oGEqKAztxyMO1hS5aM+3vxhBad+ytGXBq
         eUpQ==
X-Gm-Message-State: AFqh2kph4M3D2TJ+A/CGYZWmsvgT8B9GgXUN+ugt4ZpozGxFCAaagdtP
        htGdSq6kirPHJX1gT5YN8Vfr2A==
X-Google-Smtp-Source: AMrXdXvBj1/K6U8JZ4UStLdlVY8y8dYanmULvL+9Aqp+CzeTrzxkQ7Po5IEBuebAxjGp2azfs+2T1Q==
X-Received: by 2002:a17:906:3f87:b0:809:c1f4:ea09 with SMTP id b7-20020a1709063f8700b00809c1f4ea09mr41433760ejj.69.1674910738479;
        Sat, 28 Jan 2023 04:58:58 -0800 (PST)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id f25-20020a170906139900b0087b3d555d2esm2730051ejc.33.2023.01.28.04.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 04:58:58 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 next 2/2] wifi: nl80211: add MLO_LINK_ID to CMD_STOP_AP event
Date:   Sat, 28 Jan 2023 13:58:44 +0100
Message-Id: <20230128125844.2407135-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230128125844.2407135-1-alvin@pqrs.dk>
References: <20230128125844.2407135-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

nl80211_send_ap_stopped() can be called multiple times on the same
netdev for each link when using Multi-Link Operation. Add the
MLO_LINK_ID attribute to the event to allow userspace to distinguish
which link the event is for.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
v1 -> v2: new patch
---
 net/wireless/ap.c      | 2 +-
 net/wireless/nl80211.c | 6 ++++--
 net/wireless/nl80211.h | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index e68923200018..0962770303b2 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -39,7 +39,7 @@ static int ___cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		wdev->u.ap.ssid_len = 0;
 		rdev_set_qos_map(rdev, dev, NULL);
 		if (notify)
-			nl80211_send_ap_stopped(wdev);
+			nl80211_send_ap_stopped(wdev, link_id);
 
 		/* Should we apply the grace period during beaconing interface
 		 * shutdown also?
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7370ddf84fd3..fd231e37ea9d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19701,7 +19701,7 @@ void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp)
 }
 EXPORT_SYMBOL(cfg80211_crit_proto_stopped);
 
-void nl80211_send_ap_stopped(struct wireless_dev *wdev)
+void nl80211_send_ap_stopped(struct wireless_dev *wdev, unsigned int link_id)
 {
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -19719,7 +19719,9 @@ void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex) ||
 	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
-			      NL80211_ATTR_PAD))
+			      NL80211_ATTR_PAD) ||
+	    (wdev->valid_links &&
+	     nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id)))
 		goto out;
 
 	genlmsg_end(msg, hdr);
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index ba9457e94c43..0278d817bb02 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -114,7 +114,7 @@ nl80211_radar_notify(struct cfg80211_registered_device *rdev,
 		     enum nl80211_radar_event event,
 		     struct net_device *netdev, gfp_t gfp);
 
-void nl80211_send_ap_stopped(struct wireless_dev *wdev);
+void nl80211_send_ap_stopped(struct wireless_dev *wdev, unsigned int link_id);
 
 void cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev);
 
-- 
2.39.0

