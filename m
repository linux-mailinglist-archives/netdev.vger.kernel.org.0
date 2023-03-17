Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716966BED69
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 16:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbjCQPz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 11:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjCQPzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 11:55:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCC5C9CBC
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:43 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-541942bfdccso50453077b3.14
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679068543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6G/Xgo8U64xN3ThBIepQD9BAz9X3LlolLcLN5HTC6G4=;
        b=ge8w77CkVQzg0qczlSgV76Z+G7JO+pwnIauucsdK078wgOtBNR8dieEZIHehpO45Eo
         fMxUrbGk1R/8+WBXOi20pEYJDlh+mer926H95Ny04rryuTdFX7j/autuyzzkyXZ2HGLV
         C4XOTYe68dFLYevkdd199Ur8e+3AZff7ATQdy9nt37S0l1zTTPH9tZg8GYNgYdOoDOhm
         AUx40pyanddDd0jx8tDJDYVHPTWIwqx9HGGV0JtUq/ULxCsvyqXj+hjbiD04Fevx/fYB
         /JkN9LhhF768tpBeLEiX3WwT4UYOnNUrOoGaBc7sI1Dzyx60Q6c1Rdp4xSuVzBpLfs85
         u3JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679068543;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6G/Xgo8U64xN3ThBIepQD9BAz9X3LlolLcLN5HTC6G4=;
        b=G66ehJ1G+Vtng6G8vWACjSTMAjQmLJO1L4vee0pQqmhKf2C8wKNT0d6WicdxXjqRBJ
         z1YzowsiAoKNW8mTatnEH9cLfJrUKWR1t7xEWGHBsCiCZ7SDaBIVDt3DybMZQCY2xPf1
         sH7iKv/6UXMzFfYRqpSi6olguHnpcoutc1TGhvpI8WGcYTxuBEwL74WACqm2FQ1powg7
         8e0hLBNC3osZrKty4gXHB5TZENua/rL71r8yxkwph/SabU9m5E0M7q0YW/YllQiy68db
         hrQsGkpNf14STj1qGutrFiBrZoYs+QkLMAtbvpb964JwpLzCGN1s2M0sZJvZtWTo9ddz
         JBoQ==
X-Gm-Message-State: AO0yUKVTZAkIW2zXpoJSNsWz1zKgmxz5YJSdXOqgGvTYq1Vlyb9IFG4t
        n7npSD6UJeOZG+h2xgeLIh2f0hjXJtlpqA==
X-Google-Smtp-Source: AK7set94s7H0gmEP81qhp20UKcCfNQikXF9nsDKETjwM3DKXpJVrqxpbKA9ET1Ic4qHZsxs+9O/lJcrVM99H1Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:183:b0:9fe:195a:ce0d with SMTP
 id t3-20020a056902018300b009fe195ace0dmr9919ybh.10.1679068542915; Fri, 17 Mar
 2023 08:55:42 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:55:30 +0000
In-Reply-To: <20230317155539.2552954-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230317155539.2552954-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230317155539.2552954-2-edumazet@google.com>
Subject: [PATCH net-next 01/10] udp: preserve const qualifier in udp_sk()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Willem de Bruijn <willemb@google.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

We can change udp_sk() to propagate const qualifier of its argument,
thanks to container_of_const()

This should avoid some potential errors caused by accidental
(const -> not_const) promotion.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 include/linux/udp.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index a2892e151644ec347ad52d426400678e4a53b359..43c1fb2d2c21afc01abdf20e4b9c03f04932c19b 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -97,10 +97,7 @@ struct udp_sock {
 
 #define UDP_MAX_SEGMENTS	(1 << 6UL)
 
-static inline struct udp_sock *udp_sk(const struct sock *sk)
-{
-	return (struct udp_sock *)sk;
-}
+#define udp_sk(ptr) container_of_const(ptr, struct udp_sock, inet.sk)
 
 static inline void udp_set_no_check6_tx(struct sock *sk, bool val)
 {
-- 
2.40.0.rc2.332.ga46443480c-goog

