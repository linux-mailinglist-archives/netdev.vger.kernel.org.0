Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E8A285C9D
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 12:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgJGKNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 06:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgJGKNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 06:13:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9C3C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 03:13:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d23so756606pll.7
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 03:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JkpW5sYQp+WHwyG8rahX3zSSTq1sUQxajkELy1EMCx4=;
        b=TEJGSJP9gJn/lrCZvkiKWY+j9QVW4QG5sxgrhUaWAqNruqZURmBqqtw27mbGO3YNjh
         po3ocltitbdMz5eGevfIBsmWYsLyDlaLqcnSDvU2Bf9j9tNrwHgy+Cuc7vYB8PgkR8A/
         VXxLt+bm1rZhdrsmNN+XGu9j3i7GRM+WfHown4R1ZGLcKWy8atf1m7Xh1XqNbzYC1vhc
         ndy+pmusVi1Gd66V4/ur7G5iQ6El6Ot90z0hKTP7ehLchyAJUlOpI9u6Bm4WqKyBsuXk
         RtTRyiW4B9BVA29LTqZEdoKbNdNICdsv/ld3MebqKnpBkLp6OJFQ+9p5Q44Pj+HlSltu
         XsWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JkpW5sYQp+WHwyG8rahX3zSSTq1sUQxajkELy1EMCx4=;
        b=jOBDszb3dyDDEMcmYyYT+koqRjlfYacFdnXMke2gPA4q0mMAsHYQ0DpOYm4kIGVvvc
         EDMRQpsG+ZCzxPqZD8pBJeCQOVqkCIpOQ+9jltlle1lp0lJoux8tcacH2MJMchbF51Cg
         rdbZvvHTZmtVT7mFGtT0FFc2L7+uQ8X4rcBToe4YPwH6let8vL+1UOdn1JS5tLV94Prn
         lZUmxwATNTDOQLx+ioCIvv3/FUYh3FX5MYk7u5CAzhuZyqE91t2bgrRhengbQ4OWSZKv
         uGazq/tOxjCGFWIH1fZy5OB/izEUQcx4P8J8LlZ49+AWBj0XprW03ncnVNC2hTRv1ng9
         cCiQ==
X-Gm-Message-State: AOAM5333BiUasSJyUDefB0p6gt55pJtMsFN5rMnGrwY3KOG/twSDnJSn
        4CJ9UyKFghBvfougzFIwcQQ=
X-Google-Smtp-Source: ABdhPJxYUWlnC2dEy9AAlyAmdPqm4yEr90frDrCiTFekiy6vnn2nzW+z26cD8q8HRbZnUKak4Ax30A==
X-Received: by 2002:a17:90b:19c4:: with SMTP id nm4mr2116837pjb.133.1602065580870;
        Wed, 07 Oct 2020 03:13:00 -0700 (PDT)
Received: from localhost.localdomain ([49.207.204.22])
        by smtp.gmail.com with ESMTPSA id q24sm1105291pgb.12.2020.10.07.03.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 03:13:00 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v2 4/8] net: mac802154: convert tasklets to use new tasklet_setup() API
Date:   Wed,  7 Oct 2020 15:42:15 +0530
Message-Id: <20201007101219.356499-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 net/mac802154/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mac802154/main.c b/net/mac802154/main.c
index 06ea0f8bf..520cedc59 100644
--- a/net/mac802154/main.c
+++ b/net/mac802154/main.c
@@ -20,9 +20,9 @@
 #include "ieee802154_i.h"
 #include "cfg.h"
 
-static void ieee802154_tasklet_handler(unsigned long data)
+static void ieee802154_tasklet_handler(struct tasklet_struct *t)
 {
-	struct ieee802154_local *local = (struct ieee802154_local *)data;
+	struct ieee802154_local *local = from_tasklet(local, t, tasklet);
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue))) {
@@ -91,9 +91,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
 
-	tasklet_init(&local->tasklet,
-		     ieee802154_tasklet_handler,
-		     (unsigned long)local);
+	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
 
 	skb_queue_head_init(&local->skb_queue);
 
-- 
2.25.1

