Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F106925B9
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbjBJSrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbjBJSr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:47:28 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7057D89F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:16 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h14-20020a258a8e000000b00827819f87e5so5754559ybl.0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e785GXmwvfzSmYLbbVI+1VOE0+IiwBRivxOEtEcnzBE=;
        b=T14yPmxA3FhQX2aejEdc3PYQZpsY3QkQzajCC68SPxDKTUk11mun3Bf0bacYx4DdQY
         TkwiHeSXMxiVFwCotYWid48q6W+0mgkMub2lkX/D9X4ALcTNRUWL86DGcx/vc0EurxsF
         ZkUUQ8Q1/lcz4FchPeTjYKYqDm0xjxP6B76W6aHG9obXaUzZLQjEKbL+GskSiRr+FDui
         EeBzikNPGKkq5IJcAQsm69rCjUxVcRyP4kMrSneh/CaLn9lG4qk0fQJQw6q+oV+dZLO8
         XMkiceeRQIXORYm16GAyf+lRvnqRhh5KiINg+ZT23VyRvhb11dpZO1Z6BLI7aIuZnvNX
         KSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e785GXmwvfzSmYLbbVI+1VOE0+IiwBRivxOEtEcnzBE=;
        b=Fs9d+v+/l0Tymt57crd1IhM5qsu/s2/815PEFOkagzqHMug7xNAzaV2LqHfuLKSSdM
         mRnXiKU7kjxYJTAJMwZCOMKubxSZo5RLooT+3FyZ8jXr3GSDOzyGmwXAM061hvh6bsqC
         FXbZirDdTVAhJhb6pb2U+s5CE0RILK+HS+oO2e2OZuYIlByjAZH19idH/elLpIeunF0C
         eMKPvlq+2MmzP0Oe0rmErEglBjP1d0nTY9YkYUdi/4zZWhlSXmcOrJrPdeztxTmRjkQ4
         LwIqQSi6BzYU5FZwe6E74SP7gGidiAf8B9dnpy1MW263sCjXzVhISYx/MxTg26jvVBxw
         31kg==
X-Gm-Message-State: AO0yUKXry/3KNmn21w6V7XYsnAAUKltpsQSHFsi0AMFfLs1wOg+R16UX
        +LmITv93K46T637u6uIgGZAKRtHg1XzC3A==
X-Google-Smtp-Source: AK7set+sFrYBL5fjvNCsztBbEkZs260RZXADqRfA9qm2IKsaQwytyOk4Fwep/kGbdO+fsKh4Nqi62yY/Dd910A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4f3:b0:8f2:34b3:fc47 with SMTP
 id w19-20020a05690204f300b008f234b3fc47mr193758ybs.10.1676054835323; Fri, 10
 Feb 2023 10:47:15 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:47:07 +0000
In-Reply-To: <20230210184708.2172562-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230210184708.2172562-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210184708.2172562-4-edumazet@google.com>
Subject: [PATCH net-next 3/4] ipv6: icmp6: add drop reason support to icmpv6_notify()
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

Accurately reports what happened in icmpv6_notify() when handling
a packet.

This makes use of the new IPV6_BAD_EXTHDR drop reason.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h |  3 ++-
 net/ipv6/icmp.c    | 25 +++++++++++++++++--------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 03f3af02a9a645b49c1de1272caf5d8d8277d0c1..7332296eca44b84dca1bbecb545f6824a0e8ed3d 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -436,7 +436,8 @@ static inline void fl6_sock_release(struct ip6_flowlabel *fl)
 		atomic_dec(&fl->users);
 }
 
-void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info);
+enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
+				   u8 code, __be32 info);
 
 void icmpv6_push_pending_frames(struct sock *sk, struct flowi6 *fl6,
 				struct icmp6hdr *thdr, int len);
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index c9346515e24dabce3aae642bfca4fb4eae4c3533..40bb5dedac09e4e4f3bd15944538c4324d028674 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -813,16 +813,19 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
 	local_bh_enable();
 }
 
-void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
+enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
+				   u8 code, __be32 info)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
+	struct net *net = dev_net(skb->dev);
 	const struct inet6_protocol *ipprot;
+	enum skb_drop_reason reason;
 	int inner_offset;
 	__be16 frag_off;
 	u8 nexthdr;
-	struct net *net = dev_net(skb->dev);
 
-	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+	reason = pskb_may_pull_reason(skb, sizeof(struct ipv6hdr));
+	if (reason != SKB_NOT_DROPPED_YET)
 		goto out;
 
 	seg6_icmp_srh(skb, opt);
@@ -832,14 +835,17 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 		/* now skip over extension headers */
 		inner_offset = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr),
 						&nexthdr, &frag_off);
-		if (inner_offset < 0)
+		if (inner_offset < 0) {
+			SKB_DR_SET(reason, IPV6_BAD_EXTHDR);
 			goto out;
+		}
 	} else {
 		inner_offset = sizeof(struct ipv6hdr);
 	}
 
 	/* Checkin header including 8 bytes of inner protocol header. */
-	if (!pskb_may_pull(skb, inner_offset+8))
+	reason = pskb_may_pull_reason(skb, inner_offset + 8);
+	if (reason != SKB_NOT_DROPPED_YET)
 		goto out;
 
 	/* BUGGG_FUTURE: we should try to parse exthdrs in this packet.
@@ -854,10 +860,11 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 		ipprot->err_handler(skb, opt, type, code, inner_offset, info);
 
 	raw6_icmp_error(skb, nexthdr, type, code, inner_offset, info);
-	return;
+	return SKB_CONSUMED;
 
 out:
 	__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+	return reason;
 }
 
 /*
@@ -953,7 +960,8 @@ static int icmpv6_rcv(struct sk_buff *skb)
 	case ICMPV6_DEST_UNREACH:
 	case ICMPV6_TIME_EXCEED:
 	case ICMPV6_PARAMPROB:
-		icmpv6_notify(skb, type, hdr->icmp6_code, hdr->icmp6_mtu);
+		reason = icmpv6_notify(skb, type, hdr->icmp6_code,
+				       hdr->icmp6_mtu);
 		break;
 
 	case NDISC_ROUTER_SOLICITATION:
@@ -995,7 +1003,8 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		 * must pass to upper level
 		 */
 
-		icmpv6_notify(skb, type, hdr->icmp6_code, hdr->icmp6_mtu);
+		reason = icmpv6_notify(skb, type, hdr->icmp6_code,
+				       hdr->icmp6_mtu);
 	}
 
 	/* until the v6 path can be better sorted assume failure and
-- 
2.39.1.581.gbfd45094c4-goog

