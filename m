Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A5E654665
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 20:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiLVTKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 14:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiLVTKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 14:10:13 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123A027CD2
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 11:10:13 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id d2-20020a170902cec200b001899479b1d8so1939911plg.22
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 11:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5Facyq7jyx06x0sde9cJm5isszyH4FOvgbaUH9yC0yo=;
        b=px3UssBjmW+eVGdLdeuT7CvlEtYfZ+nF37b4D2vAW06EscZYFMPegJdDfN2BPruqV/
         j+lKHRi99x4v/MtLPtcWa+VlWrOvnDtJ1tKAi0eGsg7fFAMiviU80JwpWzPv6rYGnYJT
         wBSTpQp61pJ1VfEAF/ebFc6n+nSL9zgcmPArX2oLjpTTCo8o5OvD+ren2kA/EaNtQHQG
         VWgvVQD4TGGD98mJCoRtuX1Ci1jVtAMn6hHW/4WRSnRDqP2JagyUa9Re3qAp3mgd0gQ1
         zIRojEFflbQ0Hc+yfkhPMKAuJyJghJNvaZ0ytIohh/CnhGXmIini1Pa0U68YjCVWiD97
         eMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Facyq7jyx06x0sde9cJm5isszyH4FOvgbaUH9yC0yo=;
        b=FyjU2JaEXnxglh12d9KMuHXzuCgbnPHQcd3vuJJM07gRS4F62EigoclLM+yNMYaQqX
         S3Z8Rj2GLdZ/7hCukn96v5O1o/m+aekOPddDA62LTWHPUQmqLaERsCcO+k5+3lxEKQ7B
         r/r5GEUB5xBc1CUGcagGs9lxessaqbr9hYmH94Ma6R3L+EmR0Hgxk1I9YU9WsoaRvn6V
         sIGJ64iCLSagCyL7YkgZ6Ozr/kP770TQ6+bs4gKveqnQpva2a8cezS6RSKtG7AOpKnl/
         7csrzEqxwOTsK3/VFdYU/cf8KPAHr5CjIRikhdlWgGEKTks0WCSTQoZCSu1Mck7CbcCk
         yUVA==
X-Gm-Message-State: AFqh2kpeyQR1bjrDZiNioGlxmX8CBxdk/2vdikFtqSiqYJ9+8Q5S3pm+
        3KBXqjjtHQzg0DcFSxrsVeodDz5Tuv0u8ZHPvYj0hmKYJXHdm0UuHWqLOIFSUtPhbhq2fHcIImY
        /c6H3YF9WbVQwAIqShnCEzZi6NKgf8UeBubINOAVS6aLYg9OX8scbD7H5f87KGEHy
X-Google-Smtp-Source: AMrXdXu1V0Y+Ya65hTsH7+lIR2809iTvIGkFpfQ5xUXgcHUS7aBUWjwNfrLF180rOb8gI8PseSbja9G905mN
X-Received: from coldfire.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b34])
 (user=maheshb job=sendgmr) by 2002:aa7:8d52:0:b0:578:8850:fe65 with SMTP id
 s18-20020aa78d52000000b005788850fe65mr527712pfe.65.1671736212424; Thu, 22 Dec
 2022 11:10:12 -0800 (PST)
Date:   Thu, 22 Dec 2022 11:10:05 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222191005.71787-1-maheshb@google.com>
Subject: [PATCH next] sysctl: expose all net/core sysctls inside netns
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All were not visible to the non-priv users inside netns. However,
with 4ecb90090c84 ("sysctl: allow override of /proc/sys/net with
CAP_NET_ADMIN"), these vars are protected from getting modified.
A proc with capable(CAP_NET_ADMIN) can change the values so
not having them visible inside netns is just causing nuisance to
process that check certain values (e.g. net.core.somaxconn) and
see different behavior in root-netns vs. other-netns

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 net/core/sysctl_net_core.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 5b1ce656baa1..e7b98162c632 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -643,11 +643,6 @@ static __net_init int sysctl_core_net_init(struct net *net)
 
 		for (tmp = tbl; tmp->procname; tmp++)
 			tmp->data += (char *)net - (char *)&init_net;
-
-		/* Don't export any sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns) {
-			tbl[0].procname = NULL;
-		}
 	}
 
 	net->core.sysctl_hdr = register_net_sysctl(net, "net/core", tbl);
-- 
2.39.0.314.g84b9a713c41-goog
