Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F28954498F
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 12:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiFIK6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 06:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243201AbiFIK6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 06:58:00 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB1C201B4
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 03:57:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b135so20750854pfb.12
        for <netdev@vger.kernel.org>; Thu, 09 Jun 2022 03:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RMK0tXGRkRS3WBpwHzA73Yw0J1wMvpyk3NkxAezBLyw=;
        b=pLEHa/HMb4C+86G3wDDO1LQ7o+TilIqIAS5DOCYd7BEHRqd7fUy2FleC8UcL6FtBOE
         uAU6SxThv8iVvyz9xWxeg0/6NxiwJXJ2L6m7xsm0PV5YSBw0C2dP3OeDYHlxYt4yTiyI
         pe0dtQ+6NjVsisqrbzuZ0kBKwi5rOxRmMynfaZK0edAEC8IExrIbt8CSwfF3On8KFYhM
         Dgi6sdKeEjpbdiRLPZW6c+mLP4awBHNs8M7E7O8wkW4AbZoAwtSw/JOX714D6IRlntLp
         GaM7EsSeet5WzgD2qHAu4W9wJuIjNRE75Xr0aX0utxbPwqwzZ1hnOObusUX2NV6zZYkP
         SobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RMK0tXGRkRS3WBpwHzA73Yw0J1wMvpyk3NkxAezBLyw=;
        b=L6mRWwFmmRiUaZ/dUa+zs9l5GDwhdh9Wu/GJTcr0ftRN2HkbHi/S1N5cDeox16lRpS
         FEfMCxpwNPz2bIpg8Xxuci5CtWfs9aEYcJEr4CTlXb7l3Tqyb70qj1Nw4/6uQHY0rd3s
         6hVlO1Ykn8CAk4myNQZlWwYYfJDyn9dewGnzypBl9tcopcmHGxNBL5k5JpsixBcqt7R+
         GGgR/w0PwOxy7wp1CQHoKuYOzJuAuuKRWTodQMggh2N4aeNfBor9wbdo5NmvaXpSTejU
         dp2mt7U/oxo/U9pLFKzqfSWNl9g7mhtFTPQcOim5oNMvXbDKqoT+I0OV1XWzk8hIC0SZ
         qlCw==
X-Gm-Message-State: AOAM530sKg2JI+TQztCVJJJ8rrXUxSoWuUq/Tu8jiHRZYqohakEx/rW7
        ymg/+tMNMvwpiZGcOn2q0e4=
X-Google-Smtp-Source: ABdhPJwCK5r6Tcm817352OwcczTcdbsqVM/X0VvjkaSQUgAnD1X2nl43+l1bKMgQ5DiKsZ+X7Crlqg==
X-Received: by 2002:a63:741:0:b0:3fc:6b3c:f9dd with SMTP id 62-20020a630741000000b003fc6b3cf9ddmr33574190pgh.351.1654772278253;
        Thu, 09 Jun 2022 03:57:58 -0700 (PDT)
Received: from nvm-geerzzfj.. ([49.7.38.61])
        by smtp.gmail.com with ESMTPSA id d82-20020a621d55000000b005184fe6cc99sm16949338pfd.29.2022.06.09.03.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 03:57:58 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org,
        Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v3 2/2] net, neigh: introduce interval_probe_time for periodic probe
Date:   Thu,  9 Jun 2022 10:57:25 +0000
Message-Id: <20220609105725.2367426-3-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220609105725.2367426-1-wangyuweihx@gmail.com>
References: <20220609105725.2367426-1-wangyuweihx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
v3:
- add limitation to prevent `INTERVAL_PROBE_TIME` to 0
- remove `NETEVENT_INTERVAL_PROBE_TIME_UPDATE`
- add .min to NDTPA_INTERVAL_PROBE_TIME

 include/net/neighbour.h        |  1 +
 include/uapi/linux/neighbour.h |  1 +
 include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
 net/core/neighbour.c           | 33 ++++++++++++++++++++++++++++--
 net/decnet/dn_neigh.c          |  1 +
 net/ipv4/arp.c                 |  1 +
 net/ipv6/ndisc.c               |  1 +
 7 files changed, 55 insertions(+), 20 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 87419f7f5421..c6a6e652d442 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -48,6 +48,7 @@ enum {
 	NEIGH_VAR_RETRANS_TIME,
 	NEIGH_VAR_BASE_REACHABLE_TIME,
 	NEIGH_VAR_DELAY_PROBE_TIME,
+	NEIGH_VAR_INTERVAL_PROBE_TIME,
 	NEIGH_VAR_GC_STALETIME,
 	NEIGH_VAR_QUEUE_LEN_BYTES,
 	NEIGH_VAR_PROXY_QLEN,
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 39c565e460c7..8713c3ea81b2 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -154,6 +154,7 @@ enum {
 	NDTPA_QUEUE_LENBYTES,		/* u32 */
 	NDTPA_MCAST_REPROBES,		/* u32 */
 	NDTPA_PAD,
+	NDTPA_INTERVAL_PROBE_TIME,	/* u64, msecs */
 	__NDTPA_MAX
 };
 #define NDTPA_MAX (__NDTPA_MAX - 1)
diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
index 6a3b194c50fe..53f06bfd2a37 100644
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
+	NET_NEIGH_INTERVAL_PROBE_TIME = 19,
 };
 
 /* /proc/sys/net/dccp */
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 54625287ee5b..845fad952ce2 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
 		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
