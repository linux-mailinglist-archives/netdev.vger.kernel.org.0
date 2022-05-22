Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F9A53005C
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 05:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiEVDZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 23:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbiEVDZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 23:25:00 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0C43B542
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 20:24:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id a38so8027198pgl.9
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 20:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WQwm87SIKdH3qv+wtBNrjZi6CSEk/BcVcphpIAkGb9U=;
        b=OjUovhE0qYiY/LF9YX80BgkPrkpwZFFx0h9k4GaaJkgvpfBrZA1eP+SzKS4I3QYngk
         cqZ9JMBkhyHHoN4SWu/DJmZ4N3wROqqnkK9klAc5Ej+uAWuWUY+NffdTlWZh+//TJ590
         3K2nseX5OtlmrwKD7+BgXY7xeaeCcBO8P29cE+sc6dfyauVL/+SyGbvg/a/XNWujYHV4
         bTO2yq5O+rWWRtqlEaLF6qnLSaydmSpVCpPSJnk+8qIutbm+oneQkn5/rvYnIR0v36cv
         GiztAV7+q/7wVhUjNf39RQWo3VnA5Mdoe5BtjzCMV1JcljoXlZA5dPPM8TNFUZpoefkz
         RKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WQwm87SIKdH3qv+wtBNrjZi6CSEk/BcVcphpIAkGb9U=;
        b=hpPbdv16SjkdSIVkmk7ilYNT6OdafxBmnu30duKXrBGHYozrlMJ5e0W2VnbwW18uVF
         TrHBbKe307XxjzilBDkYP9oCNCAdG3lypl82KwiZhvUuaCBjgHywRtuEnN0zZDh8VIRG
         Rc+awiYOkA0KMlu9KfNCM/LtQOEtDbYI0GdctOGM0jwrYUgHRqqeJ2LnvM8yBKdTccn7
         6+m5FmC4JG1ATRpDIZYhpcbYqbFw39i6aj/57AtEKrSaqAr+ovXElkQVo0INgkvgnppB
         Wr3zoVpWgmzw5Mu8imF8j6jslGGTjKxUF2Hqt6s59Qk06p0PrOjeWWDeOZNYkpleLGlb
         Oi/w==
X-Gm-Message-State: AOAM530RxGEyCj3fIUFjt0FXZypirnU5ac8P9+CgN4HxpXvHaIwFDTcN
        ku97YYt2d+d0uB9Ov+n0O6c=
X-Google-Smtp-Source: ABdhPJzzV5DMe2V5UP2CfX1YIalPBrlXNBRDeCfA5TV+6fa1fFHUbmQqLKWWxCW5ACd97JQqVOUAmw==
X-Received: by 2002:a05:6a00:1348:b0:518:7a03:1682 with SMTP id k8-20020a056a00134800b005187a031682mr7454706pfu.6.1653189895400;
        Sat, 21 May 2022 20:24:55 -0700 (PDT)
Received: from nvm-geerzzfj.. ([58.26.140.44])
        by smtp.gmail.com with ESMTPSA id e24-20020a637458000000b003f5e0c264bcsm2182412pgn.66.2022.05.21.20.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 May 2022 20:24:55 -0700 (PDT)
From:   Yuwei Wang <wangyuweihx@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
Cc:     daniel@iogearbox.net, roopa@nvidia.com, dsahern@kernel.org,
        qindi@staff.weibo.com, netdev@vger.kernel.org,
        Yuwei Wang <wangyuweihx@gmail.com>
Subject: [PATCH net-next v2] net, neigh: introduce interval_probe_time for periodic probe
Date:   Sun, 22 May 2022 03:17:39 +0000
Message-Id: <20220522031739.87399-1-wangyuweihx@gmail.com>
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

when DELAY_PROBE_TIME is `0`, the queue_delayed_work of neighbor entries with NTF_EXT_MANAGED will
be called recursively with no interval, and then threads of `system_power_efficient_wq` will consume 100% cpu. 

as commit messages mentioned in the above commit, we should introduce a new option which means resolution interval.

Signed-off-by: Yuwei Wang <wangyuweihx@gmail.com>
---
v2: 
- move `NDTPA_INTERVAL_PROBE_TIME` to the tail of uAPI enum
- add `NDTPA_INTERVAL_PROBE_TIME` to `nl_ntbl_parm_policy`
- add detail explain for the behevior when `DELAY_PROBE_TIME` is `0` in
  commit messaage

meanwhile, we should replace `DELAY_PROBE_TIME` with `INTERVAL_PROBE_TIME` 
in `drivers/net/ethernet/mellanox` after this patch was merged

and should we remove `include/uapi/linux/sysctl.h` seems it is no
longer be used.

 include/net/neighbour.h        |  3 ++-
 include/net/netevent.h         |  1 +
 include/uapi/linux/neighbour.h |  1 +
 include/uapi/linux/sysctl.h    | 37 +++++++++++++++++-----------------
 net/core/neighbour.c           | 15 ++++++++++++--
 net/decnet/dn_neigh.c          |  1 +
 net/ipv4/arp.c                 |  1 +
 net/ipv6/ndisc.c               |  1 +
 8 files changed, 39 insertions(+), 21 deletions(-)

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
index 47b6c1f0fdbb..92447f04cf07 100644
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
 
@@ -2255,6 +2257,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
+	[NDTPA_INTERVAL_PROBE_TIME]	= { .type = NLA_U64 },
 };
 
 static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -2373,6 +2376,11 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
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
@@ -3543,6 +3551,8 @@ static void neigh_proc_update(struct ctl_table *ctl, int write)
 	set_bit(index, p->data_state);
 	if (index == NEIGH_VAR_DELAY_PROBE_TIME)
 		call_netevent_notifiers(NETEVENT_DELAY_PROBE_TIME_UPDATE, p);
+	if (index == NEIGH_VAR_INTERVAL_PROBE_TIME)
+		call_netevent_notifiers(NETEVENT_INTERVAL_PROBE_TIME_UPDATE, p);
 	if (!dev) /* NULL dev means this is default value */
 		neigh_copy_dflt_parms(net, p, index);
 }
@@ -3676,6 +3686,7 @@ static struct neigh_sysctl_table {
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

base-commit: aa5334b1f96801cd09775217a72ff252ef614d7a
-- 
2.34.1

