Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032656B707F
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCMHzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbjCMHzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:55:10 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F43F52F4D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:46 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n203-20020a25dad4000000b0091231592671so12642192ybf.1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678694022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XV2q27+WLDL4yB3jbKiPFzkFK6bHorAt5xnGXFkFXUk=;
        b=dVRBU4O82UHwnt5Y30B3ZHB6/G/EaO8yJcvCP/uADO+q7i0BEcL/Xkls48N3uYj6ll
         ffciX0Q6wkh6UZzNa177AjOY4axJzWSvAyBVaYaJH0ThCzlsABXzcOk0oFbiImvvH4PV
         vcNCWwX2mnUNQa0RckyJzbG4o3U9ij50LTwFD0+06lX9qZc3OBceMOWUdetHs2u45uHt
         tlJoTDDULsa96A362cdw07VpDTJHM2DihyxJT19WdnW49Kt61mz5U/kkAM0RN/jfMv7D
         rDBGTLPbxqd2ek/gUDKRzdviT84/O7CDLs+ZAGOPHZpOCYRBkAKnhN+I+iJ8FW+8eXRJ
         SN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678694022;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XV2q27+WLDL4yB3jbKiPFzkFK6bHorAt5xnGXFkFXUk=;
        b=zxWzX3ztJgBOHDTS1pN2SonAYeEXm4rPF/M6nDyfil5vyOOcDdd2pGJZrK4ZknQpvi
         XhcWC/YlYS8CXMcpiXL9pgFGT69vg/YSNM0zAhoxCHE25BduhEblmvOUii78dKV02qbL
         xb66huSk+xaOTRp+njh72HhFcd6vLoZSKU1TvcJDY3fz6YWiqr6j4P3Cq9nFrr3n6vdp
         u5oxgQh2M/Dy/6yr30lJ1XodlrmoPnm9Fx698vn42NCgMtVS823QeHIN2o9VmTKvgPCw
         QXoToBwADNYE81tsmS7XG3AR56GX9hk2AZZkXExTA5cwCS0SDmDKLKzKCjRkRtH8nif2
         m6nQ==
X-Gm-Message-State: AO0yUKWdBuxuEpyOoIq3YPmWBRZ1SvEuHeVz4i041oWJATAEbklPXtu6
        YhqhZpvBUkfZpmxOdhQDZPTWvUaZuyw=
X-Google-Smtp-Source: AK7set+EPcMnjhQBsGHddOUYCe833wPSx4+V/NsKsO42wJTQSuTB+oXT9gmM6Npq4UbeC+UHQ8QGDtKgF7Y=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:282:b0:a02:a3a6:7a67 with SMTP id
 v2-20020a056902028200b00a02a3a67a67mr20646725ybh.11.1678694022104; Mon, 13
 Mar 2023 00:53:42 -0700 (PDT)
Date:   Mon, 13 Mar 2023 07:53:23 +0000
In-Reply-To: <20230313075326.3594869-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313075326.3594869-3-jaewan@google.com>
Subject: [PATCH v9 2/5] wifi: nl80211: make nl80211_send_chandef non-static
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose nl80211_send_chandef functionality for mac80211_hwsim or vendor
netlink can use it where needed.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V8: Initial commit (split from other change)
---
 include/net/cfg80211.h | 9 +++++++++
 net/wireless/nl80211.c | 4 ++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f115b2550309..bcce8e9e2aba 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -938,6 +938,15 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 				  const struct cfg80211_chan_def *chandef,
 				  enum nl80211_iftype iftype);
 
+/**
+ * nl80211_send_chandef - sends the channel definition.
+ * @msg: the msg to send channel definition
+ * @chandef: the channel definition to check
+ *
+ * Returns: 0 if sent the channel definition to msg, < 0 on error
+ **/
+int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef);
+
 /**
  * ieee80211_chanwidth_rate_flags - return rate flags for channel width
  * @width: the channel width of the channel
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 112b4bb009c8..1fd9e6545225 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3756,8 +3756,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
-static int nl80211_send_chandef(struct sk_buff *msg,
-				const struct cfg80211_chan_def *chandef)
+int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *chandef)
 {
 	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
 		return -EINVAL;
@@ -3788,6 +3787,7 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 		return -ENOBUFS;
 	return 0;
 }
+EXPORT_SYMBOL(nl80211_send_chandef);
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-- 
2.40.0.rc1.284.g88254d51c5-goog

