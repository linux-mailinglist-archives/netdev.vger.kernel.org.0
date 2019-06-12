Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3890426B2
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 14:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437433AbfFLMwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 08:52:18 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40039 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437347AbfFLMwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 08:52:17 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so10946406eds.7
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 05:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5HCngsw5PusIl0ZveLMtuHXSj36iGGEvUDttYU9vuRA=;
        b=2L4Qwrs4rmZ1hPpLiyiNezc7gZC4hJ/oMe8vXT3G/m8/VFWqf0S98tD6tGFtLXWBHe
         EhKiRfkeIlqGF2zgW+0FDhg26khSJdyDtHtTcp3UtDLUWERXJd30UqiR+M+pJ7qFApnw
         HNAEqqT49eM1XZm+QCgcmarpP2hzwC8s/fSU8GxoPnec7ohB+FmDU+1Ybmf743REJ0y9
         qT50MZaAqT/0YairP9b5IIMh4B260jkErZzqOB9N7SCU1pE+FVHb43HG1L2G2QYmogmB
         NY3QVPXjpitCqKqpPTYFFkpm/6PfCXDlQjK26rH1xX12xVq4OKyzbLd9qpvIU3J7ecOl
         Gqjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5HCngsw5PusIl0ZveLMtuHXSj36iGGEvUDttYU9vuRA=;
        b=HTCBrD3JJ4IScddluGfx5Pr+qarHTgXGlFV29p9BIYLUmsJS1NJCVgtrycK91IUEQc
         MGMVj6WbC9/7hga+3+CPc00NxWsjEOvPIxvn3sfBlUzHP6zEoCOeoZ7y4TWdCrUi9dPV
         Vyfvlj994edAGwK1tNxqkcTh3AawME+JGzpnYhtNufyjGgvM09WEBBC020cCSqh8H8DR
         FlghDVIb3KTYPZWYVqrAnAv8Xu0rKavbMGvBJ2h07dnz0228ZJlBVPaC+Bzah8kRTRwE
         4GspEwZ51t03YEVRaJGCG2wWJN4fWzRCIWV9Mqp2tWRiw7A9dU7m7lGlcUYtpWnRVP94
         7wwg==
X-Gm-Message-State: APjAAAWbmPe2of46zA7Ifr/Q9q23xq8L4W984tNadxQVUbfYt2sO+jr8
        zg47JAT7BALlL1UX31b6C0kSv6h3fqA=
X-Google-Smtp-Source: APXvYqy/LM/2MakpktjnMVbHIsdE+ZscOPqqMj/eZTpHbV51d9GSgy/dBh6FQKaD8LcjSYIfyi6j+A==
X-Received: by 2002:aa7:d4cf:: with SMTP id t15mr28718446edr.215.1560343935260;
        Wed, 12 Jun 2019 05:52:15 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id u15sm17043eja.32.2019.06.12.05.52.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 05:52:14 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 2/3] net: sched: include mpls actions in hardware intermediate representation
Date:   Wed, 12 Jun 2019 13:51:45 +0100
Message-Id: <1560343906-19426-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
References: <1560343906-19426-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent addition to TC actions is the ability to manipulate the MPLS
headers on packets.

In preparation to offload such actions to hardware, update the IR code to
accept and prepare the new actions.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h   | 10 +++++++
 include/net/tc_act/tc_mpls.h | 64 ++++++++++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c          | 26 ++++++++++++++++++
 3 files changed, 100 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 36fdb85..e26ae81 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -123,6 +123,10 @@ enum flow_action_id {
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
 	FLOW_ACTION_POLICE,
+	FLOW_ACTION_MPLS_PUSH,
+	FLOW_ACTION_MPLS_POP,
+	FLOW_ACTION_MPLS_MANGLE,
+	FLOW_ACTION_MPLS_DEC_TTL,
 };
 
 /* This is mirroring enum pedit_header_type definition for easy mapping between
@@ -172,6 +176,12 @@ struct flow_action_entry {
 			s64			burst;
 			u64			rate_bytes_ps;
 		} police;
+		struct {				/* FLOW_ACTION_MPLS */
+			u32		label;
+			__be16		proto;
+			u8		tc;
+			u8		ttl;
+		} mpls;
 	};
 };
 
