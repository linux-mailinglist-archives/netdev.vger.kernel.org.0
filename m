Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B85E56E24
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbfFZP4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:56:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38094 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZP4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:56:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id d18so3340614wrs.5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BUqnnI07YLWQJFnMFajRfWqiDqFK6SzTTAM6Yhz6Kqo=;
        b=DTrX6hOX3cH6snLyrDkER0RAutBTY23zkwXAzIMl0cXisi7NnYcDe+8nFtxQIt57LP
         oZJXE//fEpjJdogL4pcHZy72BZroaJ6LEZaa665IHcDPmfl5B9/i6WcWCU6P53yAyf29
         Vw8q8et2zsLSypQjQl6t/ubHwGntOts5CfYwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BUqnnI07YLWQJFnMFajRfWqiDqFK6SzTTAM6Yhz6Kqo=;
        b=kBmaQHr7ImE2j9KEWpblNcCSYbX+GuvtA9cR6bECC4RrxpoceHvxCwVWd+wrfMqIDO
         KB9e0FAhPPjQ4F9euhop63EebXM3uf32dJsV811CA8dEbSMLbI6G1y2PusYGpeTdl1bD
         iGOOIBo/UxCP6bnM8riS/hOv8x/LR2Lm/kHYu5o6o7nbXca6GMdq6Qtp7MiUld1QwP6j
         kfqxX9ZpR+rwt1sTZZreodelYPx2PpjywjiQ362hU1t/wVhXou2UrzH6T+uBpHJSRvJx
         cHyyz+mBDyuMUDkgUPXu+QGGDGDOrl78xjwT3Y1buyA5PGHXiqi133w9sd1Kn5WmmImy
         LMYQ==
X-Gm-Message-State: APjAAAW4dGieRvSx5abRviN2cQpUbajdpNuj+1RXRtBFhaVCCxuL87G+
        R/PrboIEJs4b2zFAVCHAYVxmQEqlYvU=
X-Google-Smtp-Source: APXvYqzUECjNMozG5ItGIfwBC60KSvQalpvts35QuzJ/hnp0TjY9boWQ8XZALXFKvVQ+1GbN3qcErQ==
X-Received: by 2002:a5d:5186:: with SMTP id k6mr4551001wrv.30.1561564590240;
        Wed, 26 Jun 2019 08:56:30 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h8sm1832556wmf.12.2019.06.26.08.56.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 08:56:29 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 2/4] net: sched: em_ipt: set the family based on the packet if it's unspecified
Date:   Wed, 26 Jun 2019 18:56:13 +0300
Message-Id: <20190626155615.16639-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the family based on the packet if it's unspecified otherwise
protocol-neutral matches will have wrong information (e.g. NFPROTO_UNSPEC).
In preparation for using NFPROTO_UNSPEC xt matches.

v2: set the nfproto only when unspecified

Suggested-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 64dbafe4e94c..fd7f5b288c31 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -182,6 +182,7 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	const struct em_ipt_match *im = (const void *)em->data;
 	struct xt_action_param acpar = {};
 	struct net_device *indev = NULL;
+	u8 nfproto = im->match->family;
 	struct nf_hook_state state;
 	int ret;
 
@@ -189,10 +190,14 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	case htons(ETH_P_IP):
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return 0;
+		if (nfproto == NFPROTO_UNSPEC)
+			nfproto = NFPROTO_IPV4;
 		break;
 	case htons(ETH_P_IPV6):
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
+		if (nfproto == NFPROTO_UNSPEC)
+			nfproto = NFPROTO_IPV6;
 		break;
 	default:
 		return 0;
@@ -203,7 +208,7 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	if (skb->skb_iif)
 		indev = dev_get_by_index_rcu(em->net, skb->skb_iif);
 
-	nf_hook_state_init(&state, im->hook, im->match->family,
+	nf_hook_state_init(&state, im->hook, nfproto,
 			   indev ?: skb->dev, skb->dev, NULL, em->net, NULL);
 
 	acpar.match = im->match;
-- 
2.20.1

