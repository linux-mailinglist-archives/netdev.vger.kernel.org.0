Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358323B58B2
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhF1FsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:48:01 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:40914 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbhF1Fr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 01:47:56 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id B74B0800056;
        Mon, 28 Jun 2021 07:45:29 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 07:45:29 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 07:45:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 739843180307; Mon, 28 Jun 2021 07:45:28 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 03/17] net: Remove unnecessary variables
Date:   Mon, 28 Jun 2021 07:45:08 +0200
Message-ID: <20210628054522.1718786-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628054522.1718786-1-steffen.klassert@secunet.com>
References: <20210628054522.1718786-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

It is not necessary to define variables to receive -ENOMEM,
directly return -ENOMEM.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/key/af_key.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index ef9b4ac03e7b..de24a7d474df 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -141,7 +141,6 @@ static int pfkey_create(struct net *net, struct socket *sock, int protocol,
 	struct netns_pfkey *net_pfkey = net_generic(net, pfkey_net_id);
 	struct sock *sk;
 	struct pfkey_sock *pfk;
-	int err;
 
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
@@ -150,10 +149,9 @@ static int pfkey_create(struct net *net, struct socket *sock, int protocol,
 	if (protocol != PF_KEY_V2)
 		return -EPROTONOSUPPORT;
 
-	err = -ENOMEM;
 	sk = sk_alloc(net, PF_KEY, GFP_KERNEL, &key_proto, kern);
 	if (sk == NULL)
-		goto out;
+		return -ENOMEM;
 
 	pfk = pfkey_sk(sk);
 	mutex_init(&pfk->dump_lock);
@@ -169,8 +167,6 @@ static int pfkey_create(struct net *net, struct socket *sock, int protocol,
 	pfkey_insert(sk);
 
 	return 0;
-out:
-	return err;
 }
 
 static int pfkey_release(struct socket *sock)
-- 
2.25.1

