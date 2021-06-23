Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2C3B1D9B
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 17:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhFWP3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 11:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFWP3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 11:29:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D599C061574
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 08:27:05 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y14so2037114pgs.12
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 08:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4gnq8BBbALgUY8fPQotVCejtztLpaOgP/XwGzQH1dk=;
        b=ACZXYai88oFpLJJbgkK7vlWUfrYuIDIiLUHWuYRMJvBzKO0v7u8OkJk9TxMZiiieNl
         wl4ZbOjRZ7K+kTkkvvwQQwF8WBuWqGta5GGKq7agGfDNv4VOoBI+fmloXHJElztO2qLv
         bAa1wfn6jP1y2U2hzwd5OpodbrtRqM6xQ66QxxxUFKEOmHchzpmXO4Zg+bf7GvNvsNRe
         Fb1uDQR9hj0qFAgGFBrurm4ex1QOueOvSkWVZVbyFJjkMg2vz+mb7SUz7E2Drrdk5HjF
         +vdoUWvgBI/XAbp78ZZCvJ6ksazHKFySTcSVJnKXM+pg3L4MdKOYE+W+60Qw1SvcZkt9
         S8nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y4gnq8BBbALgUY8fPQotVCejtztLpaOgP/XwGzQH1dk=;
        b=HWSoreYIKERMxo+DF6cnry04yam7IE6r4m+auZSVr1SwBcegWvZ5qJ4MBgOzDEztY9
         +j2olbb7Zt83nZqB0GBTSKM1hRf10thFwaOyQ2lutsAvw2DcwUjgrOgRiUTbCnE+QYRP
         4nVFeldZzuOmBWRJJREAy8qKdNevEV6qxUF00GzTe7o6f7WzUohAEdFodROjq34brhvr
         IZcqZBBpub2bwwde5XZhhZf0k2lNjO7UpmrKHm4OpCJZn4eduUcaaYSE5UDtu71F88ek
         ESysv+qyPR6fVLtQ13vKnDA9My+AilrrMI3uh6w/F3KNf39YTqTdCTtlCC5NpS2erKag
         likg==
X-Gm-Message-State: AOAM531tSwmqbXcT4nIkFCjE9TK3UkfSZd0vtCC44i92j/vIWKAVTPhr
        vgRPg4MGBIqk3rM27wZ5qR4=
X-Google-Smtp-Source: ABdhPJy9gmqieIdg+5KoZsEa6LMcBmBqYIGPclPBzHFZatbqIPA4Cy6KRSe4hPRvHDF7FOwQ7Ew4rA==
X-Received: by 2002:a65:4608:: with SMTP id v8mr22112pgq.269.1624462025055;
        Wed, 23 Jun 2021 08:27:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2053:62d5:263a:1851])
        by smtp.gmail.com with ESMTPSA id g13sm272370pfv.65.2021.06.23.08.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:27:03 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tom Herbert <tom@quantonium.net>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH net] ipv6: exthdrs: do not blindly use init_net
Date:   Wed, 23 Jun 2021 08:27:00 -0700
Message-Id: <20210623152700.1896304-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

I see no reason why max_dst_opts_cnt and max_hbh_opts_cnt
are fetched from the initial net namespace.

The other sysctls (max_dst_opts_len & max_hbh_opts_len)
are in fact already using the current ns.

Note: it is not clear why ipv6_destopt_rcv() use two ways to
get to the netns :

 1) dev_net(dst->dev)
    Originally used to increment IPSTATS_MIB_INHDRERRORS

 2) dev_net(skb->dev)
     Tom used this variant in his patch.

Maybe this calls to use ipv6_skb_net() instead ?

Fixes: 47d3d7ac656a ("ipv6: Implement limits on Hop-by-Hop and Destination options")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <tom@quantonium.net>
Cc: Coco Li <lixiaoyan@google.com>
---
 net/ipv6/exthdrs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 56e479d158b7c069000f77db88f468d9414ff7e5..6f7da8f3e2e5849f917853984c69bf02a0f1e27c 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -306,7 +306,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 #endif
 
 	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
+			  net->ipv6.sysctl.max_dst_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -1037,7 +1037,7 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
+			  net->ipv6.sysctl.max_hbh_opts_cnt)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.32.0.288.g62a8d224e6-goog

