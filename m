Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E9A27C240
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgI2KU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgI2KU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 06:20:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF9AC061755;
        Tue, 29 Sep 2020 03:20:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t17so1562481wmi.4;
        Tue, 29 Sep 2020 03:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CR6oJAxdsZ0oQebADeL2mKnv0XXeEsb5hXWXU1I+cgw=;
        b=mn6kU3lt9VBVcizDnEHeYfWz04AWaxbWe7IgBpFC5khbGDUWnR77i2BzrM2bSsTuNV
         QGaq7cv2Y/ATCCMGrQlEFIt6QgY/QRfx1QoE7EmUZKWwWPfezvMo0mcI17ccQ8zsNVZN
         zHBpbSadXr3DVAq6/SfhIJjZ776YKoFsdrKVjdLwKyk7AWmHrWdkGDxhUGoZge5awe4j
         ZoDxTTYoZbqQOndwpUF0ShavbBw9FqmcJKhFo55ueoG3lOSTEycJRTwa2d/WaTC+zd7j
         fbUvDzMswThRCU5VekkczyNN8PitF91d9f7cvYGotvS6DNFI6ciUxuoprgrx8Qp9JJMI
         pJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CR6oJAxdsZ0oQebADeL2mKnv0XXeEsb5hXWXU1I+cgw=;
        b=AYh3hLi7a7CAREo1vRGWJzl8uw7sCDCplCcCTZzsrd5rHJr2wbpvrP4owmAN/6PO8t
         heDGHIhZWksFPonfWTyQUfZTi5n45DayoEjZWH4+OfFM6lXI+i3UVRC0ZdJ8kTZtY3Ku
         QO7m5qpaabvN2er1sZ2yQKQR8u6oOCCZFKFUSj6u4rnFs82qQ81/Qyn5rhTGTWAt4ZWP
         PdqFaOVMRCsDcve1VE7Pyi25I+3/kjjtyj9fYZrTchvlK0U4QnfrloG16IdAj00MvvEa
         Yg4x6WFfk7wvjGRQ//7xHhQOFFNIs5sA/Ri5CRpkhSdR315uTWgLvkUmfj5yI81y83wE
         jWRg==
X-Gm-Message-State: AOAM53148dE0jJFlc3M06uHng3YtoC4gVplYaLhyTeRdPilNxrD7/eUd
        KJ1magorwav0578AA7K47OY=
X-Google-Smtp-Source: ABdhPJwwY4sIO2vQb7TXofoJGF17wZ6C0qDCqQexK77avk49EQ45Sus98hVitI4tOzOVFslntIJiaA==
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr4029413wmh.152.1601374854538;
        Tue, 29 Sep 2020 03:20:54 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id t4sm5498954wrr.26.2020.09.29.03.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 03:20:53 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net/mlx5e: Fix use of freed pointer
Date:   Tue, 29 Sep 2020 11:15:49 +0100
Message-Id: <20200929101554.8963-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200928074301.GC3094@unreal>
References: <20200928074301.GC3094@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the call to mlx5_fc_create() fails, then shared_counter will be freed
before its member, shared_counter->counter, is accessed to retrieve the
error code. Fix by using an intermediate variable.

Addresses-Coverity: CID 1497153: Memory - illegal accesses (USE_AFTER_FREE)
Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
v2:
	- Add Fixes tag (Leon)
	- Use ERR_CAST (Leon)

Hi Leon,

I've made the suggested changes. Let me know if there's anything else
you need :)

There is also this patch in the series which doesn't seem to have been
reviewed yet: https://lore.kernel.org/lkml/20200927113254.362480-4-alex.dewar90@gmail.com/

Best,
Alex


 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index b5f8ed30047b..1e80e7669995 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -738,6 +738,7 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	struct mlx5_ct_shared_counter *shared_counter;
 	struct mlx5_core_dev *dev = ct_priv->dev;
 	struct mlx5_ct_entry *rev_entry;
+	struct mlx5_fc *counter;
 	__be16 tmp_port;
 
 	/* get the reversed tuple */
@@ -775,12 +776,13 @@ mlx5_tc_ct_shared_counter_get(struct mlx5_tc_ct_priv *ct_priv,
 	if (!shared_counter)
 		return ERR_PTR(-ENOMEM);
 
-	shared_counter->counter = mlx5_fc_create(dev, true);
-	if (IS_ERR(shared_counter->counter)) {
+	counter = mlx5_fc_create(dev, true);
+	if (IS_ERR(counter)) {
 		ct_dbg("Failed to create counter for ct entry");
 		kfree(shared_counter);
-		return ERR_PTR(PTR_ERR(shared_counter->counter));
+		return ERR_CAST(counter);
 	}
+	shared_counter->counter = counter;
 
 	refcount_set(&shared_counter->refcount, 1);
 	return shared_counter;
-- 
2.28.0

