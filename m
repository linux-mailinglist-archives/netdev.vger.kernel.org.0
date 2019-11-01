Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D530EC31F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbfKAMqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:46:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40712 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbfKAMqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:46:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id q2so3574030ljg.7
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 05:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8hGSuiDX0siuyCstsxGZV1KLBVAGFihygZ3ZtImzPE=;
        b=bzd/2xI1RryF7VA9zFz0u7IFLWG16bHddSXDANDFM8IQWZfVXJiUJnaLhUqfBJLHpH
         VOZ1u3pRxiWiG0CF5AJYxY0K2+SDt79omLm4XOk2I9mjaBzAKdrnJ+FPsCG3Gg2tZkt6
         xhNPcLx18j1clo/WBJV0PA42sDifp8loxqUjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8hGSuiDX0siuyCstsxGZV1KLBVAGFihygZ3ZtImzPE=;
        b=NQbU6JmG38HqujndWUDMZUQPTnlSKrXD+vyM+KPFVDfrRWGZ30QeMcdp2Gpo5Ttd5H
         24VdYT+p1wyo8QvuO9Pwm/WktcJVhCbETvGqlf5RrvBY0s/5cx12y99xZdFrqe+3IuUP
         GrjCGtXBpGOs+ebxLKKcEXGs8dKFtcHfG+wk6ge8XYApcGCDEuvC6dHaP90P721r7T5g
         h78rOCToypFMLjYFRMyUn6Jk3y6QQnjok3hvv3P5ePgpX5yMcena/InQ/i7vUSDQcOSt
         YGmqiA1ygAqZt5UEzOdLSG/OmmMSNOImuvpNg9OHz27SjkehTCsVaxFWbSF4mpB0BAt3
         rfbg==
X-Gm-Message-State: APjAAAXim+wQMPqwzHRfpZswagGlupJUMT17YXEg9yo5jxbHbPcnY/Os
        IPH2Bz1ZPjlJTSE13BYQF9L0fVip1gY=
X-Google-Smtp-Source: APXvYqyWwrU/5nI8+MOv5v0FKAj42popJDgXL8ZRMQMf+LlpCpvMCGVPSKedVIlxwjm5imszJnj14g==
X-Received: by 2002:a2e:6817:: with SMTP id c23mr8034012lja.91.1572612407990;
        Fri, 01 Nov 2019 05:46:47 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t4sm2297909lji.40.2019.11.01.05.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 05:46:47 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, bridge@lists.linux-foundation.org,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 2/3] net: bridge: fdb: avoid two atomic bitops in br_fdb_external_learn_add()
Date:   Fri,  1 Nov 2019 14:46:38 +0200
Message-Id: <20191101124639.32140-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
References: <20191101124639.32140-1-nikolay@cumulusnetworks.com>
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

