Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88D1ADF89
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730849AbgDQOK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 10:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730563AbgDQOK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 10:10:28 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C602C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 07:10:28 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id c22so591186pgb.7
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 07:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=l/ubaUKeAg8N1Fd1hG4KHPkWsmXk4oxdzdO6tlSczSw=;
        b=rswe3m6ZkBhYk60C7EqcAsWBxMswWed3fMpumuTLViKJfN04hFuO00WvJ4bS+F45Ng
         N2kP9rVumzJpgMAHjs+WQufMLkx3S9a4G9VUYWNEey3cdlepQuPsqwFnh1mFT1TZO8WL
         qf2iw7HHlsoWUDJ8d9MMnA5o3/yCH9dj5dHULJApgmG6N/JvOj1QJvu9xUiuh8HOKX2g
         Za3vxkWy0i8gh+KzkQXbrclCB4/ibclh4Ps5C5dnCQNohFxvlJ97LW04yIOUwGJ3IaOm
         tQmg2rUXpngW+skvwYMkzmMpgUB6vek7KbcGiTw87pc+li8dZLChXyOHy3yHsEcghSfy
         di2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=l/ubaUKeAg8N1Fd1hG4KHPkWsmXk4oxdzdO6tlSczSw=;
        b=iXnApIMd/CO2GroMSIrPksS4W2Ih/ONpPT5f3zewtavfS84MZcBCttL1KaCAahM12n
         C6+k6KCIxgIttccMHl51FWbybqnyz7YYQujHOxZIiIXAIipPC/u/lKUVkif3FzLX1EN5
         OM0Mf/9QUTTJidZHbrB+Hb80QDpWM5OPcT0uPP8MQ8C1hdh5weUPQZ6qzYtoULkb/Kbg
         lR1hT+pk9Othyh0+J/rqKQ1kjHu3gpOnhLL1sFu/XuWujmmRKgV3QM5wqfMK2aVIAt81
         zdKhIPmpVYGCfxeVW96B22I28K82CpgpToW60B86d6wkOaoXxmMJKiJ21GM6OsPlIYaO
         XVxw==
X-Gm-Message-State: AGi0PuZmByVqTDpLTJDe1XR5s/lXR0O1sPC01Or9FuOOZFAgMrbWMgQo
        Wty63wIs4+r6Q7N2SazHPqAOhVRloXag0g==
X-Google-Smtp-Source: APiQypKTwVX6TmSzHsTnQtBfoPl/CRNmbNjUPh1EyI7PsEJ9aGEpfg2Zz1/AZQLVJZw4tfatVCr2rORjsr72/Q==
X-Received: by 2002:a17:90a:23ad:: with SMTP id g42mr4487754pje.35.1587132627955;
 Fri, 17 Apr 2020 07:10:27 -0700 (PDT)
Date:   Fri, 17 Apr 2020 07:10:23 -0700
Message-Id: <20200417141023.113008-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH net] tcp: cache line align MAX_TCP_HEADER
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP stack is dumb in how it cooks its output packets.

Depending on MAX_HEADER value, we might chose a bad ending point
for the headers.

If we align the end of TCP headers to cache line boundary, we
make sure to always use the smallest number of cache lines,
which always help.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
---
 include/net/tcp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5fa9eacd965a4abd6a4dd5262fa0d439aa9fe64e..dcf9a72eeaa6912202e8a1ca6cf800f7401bf517 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -51,7 +51,7 @@ extern struct inet_hashinfo tcp_hashinfo;
 extern struct percpu_counter tcp_orphan_count;
 void tcp_time_wait(struct sock *sk, int state, int timeo);
 
-#define MAX_TCP_HEADER	(128 + MAX_HEADER)
+#define MAX_TCP_HEADER	L1_CACHE_ALIGN(128 + MAX_HEADER)
 #define MAX_TCP_OPTION_SPACE 40
 #define TCP_MIN_SND_MSS		48
 #define TCP_MIN_GSO_SIZE	(TCP_MIN_SND_MSS - MAX_TCP_OPTION_SPACE)
-- 
2.26.1.301.g55bc3eb7cb9-goog

