Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D32F54979E4
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 09:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241960AbiAXIAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 03:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiAXIAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 03:00:03 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A845C06173B;
        Mon, 24 Jan 2022 00:00:03 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v74so11912088pfc.1;
        Mon, 24 Jan 2022 00:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lm/J+aImPr9M2aPp+wyjpyR9I7DDDAwWawLV3AwoeFM=;
        b=ghIrSf7/neviOSBUCJt3fLK17TjgDjbmV6j02LQxKgRzlXkwFOlZnSSdqFwaZm6cHM
         AsTOiIbpyTmxHwgxEfnTjboI5UYDc5HmDofGX/FERcKE37wh6A1hM8I3VGv8UkN6wukP
         tMJzvibNaXvvr/Z1tjlwtAE+RX+pshwqzawnEawlGqHXkNWhe2PLjSqy6e8cxklHIlJR
         bemKS6sc5v1vRVFQbJ1FaWih426mgnkbiqYG3Tbwhro2yhWSZBRkf+F9h526BHmFWa9K
         GSK6OtMAtkIAh5FceRiI1MUdR9VV+GOahr+wrRI8eM5SXHPHF0NEk6a5hxIsApS2sWw+
         pdTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lm/J+aImPr9M2aPp+wyjpyR9I7DDDAwWawLV3AwoeFM=;
        b=67VlFY3cTeHQa5w34m8I5NaaJxBhKdhrRvzxfhS4XbWrAGnC7fSuGF+K/BblcZu+N4
         tabY9pEOA9xuQMpqJPIfQ3sBdeyHBR2MkV4SLjlX51Jpb6ROajRXHzmpjQ86stuc5CAy
         118o9+g/Po+dp6X3LbZhsKI5czS6dJd4Ya6MmcE++uCUlNIYF/BUnd1wGeUep4maJJGF
         SAMqnRz4yDE+R5jy9zsTwTOkkTodDgTpTbMrpU4QGhcPWleUwCpO9gBHFemCQhkT2y1D
         wDnPHFYg4DpzEKIJK4OSk5iX6UHC9AjOVB4d8ZU5WHECGdATP42iq928eRXHm/xJURD/
         y53w==
X-Gm-Message-State: AOAM531uiSeiLrRp3T+pcxUNJzJlaE9sD7gtCNKvZGOzb4aFTUklSpOQ
        pBmXSzp48gAYm4BNH6/VIaOGpP9E6b8=
X-Google-Smtp-Source: ABdhPJx6vO8TtsrpfOV4aKeoJjXUbmSfGfFqG2MaKC65cP0qzjPWf3O1kbEraltyR3vLqJX9dLMzqQ==
X-Received: by 2002:a63:5007:: with SMTP id e7mr10901585pgb.295.1643011202055;
        Mon, 24 Jan 2022 00:00:02 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id a62sm14935460pfb.197.2022.01.23.23.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 00:00:01 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: drop_monitor: support drop reason
Date:   Mon, 24 Jan 2022 15:59:55 +0800
Message-Id: <20220124075955.1232426-1-imagedong@tencent.com>
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
 include/uapi/linux/net_dropmon.h | 1 +
 net/core/drop_monitor.c          | 6 ++++++
 2 files changed, 7 insertions(+)

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
index 7b288a121a41..4aed0e583770 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -126,6 +126,7 @@ struct net_dm_skb_cb {
 		struct devlink_trap_metadata *hw_metadata;
 		void *pc;
 	};
+	enum skb_drop_reason reason;
 };
 
 #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
@@ -508,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
+	NET_DM_SKB_CB(nskb)->reason = reason;
 	NET_DM_SKB_CB(nskb)->pc = location;
 	/* Override the timestamp because we care about the time when the
 	 * packet was dropped.
@@ -606,6 +608,7 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
 static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
+	enum skb_drop_reason reason = NET_DM_SKB_CB(skb)->reason;
 	u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
@@ -623,6 +626,9 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 	if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
+	if (nla_put_u32(msg, NET_DM_ATTR_REASON, reason))
+		goto nla_put_failure;
+
 	snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
 		goto nla_put_failure;
-- 
2.27.0

