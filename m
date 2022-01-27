Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EED049D947
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 04:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiA0DeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 22:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiA0DeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 22:34:08 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107A9C06161C;
        Wed, 26 Jan 2022 19:34:08 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id h14so1392720plf.1;
        Wed, 26 Jan 2022 19:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CVdnYpoF1nEdnt9cO+WlahA09jnbS5I/njhTfHZXfTs=;
        b=SYH2GyuiVqIYvoHm5mBwgFHcWu9Me7V0DrnkETOc6LBFXDGOR5CdbOFNrSHqhlX4ZL
         Ns5Yib5FJZzvRknsFnFSsVu6FUCerVh6SGs0o2rrYdSrxldLXv/yUu7/cLvz5palW0fh
         kRp0EnwPGNs9npaU71qYP6cmnI5moJu94weRk3aMxYAEBfOg1ELMNREOSxHudNGU7qca
         BNsZp6WCK8nGhMyyx7doynEuI3xsFnyM/cLcOlcneY7pjYbld10yJPdJ/zAFPvCg8Lb2
         UYpeosfH4QYwr5mk5ql6UfW8NElUIjaf/N+oS8iaq3bmxWWtnBIwBNjCAc+z7yiM1YPN
         5PAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CVdnYpoF1nEdnt9cO+WlahA09jnbS5I/njhTfHZXfTs=;
        b=Ng7Puwf0O/zFLsPbk0apEKgMeGVDOZvk7TD+6SFgaL92mUZPjBJ65rRm9Zerui+apm
         D1t2iXrV09zwTOq7MlTm4eL1HhqxbnAGGulni/t9MLutJ+sjnM8wKXGvLH19u+/s5eWE
         Yk8MMEE8fUSUMBqNSAWMIxTk7+/epP7v4R7ukBLX75DzrKp4t5t5jLmg3Pgf5MPPxZGa
         F6uzrLnYIndQj0KL1BYjvsfBydF0EytXjnGZ4rxUdFhJdnrmgUNgA4y+T5pKACrXaIMF
         FqlSQCT0Lps3oSg1cNzjYfCajndGponFMs7t7d66qMtK6wn9taZP7dW5XhTM/q0v8KOy
         kgSQ==
X-Gm-Message-State: AOAM532tQFRGhOoCItHfsuxbwvFF98g3K4EiP4araTdUmPouaJcm6GRb
        OFAwXebW2H+FHYEtreWI0F8=
X-Google-Smtp-Source: ABdhPJx7K+w7RiVnVWteYsPa4Zc0fWYBgXneeN54T29zVtDEUjNcNoRndPh9byBjCjLxMJT1+ZbCmQ==
X-Received: by 2002:a17:902:7c92:: with SMTP id y18mr1606804pll.131.1643254447485;
        Wed, 26 Jan 2022 19:34:07 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id z27sm1508771pgk.78.2022.01.26.19.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 19:34:06 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v3 net-next] net: drop_monitor: support drop reason
Date:   Thu, 27 Jan 2022 11:33:56 +0800
Message-Id: <20220127033356.4050072-1-imagedong@tencent.com>
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

For now, the number of drop reason is passed to users ( seems it's
a little troublesome to pass the drop reason as string ). Therefore,
users can do some customized description of the reason.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- referring to cb->reason and cb->pc directly in
  net_dm_packet_report_fill()

v2:
- get a pointer to struct net_dm_skb_cb instead of local var for
  each field
---
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
index 66048cc5d7b3..b2815166dbc2 100644
--- a/include/uapi/linux/net_dropmon.h
+++ b/include/uapi/linux/net_dropmon.h
@@ -93,6 +93,7 @@ enum net_dm_attr {
 	NET_DM_ATTR_SW_DROPS,			/* flag */
 	NET_DM_ATTR_HW_DROPS,			/* flag */
 	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
+	NET_DM_ATTR_REASON,			/* u32 */
 
 	__NET_DM_ATTR_MAX,
 	NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 7b288a121a41..11448110f65d 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -126,6 +126,7 @@ struct net_dm_skb_cb {
 		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
+	enum skb_drop_reason reason;
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -498,6 +499,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
+	struct net_dm_skb_cb *cb;
 	struct sk_buff *nskb;
 	unsigned long flags;
 
@@ -508,7 +510,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	NET_DM_SKB_CB(nskb)->pc = location;
+	cb = NET_DM_SKB_CB(nskb);
+	cb->reason = reason;
+	cb->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
 	 */
@@ -606,7 +610,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
-	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
+	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
 	void *hdr;
@@ -620,10 +624,14 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
 		goto nla_put_failure;
 
-	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
+	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
+			      NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
-	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
+	if (nla_put_u32(msg, NET_DM_ATTR_REASON, cb->reason))
+		goto nla_put_failure;
+
+	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
 
-- 
2.34.1

