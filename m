Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 112C288788
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 03:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfHJBgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 21:36:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33108 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbfHJBgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 21:36:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id r6so73173903qkc.0
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 18:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CFbHgjAPTaCA8MRNdseWob4LTLvhtIrIklCcJcw/pk8=;
        b=EY5A0zyA4vXk3piWdL1z0Uge4aswOdzItK08lD0eUzgoKaSR2nOO81W63JH14WDp7d
         1d0h+sC2g2jSNIJCjzRaA0vBqNgLgwpZfMH9ZM/RxFqDcXm/eNYFu3dtAULK+0YC7arU
         0pVEoK+FFnNr2s3DNBhQ7rhtMt9V/UpJl3Vt8fuogMELvf7ImqAvcwKWohXOUeBD2aBU
         tzxrLbGoxVHHjKJSLNS5ytWn/6AatZnKn5wWa+fywR5AKV0Cp/a31yS/8i1F3glulV1n
         z1DfkX2UlIPGNRAA/HM6PQiIXptOovTNLXw7JYkidEHz8CbWpnllnWqSnldfhAcMjla6
         GNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CFbHgjAPTaCA8MRNdseWob4LTLvhtIrIklCcJcw/pk8=;
        b=oOFz6pIkX2I3+AbY6C8jCcA5za4lyci7bjkgzzAYoCzgOi6zHEsua77nEbujTy5xpj
         XebsQx8Zj6G1fG+h8+MpH2evX7V+x5F5+qyE+LjngXRGT6TF/72d8dEGvfas2M9CkYY+
         bhFtylvOyVFAn5IMCTijBH8FUUeqRbPPERgwqFRnTAWLSeg8k8GXCvKrfYGZCgoLO/Hv
         Tdx7tvS0qWZ9THpELKMQiJOGus1/B3H5Am+BRwP4gKI5iAHSULWuU8Pz1VpoZAQ4O+wJ
         qHzokHTDDvoQnNlax1pEgSZf+pAC5w7O6WoSZwnuXnPrqIqv1S8VNQUErDOvOGL3Xhxz
         6bcQ==
X-Gm-Message-State: APjAAAW/txyui00hFGvvyTjNXLXGYgWiv6cmBG42oilmQbBvHdPqD6sL
        ka39AC+Dn8rrcKOM6kfSnCRaXw==
X-Google-Smtp-Source: APXvYqxa6vm3z6YZ/6Y7MVpa3qi9nc7Ok/s4tTJm3GedgYtvtMXc3u/dRbjVnUqP8u9o+jIlazE1FA==
X-Received: by 2002:a37:9a4a:: with SMTP id c71mr21400038qke.258.1565401012457;
        Fri, 09 Aug 2019 18:36:52 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d9sm2812685qko.20.2019.08.09.18.36.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 18:36:51 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com, davejwatson@fb.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
Subject: [PATCH net] net/tls: swap sk_write_space on close
Date:   Fri,  9 Aug 2019 18:36:23 -0700
Message-Id: <20190810013623.14707-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we swap the original proto and clear the ULP pointer
on close we have to make sure no callback will try to access
the freed state. sk_write_space is not part of sk_prot, remember
to swap it.

Reported-by: syzbot+dcdc9deefaec44785f32@syzkaller.appspotmail.com
Fixes: 95fa145479fb ("bpf: sockmap/tls, close can race with map free")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/tls/tls_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 9cbbae606ced..ce6ef56a65ef 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -308,6 +308,7 @@ static void tls_sk_proto_close(struct sock *sk, long timeout)
 	if (free_ctx)
 		icsk->icsk_ulp_data = NULL;
 	sk->sk_prot = ctx->sk_proto;
+	sk->sk_write_space = ctx->sk_write_space;
 	write_unlock_bh(&sk->sk_callback_lock);
 	release_sock(sk);
 	if (ctx->tx_conf == TLS_SW)
-- 
2.21.0

