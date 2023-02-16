Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D87699A06
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBPQ33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjBPQ3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:24 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D054C3D2
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:21 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-52ee93d7863so25577227b3.18
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qU3hlD4BX0FN+8+ix3sQ8tnTKJvLCqBx8tjcQd+e/E0=;
        b=HMNmpS8lb4Adbv098J+5C8wySj5yjBN/7symAf32phic1krpVSF5JYdoZXDspQhRUZ
         4zNJtd6a8x4GBNJU6GB3EskMOgnIJoKOcDRCpNlKi6GgbLHkOx2vyzhwNZal3WMne0vB
         WAupmPqCkF0y2R4AM+ITIQ2EP1x5G3w+fapjynlEHYF93P8bJsWvAfjBXx1/t/YO1AuS
         qQQOP2QgQEIHOXVt3YBYFYPUoPjW4Sl19JSPruT/Agn5RyewiyfKrHI21F9G4QG0GWPZ
         0dhW1J1a0OhdpIkpCyL0jybbKH+NFivXOeyABEEA/1qI6IDbCfRM8CX1xmo2sdboatMO
         IhDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qU3hlD4BX0FN+8+ix3sQ8tnTKJvLCqBx8tjcQd+e/E0=;
        b=b/oD1FYtktxY6U3bRto9FLwigMwzqj3WJcP9nAuOHTe03yDN4MZcMra04fXWJmze15
         qFjTsLt6Y8vzidBbcFUVAlmwjtFxlAZ1y02AnVmmHlxYbs9DUUnWSQa+PJwmte3/caxv
         4cMBqbEBQETF6papM9IZkVXAUBWBgbeM2e+Mu81uAZnva73baGI6q081D/A/f05glRV6
         hv0Hz/2caiS5O5Cq5eTbuu9a0O0ae4/4RDcd2HEJrmTxRlrD6/w4SEBWQi6aK9jeX4jJ
         tTwitmppRxsEW+EFn5RAoHkqPENz3Amt5V8ureOteE/CRPtfKeP+dSfVQj0/R8/bRHWG
         4kXw==
X-Gm-Message-State: AO0yUKW5oPCxi190sA6Ab0JLvpoW7rHRGDOGMjDAaz0cIEBS9llfoNAR
        2f2twp0d2IerJVfsAI7jQiUh51k3HoLm5w==
X-Google-Smtp-Source: AK7set+QfuQdqwL1OJ8DhV0f8s43poKTM7iquoh/79hBVrBkqBOyWsL6jVZVuN8VGZ7TEPODbNrbHMfX2sWogw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:481:0:b0:916:20df:c31a with SMTP id
 n1-20020a5b0481000000b0091620dfc31amr893131ybp.627.1676564961216; Thu, 16 Feb
 2023 08:29:21 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:39 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-6-edumazet@google.com>
Subject: [PATCH net-next 5/8] ipv6: icmp6: add drop reason support to ndisc_redirect_rcv()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change ndisc_redirect_rcv() to return a drop reason.

For the moment, return PKT_TOO_SMALL, NOT_SPECIFIED
and values from icmpv6_notify().

More reasons are added later.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ndisc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 7c8ba308ea4979f46cb22d0132b559278b927a5f..e9776aa6f1675e35273df16e40745779b91d117e 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1601,13 +1601,14 @@ static enum skb_drop_reason ndisc_router_discovery(struct sk_buff *skb)
 	return reason;
 }
 
-static void ndisc_redirect_rcv(struct sk_buff *skb)
+static enum skb_drop_reason ndisc_redirect_rcv(struct sk_buff *skb)
 {
-	u8 *hdr;
-	struct ndisc_options ndopts;
 	struct rd_msg *msg = (struct rd_msg *)skb_transport_header(skb);
 	u32 ndoptlen = skb_tail_pointer(skb) - (skb_transport_header(skb) +
 				    offsetof(struct rd_msg, opt));
+	struct ndisc_options ndopts;
+	SKB_DR(reason);
+	u8 *hdr;
 
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	switch (skb->ndisc_nodetype) {
@@ -1615,31 +1616,31 @@ static void ndisc_redirect_rcv(struct sk_buff *skb)
 	case NDISC_NODETYPE_NODEFAULT:
 		ND_PRINTK(2, warn,
 			  "Redirect: from host or unauthorized router\n");
-		return;
+		return reason;
 	}
 #endif
 
 	if (!(ipv6_addr_type(&ipv6_hdr(skb)->saddr) & IPV6_ADDR_LINKLOCAL)) {
 		ND_PRINTK(2, warn,
 			  "Redirect: source address is not link-local\n");
-		return;
+		return reason;
 	}
 
 	if (!ndisc_parse_options(skb->dev, msg->opt, ndoptlen, &ndopts))
-		return;
+		return reason;
 
 	if (!ndopts.nd_opts_rh) {
 		ip6_redirect_no_header(skb, dev_net(skb->dev),
 					skb->dev->ifindex);
-		return;
+		return reason;
 	}
 
 	hdr = (u8 *)ndopts.nd_opts_rh;
 	hdr += 8;
 	if (!pskb_pull(skb, hdr - skb_transport_header(skb)))
-		return;
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
 
-	icmpv6_notify(skb, NDISC_REDIRECT, 0, 0);
+	return icmpv6_notify(skb, NDISC_REDIRECT, 0, 0);
 }
 
 static void ndisc_fill_redirect_hdr_option(struct sk_buff *skb,
@@ -1855,7 +1856,7 @@ enum skb_drop_reason ndisc_rcv(struct sk_buff *skb)
 		break;
 
 	case NDISC_REDIRECT:
-		ndisc_redirect_rcv(skb);
+		reason = ndisc_redirect_rcv(skb);
 		break;
 	}
 
-- 
2.39.1.581.gbfd45094c4-goog

