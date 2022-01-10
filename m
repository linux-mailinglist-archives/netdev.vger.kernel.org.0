Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF65489594
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243262AbiAJJr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243233AbiAJJrz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:47:55 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345C4C06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:47:55 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id hv15so5577537pjb.5
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tUPLl/VL0t85t/xKdQpH7fYZEcWX6UAG8h68IG+cCro=;
        b=gZAoQ8/GBJ9ivXOMXLDcxjtUMuiYoqTVSMDDte1Pp5F550v1PHCa1H0QI/A30pHLdn
         FYICwEvCeJj8FvhnbyQtbMRBOKz6PBKOSxI1OgMekLJdzCB2CXX/vPS1TCnjPgUiP8yX
         +Qci8I03THJgS6QUh0+jVkkJv12cXZVVv90roDA2t/nR7itJdcsAPVgmSbBSgO6Kwmr4
         RJGiddmBfjhJPsQkSL4hQutBTBTL38KIBSEjB4WKtDb5RoTgsReVvJgH9GI8hcQslGdm
         it5yLKSJK/4iJU7eELZG6uoSAEgcdYcFKk+wU8nX00ia3BucY81C9vjzgM0hT6DmfiS7
         COyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tUPLl/VL0t85t/xKdQpH7fYZEcWX6UAG8h68IG+cCro=;
        b=DeD2zH3HYCRjbW4o0yfK0cDMMvZPF0h7JnmvzDjY1yMw6ADE4ivgOXpP2mT0PXukKY
         0drcdaKsoHHb8YDgBp2Yfg5BSfwNcw+9N/dmNmz0oVHOU7+oaivEThpf6y0/KvGx6d3w
         YzgrAWYq5HV3MHPAcBT3LT9sEqG31JvY/XBEOvIrLUWgT6ZWua2lgrR0rdn+8WF08C8M
         8oZDKGiNrrE1ISr3/7zp/HJjnwpmjqBNMteOF6CsnW1dZMNHERKs2qCeAdHJ7Ya76ANa
         GoPoTrO9I584rGyrHfpQt/s9j6aogzoM3FfXjbgyoaYpky1oRwzaVb1fw2ct/QSm1kpR
         Iecw==
X-Gm-Message-State: AOAM530xOnB6sqXDm63PEtrAqytjHqFR58IKIRy7hEKLb43ctleE5/E+
        qSz2K8tNM8NJ9YDpA9OZtsk=
X-Google-Smtp-Source: ABdhPJzgxvr7unCsEhwVK7OULG9xkDWPougd79US7Yib8PPpM6rCKUfoBXSBXt6bjWtA2pXonSZ+Qw==
X-Received: by 2002:a17:90b:1b0a:: with SMTP id nu10mr29423292pjb.198.1641808074778;
        Mon, 10 Jan 2022 01:47:54 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4244:3bd5:d366:2311])
        by smtp.gmail.com with ESMTPSA id d4sm8141703pjj.4.2022.01.10.01.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 01:47:54 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] net: sched: do not allocate a tracker in tcf_exts_init()
Date:   Mon, 10 Jan 2022 01:47:50 -0800
Message-Id: <20220110094750.236478-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While struct tcf_exts has a net pointer, it is not refcounted
until tcf_exts_get_net() is called.

Fixes: dbdcda634ce3 ("net: sched: add netns refcount tracker to struct tcf_exts")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/pkt_cls.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index ebef45e821afd51e407dc19d83d0ad10759e7aba..676cb8ea9e15cae4b098b461918ea0ff49d97768 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -218,8 +218,10 @@ static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
 #ifdef CONFIG_NET_CLS_ACT
 	exts->type = 0;
 	exts->nr_actions = 0;
+	/* Note: we do not own yet a reference on net.
+	 * This reference might be taken later from tcf_exts_get_net().
+	 */
 	exts->net = net;
-	netns_tracker_alloc(net, &exts->ns_tracker, GFP_KERNEL);
 	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
 				GFP_KERNEL);
 	if (!exts->actions)
-- 
2.34.1.575.g55b058a8bb-goog

