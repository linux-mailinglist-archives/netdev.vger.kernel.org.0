Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB8165C784
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 20:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238522AbjACT2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 14:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239097AbjACT2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 14:28:07 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E0215FD6
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 11:27:39 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-45dd4fb5580so328420447b3.22
        for <netdev@vger.kernel.org>; Tue, 03 Jan 2023 11:27:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yix8vsxPcWD/rhmBilWGjIP/dzLfo4zD8qNS2sLGSlk=;
        b=SfEiQa6shpWGe01FBw2P/HzQcTLTwsu8CIlaRhu/VbbnNhl5hOy76gQMJ1kYsUSAOV
         4fINuC2kpJqoEnQarpLNz+YaBfh9kGJQnrhxFsKchdKzDPQX6xeV3utXmqWTQRu6W5F7
         anInCQ4NVoO/en8WhgV6nC+z37WOgoUDqEsjg3GK9YYFGesRap0dfC99wyDe8jbgqs4y
         yWmfA7fmCszphtrPQZX/+pUEfHLmmJCgLMhMZPCH5XmHUWFOFYtwTmXOzEtxxjeKK7HM
         /T9hcnopLYH9+Z4gEK6ObD1PVeoHgsmGbTrunK8dKJnSkvg0rawmuAzeCly4XXAhdvKt
         p5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yix8vsxPcWD/rhmBilWGjIP/dzLfo4zD8qNS2sLGSlk=;
        b=WJAd6vXYFkk0OepD2ZnpNunoOmbbigxNkC9jcRCapid0OQCa5nhgVZW3NfilY7Vvwv
         X1LkI6leXIxgs/QFIHtCLWmH4Cv4syENu3gmUY3wxLMKi0RdhtLMAwQFC7RwHgEOlvb2
         XuilggfBp7AT46CAOSxTLvqaIjU7GqvetXYvfhuHON4tzwRgRXTbg7Dpb02Xm2XKPhi4
         yd/6g2WhP8mEq089Bu2ffLzhbK/Oj6c5s/Npt0eHBJHr31pXN06E/Vv3dE7n7qRcOFsh
         4Kk+I3W2nNDU94NJbwiWPQGhEDQ9Oh3Qm03zojpqkcifq1X2S6xGOu7XjBCSkfixT3GL
         kxwg==
X-Gm-Message-State: AFqh2krZxvMSXdAofjwZUdF75YHNq1vSWVNmmR1X0175D2Ev3YFuKc+t
        mx+0NL69acI6dWhwX0wj5d/S48KrTYyf/A==
X-Google-Smtp-Source: AMrXdXsaH5OrR0KtyPKcLxh4RDi/8j0VMJbptj/6EY0/6BS0mEpooN59rfPmUmLtsOoJaE9sb8mDeqrJHSjosQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:b47:0:b0:6d0:828:9852 with SMTP id
 b7-20020a5b0b47000000b006d008289852mr3023424ybr.364.1672774058332; Tue, 03
 Jan 2023 11:27:38 -0800 (PST)
Date:   Tue,  3 Jan 2023 19:27:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230103192736.454149-1-edumazet@google.com>
Subject: [PATCH net] inet: control sockets should not use current thread task_frag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com,
        Guillaume Nault <gnault@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>
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

Because ICMP handlers run from softirq contexts,
they must not use current thread task_frag.

Previously, all sockets allocated by inet_ctl_sock_create()
would use the per-socket page fragment, with no chance of
recursion.

Fixes: 98123866fcf3 ("Treewide: Stop corrupting socket's task_frag")
Reported-by: syzbot+bebc6f1acdf4cbb79b03@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Guillaume Nault <gnault@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
---
 net/ipv4/af_inet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ab4a06be489b5d410cec603bf56248d31dbc90dd..6c0ec27899431eb56e2f9d0c3a936b77f44ccaca 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1665,6 +1665,7 @@ int inet_ctl_sock_create(struct sock **sk, unsigned short family,
 	if (rc == 0) {
 		*sk = sock->sk;
 		(*sk)->sk_allocation = GFP_ATOMIC;
+		(*sk)->sk_use_task_frag = false;
 		/*
 		 * Unhash it so that IP input processing does not even see it,
 		 * we do not wish this socket to see incoming packets.
-- 
2.39.0.314.g84b9a713c41-goog

