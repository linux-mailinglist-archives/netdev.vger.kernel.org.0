Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8706164EAF
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgBSTQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:16:37 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33965 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgBSTQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:16:36 -0500
Received: by mail-qk1-f194.google.com with SMTP id c20so1238247qkm.1
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 11:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sIdRZRfay7jn8F6xqcNkG9CZ0/N+ORtvVDzRAWd+pH8=;
        b=FoA0rKoGOO84qucpYWOH7yodoWGi7hUck50OKrSOar5ny+ZBtj4f9VbYOF2cNU86+V
         AWp28tomzDiqsDkp/unT+c5n7HsBG1aQAHWV+IGls8KsweRqYBnQ3eUXruB9NuTaK/4W
         hp1RXLL+J5s2UHCy1VefgaDXFh03bZ1MJGUHCYY9i1YVjp3OREgJ1vFciPlT5XYm3df3
         XRIVJfsvuN/p2MVLaecdSemJzhft1tQcW4+R8O9bdIEdI7I8UQkKHEz62yhInSBYOcDO
         MUKwUhfMrQ1arNeb8BbLwHuTJ7BhhRsKzr8xOU+4HrX8xNTGv4lm8qpyyzjo67qR8ooZ
         e1lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sIdRZRfay7jn8F6xqcNkG9CZ0/N+ORtvVDzRAWd+pH8=;
        b=tgJerxUjMUoR45+v3hu4u+GVinmhBYK7sHWanzM7pZ0luZi+CVwGxL+7vro+Xl1y3J
         wfj1YtbbKBF0KX/Kyszm2VVM2BGV1AOHDntuYNMjRygMUk0d0S52UdiuDvTe0hqbuPNH
         V1TEmzDG7Ybaj5psHSTQzBSGlVplRyCsZmCD/sShz5OFV1AWNQg+DLYhxo1NYmwos4pI
         1kSMZMVp5RYBspBXpFLJxkr6h6oiGOXUAvgAlAmoM9NAQJovyk1CPVXLx1MJE7UPuRkH
         peJEOfZyqDu7YS0TqE0ypWQqhhCNcGVKyMwjYgjgbPT32uQyXVr49JTw/FLw/ujwJhE4
         UZ0g==
X-Gm-Message-State: APjAAAVVJnQJyeNYk59IxnwPvX9NtwXRaYzbb8kzQji16cq4RTIlAqFF
        5160xT8JVKXT+ZN9Fn7WqxFOqBTU
X-Google-Smtp-Source: APXvYqzqBXZibCiyvOOg43BJZDHwl+Efv/aDLnussiqtaQBPlXrYXC5bvITL6ubC1cBG3NxgRWNGTg==
X-Received: by 2002:a37:717:: with SMTP id 23mr21481480qkh.34.1582139795132;
        Wed, 19 Feb 2020 11:16:35 -0800 (PST)
Received: from willemb.nyc.corp.google.com ([2620:0:1003:312:6084:feee:4efa:5ea9])
        by smtp.gmail.com with ESMTPSA id e130sm324500qkb.72.2020.02.19.11.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 11:16:34 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, plroskin@gmail.com, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] udp: rehash on disconnect
Date:   Wed, 19 Feb 2020 14:16:32 -0500
Message-Id: <20200219191632.253526-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

As of the below commit, udp sockets bound to a specific address can
coexist with one bound to the any addr for the same port.

The commit also phased out the use of socket hashing based only on
port (hslot), in favor of always hashing on {addr, port} (hslot2).

The change broke the following behavior with disconnect (AF_UNSPEC):

    server binds to 0.0.0.0:1337
    server connects to 127.0.0.1:80
    server disconnects
    client connects to 127.0.0.1:1337
    client sends "hello"
    server reads "hello"	// times out, packet did not find sk

On connect the server acquires a specific source addr suitable for
routing to its destination. On disconnect it reverts to the any addr.

The connect call triggers a rehash to a different hslot2. On
disconnect, add the same to return to the original hslot2.

Skip this step if the socket is going to be unhashed completely.

Fixes: 4cdeeee9252a ("net: udp: prefer listeners bound to an address")
Reported-by: Pavel Roskin <plroskin@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 net/ipv4/udp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index db76b96092991..08a41f1e1cd22 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1857,8 +1857,12 @@ int __udp_disconnect(struct sock *sk, int flags)
 	inet->inet_dport = 0;
 	sock_rps_reset_rxhash(sk);
 	sk->sk_bound_dev_if = 0;
-	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK))
+	if (!(sk->sk_userlocks & SOCK_BINDADDR_LOCK)) {
 		inet_reset_saddr(sk);
+		if (sk->sk_prot->rehash &&
+		    (sk->sk_userlocks & SOCK_BINDPORT_LOCK))
+			sk->sk_prot->rehash(sk);
+	}
 
 	if (!(sk->sk_userlocks & SOCK_BINDPORT_LOCK)) {
 		sk->sk_prot->unhash(sk);
-- 
2.25.0.265.gbab2e86ba0-goog

