Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9B467046
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 03:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378282AbhLCCvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 21:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243291AbhLCCvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 21:51:47 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB50EC06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 18:48:23 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 8so1505466pfo.4
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 18:48:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uOGDxUJKSk/sPCLCmeDkNNHP+gUxPNLx3WgXYaYfGGQ=;
        b=WIrmF0QqnBl45nCot1nWCrdBpNHZNq/MXn+JkP7rRjemAwHK8fq3HLfTtqlFCzYcJm
         NMfsm+een5yWBRiU5CmOO8YsMCEiTNbDBYTOMrbC89u7FQd4BzIGXweD7b1DdB+2vmYP
         RT9Tua9upgSGtYWTZc9vUf+fnmvZijCvWlB4OUngy7dj/7NU0GTzxwKBmkdoOGAlcQtD
         pb4YFHrU9z/SJb/E1trLjTHcNCHIgu9YvzCrVS+xxgWeXpysBf/kbG0Umhak5/RFvfOC
         wS7mnBjq8o+WSoA89srzfc5S7o/eZ1eke68RQA7Bg7G9qGPoWv6MVtkaMZiFklkZ4FNn
         bC2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uOGDxUJKSk/sPCLCmeDkNNHP+gUxPNLx3WgXYaYfGGQ=;
        b=1/7PDufDvXQaIttESkkLZCc2m6ATEDRaKZdp0vb/nWlT6Qbfl9NEJ3hldv5xwXx/2R
         tx3nMrWJ5SNFQ7GEcR6smUS6zlLJZCl/jPBw22tSBeHZJib/aP1p4wAdqu8cqr6/PDF/
         a7pgcJ3KLhIN0bdZFEBCfEDj3tKtjdNFZoyzym2asJ+gyyZL/fOnBEA7DlRFwDywclul
         K+BVFLkdQU5m6fB7xTI+IrDW7mosaKXKLhGGrKCv2jf+COKU3UeXI5pOz2xseLEzo1WG
         xe3GMn5CAhw3jkuCQrR1xPEjDXMHSTH2Uu1gOPS0EdF2mcxDMzfdSvohgvNLoqS+YSxY
         u2iA==
X-Gm-Message-State: AOAM533B2HaWia7yn6ThM9VaXn/Ks2bXcmDyxJ7cvnIjqdOYXdw4Jmow
        s+sFO7VXNXDOiOweSaNmgfY=
X-Google-Smtp-Source: ABdhPJzZO5a7aBvu42U14Xoq61pyDVk94I+LPLPzI5cd107E3DrvjAj0YKpfMjZtnPR8jF0Dy9aiWg==
X-Received: by 2002:a65:4cc7:: with SMTP id n7mr2452528pgt.179.1638499703554;
        Thu, 02 Dec 2021 18:48:23 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:6c4b:c5cb:ac63:1ebf])
        by smtp.gmail.com with ESMTPSA id k2sm1230260pfc.53.2021.12.02.18.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 18:48:23 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 21/23] net: failover: add net device refcount tracker
Date:   Thu,  2 Dec 2021 18:46:38 -0800
Message-Id: <20211203024640.1180745-22-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
In-Reply-To: <20211203024640.1180745-1-eric.dumazet@gmail.com>
References: <20211203024640.1180745-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/failover.h | 1 +
 net/core/failover.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/failover.h b/include/net/failover.h
index bb15438f39c7d98fe7c5637f08c3cfb23e7e79d2..f2b42b4b9cd6c1fb6561e7deca3c549dcf04f20f 100644
--- a/include/net/failover.h
+++ b/include/net/failover.h
@@ -25,6 +25,7 @@ struct failover_ops {
 struct failover {
 	struct list_head list;
 	struct net_device __rcu *failover_dev;
+	netdevice_tracker	dev_tracker;
 	struct failover_ops __rcu *ops;
 };
 
diff --git a/net/core/failover.c b/net/core/failover.c
index b5cd3c727285d7a1738118c246abce8d31dac08f..dcaa92a85ea23c54bc5ea68eb8a0f38fb31ff436 100644
--- a/net/core/failover.c
+++ b/net/core/failover.c
@@ -252,7 +252,7 @@ struct failover *failover_register(struct net_device *dev,
 		return ERR_PTR(-ENOMEM);
 
 	rcu_assign_pointer(failover->ops, ops);
-	dev_hold(dev);
+	dev_hold_track(dev, &failover->dev_tracker, GFP_KERNEL);
 	dev->priv_flags |= IFF_FAILOVER;
 	rcu_assign_pointer(failover->failover_dev, dev);
 
@@ -285,7 +285,7 @@ void failover_unregister(struct failover *failover)
 		    failover_dev->name);
 
 	failover_dev->priv_flags &= ~IFF_FAILOVER;
-	dev_put(failover_dev);
+	dev_put_track(failover_dev, &failover->dev_tracker);
 
 	spin_lock(&failover_lock);
 	list_del(&failover->list);
-- 
2.34.1.400.ga245620fadb-goog