+			   NEIGH_VAR(&tbl->parms, INTERVAL_PROBE_TIME));
 	write_unlock_bh(&tbl->lock);
 }
 
@@ -2100,7 +2100,9 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 	    nla_put_msecs(skb, NDTPA_PROXY_DELAY,
 			  NEIGH_VAR(parms, PROXY_DELAY), NDTPA_PAD) ||
 	    nla_put_msecs(skb, NDTPA_LOCKTIME,
-			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD))
+			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD) ||
+	    nla_put_msecs(skb, NDTPA_INTERVAL_PROBE_TIME,
+			  NEIGH_VAR(parms, INTERVAL_PROBE_TIME), NDTPA_PAD))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
+	[NDTPA_INTERVAL_PROBE_TIME]	= { .type = NLA_U64, .min = 1 },
 };
 
 static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -2373,6 +2376,10 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 					      nla_get_msecs(tbp[i]));
 				call_netevent_notifiers(NETEVENT_DELAY_PROBE_TIME_UPDATE, p);
 				break;
+			case NDTPA_INTERVAL_PROBE_TIME:
+				NEIGH_VAR_SET(p, INTERVAL_PROBE_TIME,
+					      nla_get_msecs(tbp[i]));
+				break;
 			case NDTPA_RETRANS_TIME:
 				NEIGH_VAR_SET(p, RETRANS_TIME,
 					      nla_get_msecs(tbp[i]));
@@ -3562,6 +3569,24 @@ static int neigh_proc_dointvec_zero_intmax(struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static int neigh_proc_dointvec_jiffies_positive(struct ctl_table *ctl, int write,
+						void *buffer, size_t *lenp,
+						loff_t *ppos)
+{
+	struct ctl_table tmp = *ctl;
+	int ret;
+
+	int min = HZ;
+	int max = INT_MAX;
+
+	tmp.extra1 = &min;
+	tmp.extra2 = &max;
+
+	ret = proc_dointvec_jiffies_minmax(&tmp, write, buffer, lenp, ppos);
+	neigh_proc_update(ctl, write);
+	return ret;
+}
+
 int neigh_proc_dointvec(struct ctl_table *ctl, int write, void *buffer,
 			size_t *lenp, loff_t *ppos)
 {
@@ -3658,6 +3683,9 @@ static int neigh_proc_base_reachable_time(struct ctl_table *ctl, int write,
 #define NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(attr, name) \
 	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_userhz_jiffies)
 
+#define NEIGH_SYSCTL_JIFFIES_POSITIVE_ENTRY(attr, name) \
+	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_jiffies_positive)
+
 #define NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(attr, data_attr, name) \
 	NEIGH_SYSCTL_ENTRY(attr, data_attr, name, 0644, neigh_proc_dointvec_ms_jiffies)
 
@@ -3676,6 +3704,7 @@ static struct neigh_sysctl_table {
 		NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(RETRANS_TIME, "retrans_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(BASE_REACHABLE_TIME, "base_reachable_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(DELAY_PROBE_TIME, "delay_first_probe_time"),
+		NEIGH_SYSCTL_JIFFIES_POSITIVE_ENTRY(INTERVAL_PROBE_TIME, "interval_probe_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(GC_STALETIME, "gc_stale_time"),
 		NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(QUEUE_LEN_BYTES, "unres_qlen_bytes"),
 		NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(PROXY_QLEN, "proxy_qlen"),
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index fbd98ac853ea..995b22841ebf 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -94,6 +94,7 @@ struct neigh_table dn_neigh_table = {
 			[NEIGH_VAR_RETRANS_TIME] = 1 * HZ,
 			[NEIGH_VAR_BASE_REACHABLE_TIME] = 30 * HZ,
 			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+			[NEIGH_VAR_INTERVAL_PROBE_TIME] = 5 * HZ,
 			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
 			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
 			[NEIGH_VAR_PROXY_QLEN] = 0,
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index ab4a5601c82a..dbea1f7a7e2b 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -168,6 +168,7 @@ struct neigh_table arp_tbl = {
 			[NEIGH_VAR_RETRANS_TIME] = 1 * HZ,
 			[NEIGH_VAR_BASE_REACHABLE_TIME] = 30 * HZ,
 			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+			[NEIGH_VAR_INTERVAL_PROBE_TIME] = 5 * HZ,
 			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
 			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
 			[NEIGH_VAR_PROXY_QLEN] = 64,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index b0dfe97ea4ee..aa9dc032bac5 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -128,6 +128,7 @@ struct neigh_table nd_tbl = {
 			[NEIGH_VAR_RETRANS_TIME] = ND_RETRANS_TIMER,
 			[NEIGH_VAR_BASE_REACHABLE_TIME] = ND_REACHABLE_TIME,
 			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+			[NEIGH_VAR_INTERVAL_PROBE_TIME] = 5 * HZ,
 			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
 			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
 			[NEIGH_VAR_PROXY_QLEN] = 64,
-- 
2.34.1

