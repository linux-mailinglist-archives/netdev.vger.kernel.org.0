Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09AD66D9E7
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbjAQJ2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbjAQJ1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:27:45 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DDC265AC;
        Tue, 17 Jan 2023 01:26:07 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l41-20020a05600c1d2900b003daf986faaeso4029833wms.3;
        Tue, 17 Jan 2023 01:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLCA8Czl5WQ/VKvIIWxUV8C56Hw+2JQ+C9JrrfhSbGo=;
        b=jTru5zR2JAPq4quFWC8I79DsdGsYxCoutSgm2m7XyTev2bPe3VOuXAt4cXu3wrcaSB
         BKs+loD/1MuvBKN4SKpUg9c8HOHlQDOAdsbWYxovyxdTOGLDcfn9fxjJsyjxoIxPl7+v
         Qmfu2H19gDKtKGlrKzEvm3JT1numjOmNllTy2d8g3d+Wq4OvsNcDC4j+sqh9yWoy+r5q
         37SIfnpuwgXeQWM2nCNLPu+okXuxdHUJI1P7YMwNEdb8oAOOwPKicqjXN/k8cCKySGna
         I0uDDSVYMK+EtqAg3BlyS7QKRq4XqnqNVIuKigq2nRt3kqmfqegsdyhBZvnVkD7w62/h
         GkqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HLCA8Czl5WQ/VKvIIWxUV8C56Hw+2JQ+C9JrrfhSbGo=;
        b=Fb9prVRS67IHuGBcmktjq1B9ziUGQ2geMZRFzVZ3HFtzGhW4b78rLfHcb10/TH/NIV
         Yd1Ad6iNvmVlxVp34b+DuNMHk2Po3BcZ/TecB1YLflQdBWUuKw3NQ/wRRBo6JhQnZjuw
         vUkx9ePqyj+jW3KVCPOqruqsY0P3yw43v3XCbERQvzv5CXJoLKCxRWV7182cUslmUsrn
         SWfIJMen3AgF0USR5Iqww26z6pjJ4KE6WxSS2PZuec9pBnlCZO2oxko6kSOrdO1y/dr+
         FJkN/OTGH71bJ3Da3yc3vgYNiU2Hxhj5bO1oxozurbuEun5tYJH6NYQW91ztdZ2xXDFS
         Dn/w==
X-Gm-Message-State: AFqh2kpjTpn5H9EKzX6FJI92cFJqF9/sJ+j8peMl0lPoIK4MQ97mZmxC
        18tlcEyJZ5nBZtlvcbYccvY=
X-Google-Smtp-Source: AMrXdXvHuCNk1VtpA0OUrQyo1zFtGnK0IGNQIdV6FDXstsNqEBiwNf2yQsBIuxfMYjbnhS2So5UMHw==
X-Received: by 2002:a05:600c:33a8:b0:3d9:ed3b:5b3e with SMTP id o40-20020a05600c33a800b003d9ed3b5b3emr2291508wmp.19.1673947565533;
        Tue, 17 Jan 2023 01:26:05 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id u21-20020a7bc055000000b003d9aa76dc6asm48008881wmc.0.2023.01.17.01.26.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:26:04 -0800 (PST)
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
Subject: [PATCH net 4/5] dpaa_eth: execute xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:25:32 +0100
Message-Id: <20230117092533.5804-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117092533.5804-1-magnus.karlsson@gmail.com>
References: <20230117092533.5804-1-magnus.karlsson@gmail.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make sure that xdp_do_flush() is always executed before
napi_complete_done(). This is important for two reasons. First, a
redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
napi context X on CPU Y will be follwed by a xdp_do_flush() from the
same napi context and CPU. This is not guaranteed if the
napi_complete_done() is executed before xdp_do_flush(), as it tells
the napi logic that it is fine to schedule napi context X on another
CPU. Details from a production system triggering this bug using the
veth driver can be found following the first link below.

The second reason is that the XDP_REDIRECT logic in itself relies on
being inside a single NAPI instance through to the xdp_do_flush() call
for RCU protection of all in-kernel data structures. Details can be
found in the second link below.

Fixes: a1e031ffb422 ("dpaa_eth: add XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 3f8032947d86..027fff9f7db0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2410,6 +2410,9 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 
 	cleaned = qman_p_poll_dqrr(np->p, budget);
 
+	if (np->xdp_act & XDP_REDIRECT)
+		xdp_do_flush();
+
 	if (cleaned < budget) {
 		napi_complete_done(napi, cleaned);
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
@@ -2417,9 +2420,6 @@ static int dpaa_eth_poll(struct napi_struct *napi, int budget)
 		qman_p_irqsource_add(np->p, QM_PIRQ_DQRI);
 	}
 
-	if (np->xdp_act & XDP_REDIRECT)
-		xdp_do_flush();
-
 	return cleaned;
 }
 
-- 
2.34.1

