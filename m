Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2010A675522
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjATNAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjATNAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:00:05 -0500
Received: from mail-vs1-xe49.google.com (mail-vs1-xe49.google.com [IPv6:2607:f8b0:4864:20::e49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71E3BF8BE
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:00:02 -0800 (PST)
Received: by mail-vs1-xe49.google.com with SMTP id u62-20020a676041000000b003c36eda854fso1506902vsb.22
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BiRcRi0wUXlcdsz+D9nC3qTODiVSw09z9B9duy2CBOk=;
        b=g1ZcGgS7/D/rgsHr9WYNUBeA8sIcd7VtW12KZiWVAOy/WcvoxXn/KSD+Me0G8Dn7Oy
         kp6IoxtpjUQrOECLjOmNFIORcMD4I0Bhw0uzArrnITPiTNUGu51mkSOImOc5X80R53Ue
         KXYXgtYQ9yHSat2P16z1xyAM4shO27JCYbyyb92vrlTJbJSkSFi4Ktcjqmy9lecIlZ4c
         IyvriCWRr2ufPSJEeapA3yEnGhgY7oCmO2QjUAqxMjEsAw2lIc/+s1WxNbPfxfNXvoB0
         KoIqprEW2wKPWxasgEyGFqPDeM3tLBAx0aCEN7s3n7UGMJqetwNn4OWNYl6LJ/4Jt8O+
         tTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BiRcRi0wUXlcdsz+D9nC3qTODiVSw09z9B9duy2CBOk=;
        b=nKO388INVMcPyD2Idgw9Cv8vxrsDrNWxXZwBResUOSBaxxy+uBd+8XW5OVGNlRjCIG
         td8Gw71l9v9I68i5lormf8BVDccI3KUHWQ/4qYGEWJ/bGz+MIB4xTHRsdfc68IDR4o2o
         e6MvGTKm4shBNfcr4XG7t0YLhAF2MDyFEd+2YP5cNn/MS8alsB/d/9qq2uHC/9CeQutj
         9m1j7CimaVgutAlGg795YLCLgess6IyagqMbFrb/1Tymq8WNyYzdOMC7fNOWS8FNMrzn
         jtAWlc+OREVhqbSldh97lp3plhKD48C/mjyk+/fz8I3sE6fyq1KTJmiTqXjmvLeZwFpt
         0ecA==
X-Gm-Message-State: AFqh2kqb1TZPLvaL10SmW34dIScpVIl9oHm58015LsLSFunFojyUJMyS
        kgm8PS2N4/T1SB0/PUez7po2dgKml3scaQ==
X-Google-Smtp-Source: AMrXdXvzV91Ux4NRBJmoPyPPz42ELs3WlNxZ5Np3XVUcET5hoEid6KuSDinE91eh+unPIqJtnFM1qriWihfyxw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ab0:2250:0:b0:418:f8f7:d9d7 with SMTP id
 z16-20020ab02250000000b00418f8f7d9d7mr1733431uan.116.1674219601788; Fri, 20
 Jan 2023 05:00:01 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:59:55 +0000
In-Reply-To: <20230120125955.3453768-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230120125955.3453768-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120125955.3453768-4-edumazet@google.com>
Subject: [PATCH net 3/3] netlink: annotate data races around sk_state
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

netlink_getsockbyportid() reads sk_state while a concurrent
netlink_connect() can change its value.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netlink/af_netlink.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b5b8c6a5fc34205c849ab2ca105cc44ffb407623..c6427765975318b4c7fe3d5291dc4d69988f5249 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1098,7 +1098,8 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		return -EINVAL;
 
 	if (addr->sa_family == AF_UNSPEC) {
-		sk->sk_state	= NETLINK_UNCONNECTED;
+		/* paired with READ_ONCE() in netlink_getsockbyportid() */
+		WRITE_ONCE(sk->sk_state, NETLINK_UNCONNECTED);
 		/* dst_portid and dst_group can be read locklessly */
 		WRITE_ONCE(nlk->dst_portid, 0);
 		WRITE_ONCE(nlk->dst_group, 0);
@@ -1122,7 +1123,8 @@ static int netlink_connect(struct socket *sock, struct sockaddr *addr,
 		err = netlink_autobind(sock);
 
 	if (err == 0) {
-		sk->sk_state	= NETLINK_CONNECTED;
+		/* paired with READ_ONCE() in netlink_getsockbyportid() */
+		WRITE_ONCE(sk->sk_state, NETLINK_CONNECTED);
 		/* dst_portid and dst_group can be read locklessly */
 		WRITE_ONCE(nlk->dst_portid, nladdr->nl_pid);
 		WRITE_ONCE(nlk->dst_group, ffs(nladdr->nl_groups));
@@ -1174,8 +1176,8 @@ static struct sock *netlink_getsockbyportid(struct sock *ssk, u32 portid)
 
 	/* Don't bother queuing skb if kernel socket has no input function */
 	nlk = nlk_sk(sock);
-	/* dst_portid can be changed in netlink_connect() */
-	if (sock->sk_state == NETLINK_CONNECTED &&
+	/* dst_portid and sk_state can be changed in netlink_connect() */
+	if (READ_ONCE(sock->sk_state) == NETLINK_CONNECTED &&
 	    READ_ONCE(nlk->dst_portid) != nlk_sk(ssk)->portid) {
 		sock_put(sock);
 		return ERR_PTR(-ECONNREFUSED);
-- 
2.39.1.405.gd4c25cc71f-goog

