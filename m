Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF186968A7
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbjBNP6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjBNP56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:57:58 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0562BF30
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 07:57:44 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id w3so17941547qts.7
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 07:57:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jsXu3Utra1XRAia3gLuyy57sXlGN3dhXka1zi+zHuPA=;
        b=J7rbhj4IGgChMGKEc3KwzEMn/XHVdDhexfBj8H/jhDqa3nI5+ZJHKg12F2pKSDxmFJ
         x4MgN9w/LyxL+r53RC9Rqg3lkEP+agM9RiVVmcFmxUwzH7pGmGiqPZfd/xesDaqUQhHp
         yeab5XcuqUDVFOaxM9rpUQM1NjEV9tS+VtXsp6RXop/eiPqlLyFx0b4qMsouNFzJ3u8u
         aBOcN0MehvagvKixqkQZIJIzRlFdqQWfPa6TE1sx5mT3+/Ox/ECKNyo+Mt1z0kKtKyxc
         9JdVJoq2jWfvQotXRLnvHg2uU97IBEXsgmzBbvzNEUv80MSl/RUbxAG4hAIfzXAf1ZGz
         Z9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jsXu3Utra1XRAia3gLuyy57sXlGN3dhXka1zi+zHuPA=;
        b=Dvva9UNO2/LoZRRyPr6oF7ZkGhUtNKb1gNXB7YNameIJ/2YaBrk60myIbjlYP6s9Mv
         XE0HNSDsl7jCxEt609BVrYNl3vNdY6gV3TvAsQLvPpBsmn3l3enegraO9milAGj5TIEg
         IdXwP+3d4Dv8yauw1DJgi42u47gSIeHWaDzx3pZhcpC+s7qP6nYMxd4VrK4boyu1ci+r
         ack33zCQGCnjywub4p16f6VJUOaaASn4XKklgMRjQXopTfFu5kfPk+NyiFzNsEe9eWuT
         JnZZi48dYLiP5XmZa0X1N2xfEh7Mgz5HwPPD2cyvXSrwZ7MwVM98TdfwASb0I8kOtzIG
         w0sQ==
X-Gm-Message-State: AO0yUKVCjwM/7wcVKBFQ+p2htrgjMyb0kdq75+QMPGd6uH4W5Ne3bFEO
        jRmwi7wj0on/GVyKrjeHZxA/2cNwXY8=
X-Google-Smtp-Source: AK7set+lII2k6lqKXcdJM0uPa20Ctx8Qcxafd1+iLgGxdQ7+Xo5JSf7KaObND25tRHjO3mgPtcl67Q==
X-Received: by 2002:a05:622a:1209:b0:3b7:fafc:73e3 with SMTP id y9-20020a05622a120900b003b7fafc73e3mr4858570qtx.41.1676390263608;
        Tue, 14 Feb 2023 07:57:43 -0800 (PST)
Received: from willemb.c.googlers.com.com (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id k13-20020ac8074d000000b003b630ea0ea1sm11186566qth.19.2023.02.14.07.57.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 07:57:43 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] net: msg_zerocopy: elide page accounting if RLIM_INFINITY
Date:   Tue, 14 Feb 2023 10:57:40 -0500
Message-Id: <20230214155740.3448763-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
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

From: Willem de Bruijn <willemb@google.com>

MSG_ZEROCOPY ensures that pinned user pages do not exceed the limit.
If no limit is set, skip this accounting as otherwise expensive
atomic_long operations are called for no reason.

This accounting is already skipped for privileged users. Rely on the
same mechanism: if no mmp->user is set, mm_unaccount_pinned_pages does
not decrement either.

Tested by running tools/testing/selftests/net/msg_zerocopy.sh with
an unprivileged user for the TXMODE binary:

    ip netns exec "${NS1}" sudo -u "{$USER}" "${BIN}" "-${IP}" ...

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 13ea10cf8544..98ebce9f6a51 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1406,14 +1406,18 @@ EXPORT_SYMBOL_GPL(skb_morph);
 
 int mm_account_pinned_pages(struct mmpin *mmp, size_t size)
 {
-	unsigned long max_pg, num_pg, new_pg, old_pg;
+	unsigned long max_pg, num_pg, new_pg, old_pg, rlim;
 	struct user_struct *user;
 
 	if (capable(CAP_IPC_LOCK) || !size)
 		return 0;
 
+	rlim = rlimit(RLIMIT_MEMLOCK);
+	if (rlim == RLIM_INFINITY)
+		return 0;
+
 	num_pg = (size >> PAGE_SHIFT) + 2;	/* worst case */
-	max_pg = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	max_pg = rlim >> PAGE_SHIFT;
 	user = mmp->user ? : current_user();
 
 	old_pg = atomic_long_read(&user->locked_vm);
-- 
2.39.1.581.gbfd45094c4-goog

