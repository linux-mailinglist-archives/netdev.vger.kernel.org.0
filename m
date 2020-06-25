Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACC1209890
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 04:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389457AbgFYCmP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 22:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388930AbgFYCmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 22:42:14 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACE4C061573;
        Wed, 24 Jun 2020 19:42:14 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id g13so3521133qtv.8;
        Wed, 24 Jun 2020 19:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=fbnRB4YoedUi6LoLD8JlUhcVfnMSczit3rkXQlpuCkk=;
        b=kEXvyUMcDZ9wfp+GNFnO7Kdy0+8rFA8576vLxYjOiNP0e2JVWJ+dy80UGug5pUWJYV
         Zh4UG/Suq3ekYULrhscG84+fpLM5gICOlmQRCpkCLyObFPu2rrsGSf92EXXD8GocGX/c
         +UzOWtEs1PoLcU+tSBNnMTl87FUYJaqcuIDSrWBeRKYqSofD4J8lgALECQrRrBxoBR68
         8E8xep34JgXlCrcCbE2IiaNElDnvpe6gIe29lwOP4A9ZWR0qAfq+huVnU/ftYyE2i1lf
         cxHN1qvjB273LYnDQMY6ntmqVU9GYFA1cbuR9izWL8NeA1HcUVTfKbRns30z7vaAYX2z
         4ayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=fbnRB4YoedUi6LoLD8JlUhcVfnMSczit3rkXQlpuCkk=;
        b=JEtAbcbH19ZlICmkbQgeBlY01Qojlsu7+twvMODyLvZY7CS6+Gpj6R9ONBxf20EOvn
         l6BRAJepYpl/FkPj59lpWDZdO0Yy/9KXrLMnBmzCMoA6lwc4e/n/BeWs00vvi0iiM6Ux
         4SNHfgzUPHsDFnWmctNsJFhPMCWyutPYiizxCFnLaWv/e9hdmfVcMmcIDoLWTFkWgF6Z
         G/uavR263ieySMB3Jgx/FyEjK90KXF+A1A218N4qY4yaDmFygG+ClQl6VZF4c5UHb+pv
         a9xsP2yfl3JXJyCzT5cZXr1Mle2kOQhyut6c1E95d/ZmXYRjyoCmKc8AyFs4u5Vuv60B
         IVOA==
X-Gm-Message-State: AOAM5322eEirxp8wsWFWayKJC2FztKaefYU2ji7aYbeVEj9eqGmADtzG
        KWXFhfFlO5r6ucQG4xzfRv8=
X-Google-Smtp-Source: ABdhPJw3OtA7sQGiEp3UleOVwFrZJEtgn2Y11sOcOrX/L957Pc2v8g55AKuks2DKCL0NaC0iXr/6+g==
X-Received: by 2002:ac8:2aa9:: with SMTP id b38mr11608952qta.49.1593052933353;
        Wed, 24 Jun 2020 19:42:13 -0700 (PDT)
Received: from linux.home ([2604:2000:1344:41d:b4f5:b2c7:27bb:8a39])
        by smtp.googlemail.com with ESMTPSA id n63sm4890048qkn.104.2020.06.24.19.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 19:42:12 -0700 (PDT)
From:   Gaurav Singh <gaurav1086@gmail.com>
To:     gaurav1086@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [IPv4/IPv6]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] [net/ipv6] remove redundant null check in frag_mt6
Date:   Wed, 24 Jun 2020 22:42:05 -0400
Message-Id: <20200625024207.1625-1-gaurav1086@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fh cannot be NULL since its already checked above after
assignment and is being dereferenced before. Remove the
redundant null check.

Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
---
 net/ipv6/netfilter/ip6t_frag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index fb91eeee4a1e..3aad6439386b 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -85,8 +85,7 @@ frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		 !((fraginfo->flags & IP6T_FRAG_NMF) &&
 		   (ntohs(fh->frag_off) & IP6_MF)));
 
-	return (fh != NULL) &&
-		id_match(fraginfo->ids[0], fraginfo->ids[1],
+	return id_match(fraginfo->ids[0], fraginfo->ids[1],
 			 ntohl(fh->identification),
 			 !!(fraginfo->invflags & IP6T_FRAG_INV_IDS)) &&
 		!((fraginfo->flags & IP6T_FRAG_RES) &&
-- 
2.17.1

