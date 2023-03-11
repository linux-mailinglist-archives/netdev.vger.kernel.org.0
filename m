Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E446B5D48
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjCKPSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbjCKPSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:18:05 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C843C10A88;
        Sat, 11 Mar 2023 07:18:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id ce8-20020a17090aff0800b0023a61cff2c6so10090266pjb.0;
        Sat, 11 Mar 2023 07:18:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678547883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vzL0lKQA7Qxou/xZXI6wkc7TkinivUbSS7RQX8UnPsM=;
        b=p6l8O63x+x3Q2LUDQ3HlrBHvQtlU5v4UezfcX7HxRInV8MkJ//yj01Fw9vrEDtNRBa
         lwG9sPxEZdfbqgXC4II3ri4yc83g2Yg4a6BAixUz3dlMrqdEFijhekqfZOOBbKGHhwye
         Xs5hQ8RTrRMfBux9kgpTUFBNO0w5JYfpLxptquaoMkFo37rkSD7yQBIWMZ0v/JSW6jWY
         VtCO4JuefR7yhA0+lBKsgVnoo/YfJ48/shsr3GedmOA/acC/SgSPRpP2YRLNcrP8/g6k
         NdhpSKlRfKoIGSgsFVEqIxem7giPHnpOh8OdcDd1GKObrf02FDXiOAfFSubAfW/fXMK0
         qnxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678547883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vzL0lKQA7Qxou/xZXI6wkc7TkinivUbSS7RQX8UnPsM=;
        b=ZjyMeCoTECo9p6ofpbVZ2NvH8pDRI3loJ91n/epLtC8S85uzJqHYhktEAOBbqn//at
         X26oFL503qCty5twi3NKAg5R1AsEa/Op/XU7sG013r/OXwFTXnqIBM1b5Fm9CbOh5ACe
         lq1ti1Tqc7GmdBZnM4uIrww8dFxVlncnmsL8NrvnyBvFO5sa2UDt1uD3t09yBW29ZRT5
         wJl4Ni6Vpo5x3sLT3jc+FOAqCElwiA1CYmZksTRZ4io3HhD4cNPBbM1lD1bn/XkdgAbV
         7SLz9r+Mh7nk4AnLZlUVkpXZ5VQP8dNos0nb9pt8fueQE90+GvDrpzTUQfKZEAkap1Tn
         QZRA==
X-Gm-Message-State: AO0yUKWDsughvy6rdOfRb8IQ6VrDp85hw5pv9GMb4nx8RSXTlyIsN/yj
        EWY1Gl5WcZU19ynicpOE8yk=
X-Google-Smtp-Source: AK7set/KJWGZB1W8/CipRrS+KK/oKGcA4x7I2P/qKdRWMqJjvvL1fwfFfQf2bwm9TJQ9AjddMrG8vw==
X-Received: by 2002:a17:902:ec84:b0:19c:c87b:4740 with SMTP id x4-20020a170902ec8400b0019cc87b4740mr33928704plg.34.1678547882857;
        Sat, 11 Mar 2023 07:18:02 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.213])
        by smtp.gmail.com with ESMTPSA id o11-20020a170902d4cb00b00194caf3e975sm1670922plg.208.2023.03.11.07.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 07:18:02 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] net-sysfs: display two backlog queue len separately
Date:   Sat, 11 Mar 2023 23:17:56 +0800
Message-Id: <20230311151756.83302-1-kerneljasonxing@gmail.com>
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
---
 net/core/net-procfs.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05c..97a304e1957a 100644
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
@@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
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
+		   0,	/* was len of two backlog queues */
+		   (int)seq->index,
+		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
 	return 0;
 }
 
-- 
2.37.3

