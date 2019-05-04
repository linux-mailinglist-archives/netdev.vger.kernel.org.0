Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12FF1398D
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbfEDLrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:21 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37291 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfEDLrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:17 -0400
Received: by mail-qt1-f194.google.com with SMTP id e2so8081570qtb.4
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mJlRB/WgHuhj4gozccJ/R9oC167Q6I8i19dnHRJvyNo=;
        b=SSv4OtpV/MnkGgy+FjvJapXSrxlqbtx6oyLyanqSyNO1y9xFDHyD9tXB/FJwPUOeIr
         qtvCU/r/dI/nQlpot7Jp6OKS+wGNATkXlwdXUJBZYjbWmDfiHiB5h/lrju6tocmTcqMI
         h4tIgSRgWLiRwFce561w/pkf85hXceoaH4zVtk7Gj0mhnY+vSQh+VmL3mqChPlW5/a27
         S+qJPtXZet9Vtw2UuoVoXN6DTbQb0SYJ+nto7jjOTKZZps4d8W/i9vYbJO5/rsNO3v/V
         km7rDqAqn3swE3pL6CUwHNaZbmFANTk+tNSHDIXgIyecND3Yy8NgboaPkMtUpG+ehXBH
         ggiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mJlRB/WgHuhj4gozccJ/R9oC167Q6I8i19dnHRJvyNo=;
        b=V3ND9EUOVqVhIffyS/XQgIlyDB6V2ZRh+1NBln488Qtgvx7MKSo75Q74SKVgSRAUUW
         X7KSu5EhZ0ajc2Zo5hSeQCu4El8GFIlSneUQQGMsMw8DNWly1sQFws20TZb4SRlCRaep
         qBurF6uREeI9Ff8+rErKRtpBGL++5jw8hgio4kKrHB51tLWZuE6l90Q01/iw7gn64xIH
         4mRMbxk0HrDJqkPmP3JtsGzKpQzIQzd/WXqZPl6pASlJOxacbgbhfr5Q4wF8vWCebyb4
         CynSLB14ZBAjIqaDESeMI6f1jMhMeaxoCftj2gKWC7d6jdasuA4UaVH1CZpbXRETpUMo
         ECEA==
X-Gm-Message-State: APjAAAU8w50cGJrEtwdt0dWMsmcej8IKlwi2xMNayCiwtfVdiEunNWRx
        jat7OZLAiSnEfXZme/mH6qSkVw==
X-Google-Smtp-Source: APXvYqwc5RWK7Hw1NWOCphqtXm2GQB8Z5Ius2nw72zRJZ0EbJiOHUWwJySuW5vcRXGib2mcVR0+EFA==
X-Received: by 2002:a0c:a286:: with SMTP id g6mr12683854qva.215.1556970436486;
        Sat, 04 May 2019 04:47:16 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:16 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 08/13] net/sched: extend matchall offload for hardware statistics
Date:   Sat,  4 May 2019 04:46:23 -0700
Message-Id: <20190504114628.14755-9-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Introduce a new command for matchall classifiers that allows hardware
to update statistics.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/pkt_cls.h    |  2 ++
 net/sched/cls_matchall.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 2d0470661277..161fcf8516ac 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -760,12 +760,14 @@ tc_cls_flower_offload_flow_rule(struct tc_cls_flower_offload *tc_flow_cmd)
 enum tc_matchall_command {
 	TC_CLSMATCHALL_REPLACE,
 	TC_CLSMATCHALL_DESTROY,
+	TC_CLSMATCHALL_STATS,
 };
 
 struct tc_cls_matchall_offload {
 	struct tc_cls_common_offload common;
 	enum tc_matchall_command command;
 	struct flow_rule *rule;
+	struct flow_stats stats;
 	unsigned long cookie;
 };
 
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 87bff17ac782..da916f39b719 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -321,6 +321,23 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 	return 0;
 }
 
+static void mall_stats_hw_filter(struct tcf_proto *tp,
+				 struct cls_mall_head *head,
+				 unsigned long cookie)
+{
+	struct tc_cls_matchall_offload cls_mall = {};
+	struct tcf_block *block = tp->chain->block;
+
+	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, NULL);
+	cls_mall.command = TC_CLSMATCHALL_STATS;
+	cls_mall.cookie = cookie;
+
+	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false);
+
+	tcf_exts_stats_update(&head->exts, cls_mall.stats.bytes,
+			      cls_mall.stats.pkts, cls_mall.stats.lastused);
+}
+
 static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
 		     struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
 {
@@ -332,6 +349,9 @@ static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	if (!head)
 		return skb->len;
 
+	if (!tc_skip_hw(head->flags))
+		mall_stats_hw_filter(tp, head, (unsigned long)head);
+
 	t->tcm_handle = head->handle;
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
-- 
2.21.0

