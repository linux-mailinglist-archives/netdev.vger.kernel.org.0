Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3A24AD232
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348194AbiBHH3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 02:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243676AbiBHH3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:29:18 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66561C03FEC0;
        Mon,  7 Feb 2022 23:29:17 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id w1so3579595plb.6;
        Mon, 07 Feb 2022 23:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=thsPfyeYMYtAXlyusg+DVkrAFWIE3Xgc5yOsBOurNPA=;
        b=Ylq9/IP4+DNobVYUr0u/AJJFD2+jXRE56dM8QzXCTG0Cn/TltRz+YokORqsBmEvZEj
         HKqLxtTMrjJxolSi4fWAzrZBvq4hzsggW5ZU+1GR/fkL4mAJzMEcBCNaN0LUw3GzsFDN
         DWFavt3JgOQFEyelTFRYLDkVCgv50xTIZP3skjjc50TKkEHfLsRlsmW5zj0zmsDwTwab
         rXwqVXhgBFiMPEF0mizfVuT4zEWxRNXoxlIzGqQNvShhL26bzfSaVNQAaCnrVK6e7tAm
         cnk8Obwhvldtwz5cRtWKtxVdvK9Zm2Wx/S5nVlh8xM+amhfV8JZXe6pns/tkspzJUCYo
         GC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=thsPfyeYMYtAXlyusg+DVkrAFWIE3Xgc5yOsBOurNPA=;
        b=eaIx6S/U687n32ZHx2g6+Ai/jAVIs8CCQ5jZbV4FRtHKU4h65jqArbPfRSTzulSwQe
         vwxoLxzm2szlfhap0ytJd0np0tot1RCpbnVvqLcnCQD42SllwjDM9+i7OhVqDbast2oC
         mkCfKUUFfnCmsEeHoNWTcy1oLj46/roGA+2fA3faZmyDTgvmK4pUYsHMsnW+t7sKtj0A
         z1kLRvOzDpGdEj3quDDIGCfHs9WA279u0YcALryoOQbttmMUdQaU9kyima2MctWqBpd5
         SUgMj1p1RpujA5gQjS58grm6ixbKUe1u2Sti6KUxkvh1B+7hd6sgroyzfjmCIuyET/qD
         4IIw==
X-Gm-Message-State: AOAM532lgnXT9Z5Jn26SyyXH1h1icvi0EDnTCWSRfjVDTDkNCk+7WiR/
        WuJZOiRciM9K90AQxegw3Dc=
X-Google-Smtp-Source: ABdhPJxVaN7kHeInW7eraQ1ka/EUMMqkTvwgqoHHYOT0aB3DOv5e00d/q2GZ4Zt/MY/J88KIsQ3ufg==
X-Received: by 2002:a17:902:d641:: with SMTP id y1mr3299941plh.64.1644305356951;
        Mon, 07 Feb 2022 23:29:16 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id n37sm435675pgl.48.2022.02.07.23.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 23:29:16 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, idosch@idosch.org
Cc:     mingo@redhat.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, imagedong@tencent.com, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v7 net-next 2/2] net: drop_monitor: support drop reason
Date:   Tue,  8 Feb 2022 15:28:36 +0800
Message-Id: <20220208072836.3540192-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208072836.3540192-1-imagedong@tencent.com>
References: <20220208072836.3540192-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
drop reason is introduced to the tracepoint of kfree_skb. Therefore,
drop_monitor is able to report the drop reason to users by netlink.

The drop reasons are reported as string to users, which is exactly
the same as what we do when reporting it to ftrace.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v7:
- take the size of NET_DM_ATTR_REASON into accounting in
  net_dm_packet_report_size()
- let compiler define the size of drop_reasons

v6:
- check the range of drop reason in net_dm_packet_report_fill()

v5:
- check if drop reason larger than SKB_DROP_REASON_MAX

v4:
- report drop reasons as string

v3:
- referring to cb->reason and cb->pc directly in
  net_dm_packet_report_fill()

v2:
- get a pointer to struct net_dm_skb_cb instead of local var for
  each field
---
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 34 ++++++++++++++++++++++++++++----
 2 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 66048cc5d7b3..1bbea8f0681e 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -93,6 +93,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
+	NET_DM_ATTR_REASON,			/* string */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 7b288a121a41..28c55d605566 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -48,6 +48,19 @@
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;
 
+#undef EM
+#undef EMe
+
+#define EM(a, b)	[a] = #b,
+#define EMe(a, b)	[a] = #b
+
+/* drop_reasons is used to translate 'enum skb_drop_reason' to string,
+ * which is reported to user space.
+ */
+static const char * const drop_reasons[] = {
+	TRACE_SKB_DROP_REASON
+};
+
 /* net_dm_mutex
  *
  * An overall lock guarding every operation coming from userspace.
@@ -126,6 +139,7 @@ struct net_dm_skb_cb {
 		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
+	enum skb_drop_reason reason;
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -498,6 +512,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
+	struct net_dm_skb_cb *cb;
 	struct sk_buff *nskb;
 	unsigned long flags;
 
@@ -508,7 +523,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	NET_DM_SKB_CB(nskb)->pc = location;
+	cb = NET_DM_SKB_CB(nskb);
+	cb->reason = reason;
+	cb->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
 	 */
@@ -574,6 +591,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PROTO */
 	       nla_total_size(sizeof(u16)) +
+	       /* NET_DM_ATTR_REASON */
+	       nla_total_size(SKB_DR_MAX_LEN + 1) +
 	       /* NET_DM_ATTR_PAYLOAD */
 	       nla_total_size(payload_len);
 }
@@ -606,8 +625,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
-	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
+	unsigned int reason;
 	struct nlattr *attr;
 	void *hdr;
 	int rc;
@@ -620,10 +640,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
 		goto nla_put_failure;
 
-	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
+			      NET_DM_ATTR_PAD))
+		goto nla_put_failure;
+
+	reason = (unsigned int)cb->reason;
+	if (reason < SKB_DROP_REASON_MAX &&
+	    nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))
 		goto nla_put_failure;
 
-	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
+	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
 
-- 
2.34.1

