Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44BFE128C5F
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 03:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfLVCvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 21:51:43 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:35903 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfLVCvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 21:51:43 -0500
Received: by mail-pl1-f181.google.com with SMTP id a6so5030521plm.3
        for <netdev@vger.kernel.org>; Sat, 21 Dec 2019 18:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=diC/lVQJw2Ov54zfpkd5pN4mAusxXbj3QpTDmgS6ibg=;
        b=dYaJRJqixyponYMRI/GhIaw1NYsTavcr3Q1p67bN8dbLhO7RxNukf9+ZdecFcWRFfk
         4hDmY3Fw4Jw6zb/7LTjpCQAoHv3yLv0YvEPUEmlqXHfng0EIAEE7ovE2nq+ubOnI3erV
         S5FueHCc5Gm9hETDyxuGQwuMwmieAsL7yMn6oHsgGJHrWGBCtAtZJfnCaR3wwiOlsCmN
         Armzq09z8Ik9uffXzVug56ByeQlEFkvptAnxCqk7fhVxcyBvvmwSwjaRVcfpqohq/AfX
         20d4aFK5cX+Qd9hf5csMe1KsfBicPBJk1tCH5e2aD9yb8VJig/1rdze5Tc+qaZ1GxoBo
         m2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=diC/lVQJw2Ov54zfpkd5pN4mAusxXbj3QpTDmgS6ibg=;
        b=X2LLpfXiddfO3T36lh00zcRuSm+PYBuWeZxu3QXwSSAvZrBwDG6fhWBPXGJZctbWos
         Rd/hU6Vi8e5WzzSS3jcsfyrJP1QA3hXMGy/oFu7mjRZWgI15j6iJvRLxU5A1FyfAcZ2X
         3RP7w+Zjd95NPm5KoDk1+vwvvgjivXn4J8mw+MjjMoVPA9JC97kD+EELv5vjr0Bq3JzK
         2gEnqvabzq+Lw7fjGpiUArzCxL5p9spwFCXuCJdT3vJE0ZTwslFhUeina2FxQFo5TDyq
         9L9u5K2K21lHfukFcxnf3+U7z+r8fH5bEYDeLqtqVAvC6SvufjFa2MyWc7H6ZeSKw6Cv
         kDRA==
X-Gm-Message-State: APjAAAVBMbM1SNkfrAlttjvE85b1ayfmgpSzQf76zselmXnmU1AY0lgD
        wvSXdO78bFgULfTa9+zszujQDKMbxw4=
X-Google-Smtp-Source: APXvYqzS3pZ6uDLviiHUIlkOl/1z0ATdpEMrNHBGeBXj49JKMfDVHUxCXUwWDRDwIBxEGeYO9xMuqg==
X-Received: by 2002:a17:90a:d344:: with SMTP id i4mr26762409pjx.42.1576983102098;
        Sat, 21 Dec 2019 18:51:42 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1866775pjo.19.2019.12.21.18.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 18:51:41 -0800 (PST)
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
Subject: [PATCHv5 net 2/8] ip6_gre: do not confirm neighbor when do pmtu update
Date:   Sun, 22 Dec 2019 10:51:10 +0800
Message-Id: <20191222025116.2897-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191222025116.2897-1-liuhangbin@gmail.com>
References: <20191220032525.26909-1-liuhangbin@gmail.com>
 <20191222025116.2897-1-liuhangbin@gmail.com>
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

v5: No change.
v4: No change.
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Reported-by: Jianlin Shi <jishi@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: David Ahern <dsahern@gmail.com>
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

