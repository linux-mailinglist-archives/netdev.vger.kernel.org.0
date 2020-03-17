Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7CD188989
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 16:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCQPzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 11:55:44 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55541 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCQPzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 11:55:44 -0400
Received: by mail-pj1-f65.google.com with SMTP id mj6so10173736pjb.5;
        Tue, 17 Mar 2020 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=rIOYXa4n3W4fvDIFexK8Xd1iAbQHd2/NWX4UF2y8JPU=;
        b=irfrBskVIzOYnt/8r4tZQkRb68wX1xdH3cibG7ArPih3W4C8DDXVzgNH550GQ96uAr
         jqoYAlgRrigTEqn3/aSlfNxHsiqOPz8uSpuxx032eJ1yTZFg7zVtabnFhEjkdfuXwHQC
         ZptWEZfY/eBxexy70Z6S05vR1GuZjwB8UEArvF4djW+XTlobg7LpVrFmKkUJ5IAuD9w4
         ShHyFljj8mHxonbV1k6VGzmLVXAQVDsiD3Fv5iYzEM0Cp6vv1kPRKTZQ+q+ejfWOhSL3
         l6ZOb71iiAsJcf3s/dNYOvvI/VIngpu4fwhYmDyFnaZorpKvJ5cNbswj6fBnOkCZh8CM
         NyFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=rIOYXa4n3W4fvDIFexK8Xd1iAbQHd2/NWX4UF2y8JPU=;
        b=kzf0S5W4ROoCDhdY7wzm8EHP5t0ArTNqeqou1uVvNVr/LAfD8jEnD9vX84rNHyY9Ed
         MN9Ba83VDW3FqgNf03+Hj77YKLvQbAs5V3mYQIkYQl6qd64gN3kqEutHEeE9mNtdQiLD
         x1Bde86f8brDkn27UPfxoJQskK6hQrlI+Pedy/SJH7iqW6Vlv/tRxP2UMMgHScGuPile
         wTP5tU0f/AJPAW7nsorPWJfsLvt5ygZ2sNm/hamD7cHsSl0PzESxJOKmUfREHuXuqch2
         /gTIWVHBVcB6lqWHsFmHs/25TJhszxEg8hPbOq6VciyuxnMW74aTKwu7m8be50clQXrI
         ygSw==
X-Gm-Message-State: ANhLgQ18q5Mwu8Bm105BZuGWJ1AcQBDku7XdXDn7nkRipi3DvKtGoFfG
        UkczOs8dvp3lqyMel87dDPQ=
X-Google-Smtp-Source: ADFU+vsXJcKIHwYeeKLVHimqaIiwGZKzfpf0o1uTLHXjAzQQxGHWA+wfsYGrjvu6bZ6GZ6w3hOSWCg==
X-Received: by 2002:a17:902:d712:: with SMTP id w18mr5146760ply.238.1584460542597;
        Tue, 17 Mar 2020 08:55:42 -0700 (PDT)
Received: from localhost ([161.117.239.120])
        by smtp.gmail.com with ESMTPSA id s19sm3665027pfh.218.2020.03.17.08.55.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Mar 2020 08:55:41 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     marcelo.leitner@gmail.com, davem@davemloft.net
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anenbupt@gmail.com,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH v2] sctp: fix refcount bug in sctp_wfree
Date:   Tue, 17 Mar 2020 23:55:36 +0800
Message-Id: <20200317155536.10227-1-hqjagain@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do accounting for skb's real sk.
In some case skb->sk != asoc->base.sk:

migrate routing        sctp_check_transmitted routing
------------                    ---------------
lock_sock_nested();
                               mv the transmitted skb to
                               the it's local tlist

sctp_for_each_tx_datachunk(
sctp_clear_owner_w);
sctp_assoc_migrate();
sctp_for_each_tx_datachunk(
sctp_set_owner_w);

                               put the skb back to the
                               assoc lists
----------------------------------------------------

The skbs which held bysctp_check_transmitted were not changed
to newsk. They were not dealt with by sctp_for_each_tx_datachunk
(sctp_clear_owner_w/sctp_set_owner_w).

It looks only trouble here so handling it in sctp_wfree is enough.

Reported-and-tested-by: syzbot+cea71eec5d6de256d54d@syzkaller.appspotmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 net/sctp/socket.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 1b56fc440606..5f5c28b30e25 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9080,7 +9080,7 @@ static void sctp_wfree(struct sk_buff *skb)
 {
 	struct sctp_chunk *chunk = skb_shinfo(skb)->destructor_arg;
 	struct sctp_association *asoc = chunk->asoc;
-	struct sock *sk = asoc->base.sk;
+	struct sock *sk = skb->sk;
 
 	sk_mem_uncharge(sk, skb->truesize);
 	sk->sk_wmem_queued -= skb->truesize + sizeof(struct sctp_chunk);
@@ -9109,7 +9109,7 @@ static void sctp_wfree(struct sk_buff *skb)
 	}
 
 	sock_wfree(skb);
-	sctp_wake_up_waiters(sk, asoc);
+	sctp_wake_up_waiters(asoc->base.sk, asoc);
 
 	sctp_association_put(asoc);
 }
-- 
2.17.1

