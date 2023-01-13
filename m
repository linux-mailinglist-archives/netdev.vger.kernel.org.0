Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5356695DE
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 12:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241362AbjAMLud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 06:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjAMLuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 06:50:12 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38F165E1
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:40:37 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id 18so30787204edw.7
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 03:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J8RqKVGTVaHxhbIy1nikSb/1jTDktxJWHpyA+K2S4X0=;
        b=ozo7/KUZ5GD4ln62RZKc4YkS+E0laJWYvtF3N4jXYNvgecbm1eWfeirVyvGFC20pWn
         /sjs2uzT+mh64DGfkcb7TbnFK6k5wjqu5Pdu/FQbbfuOHe+OIdxvWGIT7fye/F0WO4mY
         z7k5AdJMy0u0tr3fwT//1LKiQ35E7nbxAZH6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J8RqKVGTVaHxhbIy1nikSb/1jTDktxJWHpyA+K2S4X0=;
        b=72tQoCE5XQjh9wTcmFBZjme3AgbHKKKmEgOTZcy2MdFBn7v/5EboLBpptW7y/14/r/
         rYeQ8AyQMwe/RbEdMhscYq50SbWyDCIxHX89eUs0qbRFhlAw3L8mjKzA2RypgmWGjbi8
         zsr1kMsmFStnWtI/udirg7AU7R3aQEanLzdVEzg8RK982iv58rpJDw+txHfi6vSmCaEg
         GcXTeZsukbVZTfHxOvDxGS125aItN3CAC0MdjBxP2OYtAmikjoli6llCWzG7MhtyPkZ8
         2VhgndMUkzpBeopSzQHQG3yDp+b+GPlxjFR2VKk99LFBuPegihWp/2cOxIrCiZBcTC59
         +ttQ==
X-Gm-Message-State: AFqh2kqvD6orj9VY8L/gjJXM7jVvu0HQyDp0HEtwrnXHMpyzfTBOxTYT
        cOz6G3VtxFgP/va/yY/fDEc2Jw==
X-Google-Smtp-Source: AMrXdXvhDN17WxrwxjHzIlSKf9w9KFtxbwn4t0BLlpLFmfbsQT9OU9+GpafJM5caFVB8SWQ7Nx0l+w==
X-Received: by 2002:a05:6402:1613:b0:492:798:385e with SMTP id f19-20020a056402161300b004920798385emr28016500edv.33.1673610036163;
        Fri, 13 Jan 2023 03:40:36 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id r24-20020aa7da18000000b004704658abebsm8167428eds.54.2023.01.13.03.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 03:40:35 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Fri, 13 Jan 2023 11:39:47 +0000
Subject: [PATCH v2] inet: fix fast path in __inet_hash_connect()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAANDwWMC/42OTQrDIBSErxJc16CGou2q9yhB/HmJbxEtakNLy
 N1rcoIuvxn4ZjZSICMUcu82kmHFgik2EJeOuGDiDBR9YyKYGBjngmKEqoMpQbsUI7iqLUavAxhP
 1SS8u6mJKctJM1hTgNpsoguHYzGlQj6KV4YJP+fsc2wcsNSUv+eLlR/pf4Mrp5xKGJyUjF+lUw+
 PZu7fEXNaDO+xknHf9x9ujeO55gAAAA==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.11.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1673610035; l=2286;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=7SdQz+1ZgftHVd2AXDRwkUW7s5EIgW3C97LksHTS4dQ=;
 b=u6t2GLblTIOgmKMJX4WYGBW+qiQwdE2FWrqk6ZtZ4HoMKj0B55VPzgGsXV5mrGgihoByLsIZRKCO
 amnqpAgcCczUq5Qlui0deFZ+VYoB1SjX89rGus3JPx3lYA7qLbtS
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
sk_head() returns the hlist_entry() with respect to the sk_node field.
However entries in the tb->owners list are inserted with respect to the
sk_bind_node field with sk_add_bind_node().
Thus the check would never pass and the fast path never execute.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
Changes in v2:
- nit: s/list_entry/hlist_entry/
- Link to v1: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it
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
