Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EA656821
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfFZMBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:01:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34761 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZMBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:01:05 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so4478278wmd.1
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gUAsyBC+YyCn6Chz7Qnk989iaecFlEUtVr7lsQ7ziVw=;
        b=D3aPt8/M7dlnGwHdMMjOJ6+zEV+tnY5tR+8OlimQXLAdCABGG6NqIhgjwSPmpu4cfB
         c5mpBMktTLpHZ6iBtGnT0Y14q1Qw90kVlLQMA0T2NJjKmRBcQ3o1CHDeqzL3uxQ5yAaa
         kT/8BxfrBOULiiy7q662mSSGdevMFFZFzYA5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gUAsyBC+YyCn6Chz7Qnk989iaecFlEUtVr7lsQ7ziVw=;
        b=QrdSjicfAsqmKc90QJiiNNCpImU/U2plc9es+/vnoFwG1hs9Pii4q7KmA2MYPPpo3U
         NBzIx8TrWvA/1UfqrqB3D04M3NCvUaff0SJuEfyacrbOPmti1r3rrVALyPWqg6+Gcu56
         UzIviROwwel8hTnTd0SPMwygse4a27fsQ9iSjccmiAHhSCqKxB6k1asq+VgBYLBH82N7
         Ol769fNHd+WeykleK+Uo9eahZqQGKVuX+uIyTI24Rv2SmtjCaEGolhfozPDr6DDuc7X4
         0L/Z6QU6+1Ro/c8xkfHrlv3B4OG7KSdmsXsIgJCUiAbP1d16H4AIK70RVPlXHk7WW2UI
         MNxA==
X-Gm-Message-State: APjAAAVEH2E8AvOSfDoTDrLbSZDt/s7LL79Pjrg/kaSiXl7YomAmdxlO
        aKZJaLrasWntaNeL6QCSh9m4rtwWiUI=
X-Google-Smtp-Source: APXvYqy7a1yqcvajdECGqvpDuCSkHeKB4s+Rkvk/oRwrrdOqifTM2m32mhuol+Z7cT+8s4QVdTHZyQ==
X-Received: by 2002:a05:600c:214e:: with SMTP id v14mr2612118wml.96.1561550463236;
        Wed, 26 Jun 2019 05:01:03 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id f190sm1676818wmg.13.2019.06.26.05.01.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:01:02 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 1/5] net: sched: em_ipt: match only on ip/ipv6 traffic
Date:   Wed, 26 Jun 2019 14:58:51 +0300
Message-Id: <20190626115855.13241-2-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
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

