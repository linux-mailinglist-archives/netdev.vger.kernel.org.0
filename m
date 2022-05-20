Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1A52E487
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345641AbiETFwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345655AbiETFv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:51:56 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B8662128
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 22:51:54 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id l14so7139229pjk.2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 22:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=10odKy7auSrsqxSQi0CY7mnEtuGmUZB9UZHxxs/RHzo=;
        b=CHHnKvjJy1/UenAXvOKw/Jf76a/RZ14DJj1ULa74xDVUDeXstnWp3x/98Wo63zG468
         QvcjZRNcXOd/Hhuhgjhmt/H2iuUqzpjcM7DLW0zRS/Nt5ux7RgqB7vLzO8xKIccf/P35
         b+47n2UYN09+0hWAf+0joGSQ4QevqPSAgJZaC6YeZSsGGy0A+icSxslVw6JdAnYNrUDA
         ZLEThpyQqWbrlBTnUC/RMMXFz0QMjl5AdI4esh+JficyC6s4gYCU7UQkvHRQ/T7px5Ng
         BuX5EjBOrOOuKtFvgFs+eFf0p0VbZSDCBzUBIhrQSfCnV+vRtowOdaEfbemLmITCy4Er
         mK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=10odKy7auSrsqxSQi0CY7mnEtuGmUZB9UZHxxs/RHzo=;
        b=tlsQB3DiWLfKafCH8q8sjeYuLu1Cj44GEWB5ZeOfWNwqfb5rqczR6kvj345mKNX26h
         jrAdKqPIUT/Ip5NF5TrXBRiJVKvY5W8nxUF87KaQpAbGKvDLvMaoEyt9aHSsjeT8oI1r
         djOOnnDJHpvhD1xfMU9oKThgR0YdqeoyQ9NIbATCXI1m5nJFvIgyj4f7IaIzYqnvEBwg
         ToCtUS/gFDp2llnH4SEZ6qNDUG/3OveTTS79rcnQ672SWwIgbY3osbDEVQBsIGgW4071
         TvOq9r5KkszpLeriSINm1HmK+WdA6vJ88MMlNkWxh7hSPg0qcw0DEwoNhbAq8FI8tUC+
         L7yA==
X-Gm-Message-State: AOAM532tEz37gN9sXOJUrg5yYHwvuNLFTK+Aa+qLele467BScTeNaWBo
        5oJzIwvSx24WGAbfZfAmTFn7tcHi/JOuwlqee7s=
X-Google-Smtp-Source: ABdhPJwgNYjCDTFGAY3fqKzelO+ZXDDgaFLyu5O/GV4msYNmpMAvUu+DxvSrCRtJywiLZIAXqeqZEw==
X-Received: by 2002:a17:90b:4c07:b0:1df:f11a:7d4a with SMTP id na7-20020a17090b4c0700b001dff11a7d4amr3292421pjb.214.1653025914016;
        Thu, 19 May 2022 22:51:54 -0700 (PDT)
Received: from nvm-geerzzfj.. ([212.107.31.242])
        by smtp.gmail.com with ESMTPSA id b6-20020a62a106000000b0050dc76281a0sm753416pff.122.2022.05.19.22.51.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 22:51:53 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org,
        Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH] net, neigh: introduce interval_probe_time for periodic probe
Date:   Fri, 20 May 2022 05:51:04 +0000
Message-Id: <20220520055104.1528845-1-wangyuweihx@gmail.com>
X-Mailer: git-send-email 2.34.1
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

commit 7482e3841d52 ("net, neigh: Add NTF_MANAGED flag for managed neighbor entries")
neighbor entries which with NTF_EXT_MANAGED flags will periodically call neigh_event_send()
for performing the resolution. and the interval was set to DELAY_PROBE_TIME

DELAY_PROBE_TIME was configured as the first probe time delay, and it makes sense to set it to `0`.

when DELAY_PROBE_TIME is `0`, the resolution of neighbor entries with NTF_EXT_MANAGED will
trap in an infinity recursion.

as commit messages mentioned in the above commit, we should introduce a new option which means resolution interval.

Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
---
meanwhile, we should replace `DELAY_PROBE_TIME` with `INTERVAL_PROBE_TIME` 
in `drivers/net/ethernet/mellanox` after this patch was merged

