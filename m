Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 098915681E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfFZMBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:01:09 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35311 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZMBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:01:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id f15so2446371wrp.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ai3FeunYCpfKeTd/zNryFE9l4/0ZIZ4EfuS3mJJ2Q80=;
        b=QO+cJqgDgbEMPZyLd3OEQrQN49q2odfXwaMbDOtDf+DxpJI2/JoY0zGCVxJiHH8KIk
         IqbuG6yPzAPQfk4q7ChhWG4jxSKyv/iO+Y7OU/hlnevxY4mbp9s+dYw9HBgoHGNv4Tsv
         7EKDXrInAnkTOyS7b4M/Dhp0o3ogVLvHnoxQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ai3FeunYCpfKeTd/zNryFE9l4/0ZIZ4EfuS3mJJ2Q80=;
        b=p8px/ilKxq/ZPn7rA+trGFbTz31SEDxX+Go3QorbysCHcz2M/BQwS6W7DH5rZMtxnQ
         Vm1nytCLg85Qg4N9gBJiUEf0rCZXBl2xfYgF8dmCZ135f7rp1tgQQdux+hrIh7GPeWpA
         eHMPnFC0pCzGYOpJIeJ0mZrJtza3dIo2sTer33/HA4lemF9/i9Ocp6Z3j+4ws9rGWBpN
         y9qmwOuDoHfKrQZRS/WFpOruW4Ay0JlFCAYCWGtHkYOivHBrm+ZWe/xj5qhmjT95eEwY
         zCHCB/JBBg12GZfDd/Dr/kJ8ijXG/jTcOr+T8tPHZXMSQPI7NIJDMvK7/6XxWIV/P0G8
         G4Wg==
X-Gm-Message-State: APjAAAXz+N3oACj7cXG6+Ww1I9bdGkncrMLzH0+up3rtrF8NbEoyqLYz
        4/qr9iIW1LwH1xWdymRFAaYvwbZ8IPg=
X-Google-Smtp-Source: APXvYqyEzC0gNJjXiXMl9WmIAEN1Us0MBg8M+ENNr+aB/jzDqd2oy2U+9Hjf8r8g/fK0urCAJE8DTg==
X-Received: by 2002:a05:6000:106:: with SMTP id o6mr3555560wrx.4.1561550464599;
        Wed, 26 Jun 2019 05:01:04 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id f190sm1676818wmg.13.2019.06.26.05.01.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:01:04 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 2/5] net: sched: em_ipt: set the family based on the protocol when matching
Date:   Wed, 26 Jun 2019 14:58:52 +0300
Message-Id: <20190626115855.13241-3-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the family based on the protocol otherwise protocol-neutral matches
will have wrong information (e.g. NFPROTO_UNSPEC). In preparation for
using NFPROTO_UNSPEC xt matches.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 64dbafe4e94c..23965a071177 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -189,10 +189,12 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	case htons(ETH_P_IP):
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return 0;
+		state.pf = NFPROTO_IPV4;
 		break;
 	case htons(ETH_P_IPV6):
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
+		state.pf = NFPROTO_IPV6;
 		break;
 	default:
 		return 0;
@@ -203,7 +205,7 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	if (skb->skb_iif)
 		indev = dev_get_by_index_rcu(em->net, skb->skb_iif);
 
-	nf_hook_state_init(&state, im->hook, im->match->family,
+	nf_hook_state_init(&state, im->hook, state.pf,
 			   indev ?: skb->dev, skb->dev, NULL, em->net, NULL);
 
 	acpar.match = im->match;
-- 
2.20.1

