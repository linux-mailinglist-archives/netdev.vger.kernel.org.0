Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B263804BD
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhENH5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:57:16 -0400
Received: from m12-13.163.com ([220.181.12.13]:47603 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232903AbhENH5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 03:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=CBLat
        +ZXhC8qxPjdaARxRUWnTKRDHA0cZBqWH1oRFFc=; b=B9gQs9L4XDbWA7T2k8nJh
        839Z+b6dLSsv60RZR1sH50Oi1HFi6ZCO2QeXZ0ALy6S5FNNbScpq7bnDKGXQF5r2
        nnch87v/e/JlQ0pA+hbVQglLcwy6qjcPj2NAoAmjCutT5yUwHHoPoef1B4hTwa+j
        40zAEIPKWst0nxLe1ilALo=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp9 (Coremail) with SMTP id DcCowAB3mffjLJ5gGvMlAg--.37879S2;
        Fri, 14 May 2021 15:55:19 +0800 (CST)
From:   zuoqilin1@163.com
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] net: Remove unnecessary variables
Date:   Fri, 14 May 2021 15:55:13 +0800
Message-Id: <20210514075513.1801-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowAB3mffjLJ5gGvMlAg--.37879S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7GF1fGrWrur4UJryfXFykGrg_yoW8Jr4xpF
        4UGryDu3yUtrWaga1rJF4Du34Syw18GrsFk34rXwn3Zw1vgw1rta48trWj9FnY9rW8C3Wf
        JFWqgr4v9F4jkrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j5cTQUUUUU=
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/1tbiHgeSiVSIug-K0gAAsz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

It is not necessary to define variables to receive -ENOMEM,
directly return -ENOMEM.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 net/key/af_key.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index ef9b4ac..de24a7d 100644
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
1.9.1


