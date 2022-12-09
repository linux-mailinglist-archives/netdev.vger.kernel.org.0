Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96719648584
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiLIP3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLIP2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:28:53 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2B3FAF1
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:28:50 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id b2so12290714eja.7
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 07:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/CBIx7WhayGl8L5UnKkWTZlh8ccP3yQ9V2VOk1LDfuU=;
        b=g3vLufSXkk6Bd3BbnBSvYEhasj4ZRFzeqITPpY1spDMrZTTsgQWtZjx0r+YQmw17sX
         ZMkDKy6mms6/tQjTrYstAp0/HovfK/Wdhi7W+nl3VNNxpyBkOEG+0tB0gUOQ2tzglGPc
         dYprSHDOKFiY7kDDop4pYjHpFp/ylftdANH3w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/CBIx7WhayGl8L5UnKkWTZlh8ccP3yQ9V2VOk1LDfuU=;
        b=CtxvldqYmvFU8MavCTPaFAiOGIHQ2VTpS1EvJLOI5lJ1S6u7Yb4uqRzoUf0MfQqssW
         AHCrSQ6+TwpqX2kOE+WKq5ziDdNQMuzl8NScUbOINJ8gQQU9655IJQXf27zlEyWAlmEM
         KiXej6t7BBQJes93uHLnh2AVKSkMWzHswXfTrXkfXAf+HvIRVoltGORxlFMGrsycMNYv
         IRlp4JyffYsBrvY3YO6Nm5+gHW42ZM3NhCxwIlfFFW91brTkEKLcPo8yBllkgGW1HPth
         /F4xdc3eqkz7fjKrBHqfjdbiSk6ajPIyw2EBo/y1wsD6UML2Z4sH6nv0DSFQYgx5B5Zl
         RH4w==
X-Gm-Message-State: ANoB5pmKqMzI706F3hp/9VmOncR3Selg+Obm2UaRV68ciJmw4yCIH72A
        M9kZUs60ur8zSZvxSqXh7ezHxQ==
X-Google-Smtp-Source: AA0mqf5/vEoKDQ/I1fRr88dwfhK6CwIW9Llpcvbo3r/hM0pGFZJgqq3o3VphKB2jSTzL6JamOXrW0A==
X-Received: by 2002:a17:906:2881:b0:7ad:d835:e822 with SMTP id o1-20020a170906288100b007add835e822mr4899301ejd.42.1670599729472;
        Fri, 09 Dec 2022 07:28:49 -0800 (PST)
Received: from localhost.localdomain (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id o20-20020a170906769400b0077a11b79b9bsm24901ejm.133.2022.12.09.07.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 07:28:49 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH next] wifi: nl80211: emit CMD_START_AP on multicast group when an AP is started
Date:   Fri,  9 Dec 2022 16:28:36 +0100
Message-Id: <20221209152836.1667196-1-alvin@pqrs.dk>
X-Mailer: git-send-email 2.37.3
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

Userspace processes such as network daemons may wish to be informed when
any AP interface is brought up on the system, for example to initiate a
(re)configuration of IP settings or to start a DHCP server.

Currently nl80211 does not broadcast any such event on its multicast
groups, leaving userspace only two options:

1. the process must be the one that actually issued the
   NL80211_CMD_START_AP request, so that it can react on the response to
   that request;

2. the process must react to RTM_NEWLINK events indicating a change in
   carrier state, and may query for further information about the AP and
   react accordingly.

Option (1) is robust, but it does not cover all scenarios. It is easy to
imagine a situation where this is not the case (e.g. hostapd +
systemd-networkd).

Option (2) is not robust, because RTM_NEWLINK events may be silently
discarded by the linkwatch logic (cf. linkwatch_fire_event()).
Concretely, consider a scenario in which the carrier state flip-flops in
the following way:

 ^ carrier state (high/low = carrier/no carrier)
 |
 |        _______      _______ ...
 |       |       |    |
 | ______| "foo" |____| "bar"             (SSID in "quotes")
 |
 +-------A-------B----C---------> time

If the time interval between (A) and (C) is less than 1 second, then
linkwatch may emit only a single RTM_NEWLINK event indicating carrier
gain.

This is problematic because it is possible that the network
configuration that should be applied is a function of the AP's
properties such as SSID (cf. SSID= in systemd.network(5)). As
illustrated in the above diagram, it may be that the AP with SSID "bar"
ends up being configured as though it had SSID "foo".

Address the above issue by having nl80211 emit an NL80211_CMD_START_AP
message on the MLME nl80211 multicast group. This allows for arbitrary
processes to be reliably informed.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 net/wireless/nl80211.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33a82ecab9d5..323b7e40d855 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5770,6 +5770,39 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
 	}
 }
 
+static void nl80211_send_ap_started(struct wireless_dev *wdev)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_START_AP);
+	if (!hdr)
+		goto out;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_WDEV, wdev_id(wdev),
+			      NL80211_ATTR_PAD) ||
+	    (wdev->u.ap.ssid_len &&
+	     nla_put(msg, NL80211_ATTR_SSID, wdev->u.ap.ssid_len,
+		     wdev->u.ap.ssid)))
+		goto out;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(wiphy), msg, 0,
+				NL80211_MCGRP_MLME, GFP_KERNEL);
+	return;
+out:
+	nlmsg_free(msg);
+}
+
 static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -6050,6 +6083,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 		if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
 			wdev->conn_owner_nlportid = info->snd_portid;
+
+		nl80211_send_ap_started(wdev);
 	}
 out_unlock:
 	wdev_unlock(wdev);
-- 
2.37.3

