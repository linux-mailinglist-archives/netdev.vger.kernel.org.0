Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37F1524118
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349408AbiEKXiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349389AbiEKXiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F34A62237
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:10 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id x88so3629388pjj.1
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YUlv7qqnItbyYlHDMUTX5gH4mFMMzUBtaLmUQsed56k=;
        b=UGTZbbMJXcPaxFHQBmYVNQzRdD3gR4ksiOZqmSlsvHXf5IUywN8KrpyvGQRBhMFwK9
         GvWgrOzweLWXGA7A7t0IHj9ac8VvfMG148bDnII5llF8YBm4QDAKFdQuGA8fbpW68GB0
         zADIzE3L4TOm43NxKl1jdO6ZnZZmZHtBOyopQPczOXBSzqGRRup6HNZofe+/OeX15mZW
         k9c6TAi2QastbMVpz0YYZkNGBikhRo2uYHF5kmQSgH/uns4+GwNEofGI6hk7qfKIXob9
         VupDHPesAINpSRC3Wci60ocnK/29jk1NU8R6Uz2qwdWuclPeyAsqQFRV44I4noOlfZmB
         SiKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YUlv7qqnItbyYlHDMUTX5gH4mFMMzUBtaLmUQsed56k=;
        b=fuBrAnHGqsgmkBBoXBIyDDdCCZRIV8zZGgEyawrN+gS9SWmp+lT0pDBU9XD9bRPKdc
         d+Xv1HXyCwh6Z5dRptEUn1VCOdvcQlKftWRTzika+q81+I940A3sMKUPBygjWbRFN8iV
         q4UHArnEyf9iaOqrM/n+DbzboGnwMuoT8fi9QNCkmHftqZF0tdtsVDC9wpqAT+bIqDax
         w5Ii59iE4HGbLJvr7Nbi6lQWsiOXevEn9xdQu4OuLABNqUYMPjsVNE88AqCBwGDRKUWQ
         MIJTeV/Xfm0AS9sHxlKzJWxqM3wGzr91Re1D/BTaIBKN9/4T7op7WMTN01vXgwKtAwjw
         PzDA==
X-Gm-Message-State: AOAM530iuN8V/AS31EDGWiD+dUsH+iZBanDFcWf6St4WJk94hOx8mvSW
        hJrOikEyAuP+B+v5kKcrACocsAe5UmU=
X-Google-Smtp-Source: ABdhPJzvst2j6DC3upxO2uPYJsZAms3HOiyNrPsPYrpH69tKkt/nLRTc8gsxDvcB4wcZ+LpUCaeemA==
X-Received: by 2002:a17:902:eb90:b0:15e:b55f:d9c5 with SMTP id q16-20020a170902eb9000b0015eb55fd9c5mr27781405plg.33.1652312289893;
        Wed, 11 May 2022 16:38:09 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:09 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/10] dccp: use READ_ONCE() to read sk->sk_bound_dev_if
Date:   Wed, 11 May 2022 16:37:52 -0700
Message-Id: <20220511233757.2001218-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

When reading listener sk->sk_bound_dev_if locklessly,
we must use READ_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/dccp/ipv4.c | 2 +-
 net/dccp/ipv6.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 82696ab86f74fd61aae5f60a3e14e769fb21abf9..3074248721607541a707d2e27dc0dfb9ff68463f 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -628,7 +628,7 @@ int dccp_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	sk_daddr_set(req_to_sk(req), ip_hdr(skb)->saddr);
 	ireq->ir_mark = inet_request_mark(sk, skb);
 	ireq->ireq_family = AF_INET;
-	ireq->ir_iif = sk->sk_bound_dev_if;
+	ireq->ir_iif = READ_ONCE(sk->sk_bound_dev_if);
 
 	/*
 	 * Step 3: Process LISTEN state
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 4d95b6400915db56e1058099e6d7015d2d64647e..d717ef0def64a9f3321fc53107f421b70a21bd16 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -374,10 +374,10 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 		refcount_inc(&skb->users);
 		ireq->pktopts = skb;
 	}
-	ireq->ir_iif = sk->sk_bound_dev_if;
+	ireq->ir_iif = READ_ONCE(sk->sk_bound_dev_if);
 
 	/* So that link locals have meaning */
-	if (!sk->sk_bound_dev_if &&
+	if (!ireq->ir_iif &&
 	    ipv6_addr_type(&ireq->ir_v6_rmt_addr) & IPV6_ADDR_LINKLOCAL)
 		ireq->ir_iif = inet6_iif(skb);
 
-- 
2.36.0.512.ge40c2bad7a-goog

