Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64CE049EC45
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 21:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343850AbiA0UJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 15:09:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240073AbiA0UJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 15:09:47 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A3EC061714;
        Thu, 27 Jan 2022 12:09:47 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i186so1356346pfe.0;
        Thu, 27 Jan 2022 12:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/qrkGMnIvAK9NC9pELAwNsO56PYT1J3Scvu6zLU6DAQ=;
        b=htYtGfMS6PvXV7MRAPe7nd0bUYu9h+QHungGiCM0+Q62e9sDaWAlTTouXh/PMthAcr
         Gsz3dlC11SEzm/swcOVp7naJhMbPJVB2ghJf9aL4Pf1Ry3nCxwGzO/DgR8EWaQcf0IZg
         98uMJT8Ck//6rroBUyPYGjUAokob7P09pJPCxfqwfwgfCZzkv0mjUUB0UVTRIg/7iqkY
         SE//c/DmSLzASb3OqL6V4+piJGlrtCaxy1lKwEZqj0IQ80adUrkHAEOZqZlnZIixFz9Y
         glMI4NRpFOXXVwGJBGMNoKrB4JWhONgLG1A3tKNwp+n6ccWpwwssJMUlHZllpt/MEyV6
         z7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/qrkGMnIvAK9NC9pELAwNsO56PYT1J3Scvu6zLU6DAQ=;
        b=G8cpqI6HBnVzJvbNO3WCVs5c0upOixufi7AO31WSFm8kh8onYoYvPQiFaul+z0Wpib
         vAxoIl+01bmwGQuAu5Tvy+/XKBYqVqPGd30i6zgBh3E9KGClSuBqprXHxOXGSibesZ+g
         DJ8UI+pr+QGJi/LeD7MfioJ2JblisKrGLryaXJaUwmhruT/16CEveB0nqgQrqPnGv6kE
         9YtDEC8ufwhk3NthwWni905P+mYrogH9+tv4ycIDd5UmbZ2FAM6ZpxOfm0KZ2OEY2AFF
         cjV0Eu62e5U0TKrNe2mUD493bei1PpAD1uVkIFBIc+sokKlAWVUUOyA8RYfTU3+X1LeP
         1U6g==
X-Gm-Message-State: AOAM531XTPlqHhs7FxpD1E5ZK/BkwIEF0uO/uBjx3aKC4mNBa2vfTZzp
        n5jjtDGliAT/4Am0GaCgh48=
X-Google-Smtp-Source: ABdhPJz8/tNNG5S9NwkbTWGX2C935svId5l5FkW7M40mATr/cqPLvYg4bPcvjQaOv3nO6h13SO0bZw==
X-Received: by 2002:a63:b90f:: with SMTP id z15mr3993038pge.73.1643314187259;
        Thu, 27 Jan 2022 12:09:47 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:ab5e:9016:8c9e:ba75])
        by smtp.gmail.com with ESMTPSA id y42sm5697892pfw.157.2022.01.27.12.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 12:09:46 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        linux-nfs <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/3] SUNRPC: add netns refcount tracker to struct gss_auth
Date:   Thu, 27 Jan 2022 12:09:36 -0800
Message-Id: <20220127200937.2157402-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
In-Reply-To: <20220127200937.2157402-1-eric.dumazet@gmail.com>
References: <20220127200937.2157402-1-eric.dumazet@gmail.com>
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
2.35.0.rc0.227.g00780c9af4-goog

