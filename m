Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283B43D2C27
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbhGVSKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 14:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbhGVSJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 14:09:59 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB0BC061757;
        Thu, 22 Jul 2021 11:50:34 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id n10so283264plf.4;
        Thu, 22 Jul 2021 11:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wlySsb7NCcOdNyg1NZSKXQbRNOuXci6cKFNHTYDMHGI=;
        b=tANL0sX86ZD+GqZzcCkAad8AnyAZk6TTJGaGkR/4dyZtkl623k8o1TY+N8OwmijmtX
         7TrPOQV58VIi+OvKiMUQD0F0Aj8fgFvcGvEIj+E5pnOrJih29RGeTW0cB1m0a/F/vWcN
         sqOB2rX+b3qJmMb0v0ASLQ125Ib/E+iaGMHOwA4KYJX8SbfSO8NwJ6l6uoBJo83ua63Y
         ykMfg0+dUCQbtMpwvmLSYo+Eo643YOCl3OEtSywPPw/AbU9yT0FU72AQQS9bp+EFHbFM
         lF1ImXC/bOSl6DZ78nujZ8Qn8eTroilrSccRoeMFyaV0Yhd/JnM0r1PlERoaJLBD6x6O
         JYBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wlySsb7NCcOdNyg1NZSKXQbRNOuXci6cKFNHTYDMHGI=;
        b=E+puHFRKEnvo67VlpE0oEz0ujrLT7R0gpdM/u4Gcr50gmAHrfR/NlE1GYz6isZolkf
         +YWj2QcnUJ8nfDVPV7hTU05utss1I4u6aEfnunucZVdGEqzyljXQ0kFTVEhxxVKddt7q
         vcsGqa6tQeb8yG52+wGVE7ZIbbVpPVDTNyh7rG37MlZLpe1Dl+XLzYpcMBdDmd1BOllX
         Bs4Z9KjJd9ihtM2FnHGUb3l9nO7Im7pYab6OhGNYAJiLKKpKoq3foBvCJIBX7J6F4GJr
         xH8n6RD/vbhoKwcFiDdVzZmHhKThJzP+KuaDLgV01rm97wneC4txr6ME393Mg5Nqs7eo
         9oqA==
X-Gm-Message-State: AOAM530rGexhvLPXN6sD8iqlIhLLjzbM6bgfxEZ2oYF5uwYovDbN7IgS
        QLzLp/+rB8RZzW3n0l6nDro=
X-Google-Smtp-Source: ABdhPJz+a6SU4QCvQpOJI9b8Z9IKDFCARTxqrN1f68A2kc5XvltUnF3KwjiRNwC0K9z+Ic8FvyizNA==
X-Received: by 2002:a17:90b:1e50:: with SMTP id pi16mr1042402pjb.147.1626979833836;
        Thu, 22 Jul 2021 11:50:33 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id w2sm5394925pjf.2.2021.07.22.11.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 11:50:33 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Martin Varghese <martin.varghese@nokia.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mpls: defer ttl decrement in mpls_forward()
Date:   Fri, 23 Jul 2021 03:50:28 +0900
Message-Id: <20210722185028.17555-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defer ttl decrement to optimize in tx_err case. There is no need
to decrease ttl in the case of goto tx_err.

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
 net/mpls/af_mpls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 05a21dd072df..ffeb2df8be7a 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -407,7 +407,6 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 	/* Verify ttl is valid */
 	if (dec.ttl <= 1)
 		goto err;
-	dec.ttl -= 1;
 
 	/* Find the output device */
 	out_dev = rcu_dereference(nh->nh_dev);
@@ -431,6 +430,7 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 	skb->dev = out_dev;
 	skb->protocol = htons(ETH_P_MPLS_UC);
 
+	dec.ttl -= 1;
 	if (unlikely(!new_header_size && dec.bos)) {
 		/* Penultimate hop popping */
 		if (!mpls_egress(dev_net(out_dev), rt, skb, dec))
-- 
2.26.2

