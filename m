Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A446679DB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 16:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjALPvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 10:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240365AbjALPvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 10:51:15 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D7B6B5F0
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:40:08 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id v6so2714686ejg.6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CpfC1agUnmzyoZZWBRoVh/rstX0bSG6U2Rx017qkZOc=;
        b=Lccs8JCjtT8tvXvXAvToicHvTm9vNcaGj2Rq+AQEFMpeMwat3KQBRSopOk8grhmlI2
         7b47C4MeOIEY999UnUda8YgP4Sp3xAS2siNa6oVFuSqn0/SyjWfwHRIHHFGDA+jr2V4w
         VZW8LoqBg8fLshw6t4BRwJFOXrE8hTLhDpKOo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CpfC1agUnmzyoZZWBRoVh/rstX0bSG6U2Rx017qkZOc=;
        b=Lpx12KlTHgI1TZPfRToRkxxTGG3jREIm5NdO2nZBj2DAdH3kr5KleHk7C6NmsG7WlK
         mlZ1hQJ7W8IXoMcysWT4B5eF10FRiypXtFhHwaWIf+1RAaGHCcDqsAHZJpn3CwL3vlTE
         /WGTBajHEE6XSM76irfN3JsO0jeH/nmBPJSofjWNJav1RlR63CuRap1hS0Yl9b4Z+ENI
         vJfOLnn0oh0DCpgF49ppCtzbvsQS+g+Wc/XPQhO/WYi8rXbmBcCFblcn9OYe3tFBrvOu
         MoJP0c7xNjMe6eOrgYw+CUnichoTmHA3+aq4ncwlbfpR53vwk6WPtVRPcnbRKnkxK+xR
         Cv4g==
X-Gm-Message-State: AFqh2kr19u7cWSEcczwoXzbMURrYugRSjLpNa/tulWNaf+uGM0r6ZZdT
        2qhuTXqwVrPZX32Q/K/QLv97AA==
X-Google-Smtp-Source: AMrXdXvSm19hZ8PVHAwxvKt0Rd/kB+K50OQngadyFFyrnY6AW36Fve0rnWx4DFTNR7Fb0/BWk2Dmqg==
X-Received: by 2002:a17:907:c28b:b0:84d:12d8:e1e9 with SMTP id tk11-20020a170907c28b00b0084d12d8e1e9mr13049194ejc.41.1673538005453;
        Thu, 12 Jan 2023 07:40:05 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id ti11-20020a170907c20b00b007c10bb5b4b8sm7482215ejc.224.2023.01.12.07.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 07:40:05 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Thu, 12 Jan 2023 15:39:23 +0000
Subject: [PATCH] inet: fix fast path in __inet_hash_connect()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAKwpwGMC/x2NQQrDIBAAvxL2XEHtxfYrpciqa91DN8WVEgj5e
 02Pw8DMDkqdSeG+7NDpy8qrTHCXBXJDeZHhMhm89VfrnDcsNGJDbTGvIpRHTCwlNsJiQvUl30K1
 ITmYhYRKJnWU3M7GG3VQP8WnU+Xtv308j+MHK9kjMIYAAAA=
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.11.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1673538005; l=2065;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=TUFvhV+TThpBJm91TM7GvgXaWlgYoPc+aQtxNdrmdCo=;
 b=47ox2+rz52E0JCplO2ia51eqiQPQdDDhXRsuRwXGWqSwTQsk5agiApjN5hBjrPT1A3g2x93OQZu7
 7UWU16pHBnuijykhpqk5H2IStcZYQnVZUJLD3h+0j0f7N5UdqOZB
X-Developer-Key: i=borrello@diag.uniroma1.it; a=ed25519;
 pk=4xRQbiJKehl7dFvrG33o2HpveMrwQiUPKtIlObzKmdY=
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__inet_hash_connect() has a fast path taken if sk_head(&tb->owners) is
equal to the sk parameter.
sk_head() returns the list_entry() with respect to the sk_node field.
However entries in the tb->owners list are inserted with respect to the
sk_bind_node field with sk_add_bind_node().
Thus the check would never pass and the fast path never execute.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
 include/net/sock.h         | 10 ++++++++++
 net/ipv4/inet_hashtables.c |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index dcd72e6285b2..23fc403284db 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -860,6 +860,16 @@ static inline void sk_nulls_add_node_rcu(struct sock *sk, struct hlist_nulls_hea
 	__sk_nulls_add_node_rcu(sk, list);
 }
 
+static inline struct sock *__sk_bind_head(const struct hlist_head *head)
+{
+	return hlist_entry(head->first, struct sock, sk_bind_node);
+}
+
+static inline struct sock *sk_bind_head(const struct hlist_head *head)
+{
+	return hlist_empty(head) ? NULL : __sk_bind_head(head);
+}
+
 static inline void __sk_del_bind_node(struct sock *sk)
 {
 	__hlist_del(&sk->sk_bind_node);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d039b4e732a3..a805e086fb48 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -998,7 +998,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 						  hinfo->bhash_size)];
 		tb = inet_csk(sk)->icsk_bind_hash;
 		spin_lock_bh(&head->lock);
-		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
+		if (sk_bind_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
 			inet_ehash_nolisten(sk, NULL, NULL);
 			spin_unlock_bh(&head->lock);
 			return 0;

---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20230112-inet_hash_connect_bind_head-8f2dc98f08b1

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>
