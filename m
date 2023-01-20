Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2B675521
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjATNAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjATNAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:00:02 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179849AA94
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:00:01 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id z17-20020a256651000000b007907852ca4dso5639618ybm.16
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rBCYpAfdbx9Jh38Ngl7/ITORvHxhv02w/j9M1uMQxzk=;
        b=cznIUcPI5gztHE9GQvlGmeSh8Wb+l37MegPnO05hPB8pHqsReGg18s0jSgN7wFddjJ
         q7IgPhVIUf90+tEtS4sB/ZnTg7XUzx3iHrdEBSuUd0weFtwc+YlHE2vJquRBgz/io6K4
         4Vt2JVqPgSn0e4aSv9GwvLRpFptCgw8qocH/a+heOAmlmm4hfaox1OevO6U/UB7FrO1D
         /VtwYGCoSgMaxVf6TKysIPF0rYQdCOlmDuyY7HVz/0YAyEvSkHjeVMk7FkGyTrus3gJ7
         6EtDkGvkxYs//0oEoR2VLvl64JrD/WNUpC43sKDvdSiq6JDo1NhI/7hTarMcNujgEWnP
         UWFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rBCYpAfdbx9Jh38Ngl7/ITORvHxhv02w/j9M1uMQxzk=;
        b=s4kvLO4xK6qkjwsxJ3+rIDsNo7Dc/QArUcu/0hCOURb8jRtYB4rBxlS9SzMHI+Qx+v
         Su9Gg+zK7xDIB8CTx7G+D06+ZPwd6p6wrZSg67CHu7XVs2y2ERVOfXhJ27ljCWOI42pA
         nHhCX0aM3WXWZq8mIf7QJNrCJ++BxryHPx3As+GMLzifCkOfS5ps5c6FmhU/qgl3cI3/
         8XqWZDNm6mnmpArgfGojOow+2ZEyi2WaRk2JSQwlnH4mcbkDOzrv9fJPr3yVs1Kl2LY8
         6NRHCi+PqFVnRwvdFH8TvdS32Sl3odicNlhHHxPkYHUBLXvJi+3JLixnJKSf0oLrYz5j
         7PlA==
X-Gm-Message-State: AFqh2kpidTuCIFHI7rjkH57nI+Y3Md6Eu2vurTdN17mvMKmfXSEMCV8y
        YCf78JL3gu/JdgOazaHBLLX8sMXuyLbr5w==
X-Google-Smtp-Source: AMrXdXvBRW8qRZGcXviLh3O1M32qXwmiFZoyPHO7HrA+N62OayfUzuTmrAguzwu4kK8lWs92eS19piblsAoeWQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:300a:0:b0:7e9:643f:155a with SMTP id
 w10-20020a25300a000000b007e9643f155amr1247336ybw.607.1674219600279; Fri, 20
 Jan 2023 05:00:00 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:59:54 +0000
In-Reply-To: <20230120125955.3453768-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230120125955.3453768-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120125955.3453768-3-edumazet@google.com>
Subject: [PATCH net 2/3] netlink: annotate data races around dst_portid and dst_group
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

netlink_getname(), netlink_sendmsg() and netlink_getsockbyportid()
can read nlk->dst_portid and nlk->dst_group while another
thread is changing them.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netlink/af_netlink.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 4aea89f7d700a587c4e9017cdff76cd3fe93ed7a..b5b8c6a5fc34205c849ab2ca105cc44ffb407623 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1099,8 +1099,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	if (addr->sa_family == AF_UNSPEC) {
 		sk->sk_state	= NETLINK_UNCONNECTED;
-		nlk->dst_portid	= 0;
-		nlk->dst_group  = 0;
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, 0);
+		WRITE_ONCE(nlk->dst_group, 0);
 		return 0;
 	}
 	if (addr->sa_family != AF_NETLINK)
@@ -1122,8 +1123,9 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 
 	if (err == 0) {
 		sk->sk_state	= NETLINK_CONNECTED;
-		nlk->dst_portid = nladdr->nl_pid;
-		nlk->dst_group  = ffs(nladdr->nl_groups);
+		/* dst_portid and dst_group can be read locklessly */
+		WRITE_ONCE(nlk->dst_portid, nladdr->nl_pid);
+		WRITE_ONCE(nlk->dst_group, ffs(nladdr->nl_groups));
 	}
 
 	return err;
@@ -1140,8 +1142,9 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 	nladdr->nl_pad = 0;
 
 	if (peer) {
-		nladdr->nl_pid = nlk->dst_portid;
-		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		nladdr->nl_pid = READ_ONCE(nlk->dst_portid);
+		nladdr->nl_groups = netlink_group_mask(READ_ONCE(nlk->dst_group));
 	} else {
 		/* Paired with WRITE_ONCE() in netlink_insert() */
 		nladdr->nl_pid = READ_ONCE(nlk->portid);
@@ -1171,8 +1174,9 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
 	/* Don't bother queuing skb if kernel socket has no input function */
 	nlk = nlk_sk(sock);
+	/* dst_portid can be changed in netlink_connect() */
 	if (sock->sk_state == NETLINK_CONNECTED &&
-	    nlk->dst_portid != nlk_sk(ssk)->portid) {
+	    READ_ONCE(nlk->dst_portid) != nlk_sk(ssk)->portid) {
 		sock_put(sock);
 		return ERR_PTR(-ECONNREFUSED);
 	}
@@ -1889,8 +1893,9 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			goto out;
 		netlink_skb_flags |= NETLINK_SKB_DST;
 	} else {
-		dst_portid = nlk->dst_portid;
-		dst_group = nlk->dst_group;
+		/* Paired with WRITE_ONCE() in netlink_connect() */
+		dst_portid = READ_ONCE(nlk->dst_portid);
+		dst_group = READ_ONCE(nlk->dst_group);
 	}
 
 	/* Paired with WRITE_ONCE() in netlink_insert() */
-- 
2.39.1.405.gd4c25cc71f-goog

