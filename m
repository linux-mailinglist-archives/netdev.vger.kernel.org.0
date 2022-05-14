Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BA6527215
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 16:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiENOgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbiENOgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 10:36:07 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F1220F67;
        Sat, 14 May 2022 07:35:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r71so9736098pgr.0;
        Sat, 14 May 2022 07:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LH2DY0hZRjZwSZkfIfm9MKqf607rYpniX8kvWvJ5SrQ=;
        b=mw06+rVjOxYyMVI9ZYHSM7zutkN/daoJ+ZPCLOPb+TLfw8lg6K8BuiR8uzrcVROl09
         AsNQc+iPKPirvKtWpjTT/sRNBrcdsJUZy7XpZZbaeOqMTfWEYKQvfXlWH0ygoDCRZk0R
         73C7NWBRYR/VrhJTuuy5zdK3q5r0raNIjRA3LpFOJcsWCwmeSWAhDZi4fH8FKY/bcKj8
         18cqNVN3mKEO6DhnlqmvSALKyzBcN99OdKViA8U6WUK0y4u6SdUAKQLArpmZPtbfG/7d
         PXP4NkaDJv2KYo48mP5IDxZSOu56qdB1PlUBTxwwhhQm0Ad5c/Dm/kNHOFPpcLqLWdBS
         2LLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LH2DY0hZRjZwSZkfIfm9MKqf607rYpniX8kvWvJ5SrQ=;
        b=4bncuKi6bZ8i94TsFDBJ1cvV510COx1K/FIKkXWDv4yElTIX5kmQfhLfDQgAlOlClI
         oVQvIrll0EHQ9kRHpZAQxuxHGr6aIztSRw5Vzg7MC6Iqzm+RXD9SWy+fjEqs6qXlXTPw
         xTgfD2I5MjKTahCx32tsIk8oWT3TD6q0Y1bkESlUp3w2pSUQAf0n8sQgkmMJ4u8BPIMN
         qs6DZwZvJ8aWcBicv9ppldjZ+I/CugBsMZzXP/Db/alFg1XZQtqvJDgU3fX8cku0RVZ0
         oaEEGrchy7RzZ1OdK6SxmKsg8Ndgh23xVAI/7FBu54p7tLQ93aySpVKOyVdmr5JptZ35
         V8wA==
X-Gm-Message-State: AOAM5303iusnw6U8fYFXR6Jo9/eY8wqzp91hXs5Moj6YlM3qZX+4YkoC
        eu4c/wMswqNlUC0Vr/aYQ64TrwHv93sIjsTbWOg=
X-Google-Smtp-Source: ABdhPJw39KpoHqB64KBC1ErT7ywfn8ZQK5im1sJJlXNIo+GgE31vYY8bNkRUc0UNVycNarWC+7aHPw==
X-Received: by 2002:a63:89c8:0:b0:3db:9da:797e with SMTP id v191-20020a6389c8000000b003db09da797emr8041421pgd.358.1652538955947;
        Sat, 14 May 2022 07:35:55 -0700 (PDT)
Received: from localhost.localdomain ([49.37.196.1])
        by smtp.gmail.com with ESMTPSA id ay4-20020a17090b030400b001df263f30e8sm595645pjb.3.2022.05.14.07.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:35:55 -0700 (PDT)
From:   Saranya Panjarathina <plsaranya@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        g_balaji1@dell.com, Saranya_Panjarathina@dell.com,
        linux-kernel@vger.kernel.org, Saranya_PL <plsaranya@gmail.com>
Subject: [patch netdev] net: PIM register decapsulation and Forwarding.
Date:   Sat, 14 May 2022 07:33:42 -0700
Message-Id: <20220514143342.2600-1-plsaranya@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220512070138.19170-1-plsaranya@gmail.com>
References: <20220512070138.19170-1-plsaranya@gmail.com>
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

From: Saranya_PL <plsaranya@gmail.com>

PIM register packet is decapsulated but not forwarded in RP

__pim_rcv decapsulates the PIM register packet and reinjects for forwarding
after replacing the skb->dev to reg_dev (vif with VIFF_Register)

Ideally the incoming device should be same as skb->dev where the
original PIM register packet is received. mcache would not have
reg_vif as IIF. Decapsulated packet forwarding is failing
because of IIF mismatch. In RP for this S,G RPF interface would be
skb->dev vif only, so that would be IIF for the cache entry.

Signed-off-by: Saranya Panjarathina <plsaranya@gmail.com>
---
 net/ipv4/ipmr.c  | 2 +-
 net/ipv6/ip6mr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 13e6329784fb..7b9586335fb7 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -598,7 +598,7 @@ static int __pim_rcv(struct mr_table *mrt, struct sk_buff *skb,
 	skb->protocol = htons(ETH_P_IP);
 	skb->ip_summed = CHECKSUM_NONE;
 
-	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
+	skb_tunnel_rx(skb, skb->dev, dev_net(skb->dev));
 
 	netif_rx(skb);
 
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 4e74bc61a3db..147e29a818ca 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -566,7 +566,7 @@ static int pim6_rcv(struct sk_buff *skb)
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->ip_summed = CHECKSUM_NONE;
 
-	skb_tunnel_rx(skb, reg_dev, dev_net(reg_dev));
+	skb_tunnel_rx(skb, skb->dev, net);
 
 	netif_rx(skb);
 
-- 
2.20.1

