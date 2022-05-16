Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E9528348
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243199AbiEPLbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243256AbiEPLbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:31:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A28938D83;
        Mon, 16 May 2022 04:31:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so3891777pjb.0;
        Mon, 16 May 2022 04:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2x/YZTWpso9swO5trJb/RJGTgZBqmDziz1tzroGtZ5M=;
        b=QqF8ZXVBp0jPQY5phyXStCS80kubX+LGHH+mJjNE/AT0rPa6iJ5t0K+PdMrge+JMZi
         VrU1lfXZxoZFU+K1I7S1nlf5+cZpz6aKFhlWOuv0eEOByg3mRZDfOU/T8KcRwp/w14u3
         sCJohhYIJGuuWkhnSUeHuHaFZyD2W3USoTsss7onlqHRUhUB8RHed6sKS7BU15HZ0/vZ
         Cmzpfc1nA1eaRTei7Osr0bETH0nruoNtSb7bRnxNTqjzC8jaW4a2qi3ZDCRfvDV5FHDi
         mytr1qgJE8xzpyFuSzj5LZQK3xLOzxEdVD3C6LXRW9yDnkjiCoq/Ybk3fhv9P/HRtOAM
         gm3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2x/YZTWpso9swO5trJb/RJGTgZBqmDziz1tzroGtZ5M=;
        b=wbQ9sFVAcmI6DzSHjivJmRshCqodQfguWTBxHTOnA0o5Qs7wg/EtochwyV+2FRuI2V
         As3xp62ddOvNqZb47WBVLWuQR5eVnGCfuOFgd6imY7JtPtnEKefrpB8EMc2c/yEoJSkQ
         kdjGXa8lHoL9QwzeXa9hWsrWeCARqAxNJJv9NqSt/snE98nVpOAA9OPciCKVxa3/d+uL
         +h3MQgo72nZYALUMjwwT7bSMNpnqAgg+wbqYqim8Gym7lWtOfxSr0H//dTtaN8msDMsQ
         /Ve7XrofsVbjv3dBUwXzIQARXD9t6QmWiNK7VYhWhheaGAofQ9ZKOl3qUdlCfR0LvQTR
         28Kw==
X-Gm-Message-State: AOAM530aqSU0EVXXE1p1GTK9OscSU+Re9NdB2bL+VqEmCDuIyAUiWMrv
        KAIORtESUn4PuNrY4livpbB9TVTuQAwp5QbDFhQ=
X-Google-Smtp-Source: ABdhPJzbS19BUa6xsJhEW4azdS140qDYeO/ZcYJtDkoBfBVC6624ZEJLR2LKndMTUaLO0HtQghBVYA==
X-Received: by 2002:a17:902:e3d4:b0:161:888e:e707 with SMTP id r20-20020a170902e3d400b00161888ee707mr2878655ple.118.1652700681606;
        Mon, 16 May 2022 04:31:21 -0700 (PDT)
Received: from localhost.localdomain ([49.37.196.1])
        by smtp.gmail.com with ESMTPSA id c14-20020a170902848e00b0015e8da1f9e8sm6774160plo.77.2022.05.16.04.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:31:21 -0700 (PDT)
From:   Saranya Panjarathina <plsaranya@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Saranya_Panjarathina@dell.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-kernel@vger.kernel.org,
        g_balaji1@dell.com, Saranya Panjarathina <plsaranya@gmail.com>
Subject: [PATCH net-next] net: PIM register decapsulation and Forwarding.
Date:   Mon, 16 May 2022 04:29:06 -0700
Message-Id: <20220516112906.2095-1-plsaranya@gmail.com>
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

