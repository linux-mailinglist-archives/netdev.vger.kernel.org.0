Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0650955DC5E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbiF1C74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243980AbiF1C7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:59:54 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3CD10C2;
        Mon, 27 Jun 2022 19:59:53 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x138so8079943pfc.3;
        Mon, 27 Jun 2022 19:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iy098yhdyb0a5SyXKWlT7u6iJuhvMN00ep0qgOXCHoI=;
        b=QNi1HHEUK8o83bxfsVWh2Z0OllMq9omDy4K0glAnV1LGSn1WJXd0+NQ3BRRpFmKvA5
         5/j747pZhTLek5CVOQXiMuEWWxwBhbLbao5Pr5hOj9KusCwA4nBbj7vXgr1Zl9RkE6EA
         qgaw2bj8pIM4ZZ0Ia8S52x392+ts1SD7cpwoEqJ5KnIqLy0gWV4Q3CFiq3SeFWPUjh2k
         p/sxlkizJIi9Dv1y57lcHlBCcn4KFG6EiU4h6ygq5x1u8ZSuwAs87Kj3xd8cMAbMG+tn
         2LxX6ntrg1x1YqjBvAj+iRdKh5D4si73ROhexqPsT087pEtiD3yccUDvnH4FiMLd4+N0
         53bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Iy098yhdyb0a5SyXKWlT7u6iJuhvMN00ep0qgOXCHoI=;
        b=I9eb/yPL1baXk6Wj5fTIzH/uEvDz1vJSZromklSWohUOY21g4fdPtRJRU0FObpKvMK
         lt3i55B9pLWmUeHZTh2qokMjo1+0tAGlTOtNJ86cjFgZW9gSmpzEY1GcDr9nUBbT1nhG
         OmhXNwhptFbXaAFOsDqQvw9qAIJeFkKaxXl5KTQDZwgD6Ial+eyLqPSbnsjKWkoBYegu
         43UZwT4jUv5jGbjcpRYVJXyMRYg1dm/cojZpTYeBoT4aM/YyHDX28iPMnmAx5kKcPJGy
         EWODvvQM33FR0Bc5NZPWL1iOu7Gm+uFMOxHEIjKj++aWDuH+9QjMfFouV+palTiK8KK5
         7vjg==
X-Gm-Message-State: AJIora/TCj4gKprZyN0xxLSI/3nbAWMrEkCMaufvWgwtdf3eDXPqp2zz
        RWv0KKs7DaUVZwdihRFcIiU=
X-Google-Smtp-Source: AGRyM1vvx3EazGHMG0o771576+yjZRDKDLi71wCcXpaTemWTOq/i4T3QX8lr7Fg/tBCUj4dtvYtX8w==
X-Received: by 2002:a63:5610:0:b0:3f2:7e19:1697 with SMTP id k16-20020a635610000000b003f27e191697mr15973688pgb.74.1656385193204;
        Mon, 27 Jun 2022 19:59:53 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id 17-20020a17090a199100b001eccaf818c5sm8096334pji.27.2022.06.27.19.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 19:59:52 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: tipc: fix possible infoleak in tipc_mon_rcv()
Date:   Tue, 28 Jun 2022 10:59:21 +0800
Message-Id: <20220628025921.14767-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dom_bef is use to cache current domain record only if current domain
exists. But when current domain does not exist, dom_bef will still be used
in mon_identify_lost_members. This may lead to an information leak.

Fix this by adding a memset before using dom_bef.

Fixes: 35c55c9877f8 ("tipc: add neighbor monitoring framework")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/tipc/monitor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 2f4d23238a7e..67084e5aa15c 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -534,6 +534,7 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->peer_gen = new_gen;
 
 	/* Cache current domain record for later use */
+	memset(&dom_bef, 0, sizeof(dom_bef));
 	dom_bef.member_cnt = 0;
 	dom = peer->domain;
 	if (dom)
-- 
2.25.1

