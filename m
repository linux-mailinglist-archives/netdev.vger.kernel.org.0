Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672B37F7A2
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 14:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392863AbfHBM50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 08:57:26 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44024 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728921AbfHBM50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 08:57:26 -0400
Received: by mail-pg1-f193.google.com with SMTP id r26so85986pgl.10;
        Fri, 02 Aug 2019 05:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9SvP2xLI0r/IFLODY4SREeRnuK66x7eKEYY7oOsxjs=;
        b=rd7F+uGpcYw7H+IxAjRfwqV33K6RSiW8chDUdhFPRCYZ1HcZETAkYIhhNnPCh0/pCe
         SMgjY1aYw8nxW6xeZKVp5hlA+R+a0JHCQ1YPqhYYEZ+mlpDOAhOfg0GW4LOT1ziQTlWi
         FWjYFbIVVp9mbhPSNWSwoT40nS1qAEjbYOKbW41zBvRCL0YfenvKrzmMNfKpQyBmpHO9
         iLS10QRzZq2G5Q5T1xxwcijkJXcYJCAu+07oWnhp4gXj/AR1Od2AUV8PIXtj9kRpvxhX
         RV50VUEykdzxW47VlzY7TGLmNegzlvEHu5q8Uq1/oRKsDKk3/HhKcMy+1BfBJvEooF6b
         K5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B9SvP2xLI0r/IFLODY4SREeRnuK66x7eKEYY7oOsxjs=;
        b=ObF0ALx14vkgNNDIO+NQQZJfq+WvsofhO5l3A9TjN3p5DFWzaxKz3LdnVoB4hja3l9
         JiBJ0n4WAPEN9G5fFR165aDl7m0etD0eCRQsImfHyduTfIP5/05ekYtXz/ppNDTBYNO7
         PqFzo+3PhtjEdgj0G3E66707DHNCOGXvdEvkrvvsP5lww5/Ix3ETi8lIVhgispj0WcEI
         Pe6A/v+DbsT6nPfK60ueUgVX/MxvFlCD7U3qkoTJY2fNEE0ut0t/lAOqiu+4Fmc3G7r6
         2KDf5jsErHMf6pNNOPIQhqj1/Mx9tKPTG7UPFIuj+zRAuBWVbqMKkOHDTbzxPtHVwxjx
         uv8Q==
X-Gm-Message-State: APjAAAV0AkeDmjJzI19MU1jUrseq4QugLdTBiW68Xp/T5Cc3yzNiK3sb
        JyUcAtpz7VFnhz7wIlKydtY=
X-Google-Smtp-Source: APXvYqzj/MAydJ+rNzPuaYOJycVzFseInedpIG+tVK3BblJVpk57r0jADfjq4CnueXStrkjOzjs0cA==
X-Received: by 2002:a17:90a:109:: with SMTP id b9mr4043952pjb.112.1564750645351;
        Fri, 02 Aug 2019 05:57:25 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id l25sm94389446pff.143.2019.08.02.05.57.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 05:57:24 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] niu: Use refcount_t for refcount
Date:   Fri,  2 Aug 2019 20:57:20 +0800
Message-Id: <20190802125720.22363-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Also convert refcount from 0-based to 1-based.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/ethernet/sun/niu.c | 6 +++---
 drivers/net/ethernet/sun/niu.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 0bc5863bffeb..5bf096e51db7 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9464,7 +9464,7 @@ static struct niu_parent *niu_new_parent(struct niu *np,
 	memcpy(&p->id, id, sizeof(*id));
 	p->plat_type = ptype;
 	INIT_LIST_HEAD(&p->list);
-	atomic_set(&p->refcnt, 0);
+	refcount_set(&p->refcnt, 1);
 	list_add(&p->list, &niu_parent_list);
 	spin_lock_init(&p->lock);
 
@@ -9524,7 +9524,7 @@ static struct niu_parent *niu_get_parent(struct niu *np,
 					port_name);
 		if (!err) {
 			p->ports[port] = np;
-			atomic_inc(&p->refcnt);
+			refcount_inc(&p->refcnt);
 		}
 	}
 	mutex_unlock(&niu_parent_lock);
@@ -9552,7 +9552,7 @@ static void niu_put_parent(struct niu *np)
 	p->ports[port] = NULL;
 	np->parent = NULL;
 
-	if (atomic_dec_and_test(&p->refcnt)) {
+	if (refcount_dec_and_test(&p->refcnt)) {
 		list_del(&p->list);
 		platform_device_unregister(p->plat_dev);
 	}
diff --git a/drivers/net/ethernet/sun/niu.h b/drivers/net/ethernet/sun/niu.h
index 04c215f91fc0..755e6dd4c903 100644
--- a/drivers/net/ethernet/sun/niu.h
+++ b/drivers/net/ethernet/sun/niu.h
@@ -3071,7 +3071,7 @@ struct niu_parent {
 
 	struct niu		*ports[NIU_MAX_PORTS];
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct list_head	list;
 
 	spinlock_t		lock;
-- 
2.20.1

