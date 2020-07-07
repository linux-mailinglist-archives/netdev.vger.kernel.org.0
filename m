Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F712174ED
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgGGRQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:16:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgGGRQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 13:16:13 -0400
Received: from embeddedor (unknown [200.39.26.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AC0206C3;
        Tue,  7 Jul 2020 17:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594142172;
        bh=KuPhIChcd5d2pA3EN3g9po5r6K9nZj7oa0RmXAtMtSE=;
        h=Date:From:To:Cc:Subject:From;
        b=qrt7ul4igFpJVTT6a3LWoNq/j48ahr2xfMzjDjgULPOga9eEHah8BlYbt6UDoVf1+
         mbkX9Ev4iqUUgrXhLmocHU0hsUTIhrcqFCqfyd/G0C0OSwduFNK/vUKzDwZBB8mt4Q
         fA6o2m4p2ZuNQg8VBvj9Er3F//jJqB09po7SMshk=
Date:   Tue, 7 Jul 2020 12:21:38 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] net/sched: Use fallthrough pseudo-keyword
Message-ID: <20200707172138.GA27126@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/sched/act_csum.c     |    3 ++-
 net/sched/act_ct.c       |    2 +-
 net/sched/sch_cbq.c      |    2 +-
 net/sched/sch_drr.c      |    2 +-
 net/sched/sch_ets.c      |    2 +-
 net/sched/sch_fq_codel.c |    2 +-
 net/sched/sch_fq_pie.c   |    2 +-
 net/sched/sch_hfsc.c     |    2 +-
 net/sched/sch_htb.c      |    2 +-
 net/sched/sch_multiq.c   |    2 +-
 net/sched/sch_prio.c     |    2 +-
 net/sched/sch_qfq.c      |    2 +-
 net/sched/sch_sfb.c      |    2 +-
 net/sched/sch_sfq.c      |    2 +-
 14 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index cb8608f0a77a..9035355e867f 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -598,7 +598,8 @@ static int tcf_csum_act(struct sk_buff *skb, const struct tc_action *a,
 		if (!tcf_csum_ipv6(skb, update_flags))
 			goto drop;
 		break;
-	case cpu_to_be16(ETH_P_8021AD): /* fall through */
+	case cpu_to_be16(ETH_P_8021AD):
+		fallthrough;
 	case cpu_to_be16(ETH_P_8021Q):
 		if (skb_vlan_tag_present(skb) && !orig_vlan_tag_present) {
 			protocol = skb->protocol;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e9f3576cbf71..bdb526ae644b 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -783,7 +783,7 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			}
 		}
 		/* Non-ICMP, fall thru to initialize if needed. */
-		/* fall through */
+		fallthrough;
 	case IP_CT_NEW:
 		/* Seen it before?  This can happen for loopback, retrans,
 		 * or local packets.
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 39b427dc7512..b2130df933a7 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -250,7 +250,7 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		case TC_ACT_STOLEN:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		case TC_ACT_RECLASSIFY:
diff --git a/net/sched/sch_drr.c b/net/sched/sch_drr.c
index 07a2b0b35495..dde564670ad8 100644
--- a/net/sched/sch_drr.c
+++ b/net/sched/sch_drr.c
@@ -324,7 +324,7 @@ static struct drr_class *drr_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_STOLEN:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		}
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index a87e9159338c..c1e84d1eeaba 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -397,7 +397,7 @@ static struct ets_class *ets_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_QUEUED:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		}
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 436160be9c18..87e4806b4b45 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -99,7 +99,7 @@ static unsigned int fq_codel_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_QUEUED:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return 0;
 		}
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
index fb760cee824e..f98c74018805 100644
--- a/net/sched/sch_fq_pie.c
+++ b/net/sched/sch_fq_pie.c
@@ -102,7 +102,7 @@ static unsigned int fq_pie_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_QUEUED:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return 0;
 		}
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index 433f2190960f..0f5f121404f3 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1136,7 +1136,7 @@ hfsc_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		case TC_ACT_STOLEN:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		}
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 8184c87da8be..ba37defaca7a 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -239,7 +239,7 @@ static struct htb_class *htb_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_STOLEN:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		}
diff --git a/net/sched/sch_multiq.c b/net/sched/sch_multiq.c
index 1330ad224931..5c27b4270b90 100644
--- a/net/sched/sch_multiq.c
+++ b/net/sched/sch_multiq.c
@@ -43,7 +43,7 @@ multiq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 	case TC_ACT_QUEUED:
 	case TC_ACT_TRAP:
 		*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-		/* fall through */
+		fallthrough;
 	case TC_ACT_SHOT:
 		return NULL;
 	}
diff --git a/net/sched/sch_prio.c b/net/sched/sch_prio.c
index 647941702f9f..3eabb871a1d5 100644
--- a/net/sched/sch_prio.c
+++ b/net/sched/sch_prio.c
@@ -46,7 +46,7 @@ prio_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		case TC_ACT_QUEUED:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		}
diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 0b05ac7c848e..6335230a971e 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -699,7 +699,7 @@ static struct qfq_class *qfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_STOLEN:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return NULL;
 		}
diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 4074c50ac3d7..da047a37a3bf 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -265,7 +265,7 @@ static bool sfb_classify(struct sk_buff *skb, struct tcf_proto *fl,
 		case TC_ACT_QUEUED:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return false;
 		}
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 5a6def5e4e6d..cae5dbbadc1c 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -186,7 +186,7 @@ static unsigned int sfq_classify(struct sk_buff *skb, struct Qdisc *sch,
 		case TC_ACT_QUEUED:
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
-			/* fall through */
+			fallthrough;
 		case TC_ACT_SHOT:
 			return 0;
 		}

