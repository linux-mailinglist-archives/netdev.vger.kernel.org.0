Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89428699A08
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBPQ3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjBPQ3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:31 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE844C3E3
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:26 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-4fa63c84621so25826297b3.20
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UXpY1QDBt9x+f4MQsrH92T2bHcD9zbnU39pummnedWg=;
        b=SHlXcU+57gwSD/X4fens7zV84TkqwG1dymbENDZtW9uvrsz9PrRknYL4X2HOs6EYjq
         Zcvkl2fZ/atT5i+/UOK/xuim4Lvv5bh/AlYvEdqM7j2gbAPJ44wQDwCUn9YNTS23Cr4L
         /kQezFkzH8qeMrLXI4Inbclq00nIb6lWLtV5bcwOKuzkVrg7n1dTqFuNipU7oTNZ75fD
         /igzbKG8enpL5c0lUG+q+v4vhHK9Wp4e3ytwA0q60IO7IA+/01zhy46BZzqq04PuevZB
         4xcf9gTVLZ8yviu3RH9gQxnNZq0piwsOSiGRw5rtRIHqYUt/QIMP6CA+jONMcnPd3TjX
         bXZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UXpY1QDBt9x+f4MQsrH92T2bHcD9zbnU39pummnedWg=;
        b=BFAokpfEy/A2dNBbTLM3evYfn2ce/7hDAqcU6kLS93ZUo5nXwrkpSb71SBnCeqtmyx
         sQLKndVARiI32vhYb4oTF4R1jBqdFGqBW+IuO5w74VxAtrRDF+nBYEiHY4DglwXlG9nT
         /dCgmt227wtwgaZY/HQjfAUofLAAypXqVgDlJ1MN+BKI8kS6l+yW/6VZRHtrtz+sauGX
         n5ejh7O9FeUEnJnj8Mh4LnpzlrTZofdLziJ/FrUWYuhBk2Yen616PAsv8UzHr6CQmhgP
         i0E/k1R9aJS+0cAkJavILIU1Ld+fQxM7lb9fbHv2urQOwDBoPnKHJav/mekzlI8x+Hqf
         y8AA==
X-Gm-Message-State: AO0yUKXog66UYcTNE0YrtKTdG7wf50+0J5bK+6LAddD5JUgMGbSlbEAi
        ytpCM9tJIXERTD33UE3hr9x6YAFD8kZNJg==
X-Google-Smtp-Source: AK7set9207yRs1hCcf39/YY49kRgKYapCRNng5Dki2Vf1s8ELpYpjHhjLQkhd1c4GcDex6Y81pPmDoqKuohPlg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:3c2:0:b0:8c7:f99b:2a6e with SMTP id
 t2-20020a5b03c2000000b008c7f99b2a6emr13ybp.6.1676564965330; Thu, 16 Feb 2023
 08:29:25 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:41 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-8-edumazet@google.com>
Subject: [PATCH net-next 7/8] ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST
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

Hosts can often receive neighbour discovery messages
that are not for them.

Use a dedicated drop reason to make clear the packet is dropped
for this normal case.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h | 5 +++++
 net/ipv6/ndisc.c         | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 239a5c0ea83eb6053df55f1ea113f3005ec050b0..c0a3ea806cd5bf3045efd568cafb227dab7f2d3d 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -77,6 +77,7 @@
 	FN(IPV6_NDISC_HOP_LIMIT)	\
 	FN(IPV6_NDISC_BAD_CODE)		\
 	FN(IPV6_NDISC_BAD_OPTIONS)	\
+	FN(IPV6_NDISC_NS_OTHERHOST)	\
 	FNe(MAX)
 
 /**
@@ -333,6 +334,10 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_IPV6_NDISC_BAD_CODE,
 	/** @SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS: invalid NDISC options. */
 	SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS,
+	/** @SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST: NEIGHBOUR SOLICITATION
+	 * for another host.
+	 */
+	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index b47e845d66eb8533e2334915fe6f05bed6f84764..c4be62c99f7371a55e56f4489f822d9c11b007f5 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -921,8 +921,10 @@ static enum skb_drop_reason ndisc_recv_ns(struct sk_buff *skb)
 					pneigh_enqueue(&nd_tbl, idev->nd_parms, n);
 				goto out;
 			}
-		} else
+		} else {
+			SKB_DR_SET(reason, IPV6_NDISC_NS_OTHERHOST);
 			goto out;
+		}
 	}
 
 	if (is_router < 0)
-- 
2.39.1.581.gbfd45094c4-goog

