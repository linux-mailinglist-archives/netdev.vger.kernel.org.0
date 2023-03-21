Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 329D86C27A9
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjCUB6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCUB6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:58:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4581926C05;
        Mon, 20 Mar 2023 18:58:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id h31so7749579pgl.6;
        Mon, 20 Mar 2023 18:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679363891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gvc7CGPJdcro45+69E4586N6NczKUrEH531fDhAuIxA=;
        b=X956UKgk2El4OGtB+nnKAWTolj1xbocbyCAeu6UzGPYa9MVPLgE7Exl5bZosljM5Cz
         ahMksLPUTNElv+YazC0b48J1hu0Rve4Ke1mgbKM5bgOUTf4NO0ygAnG0EDoie2J14S+h
         EjIR/fsh/5Wx0CPRDpT9ylws1uB1WMVHFkwYZsy08sO71kIsJQM3ZBhkEJEPOG70JzqV
         IBU1NOIWJp5MDc9arwgjxiLxI/f8sra/kdL0KqSr800CJCG2+fc9OjK0GgGO+sEa9Tg8
         jtuwzJKyxGturVlbYmiQ+NOyaHHkoVzlXqdXk+XXeiaYA+9tjdyDKz56E/827STE59zq
         wMqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679363891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gvc7CGPJdcro45+69E4586N6NczKUrEH531fDhAuIxA=;
        b=hbMNXVrPB+I2VgXm9JysrWwDinEIPF2hy2RVQA0Qbfj1aK6KGFAE9fQcv/XDUHF0eg
         jYou9w3Hcu+m8HxOKRP+qVfFu0DRna/673/D4QVir3x2DKtMwt+uVj6ytTabUjR6NVOH
         2AM0yiOswOkVXDUC83oU96MFiySHQtcyV59qYhJ29BxK8r/ahxHpRFwnJXLVEAvDM8OK
         TDrpvCL1FlSbXI9plU1A+/4YTBJ9UsvuWMrcKfs0iUrHOOC/vRXZZIPaJPlpRv3nc9XD
         //UIgGLsdDA6EN+y7FN0dE2middj/q3oNwPlRcXwsHUZAWoi9kJca/REiVJBagGbe4Gz
         wZdA==
X-Gm-Message-State: AO0yUKU5PyMujocKATdgm7X0BzRWdnIHJo2XGEye32jq+412l63uRWqZ
        qHoUm4aLbTsEWAgW0vntZso=
X-Google-Smtp-Source: AK7set8/vlIzvXFMhnPibnPYzh6AhMApZtUdWBobkVCQca7LVThc2qzKc2aUHbvpMxVtcBmQwSAjMg==
X-Received: by 2002:a62:17d4:0:b0:625:ce21:3b1b with SMTP id 203-20020a6217d4000000b00625ce213b1bmr770306pfx.3.1679363890647;
        Mon, 20 Mar 2023 18:58:10 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id h24-20020a63f918000000b004fb8732a2f9sm6904051pgi.88.2023.03.20.18.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 18:58:10 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v5 net-next] net-sysfs: display two backlog queue len separately
Date:   Tue, 21 Mar 2023 09:57:46 +0800
Message-Id: <20230321015746.96994-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Sometimes we need to know which one of backlog queue can be exactly
long enough to cause some latency when debugging this part is needed.
Thus, we can then separate the display of both.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v5:
1) drop the other patch from this series. So resend this one only.
Link: https://lore.kernel.org/all/20230315092041.35482-1-kerneljasonxing@gmail.com/

v4:
1) avoid the inconsistency through caching variables suggested
by Eric.
Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@gmail.com/
2) remove the unused function: softnet_backlog_len()

v3: drop the comment suggested by Simon
Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@gmail.com/

v2: keep the total len of backlog queues untouched as Eric said
Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
---
 net/core/net-procfs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05c..09f7ed1a04e8 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static u32 softnet_backlog_len(struct softnet_data *sd)
+static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
 {
-	return skb_queue_len_lockless(&sd->input_pkt_queue) +
-	       skb_queue_len_lockless(&sd->process_queue);
+	return skb_queue_len_lockless(&sd->input_pkt_queue);
+}
+
+static u32 softnet_process_queue_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->process_queue);
 }
 
 static struct softnet_data *softnet_get_online(loff_t *pos)
@@ -152,6 +156,8 @@ static void softnet_seq_stop(struct seq_file *seq, void *v)
 static int softnet_seq_show(struct seq_file *seq, void *v)
 {
 	struct softnet_data *sd = v;
+	u32 input_qlen = softnet_input_pkt_queue_len(sd);
+	u32 process_qlen = softnet_process_queue_len(sd);
 	unsigned int flow_limit_count = 0;
 
 #ifdef CONFIG_NET_FLOW_LIMIT
@@ -169,12 +175,14 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 * mapping the data a specific CPU
 	 */
 	seq_printf(seq,
-		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
+		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
+		   "%08x %08x\n",
 		   sd->processed, sd->dropped, sd->time_squeeze, 0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
-		   softnet_backlog_len(sd), (int)seq->index);
+		   input_qlen + process_qlen, (int)seq->index,
+		   input_qlen, process_qlen);
 	return 0;
 }
 
-- 
2.37.3

