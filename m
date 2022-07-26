Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE1B581270
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiGZL5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbiGZL5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:57:47 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4C223150
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:57:46 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id lp8-20020a056214590800b004744f4ad562so3076468qvb.2
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 04:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=HT9F7rr0NiVYksLQfowJ8+RtuFOKIsOoFuKR9JkgtVY=;
        b=QtEeew02/Anj7rIbxK3gxlV2PkN8JncqWaMYP4Bc5vw+srAMB8ZdxnKRdVN0WG0LqP
         onijB+tEUfXt3q+gqeIbzo+dzicENe3W0ufD6rNDhcuSo31XWhTXi2kLQ6gLjmmTFbV7
         xYb9BvYTdwnaM6/YbBS/11rNyX1aKBX/LRnz5wrKVu74m3cJoDuDg4f+EkGE2Uco2Qvd
         cNav36xSxjrCUMl9p5YMwemXY0Eca7eWdPnvTUc00fsYLFtSpmNqDwRXCp+QYnjbz++Y
         CoGQsFyK1U/d9Rxa8wdNLJFZNepR5sopwitKXKmO0sVMvdsgf9lQWkwsQFUUzMdmELo1
         OHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=HT9F7rr0NiVYksLQfowJ8+RtuFOKIsOoFuKR9JkgtVY=;
        b=koZK+74cCWRc4Nii7MLnNe0eIC4TgAaFtBRLpnuX1o7LOpjxBHcriis1vHNpxrrnQA
         +9fn8GTFMWCgioXRD7XEjcmh7sZs3vx4Mi7aR8elXVIRMNjIRZGx/+80SVBuSYG+gYoH
         LQ2tRAPbt2tXxlfusIhbU6ZFk3P4YLBI6D36CuzqIAjFnJiPROL45l8d6+rRWAwXsGOS
         Lt3tlYlUVWU7nYrM+2ey2ww/ITPx9+6p1smfXrC3gGEvb7I70ILA3sDfm7Ro3qA/Ms6Q
         L54KwASKmUISbcI4Qnh16GEaj37SfbtztXjJd1aPo3wzAhvTg2qTnvK2WklN6I+fd0gH
         i4ug==
X-Gm-Message-State: AJIora9DMRaa40OQjsFz19PQZ8MXGPpPhIoUR2d5ibl+gXXdl0kh8GoT
        AFDrnWTy05q5XBC1vMOT14ZoYD7Xn1gPOg==
X-Google-Smtp-Source: AGRyM1uyu4sAMcC+fHhCwqL/YFpkR1ZYx5g8B5rv8PMnE9IqqvIi/26c3OtvDcxdHS4AE000CUiEo6docmuC+Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:622a:49:b0:31f:27b7:ff54 with SMTP id
 y9-20020a05622a004900b0031f27b7ff54mr13775619qtw.602.1658836665606; Tue, 26
 Jul 2022 04:57:45 -0700 (PDT)
Date:   Tue, 26 Jul 2022 11:57:43 +0000
Message-Id: <20220726115743.2759832-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH net] tcp: md5: fix IPv4-mapped support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv@google.com>,
        Dmitry Safonov <dima@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>
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

After the blamed commit, IPv4 SYN packets handled
by a dual stack IPv6 socket are dropped, even if
perfectly valid.

$ nstat | grep MD5
TcpExtTCPMD5Failure             5                  0.0

For a dual stack listener, an incoming IPv4 SYN packet
would call tcp_inbound_md5_hash() with @family == AF_INET,
while tp->af_specific is pointing to tcp_sock_ipv6_specific.

Only later when an IPv4-mapped child is created, tp->af_specific
is changed to tcp_sock_ipv6_mapped_specific.

Fixes: 7bbb765b7349 ("net/tcp: Merge TCP-MD5 inbound callbacks")
Reported-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 002a4a04efbe076ba603d7d42eb85e60d9bf4fb8..766881775abb795c884d048d51c361e805b91989 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4459,9 +4459,18 @@ tcp_inbound_md5_hash(const struct sock *sk, const struct sk_buff *skb,
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
-	/* check the signature */
-	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
-						 NULL, skb);
+	/* Check the signature.
+	 * To support dual stack listeners, we need to handle
+	 * IPv4-mapped case.
+	 */
+	if (family == AF_INET)
+		genhash = tcp_v4_md5_hash_skb(newhash,
+					      hash_expected,
+					      NULL, skb);
+	else
+		genhash = tp->af_specific->calc_md5_hash(newhash,
+							 hash_expected,
+							 NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
-- 
2.37.1.359.gd136c6c3e2-goog

