Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07B89668A5E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbjAMDq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjAMDqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:46:50 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F2812D3C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:46:49 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so25709955pjk.3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 19:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6PUZsgimpsJsXrpUtcdF1Z0n4ZOe69d6YX+6ZJE1e3g=;
        b=pDcNdI5PsMCbQsbXR8Mx5MYzVY7T6BA+wLPIqu3YVsS/+ugJzdoR5m/LYFawwcx597
         0ZcVxiHHAR+zr4KjuKIjqKKg0vMgYyTxM/4ribLq5G1hXJXMu/fE18s7eZJbUoL4Cb2h
         /k9uTj5Qj42USHWtdXJTwiIiWMN6mpHCmI8SN7pJlTX5pNWZg9+jAjj8ij8bLWbQaHV6
         ww0mVB3Tm+j7tO9yU/+tdlQ0aDKF26nymAj2foNohlNRZCAJDRwVPigCda+5s/4jOMDD
         o174HJYG2v34hg9/OCb8RSFIzgApFRHvOEZEfYzU9bv2+REgzAIgEPeM5fCQZGTxYmpT
         PgIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6PUZsgimpsJsXrpUtcdF1Z0n4ZOe69d6YX+6ZJE1e3g=;
        b=R30Zn3DdhHAkAMe8SkaXy8toEh3P5aOHt2hxSTtQK2kWb80NXKgZ3+QH1m5ayRD1i/
         Xmks4uBQiYsKKwbSWmcGAICkcMog/cWG40HGd2ovIoPuC+6ZhXLu7EJpU+G4tTfH4X3p
         krT189YmQOT84rnTPBeeaiFUvwe7evdDmwXHQ8CEZn0X3xWeGcyZY4Ht53POrcBF6Bz+
         VbQjFXBBKqWt3har2nMS7/w29tfBvNRN9XOEW7dvQlBTNpPV2SMmh7aQamrlCoIIBZdm
         pYrL+ENBGzEKknhHbr2ACT6T0wcaeOiUxCngL5U9vIBPIERHTOzf2Ek/sMAV2OPow5+2
         oxjA==
X-Gm-Message-State: AFqh2koeV3IZ3voSZsuULSCyN0NMzAFzoC0PYsMdNp7pxnKLv7HhnLJV
        3Q5hBXHU+ML6P9dGj13q2UnKocjC9te1CqRu
X-Google-Smtp-Source: AMrXdXu8D1RlBjmxROFlRyVS8FUBMW7oeohjrSJj7yrrNNC5FFM3NgockETFuUVYJietdch3kl+Nvg==
X-Received: by 2002:a17:903:330b:b0:193:30be:d146 with SMTP id jk11-20020a170903330b00b0019330bed146mr16400858plb.63.1673581608842;
        Thu, 12 Jan 2023 19:46:48 -0800 (PST)
Received: from localhost.localdomain ([2409:8a02:781c:2330:c2cc:a0ba:7da8:3e4b])
        by smtp.gmail.com with ESMTPSA id u6-20020a170902e80600b0019251e959b1sm12897497plg.262.2023.01.12.19.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 19:46:48 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH iproute2-next 1/2] Revert "tc/tc_monitor: print netlink extack message"
Date:   Fri, 13 Jan 2023 11:46:16 +0800
Message-Id: <20230113034617.2767057-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230113034353.2766735-1-liuhangbin@gmail.com>
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 0cc5533b ("tc/tc_monitor: print netlink extack message")
as the commit mentioned is not applied to upstream.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tc/tc_monitor.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tc/tc_monitor.c b/tc/tc_monitor.c
index 64f31491..b656cfbc 100644
--- a/tc/tc_monitor.c
+++ b/tc/tc_monitor.c
@@ -42,9 +42,6 @@ static int accept_tcmsg(struct rtnl_ctrl_data *ctrl,
 	if (timestamp)
 		print_timestamp(fp);
 
-	if (n->nlmsg_type == NLMSG_DONE)
-		nl_dump_ext_ack_done(n, 0, 0);
-
 	if (n->nlmsg_type == RTM_NEWTFILTER ||
 	    n->nlmsg_type == RTM_DELTFILTER ||
 	    n->nlmsg_type == RTM_NEWCHAIN ||
-- 
2.38.1

