Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC83A1B49F6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDVQNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgDVQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:13:44 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990A4C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id c13so2211240plq.22
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Fx0YNvXj+fsR5oQvtrPgM6I8N53ushCkP+1+vjPpzvE=;
        b=mnuWHqt11g8dv/TrIMEwa197TZCvR8Hh+Q8fzLXb52apLHnR0Wz2ioJWQD0VCUCQjp
         GZTAEB5ZxY13leePkSc/l3d12wRr7M56E+CLxQdQLYC+BdJtc8Atpg3xbXHl2vQhmZII
         jcdBZjb0wrJRAWROWH8EJgh/LQhl28Gfxoyc+MLcu7P1HhqNiAkPgbhdXu4coRG/8+Jj
         NYM0QgTFjezPtu8RVlj8xW5/Rybfur1k6FKsvTnklE5+3kyLDeiJCtEf/7Trj/MINill
         6cGEOFvWd43lz3aq608zuzqbYncN+FdXBQmL2bvh3ie+dTZ6EW1YB6+cvoOPhLYpkJOD
         aLgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Fx0YNvXj+fsR5oQvtrPgM6I8N53ushCkP+1+vjPpzvE=;
        b=BbdAwiNw98kvoMiriIyh4oggkVE8w2LZRyCL+kYTQ/IuWCq7jjsOEi1Hq2KjmWxclH
         VGJGVpoBMltn6vFZZUc2Zu3x2fE6YU/lIjBEy0JyXVmsazarIw7KY8JOIQq+SARt1/XM
         hVOzbKIA8aUWQEdsB0169R5QlDFTlMk2BJzX9CEvLNcV30JbV5KPFnq8IxZf9BRRWDYS
         Mq1EowaXYuVpI8a1HErxJrQmpqZWNcII2Hd2SwCjpsdx1cwh02q0te1TJUfNP/HSNm7r
         vdl7Glgxe5tENs+SaPJ3w3QjfHK3HMq6BH7Cr59cYl8YQKgjxuCS80zjwf2unHp5CI+G
         s6mg==
X-Gm-Message-State: AGi0PuYCp63VfZY9EQwyOKr3TIuk/ONlbqO+XyH3JRpR7Uz5bBGrCFu7
        cEaM9qWAkopo/NRA0wMnvilFxzeGemrOdw==
X-Google-Smtp-Source: APiQypKHHSEcDx1UM5NFqNYW7h30c3HPkiGQiYq/Kv6KnSCIV9Fw7zj9rBOFKw57UCVyRQk+0zu6AyVduP+a6Q==
X-Received: by 2002:a17:90a:d504:: with SMTP id t4mr12905345pju.123.1587572024147;
 Wed, 22 Apr 2020 09:13:44 -0700 (PDT)
Date:   Wed, 22 Apr 2020 09:13:28 -0700
In-Reply-To: <20200422161329.56026-1-edumazet@google.com>
Message-Id: <20200422161329.56026-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200422161329.56026-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH net-next 2/3] net: napi: use READ_ONCE()/WRITE_ONCE()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gro_flush_timeout and napi_defer_hard_irqs can be read
from napi_complete_done() while other cpus write the value,
whithout explicit synchronization.

Use READ_ONCE()/WRITE_ONCE() to annotate the races.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c       | 6 +++---
 net/core/net-sysfs.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 67585484ad32b698c6bc4bf17f5d87c345d77502..afff16849c261181b4f1043cf3d23627c75c7898 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6242,12 +6242,12 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 
 	if (work_done) {
 		if (n->gro_bitmask)
-			timeout = n->dev->gro_flush_timeout;
-		n->defer_hard_irqs_count = n->dev->napi_defer_hard_irqs;
+			timeout = READ_ONCE(n->dev->gro_flush_timeout);
+		n->defer_hard_irqs_count = READ_ONCE(n->dev->napi_defer_hard_irqs);
 	}
 	if (n->defer_hard_irqs_count > 0) {
 		n->defer_hard_irqs_count--;
-		timeout = n->dev->gro_flush_timeout;
+		timeout = READ_ONCE(n->dev->gro_flush_timeout);
 		if (timeout)
 			ret = false;
 	}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f3b650cd09231fd99604f6f66bab454eabaa06be..880e89c894f6f3669b132547926164c1f36fc986 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -367,7 +367,7 @@ NETDEVICE_SHOW_RW(tx_queue_len, fmt_dec);
 
 static int change_gro_flush_timeout(struct net_device *dev, unsigned long val)
 {
-	dev->gro_flush_timeout = val;
+	WRITE_ONCE(dev->gro_flush_timeout, val);
 	return 0;
 }
 
@@ -384,7 +384,7 @@ NETDEVICE_SHOW_RW(gro_flush_timeout, fmt_ulong);
 
 static int change_napi_defer_hard_irqs(struct net_device *dev, unsigned long val)
 {
-	dev->napi_defer_hard_irqs = val;
+	WRITE_ONCE(dev->napi_defer_hard_irqs, val);
 	return 0;
 }
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

