Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84AD267AB36
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 08:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235188AbjAYHtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 02:49:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbjAYHtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 02:49:24 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954214C0DB;
        Tue, 24 Jan 2023 23:49:21 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id f12-20020a7bc8cc000000b003daf6b2f9b9so617572wml.3;
        Tue, 24 Jan 2023 23:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMWF4QkdAYkP5DtCeyCWzEJa5WlqCRU1o+Xcs+ruoIw=;
        b=A+kxeUaMRFiXW1HX0VymZhnV85y3zT+s4IPbCjyVYunL2h3Sq6fbXCBuq1uh2sGLwP
         z+lCJkqVJMqgw+OxRvZcNfvQ8gDLDRHjyZgl8tikIgErLScd0Yur4VPgrq1Fjcu5rHzr
         uf2jLhHo/WnnJQiR9g1VIbrg3Qwp80m/Y2tFgTEKEQpLYCrf1F3kwnH7tFQKrP2KSxpV
         fdtPTTZQZSc5c8rN6Ic9OVlVN5MMMLE/Qawh2RDv662ttKibvm4vfhdLSWqjtJ4+22Hq
         pkqqLcOZzm4Kva788aCsWuyo3MnPhnj8RGkkMU12cK24ug3GpC+nzX0ULeVJkuQHoxnV
         jKkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMWF4QkdAYkP5DtCeyCWzEJa5WlqCRU1o+Xcs+ruoIw=;
        b=sLkz1BLiu09qhuiWL+TgMSCsK+LVVZvNSm4vQ+ag7c+OX9lEQ/ZyTKBCotWI3PHvsp
         gifwDuHOQhFCUP62G2909HFh/fJJ+h7KxXQM9I85IrHTH3ftloi+CO9lQy3gIpbKM/oI
         7K+VAg8Vf1oJ9HzTyk0739QaukVUM6aXt28BE+EpS3hWoy5S5++jl1PrQBc5EF1I5fFq
         BbKhVMaRRn1Xr/l8azlvR6L/ZL/oHZYHtNg/JxJnSoLfHTV3xN/IMeFgsrPO6yqnPe98
         d9JuG711SkZytYqUKa08z36G7jevjpGmbUaPW4jz4TwAFqCgBigm0nBWTwSKR7KpRDQF
         n7dg==
X-Gm-Message-State: AFqh2krUdXAbyM13wmkbuiP/Hk8GwE5assHmfiygDSfpAqtH+8ZkjfC6
        jtwDR46pGzp6lwE0UDGqP0g=
X-Google-Smtp-Source: AMrXdXuREyYFoE086geZVmDLLTSzLitLtbCRiU26bzUwgYdIa9nTnX0uyebjSQyzYvlhkIeJ12UG5g==
X-Received: by 2002:a05:600c:1695:b0:3da:1c49:d632 with SMTP id k21-20020a05600c169500b003da1c49d632mr29959123wmn.1.1674632961166;
        Tue, 24 Jan 2023 23:49:21 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id n13-20020a05600c500d00b003db2b81660esm1032051wmr.21.2023.01.24.23.49.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jan 2023 23:49:20 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH net v2 5/5] dpaa2-eth: execute xdp_do_flush() before napi_complete_done()
Date:   Wed, 25 Jan 2023 08:49:01 +0100
Message-Id: <20230125074901.2737-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230125074901.2737-1-magnus.karlsson@gmail.com>
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be followed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: d678be1dc1ec ("dpaa2-eth: add XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 0c35abb7d065..2e79d18fc3c7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1993,10 +1993,15 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		if (rx_cleaned >= budget ||
 		    txconf_cleaned >= DPAA2_ETH_TXCONF_PER_NAPI) {
 			work_done = budget;
+			if (ch->xdp.res & XDP_REDIRECT)
+				xdp_do_flush();
 			goto out;
 		}
 	} while (store_cleaned);
 
+	if (ch->xdp.res & XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Update NET DIM with the values for this CDAN */
 	dpaa2_io_update_net_dim(ch->dpio, ch->stats.frames_per_cdan,
 				ch->stats.bytes_per_cdan);
@@ -2032,9 +2037,7 @@ static int dpaa2_eth_poll(struct napi_struct *napi, int budget)
 		txc_fq->dq_bytes = 0;
 	}
 
-	if (ch->xdp.res & XDP_REDIRECT)
-		xdp_do_flush_map();
-	else if (rx_cleaned && ch->xdp.res & XDP_TX)
+	if (rx_cleaned && ch->xdp.res & XDP_TX)
 		dpaa2_eth_xdp_tx_flush(priv, ch, &priv->fq[flowid]);
 
 	return work_done;
-- 
2.34.1

