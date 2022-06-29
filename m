Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2AF55FB17
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiF2IyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiF2IyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:54:01 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBD63BF8A
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:54:00 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v126so10528331pgv.11
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:54:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PkhFb7S17b9dGnBFHUia9x4S8zY7OAs2RMpiRBrK3Wg=;
        b=n4yDyvwAh0ZePMBsDSl7XxsyHl8rSvWklfRG0PhR/LwJsTruj7IBPCUrPWpM7c5qqu
         vowM0DMV9hgDTWMuLZvCQfi8OEZMYaPKTPTx3tUKOS0gbh6x67Bxh+yMNNwQEvhiyJ0v
         9QyD2/toMbey/LxoQOvQUkceXkq1PzDV+MXmV1d/DfX2TVjovO1ib0xoMej81r7Dojo1
         82SdBdzOOjhtgyCKrYynR4uGN7hZvuAmKROY+EIaQ1mLMm1hszT3XQYEX8kANAPXS5Kw
         /v0CsJsA3MMkG7mnzELT0BSpf9ZdjgqIv1iS/C/qVe6RRqdugCuaEKpI2Qed3jt7efc6
         xUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PkhFb7S17b9dGnBFHUia9x4S8zY7OAs2RMpiRBrK3Wg=;
        b=p3b9W3oSFZBsPNtRKZiplP9p/c/DT+ewoOGTYBoJo41SVaDXa3mlvd6OpDRckGLfnN
         JD0eHwJQqU3mXJO6ZlNTcKVxQPH+QOkEho/fP//mz2dLkEhhMnVrl2U+dXLWxz8NHwbB
         417VmuWqwTIIBb1BRGaeJ7c4PIl2Im4GoXEN3BdDy5W4sCbGzM1pr3YB/CEtG92iefZ7
         WSYDIhI8TpvaH0QVbHQ2vLH+jD3qwwydakAvChkh9MDUGuMG1tYtkNq/L5ZxJNr/IOGt
         U3nk41uPtp5xx/4GWQoj04QzZSdwEfccH5tC5XchJtiuLjxojNQjLCAvtpkdoVPhlvTp
         5BvQ==
X-Gm-Message-State: AJIora9Ep2g3aqhEVK336Kjx9/MLEjtSUzbdVeIHAJ3CS/fH7RH/dqvx
        +USkFg9o3Ei2UGs/8ayxznA=
X-Google-Smtp-Source: AGRyM1sN9x4EEY7uLoWpZZtuPWyf7B23rDNYBf1V3Oa663YWzmvIjkmUhCu1ZCHWCRQmms1LDI6HtA==
X-Received: by 2002:a63:f415:0:b0:408:808b:238f with SMTP id g21-20020a63f415000000b00408808b238fmr2036982pgi.469.1656492839675;
        Wed, 29 Jun 2022 01:53:59 -0700 (PDT)
Received: from nvm-geerzzfj.. ([103.142.140.73])
        by smtp.gmail.com with ESMTPSA id y19-20020a17090aca9300b001e0c5da6a51sm1425724pjt.50.2022.06.29.01.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 01:53:59 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, daniel@iogearbox.net
Cc:     roopa@nvidia.com, dsahern@kernel.org, qindi@staff.weibo.com,
        netdev@vger.kernel.org, Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v4 2/2] net, neigh: introduce interval_probe_time_ms for periodic probe
Date:   Wed, 29 Jun 2022 08:48:32 +0000
Message-Id: <20220629084832.2842973-3-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220629084832.2842973-1-wangyuweihx@gmail.com>
References: <20220629084832.2842973-1-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit ed6cd6a17896 ("net, neigh: Set lower cap for neigh_managed_work rearming")
fixed a case when DELAY_PROBE_TIME is configured to 0, the processing of the
system work queue hog CPU to 100%, and further more we should introduce
a new option used by periodic probe

Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
---
v4:
- make this option configured as ms, and rename it to `interval_probe_time_ms`
- add documentation to Documentation/networking/ip-sysctl
- fix damaged whitespace
- fix missing `proc_*_jiffies_minmax` on `CONFIG_PROC_SYSCTL` is not defined
v3:
- add limitation to prevent `INTERVAL_PROBE_TIME` to 0
- remove `NETEVENT_INTERVAL_PROBE_TIME_UPDATE`
- add .min to NDTPA_INTERVAL_PROBE_TIME

 Documentation/networking/ip-sysctl.rst |  6 +++++
 include/net/neighbour.h                |  1 +
 include/uapi/linux/neighbour.h         |  1 +
 include/uapi/linux/sysctl.h            | 37 +++++++++++++-------------
 net/core/neighbour.c                   | 32 ++++++++++++++++++++--
 net/decnet/dn_neigh.c                  |  1 +
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 8 files changed, 60 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 04216564a03c..b8604c938b4c 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -202,6 +202,12 @@ neigh/default/unres_qlen - INTEGER
 
 	Default: 101
 