diff --git a/include/net/tc_act/tc_mpls.h b/include/net/tc_act/tc_mpls.h
index ca7393a..4320de9 100644
--- a/include/net/tc_act/tc_mpls.h
+++ b/include/net/tc_act/tc_mpls.h
@@ -24,4 +24,68 @@ struct tcf_mpls {
 };
 #define to_mpls(a) ((struct tcf_mpls *)a)
 
+static inline bool is_tcf_mpls(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ACT_MPLS)
+		return true;
+#endif
+	return false;
+}
+
+static inline u32 tcf_mpls_action(const struct tc_action *a)
+{
+	u32 tcfm_action;
+
+	rcu_read_lock();
+	tcfm_action = rcu_dereference(to_mpls(a)->mpls_p)->tcfm_action;
+	rcu_read_unlock();
+
+	return tcfm_action;
+}
+
+static inline u32 tcf_mpls_label(const struct tc_action *a)
+{
+	u32 tcfm_label;
+
+	rcu_read_lock();
+	tcfm_label = rcu_dereference(to_mpls(a)->mpls_p)->tcfm_label;
+	rcu_read_unlock();
+
+	return tcfm_label;
+}
+
+static inline u8 tcf_mpls_tc(const struct tc_action *a)
+{
+	u8 tcfm_tc;
+
+	rcu_read_lock();
+	tcfm_tc = rcu_dereference(to_mpls(a)->mpls_p)->tcfm_tc;
+	rcu_read_unlock();
+
+	return tcfm_tc;
+}
+
+static inline u8 tcf_mpls_ttl(const struct tc_action *a)
+{
+	u8 tcfm_ttl;
+
+	rcu_read_lock();
+	tcfm_ttl = rcu_dereference(to_mpls(a)->mpls_p)->tcfm_ttl;
+	rcu_read_unlock();
+
+	return tcfm_ttl;
+}
+
+static inline __be16 tcf_mpls_proto(const struct tc_action *a)
+{
+	__be16 tcfm_proto;
+
+	rcu_read_lock();
+	tcfm_proto = rcu_dereference(to_mpls(a)->mpls_p)->tcfm_proto;
+	rcu_read_unlock();
+
+	return tcfm_proto;
+}
+
 #endif /* __NET_TC_MPLS_H */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ad36bbc..d41de2e 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -35,6 +35,7 @@
 #include <net/tc_act/tc_police.h>
 #include <net/tc_act/tc_sample.h>
 #include <net/tc_act/tc_skbedit.h>
+#include <net/tc_act/tc_mpls.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -3266,6 +3267,31 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.burst = tcf_police_tcfp_burst(act);
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
+		} else if (is_tcf_mpls(act)) {
+			switch (tcf_mpls_action(act)) {
+			case TCA_MPLS_ACT_PUSH:
+				entry->id = FLOW_ACTION_MPLS_PUSH;
+				entry->mpls.label = tcf_mpls_label(act);
+				entry->mpls.proto = tcf_mpls_proto(act);
+				entry->mpls.tc = tcf_mpls_tc(act);
+				entry->mpls.ttl = tcf_mpls_ttl(act);
+				break;
+			case TCA_MPLS_ACT_POP:
+				entry->id = FLOW_ACTION_MPLS_POP;
+				entry->mpls.proto = tcf_mpls_proto(act);
+				break;
+			case TCA_MPLS_ACT_MODIFY:
+				entry->id = FLOW_ACTION_MPLS_MANGLE;
+				entry->mpls.label = tcf_mpls_label(act);
+				entry->mpls.tc = tcf_mpls_tc(act);
+				entry->mpls.ttl = tcf_mpls_ttl(act);
+				break;
+			case TCA_MPLS_ACT_DEC_TTL:
+				entry->id = FLOW_ACTION_MPLS_DEC_TTL;
+				break;
+			default:
+				goto err_out;
+			}
 		} else {
 			goto err_out;
 		}
-- 
2.7.4

