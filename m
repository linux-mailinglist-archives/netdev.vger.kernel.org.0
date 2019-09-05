Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92894AADB1
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404139AbfIEVPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:15:36 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:37529 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388359AbfIEVPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 17:15:36 -0400
Received: by mail-pf1-f201.google.com with SMTP id u3so1914914pfm.4
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 14:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5OIWaQS8XUylUqWEOLvRcQ6wvtAGUWcmHb4qQooXQU4=;
        b=sqoOcBxZdlqGDWySWP2Y/co94HGedfimwCSXcJFCDa2CSHTgUIbVs4Pv6YfiqW989D
         qwxLXD2E6ccpMCJrXFqhjsQ8KvKmii4DOcdayDCxOPHgZnS3MYlw7VykblxC7tziuiWg
         TGPazBMqwY4jU9+ikaAjXWzQA567E4smuiqVvfBzdgaMlJPhw+KkxBjnb4RpotPIP0yv
         4To4Fb74sAf5hCcy3mrBjhnNGk5/27rRSbZnG99BZMVY57d6quzmuw/KdICvu3J8iC9a
         ndMLLbyFrE67/RIXYeSI2gDac9o0MrmV7qytiMO9xmjTphHOMt5lwQ4Jjd8n6/kFiDV6
         qRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5OIWaQS8XUylUqWEOLvRcQ6wvtAGUWcmHb4qQooXQU4=;
        b=BULKArSPZ8MNdHk5mJeVlQDi2jj94JFOBBTI/jbMXf7E9oPv/WJSYcX4FfxEhzVhC3
         G0WUoa4TUI5kfzZiOebhImAqofKvrad8ynxbW5IbBQ54QSI2OmMydtYcipZtv7ZAQlq6
         JWSNX0pYlALE2CWJv/E3soU8oof0MLKZamJR7LaIgrN8cKWjLQteOG84OQ1DAn5kyIus
         ZPkFxXsYCsMgtfJjadIjQkh00dKAqNZB5ungHbkfWu7ZdGhtUJULFiuTLqHyLVwFfbAe
         Djb2RZVODJ2HQSuYBWj3sJd1JgsEWWg4ukbsoddPCBYw0QFBGFsS6pZ7idM420um6bWm
         OVHg==
X-Gm-Message-State: APjAAAWD02VnqceKlM8/tQyRujYD2t3KWokaJQDCHAnuhd47MP+gl7tX
        eBPG3LmAX2LGxPSUYhiuQwtGIP7BwLcaE4SnRJE=
X-Google-Smtp-Source: APXvYqwZtsOP4oeCbgdcEYz4SC/6uGacnOnUYdFPlg0VekmO8GAS2KcyDuLyw3ItW3lkQRTZoimV43SVKTXC9aSch7E=
X-Received: by 2002:a63:2252:: with SMTP id t18mr5065062pgm.5.1567718135010;
 Thu, 05 Sep 2019 14:15:35 -0700 (PDT)
Date:   Thu,  5 Sep 2019 14:15:28 -0700
Message-Id: <20190905211528.97828-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH] kcm: use BPF_PROG_RUN
From:   Sami Tolvanen <samitolvanen@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Tom Herbert <tom@herbertland.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of invoking struct bpf_prog::bpf_func directly, use the
BPF_PROG_RUN macro.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 net/kcm/kcmsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 5dbc0c48f8cb..f350c613bd7d 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -379,7 +379,7 @@ static int kcm_parse_func_strparser(struct strparser *strp, struct sk_buff *skb)
 	struct kcm_psock *psock = container_of(strp, struct kcm_psock, strp);
 	struct bpf_prog *prog = psock->bpf_prog;
 
-	return (*prog->bpf_func)(skb, prog->insnsi);
+	return BPF_PROG_RUN(prog, skb);
 }
 
 static int kcm_read_sock_done(struct strparser *strp, int err)
-- 
2.23.0.187.g17f5b7556c-goog

