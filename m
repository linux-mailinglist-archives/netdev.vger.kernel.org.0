Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08BA6B95DD
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjCNNSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjCNNSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:18:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C662698848;
        Tue, 14 Mar 2023 06:15:06 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso1150797pjc.1;
        Tue, 14 Mar 2023 06:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678799693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+aRdMSLfh5W1VPrI0wd1+Jj7SgosES6N6qHngIoFeI=;
        b=faQsCc+NSLJS+nFWNm3Fh/qUeVUguy/rzDYSxYHXe7gDOH3SiDFim3XD0UdyTns8Mu
         2HjNeIk4rDcxnL0IiWwKSb5ok2yzQaM+6BVuQQH0/g66ePPMMTSqF3NlV1mKv+NH41cP
         QYJZKIiiSEoRiitgWWBju1+J9L5Gw5uwyJ2A6KkwC6Q4eIgabdXMoRjD+EHB02+/Nb5z
         Z0OZ0KCPVCyIWSvcRRLj23rNJW8R562EyIR+VKO4NBh5tysyPtO+sR4HNEkAsJ0bDERV
         NEMIaaGo1XyRkrZGcviZ/mxa1K5EQ0GUo83FZRPnytko7otM3zz5H9nto5q7VAIWBK0d
         JSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678799693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C+aRdMSLfh5W1VPrI0wd1+Jj7SgosES6N6qHngIoFeI=;
        b=idlw+50TaaD0Ktk1NvkNvHbZ7RridGSpGQtGYlk8nBSskjRyV6PYycs7nOEz5gZyeQ
         q0rORSSUA5aa39sUYDPL0AWDxmzgfB/62av3/4ul1oVIWQEcrKihIur7MHTh01pyPsL3
         Votbgu7oxcohWRLKuwJqPFUHoNHgwyBV6qo9EXDhHoZPnXkQngQ8Xenxu8hLAXIGVUjV
         kAWc8MNmj5VJXZQESn6eMum7wbp3kF7KkzxoJmS99ITQIFzeSqKdEMU3Wyogt3h4Ukp+
         2ddJ2XPJ35F4wHoz6emn1qK3u2PyCgJWfueBMf33+ZzyozIyBFEVo6Ug2Xnk77r9lV8A
         WAEA==
X-Gm-Message-State: AO0yUKX80lGQrkF5v2agILBNJBU5X4PI7Otj2YjxF0lFMWGuTfStipWr
        lOJO4TKl4/ioDS4X9ozgEDU=
X-Google-Smtp-Source: AK7set+K3jK11mYEtW57j8kF12ftPeTlFreajMwChUSwuUgFfmUMyuCgO2pxAA4agnioyl16UEVA9g==
X-Received: by 2002:a17:90a:6fa6:b0:23d:3aab:bd62 with SMTP id e35-20020a17090a6fa600b0023d3aabbd62mr1730493pjk.49.1678799693505;
        Tue, 14 Mar 2023 06:14:53 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090a7d0f00b0023d36aa85fesm1465843pjl.40.2023.03.14.06.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 06:14:53 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v3 net-next 1/2] net-sysfs: display two backlog queue len separately
Date:   Tue, 14 Mar 2023 21:14:26 +0800
Message-Id: <20230314131427.85135-2-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230314131427.85135-1-kerneljasonxing@gmail.com>
References: <20230314131427.85135-1-kerneljasonxing@gmail.com>
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
v3: drop the comment suggested by Simon
Link: https://lore.kernel.org/lkml/20230314030532.9238-2-kerneljasonxing@gmail.com/

v2: keep the total len of backlog queues untouched as Eric said
Link: https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
---
 net/core/net-procfs.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 1ec23bf8b05c..8056f39da8a1 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -115,10 +115,19 @@ static int dev_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
+static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->input_pkt_queue);
+}
+
+static u32 softnet_process_queue_len(struct softnet_data *sd)
+{
+	return skb_queue_len_lockless(&sd->process_queue);
+}
+
 static u32 softnet_backlog_len(struct softnet_data *sd)
 {
-	return skb_queue_len_lockless(&sd->input_pkt_queue) +
-	       skb_queue_len_lockless(&sd->process_queue);
+	return softnet_input_pkt_queue_len(sd) + softnet_process_queue_len(sd);
 }
 
 static struct softnet_data *softnet_get_online(loff_t *pos)
@@ -169,12 +178,14 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
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
+		   softnet_backlog_len(sd), (int)seq->index,
+		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
 	return 0;
 }
 
-- 
2.37.3