+neigh/default/interval_probe_time_ms - INTEGER
+	The probe interval for neighbor entries with NTF_MANAGED flag,
+	the min value is 1.
+
+	Default: 5000
+
 mtu_expires - INTEGER
 	Time, in seconds, that cached PMTU information is kept.
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 87419f7f5421..9f0bab0589d9 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -48,6 +48,7 @@ enum {
 	NEIGH_VAR_RETRANS_TIME,
 	NEIGH_VAR_BASE_REACHABLE_TIME,
 	NEIGH_VAR_DELAY_PROBE_TIME,
+	NEIGH_VAR_INTERVAL_PROBE_TIME_MS,
 	NEIGH_VAR_GC_STALETIME,
 	NEIGH_VAR_QUEUE_LEN_BYTES,
 	NEIGH_VAR_PROXY_QLEN,
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 39c565e460c7..a998bf761635 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -154,6 +154,7 @@ enum {
 	NDTPA_QUEUE_LENBYTES,		/* u32 */
 	NDTPA_MCAST_REPROBES,		/* u32 */
 	NDTPA_PAD,
+	NDTPA_INTERVAL_PROBE_TIME_MS,	/* u64, msecs */
 	__NDTPA_MAX
 };
 #define NDTPA_MAX (__NDTPA_MAX - 1)
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 6a3b194c50fe..8981f00204db 100644
--- a/include/uapi/linux/sysctl.h
+++ b/include/uapi/linux/sysctl.h
@@ -584,24 +584,25 @@ enum {
 
 /* /proc/sys/net/<protocol>/neigh/<dev> */
 enum {
-	NET_NEIGH_MCAST_SOLICIT=1,
-	NET_NEIGH_UCAST_SOLICIT=2,
-	NET_NEIGH_APP_SOLICIT=3,
-	NET_NEIGH_RETRANS_TIME=4,
-	NET_NEIGH_REACHABLE_TIME=5,
-	NET_NEIGH_DELAY_PROBE_TIME=6,
-	NET_NEIGH_GC_STALE_TIME=7,
-	NET_NEIGH_UNRES_QLEN=8,
-	NET_NEIGH_PROXY_QLEN=9,
-	NET_NEIGH_ANYCAST_DELAY=10,
-	NET_NEIGH_PROXY_DELAY=11,
-	NET_NEIGH_LOCKTIME=12,
-	NET_NEIGH_GC_INTERVAL=13,
-	NET_NEIGH_GC_THRESH1=14,
-	NET_NEIGH_GC_THRESH2=15,
-	NET_NEIGH_GC_THRESH3=16,
-	NET_NEIGH_RETRANS_TIME_MS=17,
-	NET_NEIGH_REACHABLE_TIME_MS=18,
+	NET_NEIGH_MCAST_SOLICIT = 1,
+	NET_NEIGH_UCAST_SOLICIT = 2,
+	NET_NEIGH_APP_SOLICIT = 3,
+	NET_NEIGH_RETRANS_TIME = 4,
+	NET_NEIGH_REACHABLE_TIME = 5,
+	NET_NEIGH_DELAY_PROBE_TIME = 6,
+	NET_NEIGH_GC_STALE_TIME = 7,
+	NET_NEIGH_UNRES_QLEN = 8,
+	NET_NEIGH_PROXY_QLEN = 9,
+	NET_NEIGH_ANYCAST_DELAY = 10,
+	NET_NEIGH_PROXY_DELAY = 11,
+	NET_NEIGH_LOCKTIME = 12,
+	NET_NEIGH_GC_INTERVAL = 13,
+	NET_NEIGH_GC_THRESH1 = 14,
+	NET_NEIGH_GC_THRESH2 = 15,
+	NET_NEIGH_GC_THRESH3 = 16,
+	NET_NEIGH_RETRANS_TIME_MS = 17,
+	NET_NEIGH_REACHABLE_TIME_MS = 18,
+	NET_NEIGH_INTERVAL_PROBE_TIME_MS = 19,
 };
 
 /* /proc/sys/net/dccp */
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 54625287ee5b..5715c49b5eaa 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
 		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
+			   NEIGH_VAR(&tbl->parms, INTERVAL_PROBE_TIME_MS));
 	write_unlock_bh(&tbl->lock);
 }
 
