Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E2D49F2B0
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237629AbiA1E5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiA1E5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:57:40 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FABC061714;
        Thu, 27 Jan 2022 20:57:40 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id h14so4860522plf.1;
        Thu, 27 Jan 2022 20:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lu2lBnLkSAL0IiFHPYpn99EHRd8SVjxg+NkJ9e7Rdcs=;
        b=kJKXMpphphatsAkFyChuwZdp2UWIgTH81dqCzDAFrMY9NQ6Ri1mE8hhoMlSgAmfJke
         NhjCUHbxNXLZ8uzX48HwmYS1CTxu2N6LTlN5DNn4PUtiRyO/Knpq5HeIv9myBIUH1rFs
         T/IfYJlM9Qxh47uks2Xa5V4u4z9UuB70hkDuz35xvpudOWJs/Yi2oiPwgZtX9glBbAdU
         RvIHfwFQCFVGSHBXdXsFKvHQbk5DZSoLiIw5YJ3CS6617MBfLwbkxExGdWged0obTgN7
         6XYefkPK8VoT+08eZhJU2vHYXD06lXqrKldFkj8j03wh+R1ipHfCJRSyuM7CGMVMlzAW
         v1kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lu2lBnLkSAL0IiFHPYpn99EHRd8SVjxg+NkJ9e7Rdcs=;
        b=yT0f1v6CfkoMECixawvkYyQXAVwIzAtYA0dWXx34OQ0g9uif1QPyKlv3zG7RhKrpzs
         dyU7LD70uRl9hPeWhXaCkeegqSqNM2mCv3z0Hhsox/J+AvTGrpoyO/Eh7q4tfOXf0eYk
         3RpDBx2eS439jjNmDIvec4Xqx9ftGcO1IEJ/+SJsB+ENObY9F2a4FychFna9Yvk7bEj7
         mArkXIisEvYtcs/5trRYysq+K9nbdr7lEc3SQhnAnBz8vfc2uZ8gjHkQnfQW0pF0EE4w
         PFQ9tTEeeO3fRYpWwZjgwwgiqbf3wCxpZ2RMOj2ZCIy7HIiMkZxo6Yna5iRYbwwSTO1W
         lUGg==
X-Gm-Message-State: AOAM532Kcoohbd9WTExBi8py7JTnn3oC78tEAOx3Q2NYi10UtrEvmE21
        7hwPmUDFP1lusuwInR+OLgk=
X-Google-Smtp-Source: ABdhPJydETCpBRgl7eSTSnEC+FS0USXR2VBf8zlZmTmWXDsgsp/BPDXZxIWznrjI9FoCJ1wc9rgCOQ==
X-Received: by 2002:a17:902:9a0a:: with SMTP id v10mr6518064plp.50.1643345859698;
        Thu, 27 Jan 2022 20:57:39 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id b22sm7523964pfl.121.2022.01.27.20.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 20:57:39 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, rostedt@goodmis.org, idosch@idosch.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v4 net-next] net: drop_monitor: support drop reason
Date:   Fri, 28 Jan 2022 12:57:27 +0800
Message-Id: <20220128045727.910974-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 net/core/drop_monitor.c          | 27 +++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

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
index 7b288a121a41..e7ef678f9ee6 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -48,6 +48,16 @@
 static int trace_state = TRACE_OFF;
 static bool monitor_hw;
 
+#undef EM
+#undef EMe
+
+#define EM(a, b)	[a] = #b,
+#define EMe(a, b)	[a] = #b
+
+static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
+	TRACE_SKB_DROP_REASON
+};
+
 /* net_dm_mutex
  *
  * An overall lock guarding every operation coming from userspace.
@@ -126,6 +136,7 @@ struct net_dm_skb_cb {
 		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
+	enum skb_drop_reason reason;
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -498,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
+	struct net_dm_skb_cb *cb;
 	struct sk_buff *nskb;
 	unsigned long flags;
 
@@ -508,7 +520,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	NET_DM_SKB_CB(nskb)->pc = location;
+	cb = NET_DM_SKB_CB(nskb);
+	cb->reason = reason;
+	cb->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
 	 */
@@ -606,7 +620,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
-	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
 	void *hdr;
@@ -620,10 +634,15 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
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
 
-- 
2.27.0

