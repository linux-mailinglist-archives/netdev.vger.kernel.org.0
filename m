Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB88EC2D3
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbfKAMjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:39:03 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44820 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbfKAMjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:39:02 -0400
Received: by mail-lf1-f65.google.com with SMTP id v4so7119976lfd.11
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8hGSuiDX0siuyCstsxGZV1KLBVAGFihygZ3ZtImzPE=;
        b=bTPrn29DM4oxQdTG9g2LPl94YKLIXY4Q+Mt5OJFj9hTIE8Rcc+KdHCoxhdonjxjFOO
         a+WM8zrbbykyb6weBLkEtrbqqJSCx5JShRTlmDb4mvwAyhxNIdO8S/qmN24e8wqQdg81
         rFRwvcZe8JN25EIs4EQNf2+rhglkfRwfaf8AI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8hGSuiDX0siuyCstsxGZV1KLBVAGFihygZ3ZtImzPE=;
        b=OThqd0k82W/QGXNZVeJ1weMeRXMC8LlBGNjRqXZmst0BLHw5fPAj87YR/HPN0GG/UF
         ZXLl6uKpdLMHCHS6DQQ4vwMB7mdubJ0aLDR7iFY9xvyJE3z23Ze8zKZjn7Q0XujTO/YT
         xTchPt8unHfXWYQ2imKgEqYPN1B3kRIO3ZDg9IeK8zwkIeuqqzkaFnmW16l4zH19boCH
         Qg2ZJakGIU34fCe0Lz5ACAnxS39vYogLG8l0vyFF19QLPyTDpLNLto5Pt6ZmhI8XFqis
         w56w+zCc1ye4V2/rxhoGX4wUg5jfvJVc8igGLy6m5uKsy9iDijgnDy/+1m1zlZC+DkpQ
         Sl+Q==
X-Gm-Message-State: APjAAAUJBs18dC4Lf5LTRJs5ACfgEFd7EcDB4V6m/nCDlXWfh+YmLhOe
        QVAb24r7B0qqIXWYQoHwU/vlM6igQ70=
X-Google-Smtp-Source: APXvYqz4NVwCSqthm+5MZ6bDS8JGPunuZDns1RHdt0OkzF4HfE43IhFNO5yP1zqBk0Ze+kGdiJjA6w==
X-Received: by 2002:a19:640e:: with SMTP id y14mr7333668lfb.137.1572611939969;
        Fri, 01 Nov 2019 05:38:59 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f25sm2349909ljp.100.2019.11.01.05.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:38:59 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/3] net: bridge: fdb: avoid two atomic bitops in br_fdb_external_learn_add()
Date:   Fri,  1 Nov 2019 14:38:43 +0200
Message-Id: <20191101123844.17518-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
References: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we setup the fdb flags prior to calling fdb_create() we can avoid
two atomic bitops when learning a new entry.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b37e0f4c1b2b..7500c84fc675 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1113,14 +1113,15 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 	fdb = br_fdb_find(br, addr, vid);
 	if (!fdb) {
-		fdb = fdb_create(br, p, addr, vid, 0);
+		unsigned long flags = BIT(BR_FDB_ADDED_BY_EXT_LEARN);
+
+		if (swdev_notify)
+			flags |= BIT(BR_FDB_ADDED_BY_USER);
+		fdb = fdb_create(br, p, addr, vid, flags);
 		if (!fdb) {
 			err = -ENOMEM;
 			goto err_unlock;
 		}
-		if (swdev_notify)
-			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-		set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
 		fdb->updated = jiffies;
-- 
2.21.0

