Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C037340187B
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 10:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbhIFI6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 04:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241209AbhIFI6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 04:58:12 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD05C0613CF
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 01:57:07 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o39-20020a05600c512700b002e74638b567so4225448wms.2
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 01:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=axu/h3QQb94/dtjp6k6opc3V9u9UhFdRdW3Ivohfazc=;
        b=N74WNe8Oe9dFOnNDZI/aQT/qUdOUTPRCyGqxVZgxig1Y/36mnwEZ8jrflR28sJCawJ
         bcyxco3io1D69qygPQc85hWAwbgvP2inytm2XP8lv9N+XRg7+Gg0FUmcdNR7vodjiXOa
         X+eVDyHes2mFgWIIss1CD7AYE9TcfXGehTrNIdFDSnYrqKXTG5NnW1WBhSz6myhClDzl
         BZUuNyORVbCExCrJp+x383xS+Xn9pmy6qFj9+XLmtOUWo7sjWzUXWEKTPocw397uHQf5
         rTK7oYepbdDxM29qAC0Apm/QEsor6gLP6XXQg/7JVUCHW+e2ylY0l2VtBXOaoPVs+Tcz
         6FxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=axu/h3QQb94/dtjp6k6opc3V9u9UhFdRdW3Ivohfazc=;
        b=g1Q2zmexqJR0Se2Wd5UkJ+RHwYGQgWPUoYlLzk6SNUUcVPmvFIsGF3C5A46njwdkBg
         217k8yb2iJxpYBbh51StTNe3km4KBXnOVAtokhIvwR6x/HQamE+n9KaLFqsQg72D5N6d
         eMR8K1n+U1qPkKO/AkvMzvNvDo8GSeNqQDRiLn3cIPKyTWnGCCL3ug4skuZGoWXMAdTb
         ncrLgYrv1cURBDdj53+eTCfJaOGTdUAulVLBHwpJgB2uJ0XsR+UG+lELhxz3Nomy78ix
         ej0X062+rvoPUhOpAsR33o6p7yqAgjuvI0N9rl+wjnzobHuaWDNKRLVzCniK82MAwRXj
         FlEQ==
X-Gm-Message-State: AOAM530xEXGdx7qpd8075Kl/pInFLjbO4ooyVOmU5okxT+EIpRFurtkX
        wJBkcjg40e2xFhvU0lfujryLjdyxuppPcgM=
X-Google-Smtp-Source: ABdhPJy9GBEScWIGRu/xTrBJ3zeq5rt4O4Ipd1mT92KohpRImY9sfxNstQWG+EsvvRrpzNwEZP6C1w==
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr9929283wmq.25.1630918625779;
        Mon, 06 Sep 2021 01:57:05 -0700 (PDT)
Received: from devaron.home ([2001:1620:5107:0:f22f:74ff:fe62:384a])
        by smtp.gmail.com with ESMTPSA id x9sm6523071wmi.30.2021.09.06.01.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 01:57:05 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     netdev@vger.kernel.org
Cc:     ardb@kernel.org, jbaron@akamai.com, peterz@infradead.org,
        rostedt@goodmis.org, jpoimboe@redhat.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jussi Maki <joamaki@gmail.com>,
        syzbot+30622fb04ddd72a4d167@syzkaller.appspotmail.com
Subject: [PATCH net 1/2] bonding: Fix negative jump label count on nested bonding
Date:   Mon,  6 Sep 2021 10:56:37 +0200
Message-Id: <20210906085638.1027202-2-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906085638.1027202-1-joamaki@gmail.com>
References: <20210906085638.1027202-1-joamaki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With nested bonding devices the nested bond device's ndo_bpf was
called without a program causing it to decrement the static key
without a prior increment leading to negative count.

Fix the issue by 1) only calling slave's ndo_bpf when there's a
program to be loaded and 2) only decrement the count when a program
is unloaded.

Fixes: 9e2ee5c7e7c3 ("net, bonding: Add XDP support to the bonding driver")
Reported-by: syzbot+30622fb04ddd72a4d167@syzkaller.appspotmail.com
Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 drivers/net/bonding/bond_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b0966e733926..ae155b284f94 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2169,7 +2169,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 			res = -EOPNOTSUPP;
 			goto err_sysfs_del;
 		}
-	} else {
+	} else if (bond->xdp_prog) {
 		struct netdev_bpf xdp = {
 			.command = XDP_SETUP_PROG,
 			.flags   = 0,
@@ -5224,13 +5224,12 @@ static int bond_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 			bpf_prog_inc(prog);
 	}
 
-	if (old_prog)
-		bpf_prog_put(old_prog);
-
-	if (prog)
+	if (prog) {
 		static_branch_inc(&bpf_master_redirect_enabled_key);
-	else
+	} else if (old_prog) {
+		bpf_prog_put(old_prog);
 		static_branch_dec(&bpf_master_redirect_enabled_key);
+	}
 
 	return 0;
 
-- 
2.30.2