@@ -2100,7 +2100,9 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 	    nla_put_msecs(skb, NDTPA_PROXY_DELAY,
 			  NEIGH_VAR(parms, PROXY_DELAY), NDTPA_PAD) ||
 	    nla_put_msecs(skb, NDTPA_LOCKTIME,
-			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD))
+			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD) ||
+	    nla_put_msecs(skb, NDTPA_INTERVAL_PROBE_TIME_MS,
+			  NEIGH_VAR(parms, INTERVAL_PROBE_TIME_MS), NDTPA_PAD))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
+	[NDTPA_INTERVAL_PROBE_TIME_MS]	= { .type = NLA_U64, .min = 1 },
 };
 
 static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -2373,6 +2376,10 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 					      nla_get_msecs(tbp[i]));
 				call_netevent_notifiers(NETEVENT_DELAY_PROBE_TIME_UPDATE, p);
 				break;
+			case NDTPA_INTERVAL_PROBE_TIME_MS:
+				NEIGH_VAR_SET(p, INTERVAL_PROBE_TIME_MS,
+					      nla_get_msecs(tbp[i]));
+				break;
 			case NDTPA_RETRANS_TIME:
 				NEIGH_VAR_SET(p, RETRANS_TIME,
 					      nla_get_msecs(tbp[i]));
@@ -3562,6 +3569,22 @@ static int neigh_proc_dointvec_zero_intmax(struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static int neigh_proc_dointvec_ms_jiffies_positive(struct ctl_table *ctl, int write,
+						   void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp = *ctl;
+	int ret;
+
+	int min = msecs_to_jiffies(1);
+
+	tmp.extra1 = &min;
+	tmp.extra2 = NULL;
+
+	ret = proc_dointvec_ms_jiffies_minmax(&tmp, write, buffer, lenp, ppos);
+	neigh_proc_update(ctl, write);
+	return ret;
+}
+
 int neigh_proc_dointvec(struct ctl_table *ctl, int write, void *buffer,
 			size_t *lenp, loff_t *ppos)
 {
@@ -3658,6 +3681,9 @@ static int neigh_proc_base_reachable_time(struct ctl_table *ctl, int write,
 #define NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(attr, name) \
 	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_userhz_jiffies)
 
+#define NEIGH_SYSCTL_MS_JIFFIES_POSITIVE_ENTRY(attr, name) \
+	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_ms_jiffies_positive)
+
 #define NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(attr, data_attr, name) \
 	NEIGH_SYSCTL_ENTRY(attr, data_attr, name, 0644, neigh_proc_dointvec_ms_jiffies)
 
@@ -3676,6 +3702,8 @@ static struct neigh_sysctl_table {
 		NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(RETRANS_TIME, "retrans_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(BASE_REACHABLE_TIME, "base_reachable_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(DELAY_PROBE_TIME, "delay_first_probe_time"),
+		NEIGH_SYSCTL_MS_JIFFIES_POSITIVE_ENTRY(INTERVAL_PROBE_TIME_MS,
+						       "interval_probe_time_ms"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(GC_STALETIME, "gc_stale_time"),
 		NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(QUEUE_LEN_BYTES, "unres_qlen_bytes"),
 		NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(PROXY_QLEN, "proxy_qlen"),
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index fbd98ac853ea..7c569bcc0aca 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -94,6 +94,7 @@ struct neigh_table dn_neigh_table = {
 			[NEIGH_VAR_RETRANS_TIME] = 1 * HZ,
 			[NEIGH_VAR_BASE_REACHABLE_TIME] = 30 * HZ,
 			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+			[NEIGH_VAR_INTERVAL_PROBE_TIME_MS] = 5 * HZ,
 			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
 			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
 			[NEIGH_VAR_PROXY_QLEN] = 0,
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index ab4a5601c82a..af2f12ffc9ca 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -168,6 +168,7 @@ struct neigh_table arp_tbl = {
 			[NEIGH_VAR_RETRANS_TIME] = 1 * HZ,
 			[NEIGH_VAR_BASE_REACHABLE_TIME] = 30 * HZ,
 			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+			[NEIGH_VAR_INTERVAL_PROBE_TIME_MS] = 5 * HZ,
 			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
 			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
 			[NEIGH_VAR_PROXY_QLEN] = 64,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index b0dfe97ea4ee..cd84cbdac0a2 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -128,6 +128,7 @@ struct neigh_table nd_tbl = {
 			[NEIGH_VAR_RETRANS_TIME] = ND_RETRANS_TIMER,
 			[NEIGH_VAR_BASE_REACHABLE_TIME] = ND_REACHABLE_TIME,
 			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+			[NEIGH_VAR_INTERVAL_PROBE_TIME_MS] = 5 * HZ,
 			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
 			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
 			[NEIGH_VAR_PROXY_QLEN] = 64,
-- 
2.34.1

