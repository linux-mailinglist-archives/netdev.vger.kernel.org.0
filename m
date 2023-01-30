Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC3C76806B3
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 08:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235482AbjA3Hp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 02:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235425AbjA3HpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 02:45:22 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F1D18B2D
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 23:45:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l40-20020a25ad68000000b0080b821fbb0fso12242457ybe.13
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 23:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NGmk51CCKcAKRhbiqyWogk1UQgGD95j5Rcfy6uBYfbg=;
        b=UABrQ96CX4rhaVZW6t2QPtsRFEbyGc0Si9JtLTtEVUie+G6WCqaZXOYtWDfpqn54q4
         y2fis2FL3p3uo0WWu+GNugV0JAsw2jr7zjgbdFF/jj9C6dD3Le5JI0Mb9vn9kEG0h0Nx
         jOe3noZGz4eoLG65qj1f53rmxoJZthSJLpslIr58hmK4a4LGalztVMn+z/Sd2bYy019l
         1FbKYr4geJVWchuVsx/UZZutXjr5ZlMYE+mRe1dS/a4zu5eVeWoHXlqH6q7BiVAaV9Ok
         GJBvfVc33XBDnVstTUBaZxOBkyLB7u8/1X8OCCQUM3ems04+yGrNQ9CC+erqkegKN2nV
         MyPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NGmk51CCKcAKRhbiqyWogk1UQgGD95j5Rcfy6uBYfbg=;
        b=IhljuMkC8i06mGtF9q29KIYIl78QrdaImTmUQ6Or1bJik63Qw2wYG6YUaYArokkJYm
         JkQgAQ7TuOAGLvZLD632axEzSIjRx+9IG4AjA/reWQvQ3CnHyhaxebtk4r6Xz0jFHxru
         JdYznJla10/pKe1nlG89wSe+dg693z+nkIY0m+R8LiylreJPAaclOvd7zL6dMPE+SVoi
         iQPCWLoqdwvyyiaUoO8kLOsyWJ8549xb4Iiydrfbt+N31da0DqfAmFpveDon8nFJzcn5
         HC6DyIUVwt13IM0DGDRTBNRuCiaJzGCyQk3rSNEmsiPM0ZGy8wD8pXRnE3nJ8hFFMlrS
         8pFQ==
X-Gm-Message-State: AFqh2kptF/FT+r9vVFT+yG2cvOMYc0159CPsLjZS2bI+FyixLk8NF9X6
        VxIIbisj5M8YjcTX1lKiOTitTMQbWSo=
X-Google-Smtp-Source: AMrXdXuh1GYnokliZipsoswZ9/Qq1Dxz+VJKyPNgRLMycJzRNzKbHJM8Vy1N6zKYILiqt3jbsTFytjf8u3E=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a25:644:0:b0:7c8:3b5:b58d with SMTP id
 65-20020a250644000000b007c803b5b58dmr6585606ybg.494.1675064719934; Sun, 29
 Jan 2023 23:45:19 -0800 (PST)
Date:   Mon, 30 Jan 2023 07:45:14 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230130074514.1560021-1-jaewan@google.com>
Subject: [PATCH] wifi: nl80211: log for malformed chandef
From:   Jaewan Kim <jaewan@google.com>
To:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@android.com, Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change ensures consistency for returning error in
nl80211_parse_chandef() by logging reasons for all EINVAL returns.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33a82ecab9d5..e12b01721bec 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3181,8 +3181,11 @@ int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 	struct nlattr **attrs = info->attrs;
 	u32 control_freq;
 
-	if (!attrs[NL80211_ATTR_WIPHY_FREQ])
+	if (!attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		NL_SET_ERR_MSG_ATTR(extack, attrs[NL80211_ATTR_WIPHY_FREQ],
+				    "Frequency is missing");
 		return -EINVAL;
+	}
 
 	control_freq = MHZ_TO_KHZ(
 			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
-- 
2.39.1.456.gfc5497dd1b-goog

