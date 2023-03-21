Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24E86C374A
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjCUQp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCUQpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:45:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5FA53709
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5425c04765dso158491847b3.0
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679417126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=115j3bJcmuziYs6iUe8ShA65hkJxp6AEADM5VO7Zi40=;
        b=WHYvvOZeHqAoRDuw8b2qxyL7t1lxCvYKfvM8pn+JEHmeqvTDlZqaEGdBrfbvzfnBGE
         djov6JNo8S6waxyV4+kpSGZdyPFA5sNTa/EyoXUQdexqOodoVfugnolrf8wjb0FJQhIU
         NaSJCpYPStd1lcYTOSWTmhBZ0+MFlfXTCl2RqiMmL/t5hcqH2zeFB5VpG4b4RHz+IMIq
         MheS5VlFjesT2RwtlTRX+d58k3cGiqZP4Dkmx7NAqwEbq9yWjakZ9jgFAzM2d4m0huH7
         O8JyMqGftxTWj6SYCArlcK/YbWby4d8G9ARfRYSvVBw7gdN2e1JnjaIh87C9WGSH96e0
         IdWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679417126;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=115j3bJcmuziYs6iUe8ShA65hkJxp6AEADM5VO7Zi40=;
        b=vEQvL+8Kkdn5xfI8D9447QlaQEnq/fFjnmkAYXEF0WKSCOzM30KHwsztgzvTNVJXFQ
         Y3pW5TI4tGkG9F7d8KBidCpwEKo8SE7rgH5wmmAV5bqY7dZ4YMSEMbw+viBUyQyKuMT8
         uxCzLbRCS/kW1PPhbHC1A322i0tRkDs3cDGCfwCVHTjjHcYsdtJxPKSKX/deg9i0GuSU
         D7iFL6ZE8AvSErzpIs7oYkqhLJmwQ84KSlbp7GCWZvL9P3BGsDmn+ANtHjb6B2ayvNB4
         XYicZrWw7PpxJlAItxUaWYScYGXAznlSoo1NZjzQQmyZwjmJ9p9KpHlgI1pHGK6yxKXp
         VJDw==
X-Gm-Message-State: AAQBX9cNO3sRhKGMIty30CLYDLbNX+uzf5u65er9cDohUA9eelwsskRi
        oEba5C64LGHcrH2EbuuZFKd3+spe5i05ng==
X-Google-Smtp-Source: AKy350b22CuOpJnzLY15OLp8ghFCztxdX0GRsQFQkj3/VAy8RTAByB0ORatOyQxTcxMMoZ+9kFEbNTs6+DAizw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:eb02:0:b0:52e:ee55:a81e with SMTP id
 n2-20020a81eb02000000b0052eee55a81emr1543621ywm.7.1679417126515; Tue, 21 Mar
 2023 09:45:26 -0700 (PDT)
Date:   Tue, 21 Mar 2023 16:45:19 +0000
In-Reply-To: <20230321164519.1286357-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230321164519.1286357-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230321164519.1286357-4-edumazet@google.com>
Subject: [PATCH net-next 3/3] net/sched: remove two skb_mac_header() uses
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

tcf_mirred_act() and tcf_mpls_act() can use skb_network_offset()
instead of relying on skb_mac_header().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/act_mirred.c | 2 +-
 net/sched/act_mpls.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 8037ec9b1d311486d803159b3f2f77eedf6b31d3..ec43764e92e7ba66586310628d78a6b184957fd2 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -295,7 +295,7 @@ TC_INDIRECT_SCOPE int tcf_mirred_act(struct sk_buff *skb,
 	at_nh = skb->data == skb_network_header(skb);
 	if (at_nh != expects_nh) {
 		mac_len = skb_at_tc_ingress(skb) ? skb->mac_len :
-			  skb_network_header(skb) - skb_mac_header(skb);
+			  skb_network_offset(skb);
 		if (expects_nh) {
 			/* target device/action expect data at nh */
 			skb_pull_rcsum(skb2, mac_len);
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index 809f7928a1be622671e47b8bdf384a8a10349926..1010dc632874ec5f4f0517f0512ab3ed30f14e24 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -69,7 +69,7 @@ TC_INDIRECT_SCOPE int tcf_mpls_act(struct sk_buff *skb,
 		skb_push_rcsum(skb, skb->mac_len);
 		mac_len = skb->mac_len;
 	} else {
-		mac_len = skb_network_header(skb) - skb_mac_header(skb);
+		mac_len = skb_network_offset(skb);
 	}
 
 	ret = READ_ONCE(m->tcf_action);
-- 
2.40.0.rc2.332.ga46443480c-goog

