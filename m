Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616114AA797
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 09:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351944AbiBEIR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 03:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351216AbiBEIRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 03:17:47 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471A1C061355;
        Sat,  5 Feb 2022 00:17:46 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id y5-20020a17090aca8500b001b8127e3d3aso8294778pjt.3;
        Sat, 05 Feb 2022 00:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q7pnMxxA41QGRIEltZrYAcSJW8Szr5sjwJMXNTY+cos=;
        b=Dh4/dRqdta5uoH/FAXGRbVbWSY8pJEUGbFjdzdu0nZNYBEktAfy+TEMqZMyrzXFXsL
         njI7zxaz1ALv/hKQyUOtaz1YTecrPOHuB/J+xIIRBa1lWvqSmGwEAPxWY6WQEnjfjuRV
         OljLmpO0mjQfd8GkGen6hQIyIgW88z2e+sbfsmw0pD3unDP8Z3x1Gz/Ou2t/BaY6lIJg
         syHhAZVbvzREA+t83+AziFzxJu0lnPJ5zrEcGTW0llioPcUiINCO3RLZn00kbjd4781h
         Rf3/mXF9sdXBPdbL3JnBxwuNaEbw77W+u3fDIvDUbW8LyWL0fJLtf8sXR3MPFMMhyeHJ
         frFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=q7pnMxxA41QGRIEltZrYAcSJW8Szr5sjwJMXNTY+cos=;
        b=O99zq79CiNZk7emL9FGGKqmhfxTmXN2+W5KgvoJYfY9x9bmslbe2jSHW23o1nPtshH
         bSnxhWC5H1YBoJMm6bve5O5kkg3/rBOQDX+RZ9hva96dlUGfKuYUfyZ6ePhpYkDul3A9
         FpiaAJnScbJ25/zctYXbPDFdHkoT/EvilrLH7H7VMV4sOqgXMwJec8s4WyBeXx7kOgvx
         pfLja+jp/wz9fbQcVj6tbmsJPogHnH3DTds7O9dPboCqvBMYLxDoNFCI+uFI/5qehWh7
         EXYp+cMUkHhxbJhffpfADwKFJWxlzjshBZTE6AF48zYP2lPlX9XWpmUosBHTYtZcz3Kp
         G8Wg==
X-Gm-Message-State: AOAM531S4gpr263KGq8LGo+5LbTnFS5XpW51tkgOs/H1i5sSs1jZG2Jc
        ZoGPjB1zVOV2VzgbZe3/Qe8=
X-Google-Smtp-Source: ABdhPJz8EaqFeLlCCHRtBL8zk/a7lfH+n/ALNUfnxXXU6q18NCq1RfGxBtIc6Q5L3mxNWekrfZ45LQ==
X-Received: by 2002:a17:902:7784:: with SMTP id o4mr6932893pll.173.1644049066363;
        Sat, 05 Feb 2022 00:17:46 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id b12sm4826934pfm.154.2022.02.05.00.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 00:17:45 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, dsahern@kernel.org, idosch@idosch.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v6 net-next] net: drop_monitor: support drop reason
Date:   Sat,  5 Feb 2022 16:17:38 +0800
Message-Id: <20220205081738.565394-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
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
 net/core/drop_monitor.c          | 29 +++++++++++++++++++++++++----
 2 files changed, 26 insertions(+), 4 deletions(-)

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
index 7b288a121a41..1180f1a28599 100644
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
@@ -606,8 +620,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
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
@@ -620,10 +635,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
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
2.27.0

