Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A411CC3B3
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 21:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbfJDTma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 15:42:30 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34092 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727978AbfJDTm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 15:42:29 -0400
Received: by mail-io1-f66.google.com with SMTP id q1so16130919ion.1;
        Fri, 04 Oct 2019 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6BXYfSwt6S2bUCRJ7kdKcLjYfKsE5OTiBqsT8oWEIdk=;
        b=Z+fbZVxeP1BB9h3aBY5Vc8ABBOQxPOQSDHr68Bj2NCOV/Yco6n4WR+H+PyOjRpVR0l
         W8UMqQK3aTsDmpvC0oQgybcWw/OR8QY0D5jCJoBRXEyyE7MAabJRAX+PL15VlNxpQWNX
         7QqYiKVavN9RZqC62dZLLaDCDNGCUOh79LH0oEtIjOSJU2xqHn4GzcG4OjjdY4c75Ske
         AshyucaJYg6uBjcXZ2vYpgBQ4A578gA3cUC3n6JowKvJkBjQBCc6x9FgQCoWZf64GpKk
         xuOFui0U22GNKVuIl92m5jRO5TSUVc1UvhNQF1RNCIz4JQckcS5wz9MWpTFbNN+WH3pz
         d4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6BXYfSwt6S2bUCRJ7kdKcLjYfKsE5OTiBqsT8oWEIdk=;
        b=O39cNC4B2daowrL+rmU7sDH3e2vudZo8Pa9Mt/aBHhxH/XvEA63BtqSa1VInNjEwb7
         B+MN0jdOIDyW8TawS1+25QPWK8rZl4V/cMAiLMma1st+/GKETvQCwT4tc0Lewat5WSEB
         bbOiSj9ir8H2nRRAEGIuTK3u02U/x1kQp27yi86V57Ak21Q9I4zMUBlyQYsk45+GsH1J
         2TjkSbdKpH3hvBGyHnIKhV63Tkjy8DvR8CkXdGvEFbK2Krj6/69YXaA9G/LxjJ04qgEE
         Sn5hBK8dO97w43qw/jT+Z2/WCeI4x1LmagXO3hr0egRn3TN7Lroh0qbEFw+EuVw0E46V
         w8Ng==
X-Gm-Message-State: APjAAAXaLIwo3UbzfunZrkI06lR479VbNn9sclUoI2nTNhI/+Sd753k2
        6J6vcL4YY7m3BQWku/qYk5mT9Uou43M=
X-Google-Smtp-Source: APXvYqwIqPqUaUtZkxGmJFCcYz2Kv1eMF8I2/gMKXeYv75IkMbeSZCgbZUJY49EEiRw7gNQQZaytFg==
X-Received: by 2002:a92:8fda:: with SMTP id r87mr17155295ilk.210.1570218148669;
        Fri, 04 Oct 2019 12:42:28 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [128.101.35.54])
        by smtp.googlemail.com with ESMTPSA id d9sm2458243ioq.9.2019.10.04.12.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 12:42:28 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nl80211: fix memory leak in nl80211_get_ftm_responder_stats
Date:   Fri,  4 Oct 2019 14:42:19 -0500
Message-Id: <20191004194220.19412-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nl80211_get_ftm_responder_stats, a new skb is created via nlmsg_new
named msg. If nl80211hdr_put() fails, then msg should be released. The
return statement should be replace by goto to error handling code.

Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d21b1581a665..cecd3bf101f8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13644,7 +13644,7 @@ static int nl80211_get_ftm_responder_stats(struct sk_buff *skb,
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_GET_FTM_RESPONDER_STATS);
 	if (!hdr)
-		return -ENOBUFS;
+		goto nla_put_failure;
 
 	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
-- 
2.17.1

