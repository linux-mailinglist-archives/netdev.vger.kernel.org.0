Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6C7460E1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbfFNOeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:34:12 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44314 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728246AbfFNOeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:34:11 -0400
Received: by mail-ed1-f66.google.com with SMTP id k8so3772680edr.11
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 07:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Sh6y99Hm3cMdMoET3VrRVGBG8Zx0FIyYIoMDb14fXT8=;
        b=eMqra2LL3g3g8s9xdkWvsFs8NN3lmjBg6QYT5lvYEbPzYJm6p7krD2K+mLNqaxcb4H
         nbZ/iP39vcd7rnwyXO924mTAEMVV+ZmNEg9sCsxdHVEtuby9TAwTNFpZ7y1GjboA18F+
         Qdt/RTisYLcMVjMRhC2miJn7k8syomobUuxcqmLSG8opmeEccf+XTL1iB89EWOeABDuP
         /XdaKwE7vj444MtbXXm7vh48W86dsaMxD32PyBj9wH9Svp7idPH3EgruyNr5PIM4TpXy
         gAXOOBmVdw/wRZjRvyGFx42d5OVaLoAc7fAZqNDWW5a6CH1wLLXl1cCsBqjew/qxFiRi
         2MQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Sh6y99Hm3cMdMoET3VrRVGBG8Zx0FIyYIoMDb14fXT8=;
        b=Snmitz1q4u0k/TS7BIE1pt3GM7rS0iB4/3/CkJYDzUAggyrZgH96j36jZ/WJkh3l/I
         6Ra+O5uz/vaYEGnlo9nLPYgP+H0IxZzB4mg9F2wpV97uM0gOiNBcQO6o6Ohh6Qs+noye
         6+iATzTck93HyJdOHysbYqgrOM6mkFlLxtKZaw0s9eEGSewtA4aMY+SJATcxkYcvVGCC
         RJ1/0Gtxt2w4yAlClQf+rkfq76iwoX0rUzES/Zi6MfGOGXOEUGCyigSAO05yx6ehsIFV
         1NWKX4X+YcCXoeI/+/gK2WEXGiC0kWtOG3diRN242l+QpX245kFypm0L2aZyCzwnAbf9
         j2GQ==
X-Gm-Message-State: APjAAAWHRuO5v3oGOh7gaqwiJ8DE4DYt7yrD1rC5ChaME34xlHxzbtA1
        HeC/9408sIzfPYwgYsAaedHnj9Qny4Q=
X-Google-Smtp-Source: APXvYqwLVAbovt+qoKO5QPUUNYfCWdTPyEy4o4SN16mcdr6STxoy/3yPlHRoXyM10Phxd9xaHwIMYg==
X-Received: by 2002:a17:906:2ada:: with SMTP id m26mr257108eje.265.1560522849154;
        Fri, 14 Jun 2019 07:34:09 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id r11sm350971ejr.57.2019.06.14.07.34.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 14 Jun 2019 07:34:08 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 1/2] net: sched: refactor reinsert action
Date:   Fri, 14 Jun 2019 15:33:50 +0100
Message-Id: <1560522831-23952-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
References: <1560522831-23952-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TC_ACT_REINSERT return type was added as an in-kernel only option to
allow a packet ingress or egress redirect. This is used to avoid
unnecessary skb clones in situations where they are not required. If a TC
hook returns this code then the packet is 'reinserted' and no skb consume
is carried out as no clone took place.

This return type is only used in act_mirred. Rather than have the reinsert
called from the main datapath, call it directly in act_mirred. Instead of
returning TC_ACT_REINSERT, change the type to the new TC_ACT_CONSUMED
which tells the caller that the packet has been stolen by another process
and that no consume call is required.

Moving all redirect calls to the act_mirred code is in preparation for
tracking recursion created by act_mirred.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
---
 include/net/pkt_cls.h     | 2 +-
 include/net/sch_generic.h | 2 +-
 net/core/dev.c            | 4 +---
 net/sched/act_mirred.c    | 3 ++-
 4 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 514e3c8..3ecb5c2 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -9,7 +9,7 @@
 #include <net/flow_offload.h>
 
 /* TC action not accessible from user space */
-#define TC_ACT_REINSERT		(TC_ACT_VALUE_MAX + 1)
+#define TC_ACT_CONSUMED		(TC_ACT_VALUE_MAX + 1)
 
 /* Basic packet classifier frontend definitions. */
 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 21f434f..855167b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -279,7 +279,7 @@ struct tcf_result {
 		};
 		const struct tcf_proto *goto_tp;
 
-		/* used by the TC_ACT_REINSERT action */
+		/* used in the skb_tc_reinsert function */
 		struct {
 			bool		ingress;
 			struct gnet_stats_queue *qstats;
diff --git a/net/core/dev.c b/net/core/dev.c
index eb7fb6d..ed5eeb7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4689,9 +4689,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		__skb_push(skb, skb->mac_len);
 		skb_do_redirect(skb);
 		return NULL;
-	case TC_ACT_REINSERT:
-		/* this does not scrub the packet, and updates stats on error */
-		skb_tc_reinsert(skb, &cl_res);
+	case TC_ACT_CONSUMED:
 		return NULL;
 	default:
 		break;
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 58e7573d..8c1d736 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -277,7 +277,8 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 		if (use_reinsert) {
 			res->ingress = want_ingress;
 			res->qstats = this_cpu_ptr(m->common.cpu_qstats);
-			return TC_ACT_REINSERT;
+			skb_tc_reinsert(skb, res);
+			return TC_ACT_CONSUMED;
 		}
 	}
 
-- 
2.7.4

