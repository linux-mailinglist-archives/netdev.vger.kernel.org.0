Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5755E22A56F
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387546AbgGWC6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgGWC6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 22:58:50 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E831C0619DC;
        Wed, 22 Jul 2020 19:58:50 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id k6so3133353ili.6;
        Wed, 22 Jul 2020 19:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pCEmXUzqxk9okJ46w5/kqnzWiON/PCFBw3SwsJJjA2o=;
        b=NtNAZUXmro3U0W/eNGRzVoBsxEYtYMLzoPj5l7VxYOpm/X0b/0EZvb11cK+dng1tOF
         E5Dycrk89GiRbg83zdDDoMo2b4l96xYzWE/5tg8t/1QIK2x5HoYNxuMO68sMnbji6uWX
         e9HVv1kIU5XGUGy9X0evv0fqoe3+qEj3o7Gl6JA222lS9SASteFBbfH764ZQcDTgqFd/
         kVAe6ARC88PVePDdbPFw4if1xI2H921HfOLjdo22ZG/ewvzAt6EUhDtxklaOVKY0vVo7
         gCnN2JQHGYn7OacZrRV1OMfGWPSjuz84SR1dOA0M/Roy1/q5AkN5aDc5IAagW8xepZbG
         kIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pCEmXUzqxk9okJ46w5/kqnzWiON/PCFBw3SwsJJjA2o=;
        b=nnkhTAqvx5LzReS2NSix/gBAjF5rCCmcVXf+zQpBeeqU1NUh9RB4e1LwLrMKJ+zKXX
         AF+u0bbJiCvxUtU1kQmELuUAomF8KA0HaN3U3inwDwaOk+vy2D52IV/hpe+qlDxOo8yh
         4UrzQSfKGydRb5acooEpOqH/qnLHOWQFE2JAyem+SzisHGYis1ifdgGjEWtNrgeK2T6d
         MwZW8FcYtRncFJX/3cXSluDVodd9B1lO6MpQbjdrXBSdIIpPCmCzD58e1VZWPSCRNDB8
         0GmBquIZV8fFTWKg4HXPYppcA++ifS6xILC3ZDYUNZtK4u4eDfjbU1HijvH93rzPgm5C
         c8LA==
X-Gm-Message-State: AOAM532Of/Tb1IwUnJsSI8n29gKKZQf/DhMzQOkCrCx9LbPC/SAB1H7o
        KOPZS8EUMHM3M9MEKqRpB24=
X-Google-Smtp-Source: ABdhPJwAoE8fRLdmHRlsEZEJYMK7ZYOKfvLS/NusuyNuU49d0EFTv0opFhb1XqOR7WOyHLulJ1S3vA==
X-Received: by 2002:a92:794f:: with SMTP id u76mr2747797ilc.215.1595473130030;
        Wed, 22 Jul 2020 19:58:50 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id c3sm744628ilj.31.2020.07.22.19.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 19:58:49 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Vishal Kulkarni <vishal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH v3] cxgb4: add missing release on skb in uld_send()
Date:   Wed, 22 Jul 2020 21:58:39 -0500
Message-Id: <20200723025841.22535-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722.181436.414462601873878102.davem@davemloft.net>
References: <20200722.181436.414462601873878102.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of uld_send(), the skb is consumed on all
execution paths except one. Release skb when returning NET_XMIT_DROP.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
v3:
	- fixed the base problem, and used kfree_skb
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 32a45dc51ed7..92eee66cbc84 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2938,6 +2938,7 @@ static inline int uld_send(struct adapter *adap, struct sk_buff *skb,
 	txq_info = adap->sge.uld_txq_info[tx_uld_type];
 	if (unlikely(!txq_info)) {
 		WARN_ON(true);
+		kfree_skb(skb);
 		return NET_XMIT_DROP;
 	}
 
-- 
2.17.1

