Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A51968D7FE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 14:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjBGNE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 08:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjBGNE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 08:04:56 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75013A587
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 05:04:46 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id g6so5500000wrv.1
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 05:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmesjpDIr41PWKtzB6vOyUJvIfGcXoSXXW1ARPTGITM=;
        b=owM3VR/jlNpYcBXX8SZAxXp1etnWM6U2dXrfws3gNjXUFOyb7fN8PzE3YmG3EI7Yyg
         6/8Q66QFBkLywuVTaZgLQ+M3i8Glgkldi0YROlbo3qGt+vn/wmbEDjkQlr+Wh6pW4ny2
         MJfwTU/dX8l8Es5leQcD2/8jG7BSJyB0CGKlT1+P7jchzA3TRvUoIZ0IUL/sq4GyGP82
         vo1lpuNAQdsgKrMhDVIgoWmeFHkc/vu9zAfjE04M0Bp4SZ31NGfXorI0czA7ZRgzuT/Z
         uKuq/ZXWUDqTQB2x6m8ZkFQJ/QxjDyFgyVnBmZ+QGwaRB+/WzgbvP+q3Qd066gJQC0Dd
         +7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmesjpDIr41PWKtzB6vOyUJvIfGcXoSXXW1ARPTGITM=;
        b=Emzdg/cxcWG0Qb/breUi55ufwTbZJHCO5pMpS+/iRgPsOxL+mlkfyWzA8AF9EYmkuB
         3DAcmvGOKM1hFwx5chtKKm/DIWEkgpZnD/Y2SeQJSLPj8m6BQDgfSSE6zHztLhG7yflE
         zqKU4M6poIwkZiSbTXRC9mBdxUqDTtRQyDgzMY6tm201p6si/tGnFi5Lvaz5IzjLuNGq
         BIOumuqGCKiDYfg8+QRYiNBxjC5u38j9oyodcGCTiRCLq3kUtwk1tbG12Zhe3+MJd6aV
         gVwDCCtRe/C+AMJv7cqnFQJGHpnW53+xMKFDhyqO5PTl7d3bXf/dN+7He3y4Bl+rGZtI
         nAxw==
X-Gm-Message-State: AO0yUKVogyflRrzrEGS5hLSg18UJqhWZqaXOCujuUIWuS4Kdj/3qA2v0
        86cO8oipoz6HG/Tv7Rmlf2ehII7T8JKh89YujXk=
X-Google-Smtp-Source: AK7set9+zwthM+/G6Yk0ww+saUL5xnqbN6hgGphVYrxhToDm2a6eruPHUgp6XRQU1dt8w36BxWLp2Q==
X-Received: by 2002:adf:f783:0:b0:2bf:c741:5956 with SMTP id q3-20020adff783000000b002bfc7415956mr2476789wrp.19.1675775085136;
        Tue, 07 Feb 2023 05:04:45 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id n9-20020a5d5989000000b002bc7fcf08ddsm11645394wri.103.2023.02.07.05.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:04:44 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Tue, 07 Feb 2023 14:04:15 +0100
Subject: [PATCH net 3/6] mptcp: fix locking for in-kernel listener creation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230207-upstream-net-20230207-various-fix-6-2-v1-3-2031b495c7cc@tessares.net>
References: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
In-Reply-To: <20230207-upstream-net-20230207-various-fix-6-2-v1-0-2031b495c7cc@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Benjamin Hesmans <benjamin.hesmans@tessares.net>,
        Geliang Tang <geliangtang@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2251;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=XqGLRd5Gpr7HPf6uQpX8sWyYQO0xBG7RUyxFxCjNxK0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj4kxovoLKV49l0355uwyXmfmFrMmpaxMCjYT6d
 x2e2nb+W/WJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY+JMaAAKCRD2t4JPQmmg
 cx4JD/4qaEwAHa2J7Ygws0P1+1OO4C/tG0wO+xAF48Op10/BYRxRsw8VL1OyifNuO46USuHEcoK
 kRhuZsn4dUiinVV7xNUK8zW/yayMo21TZEzheAd9zx1C6ut48HKofQ3XMbQir/T4C/Mv0qprdrQ
 p+k9FjgW3eph3rq1FUhI5n0/GYGmh54+wfo3aA4Ache57HqU3/K0+4bMix16VEi2sWEIsGh2K4R
 Xw0FCTdZkh5Rm0xRVQzHgSEC76MSzukJ2T8ggFTOOLdWNbt6wkBv8PuVrWpJjSk+0S1aIu2j1y3
 sdvQ/ieBfT4dOzKnM0QrpLRN8pjgxbUg88SHthyfPs6z0yOLaVJxS/0da1o2tRHKP9NVE3S9EI3
 9Q41hVCZ1T/7nu1HL3w+80ryzuxAVEFb2QbnVNnQABWHq34iJ5eFKb3N8JkhoBzu0XtAwzP+qta
 3a8gNgC0mSUltHexuRf3KgpgUgG9yKuP2wOddCRlTJjt62hW1EBW6KhKbEc/JCMqdMZMeu/xz3s
 y4md89lL+0ThShZNKZzUhtP+9MTIFeXiaBIMnIk9BR7g1hISdugxKR445k0LZk/L8bkPdWTjBj2
 7Q+1Ks8kvhzCztT5/Zu38EUJ8f2QXiwjdyCrrFRAC82ylDIr6fT26MioCzQPilLdUcXHhJU/h80
 AmaL9/lyTTi0+Ng==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

For consistency, in mptcp_pm_nl_create_listen_socket(), we need to
call the __mptcp_nmpc_socket() under the msk socket lock.

Note that as a side effect, mptcp_subflow_create_socket() needs a
'nested' lockdep annotation, as it will acquire the subflow (kernel)
socket lock under the in-kernel listener msk socket lock.

The current lack of locking is almost harmless, because the relevant
socket is not exposed to the user space, but in future we will add
more complexity to the mentioned helper, let's play safe.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c | 10 ++++++----
 net/mptcp/subflow.c    |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 2ea7eae43bdb..10fe9771a852 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -998,8 +998,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 {
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
-	struct mptcp_sock *msk;
 	struct socket *ssock;
+	struct sock *newsk;
 	int backlog = 1024;
 	int err;
 
@@ -1008,11 +1008,13 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
-	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk)
+	newsk = entry->lsk->sk;
+	if (!newsk)
 		return -EINVAL;
 
-	ssock = __mptcp_nmpc_socket(msk);
+	lock_sock(newsk);
+	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
+	release_sock(newsk);
 	if (!ssock)
 		return -EINVAL;
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index ec54413fb31f..a3e5026bee5b 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1679,7 +1679,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	if (err)
 		return err;
 
-	lock_sock(sf->sk);
+	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);

-- 
2.38.1

