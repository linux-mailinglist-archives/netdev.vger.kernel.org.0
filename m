Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7BF124632
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfLRLxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:53:51 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36054 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLRLxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:53:50 -0500
Received: by mail-pf1-f196.google.com with SMTP id x184so1089616pfb.3
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sjvc6ICHXb2ZpNs45lcs+VlSF+MumGlOBWBtTgJJ3J4=;
        b=OwC96JMxxhAR2vKiO5iG2js7xqWtdchYsAZeBz2kFozKoZBAHUik1PHE7UKXA1aWgi
         t/6h2Akskd6g6sUayEdJ3vUbsp6mzo+QSLnaY15CTSL2Q+v5DeWcr1VyO8ztN12eHG90
         yjzrMx66XvnpP1f3+2RS0qogAXIZxR2SiqCIy177xFfmaQGCoRuJcNxzAtN+jPj9/6qd
         J7yUoYdXfIef7PmlsIvvFclYmKr1lsFtLvUtkbx5tyBsFbdA+08/Q5oZFM+YyETX311f
         ST2TI4jWoDXofzVAJDKW0H2MUFkYMxriMqgu1LWj/dlrcaBODv676VwlX3zTO12kbrvA
         TwTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sjvc6ICHXb2ZpNs45lcs+VlSF+MumGlOBWBtTgJJ3J4=;
        b=sJkNcixSlAp1YkStrPU1oO8N6mNt6OxKycrghfVJqPfLlKiWvbpbbCO1YdCLD9d+r5
         +bJ+5uSychNNTRFm8f75dQTG4J4SN+vywiqZrRMCe9OQrKkQquUr312pslzBlgygM5wC
         NLcRLP+V64B+UyvnU/u7kr+3/vhqOnObcJuzQGIfsZ5XsxFRLgScxVBVgCmZFbdvtHF2
         BCA9uCr6ZiTZo4Up5oBhNfYos/XzNKM5DyOz+VZPjZICocqyQt01SGcER+Df8RawBPO0
         fJjJhnrpuM9oJhYSqkWRMWlzAK9F+laR3EcCglG1uTQmQhzhQG2UnZa1U0d7SHKhKuwm
         rFpQ==
X-Gm-Message-State: APjAAAVnSWwmfkLRpshGiVVkaL1CWmCAJMxogwjyWnh2ycbZI/aQqNEV
        DNG5ueUPvU0Hr0AyS7TINEAxJsjy/jqRuQ==
X-Google-Smtp-Source: APXvYqwNz6pixnhf1m+/GO7OF+cdcOGBVOyXDXJVhJ7aCUAcok0/UP5nlJXy9vvObwaakPKnX9eE+w==
X-Received: by 2002:a63:5b0a:: with SMTP id p10mr2608123pgb.228.1576670029716;
        Wed, 18 Dec 2019 03:53:49 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x33sm2961067pga.86.2019.12.18.03.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:53:49 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net-next 2/8] ip6_gre: do not confirm neighbor when do pmtu update
Date:   Wed, 18 Dec 2019 19:53:07 +0800
Message-Id: <20191218115313.19352-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we do ipv6 gre pmtu update, we will also do neigh confirm currently.
This will cause the neigh cache be refreshed and set to REACHABLE before
xmit.

But if the remote mac address changed, e.g. device is deleted and recreated,
we will not able to notice this and still use the old mac address as the neigh
cache is REACHABLE.

Fix this by disable neigh confirm when do pmtu update

Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv6/ip6_gre.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 071cb237f00b..189de56f5e36 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1040,7 +1040,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 
 	/* TooBig packet may have updated dst->dev's mtu */
 	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, true);
+		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, false);
 
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   NEXTHDR_GRE);
-- 
2.19.2

