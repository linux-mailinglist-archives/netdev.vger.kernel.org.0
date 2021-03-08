Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB59B330640
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhCHDLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbhCHDLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:11:12 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0789CC06174A;
        Sun,  7 Mar 2021 19:11:11 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o10so5527190pgg.4;
        Sun, 07 Mar 2021 19:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DhMvXCk0sXJv+GDmGzzD6QP4j5FriOS751Xaxos7THU=;
        b=dQ2qjwkwafeKbLS7P1d7TVuwiAe7RfloRuMYtxyGLbYYW0a882yUD+8RtMsrDnuiYr
         MfUjzkerg/E7fVXVnauJtI4lLgYo5Q8JzpQnBeEcnX5LaxWwJ58w6+xIAFfIJpWWpnFe
         TCVHKfrTWIeZUtaiVh8mg/SndK2QZCrLEN3sQj542lYZhIxvEaXja9WChc5CsUNynalH
         zdeb3Nzgv6EO/EsBlnFlVSmjM/lXKhRNEBSywWelK7dXEFREJ4jdYxMDKPZ172Jph94n
         nbXsZGhizxb3SA9sCkDUP1+th0cQXd3PZ26YyzMVfrHrReRIE9fQR0kGc6hgvJitFd69
         jw4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DhMvXCk0sXJv+GDmGzzD6QP4j5FriOS751Xaxos7THU=;
        b=tRQqqYwP/cAbA7Ev9UnUAvZOCE5TSuAL1iuT2wIL1Uv6zPdVog8MbEIU01rnry++oQ
         QJONVxhDWwsSXDDEsUNlbNefXw3YlgLz4EMTVij29bctYXgFrZmldb+Vzarm41Hr9s31
         yRm22362WiG3tqg9aeNTi9YoyZTrYCHbKhmLcua9G+9WBNQ2ZsH/wIMFUy6cyBns45cy
         eQ5XfWVOlOgLm2hR6a5mC8pXwUC/8VomqG0Tbm9rGTcekm+qytpl6pa4kEZqxWs693Bg
         d9JC7FWa9X6hyC6QrlEYhMYLmpGyAjCUjWD3z1sQXHFa2Hz2MIc0G463oGfrUKOWl5Lz
         6iew==
X-Gm-Message-State: AOAM530SFhSZvwungyvDd9ogTWWapfqUbJULEowJs2n1QacTguCHfiIH
        yrVjZXxbV67vDfoEl3NO+yY=
X-Google-Smtp-Source: ABdhPJwt6HpSwZaIkpTZ+kCj4NevJvGdmTCcaMRcVUVvGpTHruPZU8qx90emf0Qmmidr7U4C72+TuA==
X-Received: by 2002:a63:5c63:: with SMTP id n35mr18585291pgm.26.1615173071435;
        Sun, 07 Mar 2021 19:11:11 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.99])
        by smtp.gmail.com with ESMTPSA id g12sm8754793pjd.57.2021.03.07.19.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:11:11 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: bonding: fix error return code of bond_neigh_init()
Date:   Sun,  7 Mar 2021 19:11:02 -0800
Message-Id: <20210308031102.26730-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
return code of bond_neigh_init() is assigned.
To fix this bug, ret is assigned with -EINVAL in these cases.

Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/bonding/bond_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 74cbbb22470b..456315bef3a8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3978,11 +3978,15 @@ static int bond_neigh_init(struct neighbour *n)
 
 	rcu_read_lock();
 	slave = bond_first_slave_rcu(bond);
-	if (!slave)
+	if (!slave) {
+		ret = -EINVAL;
 		goto out;
+	}
 	slave_ops = slave->dev->netdev_ops;
-	if (!slave_ops->ndo_neigh_setup)
+	if (!slave_ops->ndo_neigh_setup) {
+		ret = -EINVAL;
 		goto out;
+	}
 
 	/* TODO: find another way [1] to implement this.
 	 * Passing a zeroed structure is fragile,
-- 
2.17.1

