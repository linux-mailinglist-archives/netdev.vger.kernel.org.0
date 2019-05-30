Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54B72FF66
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 17:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfE3P10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 11:27:26 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46598 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfE3P1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 11:27:25 -0400
Received: by mail-pg1-f195.google.com with SMTP id v9so2202834pgr.13;
        Thu, 30 May 2019 08:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/Pn5l7Gl3fvih/5a8ecI7LW5krUKtJRfsuSUzHjs23s=;
        b=gpP2jFgtCJLEB0MnQDyz47dV/7gnyYt1BYPZpOKP9dg6hZigrNid6HaEfleX8rBhDT
         2CMbnqRfJSPZU49ILILmeW18onoEXeSLtwwUgj14BpokFfGihmaEgN1O84ORiKN5g7AU
         rSjVJZGa1KyvV5SoV6BMW7GQJwfsfw+f9xGQZPws4NCbe7OyU5qm2lhndbFGJAASQCJd
         GONqeXBIkUhBF8bXKRP5HQVoPTcHAXr/Xa7pGfKov1ZrDlzKxpwMOMuNMXNOxvsebNFm
         WXgy3x4rlvFU//rUsD8CoYwPyg0aLzvgBb5aFcfFgu6FeSFEk/6yr5SzRtXeyZgLbcVs
         0Mpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/Pn5l7Gl3fvih/5a8ecI7LW5krUKtJRfsuSUzHjs23s=;
        b=o41NbF4V6onCplPqdHA7MHanCVath9pVyugj2xCZyj9lW2OoFwyx8j714KBPznrE1S
         1BDmF71mx8ewWdlqaKsmdPWYdoslUlvTkERixluO0bIiweQ6RxfZP0Mk0yCtUJg4UByG
         NNskUjua2tuNutKKS68xw0BcMHkldoFNLVM0ac6B7WjuwcifWp88mbz0xomfrPfgroSi
         kmI0TGR0gvR+VUtrBsp6DjKv/CRrQZp30qhE39XlUe+NUNCQud2skX9dRk28F0yl9SQa
         jlChXxoIhV1Y+qDL1jio6CkssLoWk06a1wFm6UPOw4YLokUs2Z9hlskyQ61sRDZmuY03
         qWww==
X-Gm-Message-State: APjAAAW+Ezj3RJNT5ZL2eJx155F0VZGciCORxlw0WNGJ5EdH4ntomAXX
        fWzR2cNXb9rJzGa3L7+bSdU=
X-Google-Smtp-Source: APXvYqwJ7xSLFQLOkGndSn8SMMOb04mrm4o41TpHVluzE92VccrJo04wRYcNI3pBU0fXADZ0SYcZAw==
X-Received: by 2002:a17:90a:6505:: with SMTP id i5mr2443651pjj.13.1559230045287;
        Thu, 30 May 2019 08:27:25 -0700 (PDT)
Received: from xy-data.openstacklocal (ecs-159-138-22-150.compute.hwclouds-dns.com. [159.138.22.150])
        by smtp.gmail.com with ESMTPSA id s28sm2750518pgl.88.2019.05.30.08.27.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 08:27:24 -0700 (PDT)
From:   Young Xiao <92siuyang@gmail.com>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>
Subject: [PATCH] ipv6: Prevent overrun when parsing v6 header options
Date:   Thu, 30 May 2019 23:28:18 +0800
Message-Id: <1559230098-1543-1-git-send-email-92siuyang@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fragmentation code tries to parse the header options in order
to figure out where to insert the fragment option.  Since nexthdr points
to an invalid option, the calculation of the size of the network header
can made to be much larger than the linear section of the skb and data
is read outside of it.

This vulnerability is similar to CVE-2017-9074.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
---
 net/ipv6/mip6.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 64f0f7b..30ed1c5 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -263,8 +263,6 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 			       u8 **nexthdr)
 {
 	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
 	const unsigned char *nh = skb_network_header(skb);
 	unsigned int packet_len = skb_tail_pointer(skb) -
 		skb_network_header(skb);
@@ -272,7 +270,8 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 
 	*nexthdr = &ipv6_hdr(skb)->nexthdr;
 
-	while (offset + 1 <= packet_len) {
+	while (offset <= packet_len) {
+		struct ipv6_opt_hdr *exthdr;
 
 		switch (**nexthdr) {
 		case NEXTHDR_HOP:
@@ -299,12 +298,15 @@ static int mip6_destopt_offset(struct xfrm_state *x, struct sk_buff *skb,
 			return offset;
 		}
 
+		if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
+			return -EINVAL;
+
+		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 		offset += ipv6_optlen(exthdr);
 		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 	}
 
-	return offset;
+	return -EINVAL;
 }
 
 static int mip6_destopt_init_state(struct xfrm_state *x)
@@ -399,8 +401,6 @@ static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
 			     u8 **nexthdr)
 {
 	u16 offset = sizeof(struct ipv6hdr);
-	struct ipv6_opt_hdr *exthdr =
-				   (struct ipv6_opt_hdr *)(ipv6_hdr(skb) + 1);
 	const unsigned char *nh = skb_network_header(skb);
 	unsigned int packet_len = skb_tail_pointer(skb) -
 		skb_network_header(skb);
@@ -408,7 +408,8 @@ static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
 
 	*nexthdr = &ipv6_hdr(skb)->nexthdr;
 
-	while (offset + 1 <= packet_len) {
+	while (offset <= packet_len) {
+		struct ipv6_opt_hdr *exthdr;
 
 		switch (**nexthdr) {
 		case NEXTHDR_HOP:
@@ -434,12 +435,15 @@ static int mip6_rthdr_offset(struct xfrm_state *x, struct sk_buff *skb,
 			return offset;
 		}
 
+		if (offset + sizeof(struct ipv6_opt_hdr) > packet_len)
+			return -EINVAL;
+
+		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 		offset += ipv6_optlen(exthdr);
 		*nexthdr = &exthdr->nexthdr;
-		exthdr = (struct ipv6_opt_hdr *)(nh + offset);
 	}
 
-	return offset;
+	return -EINVAL;
 }
 
 static int mip6_rthdr_init_state(struct xfrm_state *x)
-- 
2.7.4

