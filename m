Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F16B4AEA26
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 07:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiBIGRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 01:17:53 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiBIGLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 01:11:05 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410B3C1036B8;
        Tue,  8 Feb 2022 22:09:03 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id i6so612282pfc.9;
        Tue, 08 Feb 2022 22:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7qu9SXzamv/QkP+1OWSYirJbPVRFGrMjMBWpsyDdk9k=;
        b=CTcStu2DYq1/LPHmRKZ6GwkibuxZPg6hvbaAf8Ifs/rospQZ3e03hK9Azp7bvenjXP
         dqtUvM/l0p6FzPaqzBDGH+Fe6KQ5nO45X0xgPQ0edj9m3tTy32tbsi8zG7ukxERyZ1N5
         OzS8W5OvDHPtEd0SfYQHQpZJYuLbUnU3vPiBv3bbfDa4VVNF8OzU50jGbb2e3Bb9Xw+I
         hCj1de4hBnrAlbrLBEu6xv/kpPT9H5bdCMzmsLQWrPPCztU6uYaqylozCsGSN29qwnqr
         iTqzu0ay2lsODaYndYtgnbppCo30bUgPDDYvFwhorV47uGBlq2rKy678YQyjvOWKQoic
         mCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7qu9SXzamv/QkP+1OWSYirJbPVRFGrMjMBWpsyDdk9k=;
        b=QFFTv8X/ZoZ0KBLgrzv3qIppH4ghUKKHqCVSWGLvbkUE/ASBacWB3I8zBJB2+C0qit
         xETjN00/1WT9jjkeMZSOHHZFthw8ru1LyIynSLrfH8bgNv6vJCMRUKH6Pd5Wv+FC2SiI
         XoBxsu43A97zsIKDzd2nC3O6Ru7yYkppRxWBlnBvwiKieNGVewxh3LKPa52Vu8sOfckW
         AHOX5pK8zNJUj4Y9IZ2K6HV6wPC5BjVgYWGAWA26LTn82V0XyGzVECpVJtTlq4VDF1Fl
         T+OFACg5xkEiM9yvuX5jSNHsjOghuloQKaOE38gEpjioIndS3uZb4+qVRb+vvmlkmyWv
         NtCQ==
X-Gm-Message-State: AOAM533u8EWoj3S1XaieVz7gwKdBmfiq4UI2hxxb7PKj2J7K/hDLmuNv
        vPt1HS5a3w65y3kMFzk2dDk=
X-Google-Smtp-Source: ABdhPJyam0O1L9PHL4QJzBnA7ZzLLWr0s6N1yboZe3wXkn5GDckeROUhMgGCRGSRTFRE6J0fDFqegQ==
X-Received: by 2002:a63:5a64:: with SMTP id k36mr698362pgm.408.1644386941495;
        Tue, 08 Feb 2022 22:09:01 -0800 (PST)
Received: from localhost ([139.155.25.230])
        by smtp.gmail.com with ESMTPSA id l13sm12788114pgs.16.2022.02.08.22.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 22:09:00 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     idosch@idosch.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dsahern@kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v8 net-next] net: drop_monitor: support drop reason
Date:   Wed,  9 Feb 2022 14:08:38 +0800
Message-Id: <20220209060838.55513-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
drop reason is introduced to the tracepoint of kfree_skb. Therefore,
drop_monitor is able to report the drop reason to users by netlink.

The drop reasons are reported as string to users, which is exactly
the same as what we do when reporting it to ftrace.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v8:
- pass drop reason to net_dm_packet_report_size()
- move drop reason validation to net_dm_packet_trace_kfree_skb_hit()

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
 net/core/drop_monitor.c          | 41 +++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

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
index 7b288a121a41..4641126b8a20 100644
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
 
@@ -508,7 +523,11 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	NET_DM_SKB_CB(nskb)->pc = location;
+	if ((unsigned int)reason >= SKB_DROP_REASON_MAX)
+		reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	cb = NET_DM_SKB_CB(nskb);
+	cb->reason = reason;
+	cb->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
 	 */
@@ -553,7 +572,8 @@ static size_t net_dm_in_port_size(void)
 
 #define NET_DM_MAX_SYMBOL_LEN 40
 
-static size_t net_dm_packet_report_size(size_t payload_len)
+static size_t net_dm_packet_report_size(size_t payload_len,
+					enum skb_drop_reason reason)
 {
 	size_t size;
 
@@ -574,6 +594,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
 	       nla_total_size(sizeof(u32)) +
 	       /* NET_DM_ATTR_PROTO */
 	       nla_total_size(sizeof(u16)) +
+	       /* NET_DM_ATTR_REASON */
+	       nla_total_size(strlen(drop_reasons[reason]) + 1) +
 	       /* NET_DM_ATTR_PAYLOAD */
 	       nla_total_size(payload_len);
 }
@@ -606,7 +628,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
-	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
 	void *hdr;
@@ -620,10 +642,15 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
 		goto nla_put_failure;
 
-	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
+			      NET_DM_ATTR_PAD))
+		goto nla_put_failure;
+
+	if (nla_put_string(msg, NET_DM_ATTR_REASON,
+			   drop_reasons[cb->reason]))
 		goto nla_put_failure;
 
-	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
+	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
 
@@ -679,7 +706,9 @@ static void net_dm_packet_report(struct sk_buff *skb)
 	if (net_dm_trunc_len)
 		payload_len = min_t(size_t, net_dm_trunc_len, payload_len);
 
-	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
+	msg = nlmsg_new(net_dm_packet_report_size(payload_len,
+						  NET_DM_SKB_CB(skb)->reason),
+			GFP_KERNEL);
 	if (!msg)
 		goto out;
 
-- 
2.34.1

