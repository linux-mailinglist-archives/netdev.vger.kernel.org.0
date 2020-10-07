Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE721285767
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 05:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgJGDyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 23:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbgJGDyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 23:54:18 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75ECAC061755;
        Tue,  6 Oct 2020 20:54:17 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 34so510552pgo.13;
        Tue, 06 Oct 2020 20:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p+QF0MXUCrLAwwOTQcY0kO3Iiy6gO/CVTSWip3EaAQw=;
        b=PkilCjXO3ldpksAP/hgu2ylQJHuGX3Cc/p+GhEdHw13g5S44JTfZCygf/8fz4W+PFJ
         Nb4OmBNVrXUhof9WbgNl40xVtf7D4zqtqIqLaWJ1N22Q2p73kJBs+jJq6mN1lCyOUKyB
         +Y6NQrqC9bl0ZmkrDwTr9UQL/qIo1wV5QFSyP7hUrts/NnYKBYakmqf90XXi59fqmAA1
         lQmHg8TtuiYhZOHIS+DOL59zTpqduP36bpPftwsaO/gscVLeomWMwbjAIF5FU/dhVBDM
         peCclmXfi1F5NJNwAMSZojJFTTXlLqXTYZmegkSdgWRa/XyRAYZ4x+cngJVFXs0tuuH6
         xOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p+QF0MXUCrLAwwOTQcY0kO3Iiy6gO/CVTSWip3EaAQw=;
        b=WpHNznyXLArYsMzYsocAdTPP7imHc5HNDHIHoMHks0hRvPOKGJsHXA3O1bwG+kzqVH
         zPKAWpX1KWR14SD8yPyQoz+Y3d/cG4rNavjzZBcAoCdNwRgQF6cLCcz+V8INgj8Kxs/c
         NCTMBE/qOC4lR30m3OZky3448qVVD8S1F6J6RfmhbG6MwWUQbLT5fl7b/YPAnqs85Foq
         6weFHOCssN2L8cRP0Lmj7S0LcDPYf2FZw/rts9bnj2NKi9XTOdaIGg/fow69Cuibnr1S
         NWWcZarIYaXOnyE+hyhpvbMIuz1N2IDKC3lyPtoYBMRFJb68+qX5HGsYETe5EbvEgR7N
         E/2g==
X-Gm-Message-State: AOAM531aaBUf5QLqk3WETp++tqX0iqWmQbvEPqaP+sCeta3hxQJOBcGW
        KvkDMbTt7bNxGt9UrBidRrQ=
X-Google-Smtp-Source: ABdhPJzUQKiSws5uRfeH5+wvhqfgLF3FUhAd5S5CQv7fIApvbLw3es85ToS/n34WDxWxMhjg6glgmw==
X-Received: by 2002:a63:f803:: with SMTP id n3mr1239963pgh.231.1602042856673;
        Tue, 06 Oct 2020 20:54:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.207.135])
        by smtp.gmail.com with ESMTPSA id k7sm509309pjs.9.2020.10.06.20.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 20:54:16 -0700 (PDT)
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: nl80211: fix out-of-bounds access in nl80211_del_key()
Date:   Wed,  7 Oct 2020 09:24:01 +0530
Message-Id: <20201007035401.9522-1-anant.thazhemadam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nl80211_parse_key(), key.idx is first initialized as -1. 
If this value of key.idx remains unmodified and gets returned, and
nl80211_key_allowed() also returns 0, then rdev_del_key() gets called 
with key.idx = -1.
This causes an out-of-bounds array access.

Handle this issue by checking if the value of key.idx after
nl80211_parse_key() is called and return -EINVAL if key.idx < 0.

Reported-by: syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com
Tested-by: syzbot+b1bb342d1d097516cbda@syzkaller.appspotmail.com
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2c9e9a2d1688..7fd45f6ddb05 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4172,6 +4172,9 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (key.idx < 0)
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-- 
2.25.1

