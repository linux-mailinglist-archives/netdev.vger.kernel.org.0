Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC7672E58
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 02:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjASBhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 20:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjASBfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 20:35:48 -0500
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D631665AC;
        Wed, 18 Jan 2023 17:35:46 -0800 (PST)
Received: by mail-il1-f179.google.com with SMTP id p12so487523ilq.10;
        Wed, 18 Jan 2023 17:35:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tcLHpnRNh3ty5rv7JErXW5X+LMKRtJ6Ae8+AonT+Wt4=;
        b=0jLa0aGyVKMnt4/0y0IWTAk3bDxbSkFR0OThuSTTcKbqr3Vp/umF+56yBIgQT+wncE
         9VcozD8zQMNki1kQCYc/uiQEVqjlzUiys0nVyCbaN+Wh02A2uUCcOmahXXdOz5N0Tkhl
         boCWyHypS7aGaspb39mZmvhXYQSIgYqOdd2yqoSgXPCBbVr+g3Adu9xhM6foy7j0oqwT
         gUeStPSpjBJxe31zJ5yMLtwuIjqfMCHYJ3j8Y6qxN+B0l62eZXkohMHOdpI+8sQCSE8D
         WvVMbfiYl9/bMPZRk4LXmORvhUatK9i0Xtmn7h/8pDVf+7pjzLOPJfqfjOKmUOUO1REX
         J/6Q==
X-Gm-Message-State: AFqh2krR2gR//MhucOdkk6bRryC69FI7CZ3P4AvPK+0nkkA71TcYIPoM
        K4eirovp6NRuwyCASLUHyxg=
X-Google-Smtp-Source: AMrXdXvxlTgKBAhWQR4LZca7F3Mn+uGGZnTz9tjG2PdmlP9Pq5eRuymaOtgjrbYGoVOO6TucK1UGTg==
X-Received: by 2002:a05:6e02:2191:b0:30f:12c9:f767 with SMTP id j17-20020a056e02219100b0030f12c9f767mr9659967ila.11.1674092145973;
        Wed, 18 Jan 2023 17:35:45 -0800 (PST)
Received: from noodle.cs.purdue.edu (switch-lwsn2133-z1r11.cs.purdue.edu. [128.10.127.250])
        by smtp.googlemail.com with ESMTPSA id cs10-20020a056638470a00b0039d756fb908sm3547284jab.40.2023.01.18.17.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 17:35:44 -0800 (PST)
From:   Sungwoo Kim <iam@sung-woo.kim>
Cc:     daveti@purdue.edu, wuruoyu@me.com, benquike@gmail.com,
        Sungwoo Kim <iam@sung-woo.kim>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org (open list:BLUETOOTH SUBSYSTEM),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] L2CAP: Fix null-ptr-deref in l2cap_sock_set_shutdown_cb
Date:   Wed, 18 Jan 2023 20:34:05 -0500
Message-Id: <20230119013405.3870506-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The L2CAP socket shutdown invokes l2cap_sock_destruct without a lock
on conn->chan_lock, assigning NULL to chan->data *just before*
the l2cap_disconnect_req thread that accesses to chan->data.
This patch prevent it by adding a null check for a workaround, instead
of fixing a lock.

This bug is found by FuzzBT, a modified Syzkaller by Sungwoo Kim(me).
Ruoyu Wu(wuruoyu@me.com) and Hui Peng(benquike@gmail.com) has helped
the FuzzBT project.

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/l2cap_sock.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index ca8f07f35..350c7afdf 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1681,9 +1681,11 @@ static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
 {
 	struct sock *sk = chan->data;
 
-	lock_sock(sk);
-	sk->sk_shutdown = SHUTDOWN_MASK;
-	release_sock(sk);
+	if (!sk) {
+		lock_sock(sk);
+		sk->sk_shutdown = SHUTDOWN_MASK;
+		release_sock(sk);
+	}
 }
 
 static long l2cap_sock_get_sndtimeo_cb(struct l2cap_chan *chan)
-- 
2.25.1

