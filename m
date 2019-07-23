Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82A6C71A76
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390424AbfGWOfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:35:05 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33803 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732631AbfGWOfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:35:04 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so43493788wrm.1
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 07:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pq7ZqhgMhmTZxHcB33wL+SDq5biZ2pX/Ow9vHAYJNGg=;
        b=yJLNB0HgnzBD3fZ+HkCZsi1fzKSPpnAQ9SSxhcDcRnNv/nFeltsfdoXUIm68wBc8c8
         8OGMH2FOAtV7jwE+yZD6OdzAB0oUcLaXTGOn5MzF66x3qv9XzjhPOgKUEx6Rj9QU6NBk
         Pz095c/KdFqiQM28AdsZu2odJWZkahTHdgV0DNedq1/6eefwOkTyuEjH7T1R/pAfz8kI
         F0VotaNX0pvp/XNlH/G+Vp2yEAzXByF8E0jWA+nVFm0jvMhMZc3XjPJot315VN/U7m/m
         aNdznUA5ddNYKvAPi3uaSAf8NPJh2QaotUT6ckLbaWE6d4MPJHFX5kKqgaqTeUBcn9Ot
         az8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pq7ZqhgMhmTZxHcB33wL+SDq5biZ2pX/Ow9vHAYJNGg=;
        b=tVVn2mJ5lY/EBHHmAy2InCVSOxV52aRv+w0ygZYtu8zyMc+BTTOZYB+fYM0IQdkGRb
         zZZSxdP6BiNUc8zXIdmuHpPfkyMR8N75Re1UkKPVC8hoQCNtU6u5fY3onhQJbwPLaI+W
         x6g1dcoA0WYYjHAN2lwc1/ARJL5+k9qR6t7vM6kuWywKokLdvlH7Rc6VrG8sek0pwco7
         wZH41+GAcYCNLvUF2AwfsgagMhNAVCqNfQCnC6P5qJKY1xpy78hqKoSVFJdt3cBE6zjB
         eAoGaOwSOTHwzY05QcbQOmsZDNtXV8yUea00NrXe8CEt52j27XXdzmUpqEavo7S4GNwi
         0Zzw==
X-Gm-Message-State: APjAAAWnMQSVKhjRby+Dyw5NYANjscMD7IaCXRLnf18K4WV6kMFHUC43
        r5pNiv7N/UkVjuRrXiXda1pMxOZpL20=
X-Google-Smtp-Source: APXvYqzngBrTcaOcs9vBxycTsQ4I8VYoetN3Ri80WdCUBVgTlsGmuuwF+6z4VxVIvCnNG0VS1HrU6A==
X-Received: by 2002:a5d:4941:: with SMTP id r1mr78478624wrs.225.1563892501869;
        Tue, 23 Jul 2019 07:35:01 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm36710165wmh.36.2019.07.23.07.35.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 07:35:01 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 1/4] net: sched: include mpls actions in hardware intermediate representation
Date:   Tue, 23 Jul 2019 15:33:59 +0100
Message-Id: <1563892442-4654-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
References: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent addition to TC actions is the ability to manipulate the MPLS
headers on packets.

In preparation to offload such actions to hardware, update the IR code to
accept and prepare the new actions.

Note that no driver currently impliments the MPLS dec_ttl action so this
is not included.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h   | 19 +++++++++++
 include/net/tc_act/tc_mpls.h | 75 ++++++++++++++++++++++++++++++++++++++++++++
 net/sched/cls_api.c          | 25 +++++++++++++++
 3 files changed, 119 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index b16d216..00b9aab 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -131,6 +131,9 @@ enum flow_action_id {
 	FLOW_ACTION_SAMPLE,
 	FLOW_ACTION_POLICE,
 	FLOW_ACTION_CT,
+	FLOW_ACTION_MPLS_PUSH,
+	FLOW_ACTION_MPLS_POP,
+	FLOW_ACTION_MPLS_MANGLE,
 };
 
 /* This is mirroring enum pedit_header_type definition for easy mapping between
@@ -184,6 +187,22 @@ struct flow_action_entry {
 			int action;
 			u16 zone;
 		} ct;
+		struct {				/* FLOW_ACTION_MPLS_PUSH */
+			u32		label;
+			__be16		proto;
+			u8		tc;
+			u8		bos;
+			u8		ttl;
+		} mpls_push;
+		struct {				/* FLOW_ACTION_MPLS_POP */
+			__be16		proto;
+		} mpls_pop;
+		struct {				/* FLOW_ACTION_MPLS_MANGLE */
+			u32		label;
+			u8		tc;
+			u8		bos;
+			u8		ttl;
+		} mpls_mangle;
 	};
 };
 
diff --git a/include/net/tc_act/tc_mpls.h b/include/net/tc_act/tc_mpls.h
index 4bc3d92..721de4f 100644
--- a/include/net/tc_act/tc_mpls.h
+++ b/include/net/tc_act/tc_mpls.h
@@ -27,4 +27,79 @@ struct tcf_mpls {
 };
 #define to_mpls(a) ((struct tcf_mpls *)a)
 
+static inline bool is_tcf_mpls(const struct tc_action *a)
+{
+#ifdef CONFIG_NET_CLS_ACT
+	if (a->ops && a->ops->id == TCA_ID_MPLS)
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
+static inline u8 tcf_mpls_bos(const struct tc_action *a)
+{
+	u8 tcfm_bos;
+
+	rcu_read_lock();
+	tcfm_bos = rcu_dereference(to_mpls(a)->mpls_p)->tcfm_bos;
+	rcu_read_unlock();
+
+	return tcfm_bos;
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
 #endif /* __NET_TC_MPLS_H */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index efd3cfb..3565d9a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -36,6 +36,7 @@
 #include <net/tc_act/tc_sample.h>
 #include <net/tc_act/tc_skbedit.h>
 #include <net/tc_act/tc_ct.h>
+#include <net/tc_act/tc_mpls.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
 
@@ -3269,6 +3270,30 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->id = FLOW_ACTION_CT;
 			entry->ct.action = tcf_ct_action(act);
 			entry->ct.zone = tcf_ct_zone(act);
+		} else if (is_tcf_mpls(act)) {
+			switch (tcf_mpls_action(act)) {
+			case TCA_MPLS_ACT_PUSH:
+				entry->id = FLOW_ACTION_MPLS_PUSH;
+				entry->mpls_push.proto = tcf_mpls_proto(act);
+				entry->mpls_push.label = tcf_mpls_label(act);
+				entry->mpls_push.tc = tcf_mpls_tc(act);
+				entry->mpls_push.bos = tcf_mpls_bos(act);
+				entry->mpls_push.ttl = tcf_mpls_ttl(act);
+				break;
+			case TCA_MPLS_ACT_POP:
+				entry->id = FLOW_ACTION_MPLS_POP;
+				entry->mpls_pop.proto = tcf_mpls_proto(act);
+				break;
+			case TCA_MPLS_ACT_MODIFY:
+				entry->id = FLOW_ACTION_MPLS_MANGLE;
+				entry->mpls_mangle.label = tcf_mpls_label(act);
+				entry->mpls_mangle.tc = tcf_mpls_tc(act);
+				entry->mpls_mangle.bos = tcf_mpls_bos(act);
+				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
+				break;
+			default:
+				goto err_out;
+			}
 		} else {
 			goto err_out;
 		}
-- 
2.7.4

