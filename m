Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9F47838C
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 05:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfG2DDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 23:03:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46989 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfG2DDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 23:03:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id k189so8406761pgk.13;
        Sun, 28 Jul 2019 20:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vhdyHKbr6BRELOCiWIx8QFrf2iWsG4qCQT0zVGLttDQ=;
        b=fYkbKVYbMf7WylANOPWUxOmxhD0YEN3Arb+f4/5LmCJvzWI/K7DodlBOlT/0Dv97xB
         hXR41NQfxhGHng8dn5Wi7pv5WiWYA9ZnpivmMzmBCBcZFs5dalWXv08FTCRV/NHF+zQl
         4ttOfg6yC8yU7jbOF5XFNpAG+klbqalXmZC4Fb0DQlaepm6hWzrhQpDTt7SxJzS1j8Wy
         Rt5dgMjxwjQkRMoX8/Iu/I4EdkJ0Do8pp1PMwNPoMy95fvz7oB2E+ZkEq7deZw5a/YyN
         5XM3okKO7MCXLRC4r5dzsQU7z28G6i/DbBi4BjAuETipwPfylJ3bMPLg5mI4l44V3KIZ
         wcGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vhdyHKbr6BRELOCiWIx8QFrf2iWsG4qCQT0zVGLttDQ=;
        b=dXKauXZqnFuaPIqlHXmzDLchO5WM0Eau77ftTevClwOZ32o/swJO1Ii4FE8xFt+EW4
         +LXgZafWYN3hwcE23IKRqy3jKFO1ovZCXscdUbYNlGK0h12Jo2/NfbTI8GnJwch1pGte
         liQFHBefRj33Oku5h7m3NZWlcE5AqVynYJ5KMOTL9Co0vD3Nod7AFS2BgAllR3DJAUOo
         0lXJmYnixhncgiGV3rqkSVnxf1ihxzLu7us0UOthcECmaDV03cJlv2Z/BZHSqCFGyE8B
         d5xa4ceY2wEiHlPXdiq7n0SS8nUMSm2BRKRan/742Xphacz3dxh6gewtW9kxXw6MOlY1
         aeWA==
X-Gm-Message-State: APjAAAUWIisMkMNLcOaoTOWO4R7yWLi3UYtYv8vqGt5xpbbqQEATwuBL
        x5TzCLTbSHPLdrfkDNzyJmg=
X-Google-Smtp-Source: APXvYqy24B8Gn7MJsm4X2EXqziW8iKygHbrckYkajJkAi6vD9kLgfy2gVbVm/575Xf9i/1X6dbULzQ==
X-Received: by 2002:a05:6a00:4c:: with SMTP id i12mr34459331pfk.134.1564369392804;
        Sun, 28 Jul 2019 20:03:12 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id h14sm74535781pfq.22.2019.07.28.20.03.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 20:03:12 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] ath6kl: Fix a possible null-pointer dereference in ath6kl_htc_mbox_create()
Date:   Mon, 29 Jul 2019 11:03:05 +0800
Message-Id: <20190729030305.18410-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ath6kl_htc_mbox_create(), when kzalloc() on line 2855 fails,
target->dev is assigned to NULL, and ath6kl_htc_mbox_cleanup(target) is
called on line 2885.

In ath6kl_htc_mbox_cleanup(), target->dev is used on line 2895:
    ath6kl_hif_cleanup_scatter(target->dev->ar);

Thus, a null-pointer dereference may occur.

To fix this bug, kfree(target) is called and NULL is returned when
kzalloc() on line 2855 fails.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 65c31da43c47..998947ef63b6 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -2855,8 +2855,8 @@ static void *ath6kl_htc_mbox_create(struct ath6kl *ar)
 	target->dev = kzalloc(sizeof(*target->dev), GFP_KERNEL);
 	if (!target->dev) {
 		ath6kl_err("unable to allocate memory\n");
-		status = -ENOMEM;
-		goto err_htc_cleanup;
+		kfree(target);
+		return NULL;
 	}
 
 	spin_lock_init(&target->htc_lock);
-- 
2.17.0

