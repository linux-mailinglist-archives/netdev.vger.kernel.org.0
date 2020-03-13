Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2A3184115
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 07:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgCMGuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 02:50:40 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43436 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbgCMGuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 02:50:40 -0400
Received: by mail-pg1-f195.google.com with SMTP id u12so4410436pgb.10
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 23:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rKoLMWAEb8bVDQaI+0K2QIouDx3X1f41EflyGqJejAw=;
        b=uzeeEP1dUa5SHkVGm+hMX2iPibbexesB4zKnMev7s4pMXUUzqL7TotTge4Xgg23CkP
         8PhUTfSySNKwMkEXk9lczLogJRj5WzRRo2EC0J1Zdd59hV4+z/tpMYNFp3NPdiTBV3A/
         yHx2uADZY4Ijds2Yrmr28S1UjhwDwBWwPTnCwdHuECKV6u4W4b3ZNmMqWnQPfkNlgOaF
         lNxRtlXry98S8fbm1G2k69m7HSlVUVE8UGRfEYr2sfJ/v0WaMFj5DQIXEYVMCtb+yDp/
         GSQGe3GuKABW+MD9ku0scZQpvdbwrFh/Qe/RiKOvAKqTr8bMPDifbuWFMyn1A/6/fVmy
         9Fzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rKoLMWAEb8bVDQaI+0K2QIouDx3X1f41EflyGqJejAw=;
        b=RMNkHht/k0ISDyDMf4urIRW3NDuVhQYVRffdo8HOMkhiIyPcCAP2CejT5srIV8VmP7
         f4qzk2YBWMBlAdfO72bXDWAPcfY2hIjnnbHoBI44Uusws8AGIlQRg/BvYXP8Ot3LBS/A
         tkgp3YgbIwdoIFUYuvb1nZfupfQnphpe060xJNDJadfX+lWJUkKIzjhcyvn0RVfwRLGB
         RkKoADmn602U2DYVM8Afp6CjuxYDdwJFX2F/Zxz/hZ7qbwEebPJk9yMDUILKjJ8JCwS4
         dkYYanyw2X8Pursk3dqIts22oncCIMazEHfqFKFuY6Z6wIVWPRORwBv9smgsOLIYH6Ft
         exLg==
X-Gm-Message-State: ANhLgQ23YVkIhtnSJgTZmJfImefv/kTL6NBDj333GtF49/FfPcfMOLMB
        By7FVUn4yiI5Bpn0qnwRFlM=
X-Google-Smtp-Source: ADFU+vu5DyPhGip3hUuXRpyj/72LgrmiQwrrptPQuPsvWg9SecjL8ZiAMNIoyW0vhyHWCShn5NtQAg==
X-Received: by 2002:a63:114a:: with SMTP id 10mr11353697pgr.185.1584082239575;
        Thu, 12 Mar 2020 23:50:39 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id a71sm19297937pfa.162.2020.03.12.23.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 23:50:38 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 3/3] hsr: set .netnsok flag
Date:   Fri, 13 Mar 2020 06:50:33 +0000
Message-Id: <20200313065033.32326-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr module has been supporting the list and status command.
(HSR_C_GET_NODE_LIST and HSR_C_GET_NODE_STATUS)
These commands send node information to the user-space via generic netlink.
But, in the non-init_net namespace, these commands are not allowed
because .netnsok flag is false.
So, there is no way to get node information in the non-init_net namespace.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1->v2:
 - This patch is not changed

 net/hsr/hsr_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 726bfe923999..fae21c863b1f 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -470,6 +470,7 @@ static struct genl_family hsr_genl_family __ro_after_init = {
 	.version = 1,
 	.maxattr = HSR_A_MAX,
 	.policy = hsr_genl_policy,
+	.netnsok = true,
 	.module = THIS_MODULE,
 	.ops = hsr_ops,
 	.n_ops = ARRAY_SIZE(hsr_ops),
-- 
2.17.1

