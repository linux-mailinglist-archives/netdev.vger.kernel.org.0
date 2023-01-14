Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3ED66ADFE
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 21:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjANU7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 15:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjANU7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 15:59:14 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264A27EFF;
        Sat, 14 Jan 2023 12:59:13 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 1A7D4419E9F2;
        Sat, 14 Jan 2023 20:59:11 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 1A7D4419E9F2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1673729951;
        bh=hVgFEbttc6O8/g5okwEBjsKPQRLGn8nsRQ3DxCuxhlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BcyF5+C3x7xIhQoNgim15t22u7NHTpDrlcgcg+HrA7CtXHvFJjv4TyLlo/0PYNR1/
         iqEr+bBGZ3A7Q+thxIAdeUXn4f59964Kn9EGjcYLdSTv7uYapTz9/KoOgGDfpJdHbR
         VoMb+iRZwXadlGKfO8lHmHulEGAa3ClpU4nO3gPM=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com
Subject: [PATCH 5.10 1/1] xfrm: fix rcu lock in xfrm_notify_userpolicy()
Date:   Sat, 14 Jan 2023 23:58:49 +0300
Message-Id: <20230114205850.176370-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230114205850.176370-1-pchelkin@ispras.ru>
References: <20230114205850.176370-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit 93ec1320b0170d7a207eda2d119c669b673401ed upstream.

As stated in the comment above xfrm_nlmsg_multicast(), rcu read lock must
be held before calling this function.

Reported-by: syzbot+3d9866419b4aa8f985d6@syzkaller.appspotmail.com
Fixes: 9856c3a129dd ("xfrm: notify default policy on update")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/xfrm/xfrm_user.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d9841f44487f..b5a517916895 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1920,6 +1920,7 @@ static int xfrm_notify_userpolicy(struct net *net)
 	int len = NLMSG_ALIGN(sizeof(*up));
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
+	int err;
 
 	skb = nlmsg_new(len, GFP_ATOMIC);
 	if (skb == NULL)
@@ -1938,7 +1939,10 @@ static int xfrm_notify_userpolicy(struct net *net)
 
 	nlmsg_end(skb, nlh);
 
-	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_lock();
+	err = xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_POLICY);
+	rcu_read_unlock();
+	return err;
 }
 
 static bool xfrm_userpolicy_is_valid(__u8 policy)
-- 
2.34.1

