Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50308699A04
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBPQ3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 11:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBPQ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 11:29:19 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949F93D0A3
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:18 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-527501b56ffso25479177b3.15
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 08:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i/MC5TmYp0neOUTobGzd9tXonCwOJXMvaxmwjYdzPqU=;
        b=fN94D7zxBrPS0yuo22Wf7aY85PontTnDnZScllx5pMSLx5WHxE+k3fbWVfgq/oEfYf
         cePYUftLPl7wU2LP1pdIk3yFuE0cyGlLAJc2ql9CMhLwY3Y/W1+6VOg9Embjm4BFGq+6
         7BOtksvXfXpynymKtbtoBzv6KT2tl5SuuNgkARwtBxY4sU+zCusdYDAnMerQ5oR4+xvk
         qq5GMcIoyjF8Sw7muoe5ugL0/rhIJUctcVV3pzBscTvHVr1MhuZ/tVG+n2a0mvfypmSS
         YpzaYQNHG2vD1gbulTBGyfTovTPTTnUjL3SKKCdtcqz4MxPi2VEF3fDoGdeQj5hev06t
         iRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/MC5TmYp0neOUTobGzd9tXonCwOJXMvaxmwjYdzPqU=;
        b=jpk/T1Wiq6TD4UtsR6esitcBwQiiaxtVJC1OEV1u3ix+bm7fxkklvWMRTMZviXF8Oc
         cQgZ0syR5CoxKDwsixLVkoQlMoYwPi+8YVAjXXROM7IPwkP5BOfUnS9pyigW7J8yMDuk
         C0DO0Om40z4a4Cv6OwD608seQBBatp9D2e4yxMPWU/nWWzDX+nhquWBzyj9mUW2VSMHo
         a4nXPSegDkrcrlHJOGEd5dcdNnXNmCSESoAPBdWYkFC6BastUnWYk8eKyaUlFM0dSYVh
         tVQnCqlsFbMFz88K7ZtV3aPIZpIH27pEBXsMFjnnsq0D2pugeFh3KcV9EGASjdxH9WRB
         ShSw==
X-Gm-Message-State: AO0yUKXePuuspRS5XXHhXrUEhk6rkubGGzTxtoPm2R9lPOuH+o/VBrNT
        fvZPBG2KG5jJB5KsebVNtxv9iyP19pSWug==
X-Google-Smtp-Source: AK7set8HgVzpRlcX6u9ZY0jm5Ki2JPKtn74RE8RZqiGsj2efjG6cwaJhF1kUFzpfwxOI89X+VBdLtd67UWJgRg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:af4d:0:b0:52e:b635:5496 with SMTP id
 x13-20020a81af4d000000b0052eb6355496mr14ywj.2.1676564957355; Thu, 16 Feb 2023
 08:29:17 -0800 (PST)
Date:   Thu, 16 Feb 2023 16:28:37 +0000
In-Reply-To: <20230216162842.1633734-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230216162842.1633734-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230216162842.1633734-4-edumazet@google.com>
Subject: [PATCH net-next 3/8] ipv6: icmp6: add drop reason support to ndisc_recv_rs()
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

Change ndisc_recv_rs() to return a drop reason.

For the moment, return PKT_TOO_SMALL, NOT_SPECIFIED
or SKB_CONSUMED. More reasons are added later.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ndisc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 9354cb3669c814166fb3d07b32097f0b00ef42f8..514eb8cc78792445dedead3cf0b49df696ce2785 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1127,7 +1127,7 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 	return reason;
 }
 
-static void ndisc_recv_rs(struct sk_buff *skb)
+static enum skb_drop_reason ndisc_recv_rs(struct sk_buff *skb)
 {
 	struct rs_msg *rs_msg = (struct rs_msg *)skb_transport_header(skb);
 	unsigned long ndoptlen = skb->len - sizeof(*rs_msg);
@@ -1136,14 +1136,15 @@ static void ndisc_recv_rs(struct sk_buff *skb)
 	const struct in6_addr *saddr = &ipv6_hdr(skb)->saddr;
 	struct ndisc_options ndopts;
 	u8 *lladdr = NULL;
+	SKB_DR(reason);
 
 	if (skb->len < sizeof(*rs_msg))
-		return;
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
 
 	idev = __in6_dev_get(skb->dev);
 	if (!idev) {
 		ND_PRINTK(1, err, "RS: can't find in6 device\n");
-		return;
+		return reason;
 	}
 
 	/* Don't accept RS if we're not in router mode */
@@ -1178,9 +1179,10 @@ static void ndisc_recv_rs(struct sk_buff *skb)
 			     NEIGH_UPDATE_F_OVERRIDE_ISROUTER,
 			     NDISC_ROUTER_SOLICITATION, &ndopts);
 		neigh_release(neigh);
+		reason = SKB_CONSUMED;
 	}
 out:
-	return;
+	return reason;
 }
 
 static void ndisc_ra_useropt(struct sk_buff *ra, struct nd_opt_hdr *opt)
@@ -1844,7 +1846,7 @@ enum skb_drop_reason ndisc_rcv(struct sk_buff *skb)
 		break;
 
 	case NDISC_ROUTER_SOLICITATION:
-		ndisc_recv_rs(skb);
+		reason = ndisc_recv_rs(skb);
 		break;
 
 	case NDISC_ROUTER_ADVERTISEMENT:
-- 
2.39.1.581.gbfd45094c4-goog

