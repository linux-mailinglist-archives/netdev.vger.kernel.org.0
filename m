Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBA56E25
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfFZP4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:56:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36936 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfFZP4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:56:31 -0400
Received: by mail-wr1-f66.google.com with SMTP id v14so3347805wrr.4
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUAsyBC+YyCn6Chz7Qnk989iaecFlEUtVr7lsQ7ziVw=;
        b=YmES0KER0R2TOKiGGHD2K8qfMbDIiz+ro3gFIrm2UMBKpugezOq9mtOFdTf3+7yrpL
         80qNtqimm6oambAmMvURmycx3FX1IU9aBdVzcb2CbopcE2eT7+K0rZqPHLC0sPa70HJb
         UUxBcvYK0+tOpe0XpaH93+eq9Bm44yud2Gpns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUAsyBC+YyCn6Chz7Qnk989iaecFlEUtVr7lsQ7ziVw=;
        b=PjthsaCqmMI3OPlWxq9Iz5aU7QI9hzhM8ORCmabaYT17qtT4bqRN1I5ehnxtP72Zio
         eDSmUdSWk5ud0q9D5VLaC7if1w/dedwRIfO8rzLGHWW0ctPGvBp95ugT3RL4kfUIxb31
         ZBZAf0CzatGTH1MR9BrFGz9jfQsQdBt75XRmSUHP1tAl9snhFxVH8jzBhf9z/x3Z8Hks
         3k+B6oAt18G/97vuok+xv9cWFolsREWu+3zRr+UfQfXPWJ0ij9ZLI0SSePEfIbb4oaHQ
         b8pEQ1bE6MNmiCiDODXogTm6LNA34Xst36Q9KyfUku7CZr9paL9M9lw9KZ40QAFnRak6
         6ERQ==
X-Gm-Message-State: APjAAAXDdLff1TF7M7345XE0YNTrMNVj3KBri3etMBnA3oq4CV+4VHUz
        1FDnoK7/ii/2gBZpPYY016IvNCcOtdY=
X-Google-Smtp-Source: APXvYqy9z4YNizovKB16aNtR6Iapn8pmzUwPRsmQsvkY2jBvpESH0Fu3fR9m1rXnVepXncuqOfD4Mw==
X-Received: by 2002:a5d:4642:: with SMTP id j2mr3955297wrs.211.1561564589161;
        Wed, 26 Jun 2019 08:56:29 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h8sm1832556wmf.12.2019.06.26.08.56.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 08:56:28 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 1/4] net: sched: em_ipt: match only on ip/ipv6 traffic
Date:   Wed, 26 Jun 2019 18:56:12 +0300
Message-Id: <20190626155615.16639-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Restrict matching only to ip/ipv6 traffic and make sure we can use the
headers, otherwise matches will be attempted on any protocol which can
be unexpected by the xt matches. Currently policy supports only ipv4/6.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index 243fd22f2248..64dbafe4e94c 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -185,6 +185,19 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	struct nf_hook_state state;
 	int ret;
 
+	switch (tc_skb_protocol(skb)) {
+	case htons(ETH_P_IP):
+		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+			return 0;
+		break;
+	case htons(ETH_P_IPV6):
+		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
+			return 0;
+		break;
+	default:
+		return 0;
+	}
+
 	rcu_read_lock();
 
 	if (skb->skb_iif)
-- 
2.20.1

