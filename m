Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD486B0EB0
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 17:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjCHQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 11:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbjCHQ0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 11:26:38 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C31C9A7A;
        Wed,  8 Mar 2023 08:26:32 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id m8-20020a17090a4d8800b002377bced051so2977143pjh.0;
        Wed, 08 Mar 2023 08:26:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LQUZMW3ATClSf/r8H/ZNppEXmMdqJP2TRdMQdlzdBEU=;
        b=mFReNd43myvP8sDRapVG/f0Mh5fq+amruVFC0XBXIDWMXg4hfE390EbOCvAmdWYC2z
         JChEMlSFX83AY8Q14XMcuyjQM/FJ4Bxp3kDZFHTK35PmmLvz5C72wEv0MrDRS9KCoNKR
         fGlevMH9T2ai8edqwEocZ1S09RZRH7jhPQ2f94kq2PVA9ZA9KHXXF8VO3ekaRnhDT4YA
         DCCzvlEy5ZuOEYUf6tfQFV8Ds7Ca0iFN38k02EAcQ/th33+GsGMi2Gzqtu7ARGitpVSW
         l2VKMVSWP7ZTjb3aOjY5zTlzJX7+V4y1WutlEZo1EbPI5EzZ4Y8oqfE3WbiF7aoE6Rdw
         xYlg==
X-Gm-Message-State: AO0yUKXdwuoEJmorcKBwL3po6hFJihJMgXB7V0Mo03h09dcoNeic2veG
        yyF3eqV4ZyL33BKd25JvmeQ=
X-Google-Smtp-Source: AK7set/ljF2NSlK5iXBS5nOBvYwYALtBT6qGPN3NaOl9NmTJAqQftRWcEmjCkHVWk/x0lRsa1htRvA==
X-Received: by 2002:a17:90b:1b0f:b0:237:c18d:c459 with SMTP id nu15-20020a17090b1b0f00b00237c18dc459mr19250067pjb.31.1678292791395;
        Wed, 08 Mar 2023 08:26:31 -0800 (PST)
Received: from localhost.localdomain ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id mv15-20020a17090b198f00b0023087e8adf8sm9363818pjb.21.2023.03.08.08.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:26:31 -0800 (PST)
From:   Leesoo Ahn <lsahn@ooseel.net>
To:     lsahn@ooseel.net
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: call stmmac_finalize_xdp_rx() on a condition
Date:   Thu,  9 Mar 2023 01:26:18 +0900
Message-Id: <20230308162619.329372-1-lsahn@ooseel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase calls the function no matter net device has XDP
programs or not. So the finalize function is being called everytime when RX
bottom-half in progress. It needs a few machine instructions for nothing
in the case that XDP programs are not attached at all.

Lets it call the function on a condition that if xdp_status variable has
not zero value. That means XDP programs are attached to the net device
and it should be finalized based on the variable.

The following instructions show that it's better than calling the function
unconditionally.

  0.31 │6b8:   ldr     w0, [sp, #196]
       │    ┌──cbz     w0, 6cc
       │    │  mov     x1, x0
       │    │  mov     x0, x27
       │    │→ bl     stmmac_finalize_xdp_rx
       │6cc:└─→ldr    x1, [sp, #176]

with 'if (xdp_status)' statement, jump to '6cc' label if xdp_status has
zero value.

Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e4902a7bb61e..53c6e9b3a0c2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5145,7 +5145,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 		rx_q->state.len = len;
 	}
 
-	stmmac_finalize_xdp_rx(priv, xdp_status);
+	if (xdp_status)
+		stmmac_finalize_xdp_rx(priv, xdp_status);
 
 	priv->xstats.rx_pkt_n += count;
 	priv->xstats.rxq_stats[queue].rx_pkt_n += count;
@@ -5425,7 +5426,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		rx_q->state.len = len;
 	}
 
-	stmmac_finalize_xdp_rx(priv, xdp_status);
+	if (xdp_status)
+		stmmac_finalize_xdp_rx(priv, xdp_status);
 
 	stmmac_rx_refill(priv, queue);
 
-- 
2.34.1

