Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC75196714
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 16:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgC1Phs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 11:37:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47006 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgC1Phs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 11:37:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id j17so15316277wru.13
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 08:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ft0p5a7vw8g+de/0m8eIXpy+yOZW6EhUGJa/NIAq91g=;
        b=K6L9ztGLQKJGb4XAK7LqREGDvEs5qCjNWvhVV8a6el5jjPIv/IkQV7/LYdMoaTL0zc
         Rk9+A3SMMbc2/S9HyDGcE/EKf9KVx10lMaTWdOnNruFGqL7vifjVsiTkiXMQ+3KVozfZ
         VANBhawYZ8vQcfQevIEA/xxBwRqGFr14nLcrK9fh/RCY3SJMpNxyvDLS4q1tDFDGLcEB
         sQkUDnTswqXGKLcW6S3dfcn3dXiviJv9t+MKIjEfdLfAsgN2LFV6XlFAldd03C6qthlI
         n4NOvctsth4t86TBGYO6q5AOqpkzo+uUCWqrRCvEXVXDR0M3txmqtjlh6VH4cGUCdffo
         G3mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ft0p5a7vw8g+de/0m8eIXpy+yOZW6EhUGJa/NIAq91g=;
        b=Ytno57lYVGvYhPnkq7I4JRq2S8iPYL7EhAKWswZAWqjcSEfpPyoEeGPcJq2TZ5tFmJ
         gqf20CRMtVn/zyVSi948E2XqAVScZbj3IBxFfzh88vNC/kM0Y0sK2T0tp/8ZOifO98gn
         0Ps8MCqnecTHOra+9qJIugh0RNc++nPfR1rVbK4gsQ+VsK7GBsBXuCWsKm/y2zVuOqg6
         Zd3ctnM5wVuVzvuDp6ZPdqfvtc3ajqLHngiDUD1DFt2+RHyjWNwb1dorN3MregG9jy7x
         QUjxhWfF0h3N6LMt2dMuLBENg7Uq0UQykTmZ0pQBakrcRCedJGyv2nrhI0VDdzuTJ2cE
         yXxA==
X-Gm-Message-State: ANhLgQ12ysPj1M1O8AEgRFQx+MChlQ6L87TA+os/PmUF5xqXVEJ07HMk
        ImEj4UU2UrBJ6eQRz+pxxfBolmap4iQ=
X-Google-Smtp-Source: ADFU+vs4XBfIv8DlQ3yUI7h/VdUNV2NLZaGRbgA15XvhNt5NVnlLwFrwl6OEr/2Od5zqKiY/KXZzag==
X-Received: by 2002:adf:8364:: with SMTP id 91mr5647372wrd.251.1585409865802;
        Sat, 28 Mar 2020 08:37:45 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f22sm19839729wmf.2.2020.03.28.08.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 08:37:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, leon@kernel.org, michael.chan@broadcom.com,
        vishal@chelsio.com, pablo@netfilter.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, paulb@mellanox.com,
        alexandre.belloni@bootlin.com, ozsh@mellanox.com,
        roid@mellanox.com, john.hurley@netronome.com,
        simon.horman@netronome.com, pieter.jansenvanvuuren@netronome.com
Subject: [patch net-next 1/2] net: introduce nla_put_bitfield32() helper and use it
Date:   Sat, 28 Mar 2020 16:37:42 +0100
Message-Id: <20200328153743.6363-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200328153743.6363-1-jiri@resnulli.us>
References: <20200328153743.6363-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Introduce a helper to pass value and selector to. The helper packs them
into struct and puts them into netlink message.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/netlink.h | 15 +++++++++++++++
 net/sched/act_api.c   | 24 ++++++++----------------
 net/sched/sch_red.c   |  7 ++-----
 3 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 56c365dc6dc7..67c57d6942e3 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -1465,6 +1465,21 @@ static inline int nla_put_in6_addr(struct sk_buff *skb, int attrtype,
 	return nla_put(skb, attrtype, sizeof(*addr), addr);
 }
 
+/**
+ * nla_put_bitfield32 - Add a bitfield32 netlink attribute to a socket buffer
+ * @skb: socket buffer to add attribute to
+ * @attrtype: attribute type
+ * @value: value carrying bits
+ * @selector: selector of valid bits
+ */
+static inline int nla_put_bitfield32(struct sk_buff *skb, int attrtype,
+				     __u32 value, __u32 selector)
+{
+	struct nla_bitfield32 tmp = { value, selector, };
+
+	return nla_put(skb, attrtype, sizeof(tmp), &tmp);
+}
+
 /**
  * nla_get_u32 - return payload of u32 attribute
  * @nla: u32 netlink attribute
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 861a831b0ef7..33cc77e6e56c 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -789,23 +789,15 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 	}
 	rcu_read_unlock();
 
-	if (a->hw_stats != TCA_ACT_HW_STATS_ANY) {
-		struct nla_bitfield32 hw_stats = {
-			a->hw_stats,
-			TCA_ACT_HW_STATS_ANY,
-		};
-
-		if (nla_put(skb, TCA_ACT_HW_STATS, sizeof(hw_stats), &hw_stats))
-			goto nla_put_failure;
-	}
-
-	if (a->tcfa_flags) {
-		struct nla_bitfield32 flags = { a->tcfa_flags,
-						a->tcfa_flags, };
+	if (a->hw_stats != TCA_ACT_HW_STATS_ANY &&
+	    nla_put_bitfield32(skb, TCA_ACT_HW_STATS,
+			       a->hw_stats, TCA_ACT_HW_STATS_ANY))
+		goto nla_put_failure;
 
-		if (nla_put(skb, TCA_ACT_FLAGS, sizeof(flags), &flags))
-			goto nla_put_failure;
-	}
+	if (a->tcfa_flags &&
+	    nla_put_bitfield32(skb, TCA_ACT_FLAGS,
+			       a->tcfa_flags, a->tcfa_flags))
+		goto nla_put_failure;
 
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 3ef0a4f7399b..c7de47c942e3 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -349,10 +349,6 @@ static int red_dump_offload_stats(struct Qdisc *sch)
 static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 {
 	struct red_sched_data *q = qdisc_priv(sch);
-	struct nla_bitfield32 flags_bf = {
-		.selector = red_supported_flags,
-		.value = q->flags,
-	};
 	struct nlattr *opts = NULL;
 	struct tc_red_qopt opt = {
 		.limit		= q->limit,
@@ -375,7 +371,8 @@ static int red_dump(struct Qdisc *sch, struct sk_buff *skb)
 		goto nla_put_failure;
 	if (nla_put(skb, TCA_RED_PARMS, sizeof(opt), &opt) ||
 	    nla_put_u32(skb, TCA_RED_MAX_P, q->parms.max_P) ||
-	    nla_put(skb, TCA_RED_FLAGS, sizeof(flags_bf), &flags_bf))
+	    nla_put_bitfield32(skb, TCA_RED_FLAGS,
+			       q->flags, red_supported_flags))
 		goto nla_put_failure;
 	return nla_nest_end(skb, opts);
 
-- 
2.21.1

