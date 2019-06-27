Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7DF57E00
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfF0INK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:13:10 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37312 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbfF0INI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:13:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id v14so1422643wrr.4
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HrZKo6Aol0PYOCPda411SrRBU1eZ+Kl41QmWjghT0dk=;
        b=cWTgxmhlpJBs4RuTOVnxXIWzSx7slZAgDDtonIxXzQLTVUY0dZPFSbPOrEIsq1+NJx
         7AJqM3fYzR/vO+mo/L0QNwT4vdFzFyJRaGy2Gd3NLj/gdBe5qc42x/UVhNEBDsefxxkX
         g5xJRVWN5bzspHzb4pc7AYYgnGQxRsnA/i6ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HrZKo6Aol0PYOCPda411SrRBU1eZ+Kl41QmWjghT0dk=;
        b=EjobhaY+EoEWFCS5ORcLqgRaKTPzZJSLChgWCVCLT9rmdyu557H5Hcj0E91SpX7M81
         UanY17CVZQfvA991onETgowPixW3woyljbqv2wjMANfjYoBrJY5beZOkGrdfsgIWSdtZ
         w4Zf+byAgHe8A+s+MWvQ2+5e93fWsTmboWUYVub65vGJ1KjvzToKBT72P9+5d2qLiG7h
         XhuySv2t4pFhgXPXM9eDTFKKBrnGV4wetcWaUbzf8mssxvxDzPN5dOsvrOIdfzwxmBMZ
         d1PAklEWqW3TW7XH2kgz14Ky88xdgyrGjdslMafqaqiIwUaMvL3mtORlrAZZnkQoTKVG
         W/iQ==
X-Gm-Message-State: APjAAAUGUO4r2CRFegBB4ZNwOvcGYZF3iUIQxQokqQBiVyCv0EF0327G
        P9c8qJ3EuOSDZAu/EnGg3P5Fq3OWzXo=
X-Google-Smtp-Source: APXvYqwa/hwpy+lu82hZc8N6aOXtd6Ro7DWayAJtueyaqVEtF8/ZjgAswjY7iEmI1WRnvd8nk/b9fg==
X-Received: by 2002:adf:dfc5:: with SMTP id q5mr2164949wrn.142.1561623186896;
        Thu, 27 Jun 2019 01:13:06 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o6sm6969949wmc.15.2019.06.27.01.13.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 01:13:06 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 2/4] net: sched: em_ipt: set the family based on the packet if it's unspecified
Date:   Thu, 27 Jun 2019 11:10:45 +0300
Message-Id: <20190627081047.24537-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
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
v3: no change

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
2.21.0

