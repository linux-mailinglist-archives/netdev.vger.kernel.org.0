Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548984D0EDD
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 05:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbiCHEyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 23:54:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiCHEyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 23:54:22 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD37E33A17
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 20:53:23 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t14so15427644pgr.3
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 20:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YLOswqucgq3fVrf2Aqd5XvgTNGay1SYRoqe0PXuwbsU=;
        b=Ys//bkPyTmDAUbdEnhCcf4CAoZO3FzyXlCdzZkxAH2gGLdobQKDklmS/6uTLscwfGD
         ZJ0I7UjZKByq3L62r4v1/OVR7fO8khInqxlQNPgGG+U2kKV2F90rFHx+ejypu8CqI+l+
         8x9vjITkWxLKdkzPibQGPicudoWW8A6K1uNik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YLOswqucgq3fVrf2Aqd5XvgTNGay1SYRoqe0PXuwbsU=;
        b=UDHndnsVCvtMC/tPEUfSQAodRRCstXbIgdSqWBV771wmbL6yaz5sXJGwul7qQntVOA
         KKjtH4/WxQ/ku6bNFAzhynSPF0QKcNcn5rK3w/PsmTrAvcg8d5/6xr5gEYDGq/ecGlU/
         /5oerz3l8e9lAvjQNJmqjJQzXEOd0A2nUC282J4F+AVRw9q82SMe3ExiArNrIlpYOfsY
         QN3+btiO7e1bOI9puy/Y0i7g3G1UyEZg1kARUd5ySj6tr9xJqeGcyOzI69/+5/naLrCC
         0yNxS2Cz4Pn0ingSW8nrdwaU17wA2VEhyCdFArgV7jay8SsrDrHdv7eB66ViwX+QRped
         puhQ==
X-Gm-Message-State: AOAM532r0NwwZ1TZnl2Y8uH58h9ridncr7N3K07Bmh0TTRqFqQsKC6KG
        eraKNOMaLQaNR4fmfZowMnX3LGPXY1NqlQ==
X-Google-Smtp-Source: ABdhPJyFofTCsVY80vW5l+2jBbXEhaz9JdYlAgpO3mK8B3TOsnAawdHRO7Chw47D8IyzQL/U+X8sLQ==
X-Received: by 2002:a63:28c:0:b0:380:9751:8135 with SMTP id 134-20020a63028c000000b0038097518135mr190716pgc.576.1646715203314;
        Mon, 07 Mar 2022 20:53:23 -0800 (PST)
Received: from cab09-qa-09.fungible.local ([12.190.10.11])
        by smtp.gmail.com with ESMTPSA id t5-20020a654b85000000b00373cbfbf965sm13505350pgq.46.2022.03.07.20.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 20:53:22 -0800 (PST)
From:   Dimitris Michailidis <d.michailidis@fungible.com>
X-Google-Original-From: Dimitris Michailidis <dmichail@fungible.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        d.michailidis@fungible.com
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next] net/fungible: Fix local_memory_node error
Date:   Mon,  7 Mar 2022 20:53:21 -0800
Message-Id: <20220308045321.2843-1-dmichail@fungible.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell reported the following failure on powerpc:

ERROR: modpost: ".local_memory_node"
[drivers/net/ethernet/fungible/funeth/funeth.ko] undefined!

AFAICS this is because local_memory_node() is a non-inline non-exported
function when CONFIG_HAVE_MEMORYLESS_NODES=y. It is also the wrong API
to get a CPU's memory node. Use cpu_to_mem() in the two spots it's used.

Fixes: ee6373ddf3a9 ("net/funeth: probing and netdev ops")
Fixes: db37bc177dae ("net/funeth: add the data path")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
---
 drivers/net/ethernet/fungible/funeth/funeth_main.c | 2 +-
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index c58b10c216ef..67dd02ed1fa3 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -253,7 +253,7 @@ static struct fun_irq *fun_alloc_qirq(struct funeth_priv *fp, unsigned int idx,
 	int cpu, res;
 
 	cpu = cpumask_local_spread(idx, node);
-	node = local_memory_node(cpu_to_node(cpu));
+	node = cpu_to_mem(cpu);
 
 	irq = kzalloc_node(sizeof(*irq), GFP_KERNEL, node);
 	if (!irq)
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
index 7aed0561aeac..04c9f91b7489 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_txrx.h
@@ -239,7 +239,7 @@ static inline void fun_txq_wr_db(const struct funeth_txq *q)
 
 static inline int fun_irq_node(const struct fun_irq *p)
 {
-	return local_memory_node(cpu_to_node(cpumask_first(&p->affinity_mask)));
+	return cpu_to_mem(cpumask_first(&p->affinity_mask));
 }
 
 int fun_rxq_napi_poll(struct napi_struct *napi, int budget);
-- 
2.25.1

