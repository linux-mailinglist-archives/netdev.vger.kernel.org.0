Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068DA2282CA
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728961AbgGUOwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 10:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGUOwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 10:52:02 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C71C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 07:52:02 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k27so12060601pgm.2
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 07:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=jQD6nAcjkQ5pjbGsYVmdorWOSxhqu5wiNAV7p66amNQ=;
        b=V3BlKDAJXVmqbvNX7kLZJMz3EwAoAzAmBKsBlpEYhiFsgPK7YRwRHzB9oOmnBGjfDW
         0Msb+9SiWZtYTmJH9w7zjUtNGzH4mH/tKGLZPpKDP4XZ6H2ON5hpYEGOL5f9V+cbZ5T9
         CSHXAxD4ymVmX2RR4Mc4OiHTQ8IDg4xLVQVGvyx0sQI9FGjp0R553KGqwGukubVoy8EQ
         VxwEwXjrDioHyVpSRjC/VleDayLXIScHH+FwZZWHzRYLeVo08M/A4otG7RQXsXjLTijM
         MNkg7IUyZQE5vGpLUUo87VdJDRMb7bphJ+JmbyHEKQZZlGtJmUd73KcKzSXZo2ETLlsg
         a64g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jQD6nAcjkQ5pjbGsYVmdorWOSxhqu5wiNAV7p66amNQ=;
        b=Y5QTkKzgB8xchsHxVZNdjBJaDqSvHTHmBl+OBSL5X7b1XHxT9GwGo0Uzso2H7s+juU
         euAI33xHPVYpM9NIklEbg+c1gmaaSxr/AEn2ivpvTz+ka3y8H66V2bM9lPZ7ecOHljBk
         iCHOKyUCMwYH/cVt3Zlq3PsYv23nIDTgFRLxjLw4GMje9D75rV90zupt+FU0zLZGnHvt
         u1ioHizPX2GhcCZbvbExSkFZEDDefCF7uG5OdTK5QDZE0WQ6D6GRIskADnPHdKEHGJ8W
         PYRuiPjPlwvXqQUOFyOWGnhn6GtSPkFi8ni2laWP4hNQQfiS2M0askMHTU7WvwcYBeP1
         XgrQ==
X-Gm-Message-State: AOAM531Qx5W+1hTqMAdLWBycDuDgtHvHB4qTqYqZR4otbjlr/vsVrtOH
        3Rc7XE3dlUDid/A5KWSJqPM=
X-Google-Smtp-Source: ABdhPJzrXwuDrIfsW/afWZWOjKCQ4CbbpibIkqiZM16rlvwZTbqhC/xo1dGD2Vv9laKYdqRX8/3kgQ==
X-Received: by 2002:a62:1494:: with SMTP id 142mr20437073pfu.216.1595343121871;
        Tue, 21 Jul 2020 07:52:01 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id n137sm20732395pfd.194.2020.07.21.07.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 07:52:01 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@mellanox.com, ap420073@gmail.com
Subject: [PATCH net v2] netdevsim: fix unbalaced locking in nsim_create()
Date:   Tue, 21 Jul 2020 14:51:50 +0000
Message-Id: <20200721145150.25964-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the nsim_create(), rtnl_lock() is called before nsim_bpf_init().
If nsim_bpf_init() is failed, rtnl_unlock() should be called,
but it isn't called.
So, unbalanced locking would occur.

Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1->v2:
 - Change error path label name.

 drivers/net/netdevsim/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2908e0a0d6e1..23950e7a0f81 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -302,7 +302,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 	rtnl_lock();
 	err = nsim_bpf_init(ns);
 	if (err)
-		goto err_free_netdev;
+		goto err_rtnl_unlock;
 
 	nsim_ipsec_init(ns);
 
@@ -316,8 +316,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 err_ipsec_teardown:
 	nsim_ipsec_teardown(ns);
 	nsim_bpf_uninit(ns);
+err_rtnl_unlock:
 	rtnl_unlock();
-err_free_netdev:
 	free_netdev(dev);
 	return ERR_PTR(err);
 }
-- 
2.17.1

