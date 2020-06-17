Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746751FD259
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgFQQkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgFQQkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 12:40:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F942C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 09:40:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c3so3186614ybp.8
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 09:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QL5RU32o7P70EDLV5c2O9ftBFd4A4NCwoyKteQvPMK0=;
        b=mvv3MXVp/SkwNJWdC6tmSuUp/Xhpohm0Nf/qGbAYgYJXQ79pSxgGr5OhSfNiUSR1Xo
         /H1m/MLcQIIp69jQ4RrXgWZmLpkZeAGCd/8xipINmoOTwJDhPiLdojpRnjYvooO/APq8
         TZh4aICmXB6Qn3su8p+qqEHR5iJox9bOHxm/Y83tPpvuenZ77FL0HuJZJz9lJbPHyLaB
         ii0VIKPM5IVtZSOnAUgZLQXG4xLNDPJyBjGQV0udyxBh8BGWuFtAF58NxkRjdaL1tp56
         mTvYYFIINKotJSK3Xz5wk1vN4DlRlYLEJL12jHQkCClwof0hUITokLuBxf6gITbSM0WS
         ScTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QL5RU32o7P70EDLV5c2O9ftBFd4A4NCwoyKteQvPMK0=;
        b=a2WFwvS88YfP5S6VmuUBVAhjfah5OhUUWH5Iy3p1ZHauJxWFDg3HB+3q85Uu4YDHPh
         tGj28ZQPh7De1/CseTVi18Pj+NQ1Khv+IIKyUrJrrSZ5t/5WTX8M4TlK8NHMbfCVI7M5
         +RhSd99Y59iMmmATgYQIdG5Jk94OXE2tTKMXE124khNC9lLXsNA3Siga8azUm3yHAY/j
         +Mji0QYHyYxWDlyw0HjJDyTrVdHj6HC2bCb5sqwEKrtmax1SOH4fIVjBDTKnOMpqgD+m
         P1m5qEqKnfZMS/3TZPkP5XQKAPSEytl7B8dPK6H4r6l4N7LeGWryzcRg1ui+jERbbZ5J
         zL9w==
X-Gm-Message-State: AOAM531JKz2FQTHKmrjzTjwrjt9zcMc8I89zW3jZTJfTm86qpmyWc09n
        dBNmoqj+lWmbyB3IWSKuECw4nHAkNsrptw==
X-Google-Smtp-Source: ABdhPJwgqgrAz9I911ixPLiMOYYoGz1fgMCJrnfa63WcBRa3V6B3kQhhOhE35s4aNouggZw0Yk+DLG7pD+zJug==
X-Received: by 2002:a25:76c8:: with SMTP id r191mr13970729ybc.519.1592412054393;
 Wed, 17 Jun 2020 09:40:54 -0700 (PDT)
Date:   Wed, 17 Jun 2020 09:40:51 -0700
Message-Id: <20200617164051.128487-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next] net: napi: remove useless stack trace
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whenever a buggy NAPI driver returns more than its budget,
we emit a stack trace that is of no use, since it does not
tell which driver is buggy.

Instead, emit a message giving the function name, and a
descriptive message.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 6bc2388141f6fd7c66c0e8349514a326e5106db2..cea7fc1716caf9dbe8fcfcb5c5eec0ed21e20775 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6683,7 +6683,9 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 		trace_napi_poll(n, work, weight);
 	}
 
-	WARN_ON_ONCE(work > weight);
+	if (unlikely(work > weight))
+		pr_err_once("NAPI poll function %pS returned %d, exceeding its budget of %d.\n",
+			    n->poll, work, weight);
 
 	if (likely(work < weight))
 		goto out_unlock;
-- 
2.27.0.290.gba653c62da-goog

