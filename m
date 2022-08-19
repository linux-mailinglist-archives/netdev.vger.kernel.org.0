Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3DD259A586
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350777AbiHSSe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350776AbiHSSe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:34:57 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01BEBD6303
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 11:34:56 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33580e26058so89501477b3.4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 11:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=qL+JXObshzTRrCwLbMF3qXqnBi/SJhbbagLX2SsRPgs=;
        b=bNJqH1tGwGWsw/1KNl0PRTFaqOZRZ3NVnFhQCrzQQYZhCbs3fd/92cDu+tgj2pmuVx
         ledjgzyGp72QCO+sDsb0jOZ12A44xjc5uwGHKTajRGVneBR5x1fYtlw1WQcXvJs6F/2v
         R1foPPyatJMQoZ5xRp2ujYpyiLpdJq7ii2FVHUwHYasc0ncdzIGXH1El1+aKj/tfY6pb
         QSctG7OQ2SWuy5g28kqSZo3HMYwYTQs86hu0IxhALDMLFDRfewdyhsezNzVwe1PGPXzn
         T3TRgLMVWS4aFns12AWQskOF8ZwKY4UKvoTMGNDQKZKy6ni0YkKgRnf/qdiGLezVHDlc
         ZyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=qL+JXObshzTRrCwLbMF3qXqnBi/SJhbbagLX2SsRPgs=;
        b=Evrz+csuVjefeNHjfzadH9B10k//yNCgNWFhcqMRHGhOnalTjc6sOxvTOLX84KQoIC
         OAUu95gO1GVdR85ekzQ0WHu3kLRAxpQXYV77EW5A90PgvMt01e45E0HTlBfU2gCx735X
         Nd2j8D3sitnwp8I3DS31zBks1rCurnr0hZkUdU6dv8zT/J41WQpwdArK/jz2LdJ5deCE
         V3gV3qoLLOOt6Vju2hFESdPZv3t7GyflQlXxMEJXnE8fXsM3dA64AZ1/+KosNByy1gJP
         kxmEx0DVUfwzB/pQmHNA61qThJBaOWh+IxE8zCNrxrmSM0caRZ7yBcwdrcxl68l1+f3w
         ijqg==
X-Gm-Message-State: ACgBeo00mRMfS/RvGgX9fNjSlN67mtHysFRpS4Y/M9ggIDccQpsjpLJQ
        gJ/9+3hrgnvIACN9Etx7m476+qBO/6P+MnISnwvOpX+3zZHL3zG05gtmBqFzOo7PcbdRjlQeUCf
        ufKZv7Ge9MS0xo73ye7GIHg+eUjgFKnVgFv4Abz9A/+8YHZgNK9yNuKiXddKdq1Y1KyvLIA==
X-Google-Smtp-Source: AA6agR7vyZEZLIQf16LtTe9ZW7xrDM5G8x7KlmcishWcviplENZ33tS6CwnBj67sEonTts+nuLUVqCnLWfVupOw=
X-Received: from dolcetriade.mtv.corp.google.com ([2620:15c:124:202:c4e0:298b:c301:e929])
 (user=harshmodi job=sendgmr) by 2002:a81:f47:0:b0:31f:434b:5ee with SMTP id
 68-20020a810f47000000b0031f434b05eemr9159776ywp.383.1660934095110; Fri, 19
 Aug 2022 11:34:55 -0700 (PDT)
Date:   Fri, 19 Aug 2022 11:34:51 -0700
Message-Id: <20220819183451.410855-1-harshmodi@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH] br_netfilter: Drop dst references before setting.
From:   Harsh Modi <harshmodi@google.com>
To:     netdev@vger.kernel.org
Cc:     harshmodi@google.com, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that there is already a dst allocated. If it is not
released, it will be leaked. This is similar to what is done in
bpf_set_tunnel_key().

Signed-off-by: Harsh Modi <harshmodi@google.com>
---
 net/bridge/br_netfilter_hooks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index ff4779036649..f20f4373ff40 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -384,6 +384,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
 				if (rt->dst.dev == dev) {
+					skb_dst_drop(skb);
 					skb_dst_set(skb, &rt->dst);
 					goto bridged_dnat;
 				}
@@ -413,6 +414,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
-- 
2.37.1.595.g718a3a8f04-goog

