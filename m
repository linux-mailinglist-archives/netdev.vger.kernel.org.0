Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478F11FFB1C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 20:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730451AbgFRSd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 14:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbgFRSdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 14:33:22 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4B9C06174E;
        Thu, 18 Jun 2020 11:33:22 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id i27so8438468ljb.12;
        Thu, 18 Jun 2020 11:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GfxBQhl30ftp8BzrZSRW5vI7XCIOgc9ST9sUu1yvoKQ=;
        b=HnJ6W8d8IEhzEpI5u0sQdOHDWKiBPP4zGmOesg+GBKgFdNepm4tT7iQLfBboohIhzz
         hsMa+iHPwsUR4ddHmYNsuPldOm4SiDguICTiQTBtMb3kg9BckTV+ak1N7BMutTQJBnyy
         VI7AMa6tOyipoBCk9/1+1rH3ftq/OGbyjh+YZFU/ke1hsKLA4WNLo0g0wxS4pEj9LgQw
         ygKBdcEvWID73mJblxh5nl4br8WV07Avcj2DdtiMuJCRj2d6om5R28ApTXcgHDcAaPUa
         /vqTBWb15qEm2cHWgBJmv7y1+JbUM26z108EnAhnxRRbT8uMMmUuliB9j9v1HpV+95R3
         JGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GfxBQhl30ftp8BzrZSRW5vI7XCIOgc9ST9sUu1yvoKQ=;
        b=bhA4/b30Digi8XOUsrgrnXWN5M0+0/ejgI9EO6cVWIMhWCnf4Nr6Nmcz1uhrCwfZI5
         2DM7BJ49HqYz+9yLQJ1cUrHnl39pVQx+uJc1T4n397dj/9nzExBcQGB4C3SidVEUS/k/
         BHy/4mtt5D67KFjMSptGcOhHpH7yEi7CHLac8wRtcxnldZpUSg8L6aPAahPNzGxsFOGp
         Y38eBffaCOvpDaYA8KjUlXHsaqk9sZMt/TGI/Bb00K9jkNmedFrrGCaUkIlvgnYS38V9
         3fzoqy62j7YKbTne2QYbt/+gVv/PITg0L6QXi9HuNKw9zWFmF6auMUH7psv7PN3ZspdF
         1IlA==
X-Gm-Message-State: AOAM531jp8yoY4l51J/zL/W7wvVZk9MtFbj508bhZJCKaOK0Ck5WOlGI
        ev7URK3qFJOefiT0YdJRteQ=
X-Google-Smtp-Source: ABdhPJy6jugihkxyO5CBEIfSggrL5MElULeZHrxoHVR/Zmp2AqhP8slBr5Ac+hzmMi5/l0hmUhVSJw==
X-Received: by 2002:a2e:22c2:: with SMTP id i185mr3233274lji.200.1592505200794;
        Thu, 18 Jun 2020 11:33:20 -0700 (PDT)
Received: from pc-sasha.localdomain ([146.120.244.6])
        by smtp.gmail.com with ESMTPSA id x10sm769339ljx.67.2020.06.18.11.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 11:33:20 -0700 (PDT)
From:   Alexander Kapshuk <alexander.kapshuk@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexander.kapshuk@gmail.com
Subject: [PATCH] net/9p: Fix sparse rcu warnings in client.c
Date:   Thu, 18 Jun 2020 21:33:10 +0300
Message-Id: <20200618183310.5352-1-alexander.kapshuk@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Address sparse nonderef rcu warnings:
net/9p/client.c:790:17: warning: incorrect type in argument 1 (different address spaces)
net/9p/client.c:790:17:    expected struct spinlock [usertype] *lock
net/9p/client.c:790:17:    got struct spinlock [noderef] <asn:4> *
net/9p/client.c:792:48: warning: incorrect type in argument 1 (different address spaces)
net/9p/client.c:792:48:    expected struct spinlock [usertype] *lock
net/9p/client.c:792:48:    got struct spinlock [noderef] <asn:4> *
net/9p/client.c:872:17: warning: incorrect type in argument 1 (different address spaces)
net/9p/client.c:872:17:    expected struct spinlock [usertype] *lock
net/9p/client.c:872:17:    got struct spinlock [noderef] <asn:4> *
net/9p/client.c:874:48: warning: incorrect type in argument 1 (different address spaces)
net/9p/client.c:874:48:    expected struct spinlock [usertype] *lock
net/9p/client.c:874:48:    got struct spinlock [noderef] <asn:4> *

Signed-off-by: Alexander Kapshuk <alexander.kapshuk@gmail.com>
---
 net/9p/client.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index fc1f3635e5dd..807e0e2e2e5a 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -787,9 +787,15 @@ p9_client_rpc(struct p9_client *c, int8_t type, const char *fmt, ...)
 	}
 recalc_sigpending:
 	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		struct sighand_struct *sighand;
+		rcu_read_lock();
+		sighand = rcu_dereference(current->sighand);
+
+		spin_lock_irqsave(&sighand->siglock, flags);
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		spin_unlock_irqrestore(&sighand->siglock, flags);
+
+		rcu_read_unlock();
 	}
 	if (err < 0)
 		goto reterr;
@@ -869,9 +875,15 @@ static struct p9_req_t *p9_client_zc_rpc(struct p9_client *c, int8_t type,
 	}
 recalc_sigpending:
 	if (sigpending) {
-		spin_lock_irqsave(&current->sighand->siglock, flags);
+		struct sighand_struct *sighand;
+		rcu_read_lock();
+		sighand = rcu_dereference(current->sighand);
+
+		spin_lock_irqsave(&sighand->siglock, flags);
 		recalc_sigpending();
-		spin_unlock_irqrestore(&current->sighand->siglock, flags);
+		spin_unlock_irqrestore(&sighand->siglock, flags);
+
+		rcu_read_unlock();
 	}
 	if (err < 0)
 		goto reterr;
--
2.27.0

