Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1318C65E2EF
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 03:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjAEC2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 21:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAEC2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 21:28:52 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737D265C8
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 18:28:51 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ep17-20020a17090ae65100b00219702c495cso13179524pjb.2
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 18:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9aqmCY0PmmOdoaG3y8UpkZbWIiF3b0XBvLQ5WUZdf+E=;
        b=S1NktgFQniY1aC0nI/P/2g16hSO6HtiiTb0jiwLs8EWOyuxoMTuK2R8KgF86c5mzXI
         2h6FXdRV1GYVE9oNKk2x9sRLRvHbCvgtTQOd1yvGL3GpjVPHFxP1Gof0DPPARfkWF5EI
         sHr2h/253SKx2kRp3oDJaR3g9+uE3vU+zKvN8qfUvtVbcTfGmc3tVBEaQAoHD7bBs4l2
         ZfP9CZ4YcshzgPfjDhB6A2TF+9VNrZd3OzQ2LolYB0ufRIhG6X+Fp2S4gc7zHGT7PKFz
         SuGO9iCiRHonqrCAu2C7dVK6XoukJK9bzOHq97yL88TmHBSPLQE4FvFdQbDkiUIb+UWt
         v8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9aqmCY0PmmOdoaG3y8UpkZbWIiF3b0XBvLQ5WUZdf+E=;
        b=UK/XjqTRinGsHGXFz1hWhcd3W612ZJVoCaaRmDdF4rcSVJAJmUyc1fuhtuyZNMsbNu
         v9dBnycI+xJxpNOZHbTvDy0QmJ0HdBkKJE7NGP1fb7rdDzdUg9uDBBP6OsMnP+HPrqQE
         xiAoBiX7Hpbgku/8nYt0gcE9mPtl4dmApM4t8lKmfPf/k7tNvfMYgkp1sCXDHgYk7jVK
         EwUbYoP+dF/MesP32KaJvD86LvgZ6F2/7BXyuA9bndWnMLLDfoCjjTjDQ4yPi5OGNsSA
         s4ug33SMnXhY3CChEf+J6h3gBpjEznymxevQNsc0f2Os2lNQbJDY1OvJ2sMk7v4mjpHK
         sakg==
X-Gm-Message-State: AFqh2kqyZHBwL4d4cvmFF+rzy2qYfNoEqvw84RwxATMV9MRikvGz3KYF
        oyDH2H4HJsoQ6w/ANpfpuLv/mIYejLmKWYXGidxvDHk1XfxAEcRbK0+PTFs8+0lU17Cf3MtcPdV
        VgDaCpKkPVs3j0iibz5P9DyAb3LUpOpk1lvZBuKid9/Pu2TPTtPGlkcFmrr27t17l
X-Google-Smtp-Source: AMrXdXte6ggMqNIsAcgIEjPobNoPLempe4Kn3U/fM7TkIdkXi7ts3qfu5JZ2CgIFXEDqit6QHEwiOYog/fwA
X-Received: from coldfire.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b34])
 (user=maheshb job=sendgmr) by 2002:a17:902:e345:b0:192:9e63:e2bc with SMTP id
 p5-20020a170902e34500b001929e63e2bcmr1552774plc.11.1672885730731; Wed, 04 Jan
 2023 18:28:50 -0800 (PST)
Date:   Wed,  4 Jan 2023 18:28:42 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230105022842.3113230-1-maheshb@google.com>
Subject: [PATCH (repost) next] sysctl: expose all net/core sysctls inside netns
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
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
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

