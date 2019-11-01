Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C48EC2D1
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730425AbfKAMjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:39:00 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44258 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730406AbfKAMjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:39:00 -0400
Received: by mail-lj1-f194.google.com with SMTP id g3so3993805ljl.11
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=juMaa8T+acHWGuY6rT694YoPoU3OVi+9bgYU3p25Mrw=;
        b=CdxHlu83H3t/gtHF/riMFi+m6lNx5ThrruSpaoo+VUnK8msYMR6ciuo+wnC1b1jSqT
         4I/Swi5lf5czdE/VjgaSq39bszkg3jtp+P3eL8JSiV0ud1VVUFeX5iAWqppQK3ZNNzIf
         +apLsBDr7x1hBH3cIBLU9KTLjJQ/NYSFuUZxo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=juMaa8T+acHWGuY6rT694YoPoU3OVi+9bgYU3p25Mrw=;
        b=qtoknqXgbDSEjCHrjxBZ0PSgacTQHbKbGPWwINn4xzoyLFTpcrQsCKQJRqRboaiV/C
         dmdJ0D4bw6CHTsQKhwFvjPiRdlfIbU7NKpAnLo67IuM64N0VJrfZYOUEqYMUhuHssbEc
         4I8Hm7nhjwyX4NU9uRO9l+zfRma7bI4w2Qv6Y+gpggd9KwAZVFruOd14VED9kCTQIMna
         igmivVs0B2iaMK/KqJ0S+KdjHZtj0TT5oXxLzw36JWKII3KR5Exx1utoaCvg1PlMfnRq
         860tFMcyNQMwwp5+YKk4yR5qCUP6foI7TKM4Q3nLjjqrilNUzARIw3t7Tldjng9JXW0j
         5jFA==
X-Gm-Message-State: APjAAAVZMZi7gp5SBu5sCB1MGs+a8O9Lqu+MiX/Lu2znpBHSn72BS1AI
        8kbzCrBc/cpRWzJqQSG9fKOjLbV6xdA=
X-Google-Smtp-Source: APXvYqzExQp9cCONwbyoYn3ZKE/10UZ1my6j3aDGFIwTizcCGc1h/FDjSRvSucuoXW+TY6hqJrITjA==
X-Received: by 2002:a05:651c:28a:: with SMTP id b10mr7777962ljo.124.1572611938734;
        Fri, 01 Nov 2019 05:38:58 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f25sm2349909ljp.100.2019.11.01.05.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:38:58 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/3] net: bridge: fdb: avoid one atomic bitop in br_fdb_external_learn_add()
Date:   Fri,  1 Nov 2019 14:38:42 +0200
Message-Id: <20191101123844.17518-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
References: <20191101123844.17518-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we pass the BR_FDB_ADDED_BY_EXT_LEARN flag directly to fdb_create()
we can avoid one unconditional atomic bitop when learning a new entry.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_fdb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b37e0f4c1b2b..7db09410679b 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1113,14 +1113,14 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
 
 	fdb = br_fdb_find(br, addr, vid);
 	if (!fdb) {
-		fdb = fdb_create(br, p, addr, vid, 0);
+		fdb = fdb_create(br, p, addr, vid,
+				 BIT(BR_FDB_ADDED_BY_EXT_LEARN));
 		if (!fdb) {
 			err = -ENOMEM;
 			goto err_unlock;
 		}
 		if (swdev_notify)
 			set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-		set_bit(BR_FDB_ADDED_BY_EXT_LEARN, &fdb->flags);
 		fdb_notify(br, fdb, RTM_NEWNEIGH, swdev_notify);
 	} else {
 		fdb->updated = jiffies;
-- 
2.21.0

