Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9177651E09
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfFXWOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:14:50 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38854 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbfFXWOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:14:48 -0400
Received: by mail-ed1-f65.google.com with SMTP id r12so23975343edo.5
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 15:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cu6+czkld8+3OuRIud7fAy5sd6ywX/bYQLEbBrwnvRQ=;
        b=AkEe3T4zB8/JiZuRzgSsKRUy0qIFqOtOvBfdGcZYgy2fC9KvY+w1/+ldRPrA1SVHVb
         jxaNPvj55hON2EbLpXj7SkREg0E8AW64xKGMUfIKQfJCJsw8NMZ/viPKlkLyabVU6nRD
         6nG3EeHZlEe4++5Hu5CYTJHMHHFJ+9je5sGCpDNKlXc0IDq0Jdzx10kFHhaD/DSrC9gY
         H6LgZaUY47OimvNoJI8u9HxTV88p8s9MqlQ46EwarAtiv31yfsLiFtKFcJopXc+Vp8Xj
         ypfZrfrky7yGMD2UerEFRqi8w3FhyHNrXJvoiQFThELiNA2ZecMgdy/NTsin6phrsqnz
         Q3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cu6+czkld8+3OuRIud7fAy5sd6ywX/bYQLEbBrwnvRQ=;
        b=iu6wqF+PF3aKSSba2MfaoaBZsYqjQeOlP1p8ydjftEwme8uJEy9wvtUjXr/FjgkLrW
         yUWCKUTBvOEmy8Zr+Uj2bQ7K/+An51OAecbv5VehYzpOViKu9ndGAjzFtukxcozHQbcz
         RSrUww2TiCh0kmfIo/PnDKcgW7REGKel9e12l9+tBHkyo7ZxGELPGCA3DG1FoyZNeOpS
         svPKbcHWKzt5F+Zqlwd1ogNYbSoGcjfTBlgXw6HDUCbIzJijwwetseamxAouKqzOlu63
         zYaVJYIcaX4zck4UQO+FV2iniO5AzdMJvh+WYybOUO1X9PDchZqTXxtpIpxa8c0QpLlo
         2O4Q==
X-Gm-Message-State: APjAAAX3GDrwuj5+jzfgDIXalcw1FzWFo3xcVMZIl9n+SXE2xnxPGac2
        AXDqgclBgyMxojaIQjp5b+fCVJfJO/0=
X-Google-Smtp-Source: APXvYqxdtu6u5p/X9Oic91tpTuudP09f12VgRjSN2g0rTZG9WNkPW5JwaIeluvoDZHaLcPzZTDMQeg==
X-Received: by 2002:a17:906:4e95:: with SMTP id v21mr86794964eju.105.1561414486476;
        Mon, 24 Jun 2019 15:14:46 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id y3sm4046025edr.27.2019.06.24.15.14.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Jun 2019 15:14:45 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, fw@strlen.de, jhs@mojatatu.com,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 1/2] net: sched: refactor reinsert action
Date:   Mon, 24 Jun 2019 23:13:35 +0100
Message-Id: <1561414416-29732-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com>
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
index 720f2b3..1a7596b 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -10,7 +10,7 @@
 #include <net/net_namespace.h>
 
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
index d6edd21..5852931 100644
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

