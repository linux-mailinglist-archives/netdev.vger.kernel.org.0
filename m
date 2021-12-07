Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4781346AF70
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378742AbhLGAzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378793AbhLGAzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:55:36 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A17C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 16:52:06 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so8247561plf.3
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 16:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oo3SQ3B9ieo0QEtOiGHTeKsb094AAyXG2Ek3u3c49+s=;
        b=h5GDIR808ji9DixtVBtOGDYHWJG1W2RQ4oW7W5OJq2XWnVuHeV6D+70VH9nw8FUznc
         ci1ntGHc7nqzgGAELyvOiWqF8bJ5WjKCuYgNaav07coQYgNCl0fxxtQCv6X7yTTPVz9O
         HIXngHzGAA+DSECvxw4TTVoqyI782L0IQOfcWXPzsCG58lJeFb1HN8gp56cOy6+g7NMp
         5tzNBKjb8BykkMOh4emoaeJ6A6XOZ8nIM6snoIxheHfZuRMsMO1+jON2Q21g2We0T+Nm
         +11ZMp8ttuSWLmf8jfX2M7fFadBUyx1h7Dx8c73v9u9r82rXXUkTpCoaNtLApeFCcK0Y
         T1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oo3SQ3B9ieo0QEtOiGHTeKsb094AAyXG2Ek3u3c49+s=;
        b=q93fTi6bilVXJaLpSmBX2UJbjHT9aYr+DSIZ9j2hL8RnWQnmuwJzBV/H83UYoWaIyM
         tWGCifBR9MnqD6z1FjtpyXZ+AVeTM7+B3RNwHJORrXOZMIlZGF3HOvqwSzWNE2CKSbjQ
         SegKmZGKelWWq1JAZoxVzbO9Ir8eZurtPOSwmUCI/KfkbnXIYadPsI9202DS8NgXUtFP
         CAZ6eUwGFCc3zjic5ZiJ2dD+0wygjBiN1x65XiMg+uuAL24nwNICHJKqqkUnCj2UYzTV
         Lja/pmiw2gsCZDx1vab+CjOo7UxxftjmVTqQTSxZt/9l1eb1FvIfv0T4A0c6PGowcNlV
         nwNQ==
X-Gm-Message-State: AOAM5339bWtC5IuLW4pFLKzGUpCdOQ9+pQucfP8X43mW0Z0LDlFkC1Se
        sPYPEhPB+mWshZQuZ+jL1W1xxvMRN4Q=
X-Google-Smtp-Source: ABdhPJwjPpCf7bLJHH1nRdUOS3/FeKCfLDtb9jPUgMYcgcv/9UQ4XDvwWHJy69AdhTtAVSIKgQd9YA==
X-Received: by 2002:a17:90a:8c0f:: with SMTP id a15mr2538254pjo.25.1638838326361;
        Mon, 06 Dec 2021 16:52:06 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:518c:39bf:c3e8:ffe2])
        by smtp.gmail.com with ESMTPSA id l13sm14239618pfu.149.2021.12.06.16.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 16:52:06 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 10/17] SUNRPC: add netns refcount tracker to struct gss_auth
Date:   Mon,  6 Dec 2021 16:51:35 -0800
Message-Id: <20211207005142.1688204-11-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211207005142.1688204-1-eric.dumazet@gmail.com>
References: <20211207005142.1688204-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sunrpc/auth_gss/auth_gss.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 5f42aa5fc612850b526c160ab5e5c75416862676..8eb7e8544815a8bc20a79b21b01e3ba110fc6b47 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -72,7 +72,8 @@ struct gss_auth {
 	struct gss_api_mech *mech;
 	enum rpc_gss_svc service;
 	struct rpc_clnt *client;
-	struct net *net;
+	struct net	*net;
+	netns_tracker	ns_tracker;
 	/*
 	 * There are two upcall pipes; dentry[1], named "gssd", is used
 	 * for the new text-based upcall; dentry[0] is named after the
@@ -1013,7 +1014,8 @@ gss_create_new(const struct rpc_auth_create_args *args, struct rpc_clnt *clnt)
 			goto err_free;
 	}
 	gss_auth->client = clnt;
-	gss_auth->net = get_net(rpc_net_ns(clnt));
+	gss_auth->net = get_net_track(rpc_net_ns(clnt), &gss_auth->ns_tracker,
+				      GFP_KERNEL);
 	err = -EINVAL;
 	gss_auth->mech = gss_mech_get_by_pseudoflavor(flavor);
 	if (!gss_auth->mech)
@@ -1068,7 +1070,7 @@ gss_create_new(const struct rpc_auth_create_args *args, struct rpc_clnt *clnt)
 err_put_mech:
 	gss_mech_put(gss_auth->mech);
 err_put_net:
-	put_net(gss_auth->net);
+	put_net_track(gss_auth->net, &gss_auth->ns_tracker);
 err_free:
 	kfree(gss_auth->target_name);
 	kfree(gss_auth);
@@ -1084,7 +1086,7 @@ gss_free(struct gss_auth *gss_auth)
 	gss_pipe_free(gss_auth->gss_pipe[0]);
 	gss_pipe_free(gss_auth->gss_pipe[1]);
 	gss_mech_put(gss_auth->mech);
-	put_net(gss_auth->net);
+	put_net_track(gss_auth->net, &gss_auth->ns_tracker);
 	kfree(gss_auth->target_name);
 
 	kfree(gss_auth);
-- 
2.34.1.400.ga245620fadb-goog

