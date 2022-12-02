Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABCF63FFD5
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 06:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbiLBF3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 00:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiLBF2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 00:28:52 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96371DC4E8
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 21:28:49 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3b5da1b3130so38762757b3.5
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 21:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MR0sL5jhbXkj+Wk0IMMMOhnM4M8pDJioFTVy1grurXY=;
        b=QoRNM6wfdWoVL1mnJiZBcTf7gLg5B81C9cfEHccKW+OvYB6jh0TqQy6FLctLRDSrCU
         8crE0LOa8oVsUNM/lRb5HzzMKCohxGlAc/jcoescJqstDIu1yrLo3hdu/4YKmHABJU7U
         uzMaFsq2lzNo9JevRgS9M2njSxLfGj82bv445F0tXyX/fdA+OQNyXlGJKJybr24o/Zt6
         WMd8dwqnluXVaN0o2XawAomMRqWDn8zc+LCUqu5gZCYVpzJv16mDW5ek81BWS8TAlpyq
         kyR1w3LcvN03QPqxQzZ3jsbTa59V22mmk2yttlCDfWldqJWOwh26r1vEJ5hXW3n160at
         JOBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MR0sL5jhbXkj+Wk0IMMMOhnM4M8pDJioFTVy1grurXY=;
        b=c0R2QFhOLqpLccyrK6Zg1d9cR4vkC5Dm9UkWjmEfSZ/u5GwbtlwioM21BArfrhRTTH
         lnrZmNW6tOuVWgLWr5dRsdQ6UbcICJgtYOLS6+PLQk/0MJTgtHTtCUePL2U4AVaEV7yI
         fa1GsWaUgJS/yET6gHgLhlc4WApnm+YXYf2axfsdMNPxQ0XpVqaFiY5HpAxZEWdvTllH
         ZriIXcft/DsyTa3oN06/cnzR5zd65DVTDuXrJT2RhmRnRleed5mhdmueUJvc1pBldBdB
         4d8ggsmw6XOT6Nyf9zrc5TpzFI/92wIKev+9z1YMw+Uj8XS5PLwpYgGL2+a76qx59b0C
         UM2g==
X-Gm-Message-State: ANoB5pk8lXuwb1JY2e1ykDxBul/5vP4xapDJT1YPTRGgtQltFF0lOqT/
        t1lwAAnr4H57s8Xtsm4fe5txb961E22oSQ==
X-Google-Smtp-Source: AA0mqf6ND4t7w/W5T/GkCyjwu6tjEFGmXHgHOHVXmeYJtRzDs8WQlWyPE1FHYGzP1bQWLnKvxVqBNNmaZO1yyg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:6f44:0:b0:396:6607:354d with SMTP id
 k65-20020a816f44000000b003966607354dmr47581930ywc.177.1669958928759; Thu, 01
 Dec 2022 21:28:48 -0800 (PST)
Date:   Fri,  2 Dec 2022 05:28:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202052847.2623997-1-edumazet@google.com>
Subject: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <dima@arista.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
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

kfree_rcu(1-arg) should be avoided as much as possible,
since this is only possible from sleepable contexts,
and incurr extra rcu barriers.

I wish the 1-arg variant of kfree_rcu() would
get a distinct name, like kfree_rcu_slow()
to avoid it being abused.

Fixes: 459837b522f7 ("net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 7fae586405cfb10011a0674289280bf400dfa8d8..8320d0ecb13ae1e3e259f3c13a4c2797fbd984a5 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1245,7 +1245,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			rcu_assign_pointer(tp->md5sig_info, NULL);
-			kfree_rcu(md5sig);
+			kfree_rcu(md5sig, rcu);
 			return -EUSERS;
 		}
 	}
@@ -1271,7 +1271,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
 			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
 			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
 			rcu_assign_pointer(tp->md5sig_info, NULL);
-			kfree_rcu(md5sig);
+			kfree_rcu(md5sig, rcu);
 			return -EUSERS;
 		}
 	}
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

