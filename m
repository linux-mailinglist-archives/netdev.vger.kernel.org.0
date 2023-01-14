Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78DD266AB78
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 14:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjANNMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 08:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjANNML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 08:12:11 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77C5759D9
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:12:09 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id qk9so58207662ejc.3
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 05:12:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=diag.uniroma1.it; s=google;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TA5irrJ97Zm1pKOtsaRcVAWqWkukQuvBG068G/jV9M0=;
        b=LpVRFjJjAm0OwujEHeVao7WLsD0eVoWBg0v6mpYCslEPyfsIIzLBGaLlt+xj6Lbsgn
         1yZvHYbZEG7rs8TFeR066CITO5q22INXtET1BZ0B0eAg728q3Z9IkdRQnzGh/9zQBgns
         5iXhHDd8Px3f80eu6Na/FKeu5Xl8OeOinj9F0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TA5irrJ97Zm1pKOtsaRcVAWqWkukQuvBG068G/jV9M0=;
        b=yIF06FSVeMr6ND08uRg+tZYIGFwz7WCPYE3vzclleYzRIJUgf5DIInVrz9YgCaCkKR
         ke2hy+Cu0QJHvl301QDV1N+W3eHOYvNw2rXyqzwNYKi1EWImuZx2eXkyW3QfLSDqE4HR
         nZ27THMHgqi7EJOZKS3J0TmXQ650YyRdZNGNAXU6E4Okh3K0zOSgQkXCl829nvAAWztt
         Rh7LI7+HRQ3Z72Xy6blzbDbTrf46h8KfALr6bFaGzzsts3MT8y1WSdck/YTQE65c8sr5
         SULXaCt8Qv7U7lgMux8byH24Dufy6q5Hjgw5dv4Sm4KruCJ3PuPqmAu3XywI5nbSWyGh
         J05Q==
X-Gm-Message-State: AFqh2kqoQ8s8coCZ4Ch93cinsUE6qlKvBYc/ZY99xl11WdjUWIH8WhyC
        g0/3wVF1q/iXBfYL+V9u+bN/PA==
X-Google-Smtp-Source: AMrXdXvvxApPCP+ySbwSqzRgDVGCJglvbxaTNamdf0Grt4bc2WUN//7WN3B9nBiQgillujYPfKOmGw==
X-Received: by 2002:a17:906:da09:b0:7c0:e5c6:2a6d with SMTP id fi9-20020a170906da0900b007c0e5c62a6dmr6425666ejb.39.1673701927984;
        Sat, 14 Jan 2023 05:12:07 -0800 (PST)
Received: from [192.168.17.2] (wolkje-127.labs.vu.nl. [130.37.198.127])
        by smtp.gmail.com with ESMTPSA id p4-20020a17090653c400b0084ca4bd745esm9658956ejo.35.2023.01.14.05.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 05:12:07 -0800 (PST)
From:   Pietro Borrello <borrello@diag.uniroma1.it>
Date:   Sat, 14 Jan 2023 13:11:41 +0000
Subject: [PATCH net-next v3] inet: fix fast path in __inet_hash_connect()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-inet_hash_connect_bind_head-v3-1-b591fd212b93@diag.uniroma1.it>
X-B4-Tracking: v=1; b=H4sIAA2qwmMC/5XOQQ6CMBQE0KuQri2hJUhx5T2MIaX90L/gY9pKM
 IS7W3DrQpeTSd7MygJ4hMAu2co8zBhwohTKU8aM0zQAR5syk4UsCyEkR4LYOh1cayYiMLHtkGzr
 QFuuemlNo/pCdYIlodMBeOc1Gbcbow4R/F48PPS4HLM3lkBOsER2T43DECf/Ov7M4uh/mp4FF7y
 G0tR1IaraqKtFPeRPQj+NWuT44Wf5BykTWYFp5Nla26jqC7lt2xsxIc0pQwEAAA==
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>, Jakob Koschel <jkl820.git@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pietro Borrello <borrello@diag.uniroma1.it>
X-Mailer: b4 0.11.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1673701927; l=2061;
 i=borrello@diag.uniroma1.it; s=20221223; h=from:subject:message-id;
 bh=8v/y9dezeD4bGg+sLXesbdVfw+jitR6F8rl/F0ZYHVI=;
 b=ckGjINy49k27kdG5mt+R5zuKdRjUsFOmYQWCPHQpwRNFW4KGOGVWC/7F3XrPfXsc4pp7b5kTiQxT
 q+FrBtUcCperCfbiGJ2MiJTDNIZ1WjwFYLRhA4LZshdS1Qa7QUVW
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

This fast path has never been executed or tested as this bug seems
to be present since commit 1da177e4c3f4 ("Linux-2.6.12-rc2"), thus
remove it to reduce code complexity.

Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
---
Changes in v3:
- remove the fast path to reduce code complexity
- Link to v2: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v2-1-5ec926ddd985@diag.uniroma1.it

Changes in v2:
- nit: s/list_entry/hlist_entry/
- Link to v1: https://lore.kernel.org/r/20230112-inet_hash_connect_bind_head-v1-1-7e3c770157c8@diag.uniroma1.it
---
 net/ipv4/inet_hashtables.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index d039b4e732a3..b832e7a545d4 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -994,17 +994,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	u32 index;
 
 	if (port) {
-		head = &hinfo->bhash[inet_bhashfn(net, port,
-						  hinfo->bhash_size)];
-		tb = inet_csk(sk)->icsk_bind_hash;
-		spin_lock_bh(&head->lock);
-		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL, NULL);
-			spin_unlock_bh(&head->lock);
-			return 0;
-		}
-		spin_unlock(&head->lock);
-		/* No definite answer... Walk to established hash table */
+		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL);
 		local_bh_enable();
 		return ret;

---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20230112-inet_hash_connect_bind_head-8f2dc98f08b1

Best regards,
-- 
Pietro Borrello <borrello@diag.uniroma1.it>
