Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29A0534D10
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 12:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239614AbiEZKMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 06:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346966AbiEZKMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 06:12:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DE62644;
        Thu, 26 May 2022 03:12:36 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso1370987pjg.0;
        Thu, 26 May 2022 03:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xAQlpNbU2NjknCJlnhi8QNZU6DsJe41C4/l5GK8TjmM=;
        b=CImTY0YiCYdF0KMjX3hj3mJjtQP8gGtFHiiZ6UzWlmmICN0rw1yEe7ox1Bvx8q9+QJ
         57lacZqqNXbKLBcPwmjtv2c+TxoHE5coqpXH+k2SimNgnam3qZX9lb9Vzm2yaC2u092B
         BuZPoPs2y9WL8nA+jq7ZQJm8to/2ZOlGZwCEASjTjbWXzJu4O9xzs8xrbKc4n50vRcEg
         eKz9135zSAVI/kbXS91beHuiri+IlAfO0yioIzOWTfB26PCGYqrAJTd8BoBL+p4BsyA4
         D/THK2M5VdyyLzVx43m7Y9QZwmdGKJO8q2yoXVPk3Ch8Tc1j+N+qXUjeDanWUOkvwIW+
         FTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xAQlpNbU2NjknCJlnhi8QNZU6DsJe41C4/l5GK8TjmM=;
        b=UiAn+aU7dz/NtJ6HKE9TQid+7xJ6N26CJr64YYLEmkzA5mSSUBLOJq5AVPxpn5epOL
         4hkqmh63RQQ79nP56YsGtYNongOTUou+cnAz6X3UZrTovTQbNoRmMigxFSHgCKEpCe/s
         YlW5T0MvXBImnU7qg0chfN+I6dtAJ0+PNuXJ7ZfVkhXTXm9MDOpPnqM6xnSC0FPLPCxA
         /LzgNoAfNDgxtq3w3TF1lPm0LE4wMOa6LMF6ZZTlFYPQ+5/vMJoSrpcFQj8C84+Cmt0Y
         yqze8IecSmvAsce1EUWUg3PDDTdY3MhYiTGsdi9uogXWFcvKZcn00bnAjMdBtoVk9ztw
         DrwA==
X-Gm-Message-State: AOAM533xgudKzuab01pAaAD8ZTZ0LkNvAv6SUMN8POQt0gEp26NgTdmn
        YFlUQH6X2WimpKSXj8DBefM=
X-Google-Smtp-Source: ABdhPJyljOBjwFuJo3P/fN9WLD7ZVEn5FDVre+7cTcjsDbNwirZRbjg88K8KpeR/+attvz8aKKfuIg==
X-Received: by 2002:a17:90a:d3d4:b0:1e0:a6a7:6ef with SMTP id d20-20020a17090ad3d400b001e0a6a706efmr1822421pjw.17.1653559955995;
        Thu, 26 May 2022 03:12:35 -0700 (PDT)
Received: from localhost.localdomain ([150.107.0.8])
        by smtp.gmail.com with ESMTPSA id j2-20020aa79282000000b005187f4ebd12sm1055018pfa.123.2022.05.26.03.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 03:12:35 -0700 (PDT)
From:   zhanggenjian <zhanggenjian123@gmail.com>
X-Google-Original-From: zhanggenjian <zhanggenjian@kylinos.cn>
To:     pabeni@redhat.com, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huhai@kylinos.cn, zhanggenjian123@gmail.com
Subject: [PATCH v2] net: ipv4: Avoid bounds check warning
Date:   Thu, 26 May 2022 18:12:13 +0800
Message-Id: <20220526101213.2392980-1-zhanggenjian@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huhai <huhai@kylinos.cn>

Fix the following build warning when CONFIG_IPV6 is not set:

In function ‘fortify_memcpy_chk’,
    inlined from ‘tcp_md5_do_add’ at net/ipv4/tcp_ipv4.c:1210:2:
./include/linux/fortify-string.h:328:4: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
  328 |    __write_overflow_field(p_size_field, size);
      |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: huhai <huhai@kylinos.cn>
---
 net/ipv4/tcp_ipv4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 457f5b5d5d4a..46ae9d535086 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1208,8 +1208,8 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 	key->l3index = l3index;
 	key->flags = flags;
 	memcpy(&key->addr, addr,
-	       (family == AF_INET6) ? sizeof(struct in6_addr) :
-				      sizeof(struct in_addr));
+	       (IS_ENABLED(CONFIG_IPV6) && family == AF_INET6) ? sizeof(struct in6_addr) :
+								 sizeof(struct in_addr));
 	hlist_add_head_rcu(&key->node, &md5sig->head);
 	return 0;
 }
-- 
2.27.0