and should we remove `include/uapi/linux/sysctl.h` seems it is no
longer unused.

 include/net/neighbour.h        |  3 ++-
 include/net/netevent.h         |  1 +
 include/uapi/linux/neighbour.h |  1 +
 include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
 net/core/neighbour.c           | 14 +++++++++++--
 net/decnet/dn_neigh.c          |  1 +
 net/ipv4/arp.c                 |  1 +
 net/ipv6/ndisc.c               |  1 +
 8 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 87419f7f5421..75786903f1d4 100644
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
@@ -64,7 +65,7 @@ enum {
 	NEIGH_VAR_GC_THRESH1,
 	NEIGH_VAR_GC_THRESH2,
 	NEIGH_VAR_GC_THRESH3,
-	NEIGH_VAR_MAX
+	NEIGH_VAR_MAX,
 };
 
 struct neigh_parms {
diff --git a/include/net/netevent.h b/include/net/netevent.h
index 4107016c3bb4..121df77d653e 100644
--- a/include/net/netevent.h
+++ b/include/net/netevent.h
@@ -26,6 +26,7 @@ enum netevent_notif_type {
 	NETEVENT_NEIGH_UPDATE = 1, /* arg is struct neighbour ptr */
 	NETEVENT_REDIRECT,	   /* arg is struct netevent_redirect ptr */
 	NETEVENT_DELAY_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
+	NETEVENT_INTERVAL_PROBE_TIME_UPDATE, /* arg is struct neigh_parms ptr */
 	NETEVENT_IPV4_MPATH_HASH_UPDATE, /* arg is struct net ptr */
 	NETEVENT_IPV6_MPATH_HASH_UPDATE, /* arg is struct net ptr */
 	NETEVENT_IPV4_FWD_UPDATE_PRIORITY_UPDATE, /* arg is struct net ptr */
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index 39c565e460c7..5ae538be64b9 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -143,6 +143,7 @@ enum {
 	NDTPA_RETRANS_TIME,		/* u64, msecs */
 	NDTPA_GC_STALETIME,		/* u64, msecs */
 	NDTPA_DELAY_PROBE_TIME,		/* u64, msecs */
+	NDTPA_INTERVAL_PROBE_TIME,	/* u64, msecs */
 	NDTPA_QUEUE_LEN,		/* u32 */
 	NDTPA_APP_PROBES,		/* u32 */
 	NDTPA_UCAST_PROBES,		/* u32 */
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
index 47b6c1f0fdbb..f07cac60c834 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
 		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
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
 
@@ -2373,6 +2375,11 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 					      nla_get_msecs(tbp[i]));
 				call_netevent_notifiers(NETEVENT_DELAY_PROBE_TIME_UPDATE, p);
 				break;
+			case NDTPA_INTERVAL_PROBE_TIME:
+				NEIGH_VAR_SET(p, INTERVAL_PROBE_TIME,
+					      nla_get_msecs(tbp[i]));
+				call_netevent_notifiers(NETEVENT_INTERVAL_PROBE_TIME_UPDATE, p);
+				break;
 			case NDTPA_RETRANS_TIME:
 				NEIGH_VAR_SET(p, RETRANS_TIME,
 					      nla_get_msecs(tbp[i]));
@@ -3543,6 +3550,8 @@ static void neigh_proc_update(struct ctl_table *ctl, int write)
 	set_bit(index, p->data_state);
 	if (index == NEIGH_VAR_DELAY_PROBE_TIME)
 		call_netevent_notifiers(NETEVENT_DELAY_PROBE_TIME_UPDATE, p);
+	if (index == NEIGH_VAR_INTERVAL_PROBE_TIME)
+		call_netevent_notifiers(NETEVENT_INTERVAL_PROBE_TIME_UPDATE, p);
 	if (!dev) /* NULL dev means this is default value */
 		neigh_copy_dflt_parms(net, p, index);
 }
@@ -3676,6 +3685,7 @@ static struct neigh_sysctl_table {
 		NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(RETRANS_TIME, "retrans_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(BASE_REACHABLE_TIME, "base_reachable_time"),
 		NEIGH_SYSCTL_JIFFIES_ENTRY(DELAY_PROBE_TIME, "delay_first_probe_time"),
+		NEIGH_SYSCTL_JIFFIES_ENTRY(INTERVAL_PROBE_TIME, "interval_probe_time"),
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
index 254addad0dd3..283b0a188c0e 100644
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

base-commit: 0784c25d21cfe14c128ea5ed3c9ab843fdfac737
-- 
2.34.1

