Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920E26755D3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjATNbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjATNbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:31:43 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA104DCCF
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:31:42 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id u10-20020a05620a0c4a00b00705e77d6207so3420292qki.5
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RLHVCxcQMQ73ZiOD5M453KKggeS5DcIz1XiyH0HvcAA=;
        b=HjUtij/mbmYPRvvVAxK7DojipwbEYh2ny82NmePeTWJFgcoL0adE0sq64Xh5Ev2bjU
         9lZlic4/DnZkzuprbcm+yrkePctWxfkbySHV/tmjwXRcdNfydwUGh7+wRmb8vQfXy5bm
         5KNcwZ2G7luc42JAWsx5NGgYVwFLMBkPgCsDr4sdMnYYxsa0jrcf74zEFwbkArlsO5Hg
         9xG5ayb7Bw/Iplnxtm/5JfmOWwsGs7pkZl2ECXRzThEDqbjy0vhDuWIOSQUqSCZIly0O
         AbLFyJiUta7J3d1ZHLGVj1TtmQ1fQmX96CyT2bgkn0Uc+kzthM7rG8HpUFFF8unDZWzl
         FlIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RLHVCxcQMQ73ZiOD5M453KKggeS5DcIz1XiyH0HvcAA=;
        b=ZbzNPVzTdRnW4P1jbKIK2TndccwGf18RwTfZmNSkNrr/lKoLEAKFcHdwaI0EbJaSHO
         ur05qQyBruomDKSTXOr68gTQnQLWNRNjCYt2yzRTOuDj4wirym4HeRDtkiHGSB+fz8t8
         LHL/jBf0nF90WZjGgoEsG18pnmkOfuV6OUkWtx/rZ4Otk21sRR3neeHKIobxkbgr8LNf
         /Ffear9alSJoCZcpLvRamev3bIB9dEVFHxlEWhrqk8YHrgy7OwbKnRQlx1M99A+bP8/l
         +fEWcDv4WHaBLOs9Esi9e7uSKiEDLinwCiS2XVzX2o0WtEPfmIuc/AIDOMBIq+yDid4j
         2IkQ==
X-Gm-Message-State: AFqh2kpVGyrYTNAKKu+5uy+n+xSK/0mizI5iB+BpUwPMxJYQNXfOwJhL
        SMBPB6XXQJZfzEtyVZnst3vUEgA35251uA==
X-Google-Smtp-Source: AMrXdXsW2sFk8EKtjm+63XMdnP6FRZOcbQrzuzDIsqh7pB7n/J5PWpLJR1T0O+BpPFAcjHzRCTjparbHSxpQsw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a37:e312:0:b0:706:7182:a7f2 with SMTP id
 y18-20020a37e312000000b007067182a7f2mr859912qki.205.1674221501596; Fri, 20
 Jan 2023 05:31:41 -0800 (PST)
Date:   Fri, 20 Jan 2023 13:31:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120133140.3624204-1-edumazet@google.com>
Subject: [PATCH net] ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
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

    if (!type)
        continue;
    if (type > RTAX_MAX)
        return false;
    ...
    fi_val = fi->fib_metrics->metrics[type - 1];

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 5f9ae3d9e7e4 ("ipv4: do metrics match when looking up and deleting a route")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/fib_semantics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ce9ff3c62e84055393ca1ff98f1d2ae391978638..3bb890a40ed73626acba8c22044d1c5f99c872e8 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netlink.h>
 #include <linux/hash.h>
+#include <linux/nospec.h>
 
 #include <net/arp.h>
 #include <net/inet_dscp.h>
@@ -1022,6 +1023,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 		if (type > RTAX_MAX)
 			return false;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
-- 
2.39.1.405.gd4c25cc71f-goog

