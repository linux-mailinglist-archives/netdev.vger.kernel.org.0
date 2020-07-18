Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905F1224961
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 08:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgGRGti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 02:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbgGRGti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 02:49:38 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1833CC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 23:49:38 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id u5so6423838pfn.7
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 23:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d/RFFZ2xUY28o7Bo7g0kzJSe1aDQDUlpOouEQqwgzP0=;
        b=JSTFP6BUryiLeA6T+bN/mMqipYZDSRVNrUsWsWb3kzFvLMpkJlxjPwvfld+va3aXoZ
         FODbOmimy123lOo6VTy8NiAYMap5ZHL24UgPGUwOHKO4F5D/YGwr5n38Qq3V3rj+9a8c
         2k5SIvu9nh4m/TbUfnjlW89olL4oZuwN2g0t+swcdn7+1TPUYXTN0rhPXIlhxY+brNHI
         S4L7hW3oVTFv7CgnzqKUJrEgjRgQP700dRkoK9aGhHpRLv2V447AonN962hAh5Q4aHtj
         bXSd+12C4YEz155xAKpKOL9LT5c5BZKWQEVa9kmd6mRg9JVA871AZWfqyvqqK6uhmtUg
         ZBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d/RFFZ2xUY28o7Bo7g0kzJSe1aDQDUlpOouEQqwgzP0=;
        b=QI4TgI8Cd9Enobl3+EkHMwJJU768RIGCbXe7+2tN2W+4UkWSs1c9CKgoBYg5Rn4+JY
         3m6El46oTm0bJyCeZ28P6gN14/8mApE7N7vIwpS3NKpDIjosGan2z9Il9HDEQM1wKmZq
         K6pi1Za37CcmoU7uiZmL9Oe/e3TrvPl2mAq/TU01I/8dj5T4PLRMMZCseWFQDLZmwsL2
         id0D6cvFzG0C8cow2yCqDj6V6watjh7aOjIqKEGPLM87x9lb8Op9rR8FmSEgwGjJrS0L
         Z4Zikn77zFA8cPHy0gu9IDlEN21hPdPM02c9cBmodUM1VzgSpL5axyLL5K4zwD+AQC97
         jb8A==
X-Gm-Message-State: AOAM531pwH8G/NljE0AxZe/TGlCbfflUfgpZxxf22DfGM2wk1eJtzNkq
        xM8om+ZZiHdAqpFjkJQS3C0=
X-Google-Smtp-Source: ABdhPJxSgiAwI0UOc05YPU3WAs/VhDcfj3jxbXOFy+MAl+UZxwfvAYWuilLh1L05X1UY83VAfXvXKg==
X-Received: by 2002:a63:338c:: with SMTP id z134mr11208864pgz.245.1595054977616;
        Fri, 17 Jul 2020 23:49:37 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id j8sm9827905pfd.145.2020.07.17.23.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 23:49:36 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@mellanox.com, ap420073@gmail.com
Subject: [PATCH net] netdevsim: fix unbalaced locking in nsim_create()
Date:   Sat, 18 Jul 2020 06:49:21 +0000
Message-Id: <20200718064921.9280-1-ap420073@gmail.com>
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
 drivers/net/netdevsim/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2908e0a0d6e1..b2a67a88b6ee 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -316,8 +316,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
 err_ipsec_teardown:
 	nsim_ipsec_teardown(ns);
 	nsim_bpf_uninit(ns);
-	rtnl_unlock();
 err_free_netdev:
+	rtnl_unlock();
 	free_netdev(dev);
 	return ERR_PTR(err);
 }
-- 
2.17.1

