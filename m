Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2738E66D9DC
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbjAQJ1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236582AbjAQJ1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:27:16 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DF815567;
        Tue, 17 Jan 2023 01:25:59 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so1048610wmq.0;
        Tue, 17 Jan 2023 01:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAUfOgwTFuIvNwuhx5n2F0/0oHdZLDnXBOo9K0VmpcQ=;
        b=CWtyl5xVAN8hDnS+osaxQdP5svguFEVGu+ZeXMtdRw3eRHlOE/vA/IYhk/kfGU3GAH
         hVuHssnTRYINV7FlfDIUsyQlOvRZkc6OH3B70eG6eWmsyaEZaihqU1tMb2w2uZ6eKYmO
         6+cm3IsMfMWgLzdHFXRxNegoPQfXf8ghmzi00CDMYxK5rO/9etaH7I35oV89SJsXGH3j
         mw/KNj6pNs92b7fJk2WThTpCGq12pSu4rKfQkCHpd4yaZvNqj21rOOJZW/opXEZ2nX6u
         kWG+fWpHrhqDx7ZrhZ2zZw8qojOBUm+cin3YPkJeV/G+FdiB970Tnwha+pOZ5TiHbieT
         ae7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qAUfOgwTFuIvNwuhx5n2F0/0oHdZLDnXBOo9K0VmpcQ=;
        b=6RzOPnkfuTTSG8Ddn+NXz5x0mW+TEjPvDvQB8jS//K6gllNCkLJY1DgBuRPBwX7UDy
         KddPEXbsycSyv1/H/ewNKHgUmMsOFNF1kFTiokH8NCfAdnsCVupbK5X3YMkkBpPuSN9t
         Lg23Tv6uBxYWnRKdSQH7Qh+pXfV0COYHNF7S9SxSNKdt3Wgi1NcJgS1TYrwE2L0vM4Fo
         fZjQ4co0O6HKg2hM0/U5toyORAzvPXiN2/E53PVxEq1LJjfvXC+b41RGC00fRZENG6fs
         FOSlWRsd1OdyPL5Df/AK849QhbtUPtuBtahlSHOb3h19LloNlJaYelaASzAkflLKAQJf
         mPSw==
X-Gm-Message-State: AFqh2kobv0ihZJZyTYBVV5D1KI7d/mHIdsiusR7BYZGMJCzOXicw1tyA
        9x0bIrStgxyH6UREm9S4xdA=
X-Google-Smtp-Source: AMrXdXtKyFP8bM66TzUWLToIZLcryLHL4fR0j/jL6Fd7JFFRr2/Frp8JmnrnOF4nJMhclqcklA5QGw==
X-Received: by 2002:a7b:c5cb:0:b0:3da:fac4:7da3 with SMTP id n11-20020a7bc5cb000000b003dafac47da3mr2243545wmk.36.1673947558214;
        Tue, 17 Jan 2023 01:25:58 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id u21-20020a7bc055000000b003d9aa76dc6asm48008881wmc.0.2023.01.17.01.25.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Jan 2023 01:25:57 -0800 (PST)
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
Subject: [PATCH net 1/5] qede: execute xdp_do_flush() before napi_complete_done()
Date:   Tue, 17 Jan 2023 10:25:29 +0100
Message-Id: <20230117092533.5804-2-magnus.karlsson@gmail.com>
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

Fixes: d1b25b79e162b ("qede: add .ndo_xdp_xmit() and XDP_REDIRECT support")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 7c2af482192d..cb1746bc0e0c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1438,6 +1438,10 @@ int qede_poll(struct napi_struct *napi, int budget)
 	rx_work_done = (likely(fp->type & QEDE_FASTPATH_RX) &&
 			qede_has_rx_work(fp->rxq)) ?
 			qede_rx_int(fp, budget) : 0;
+
+	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
+		xdp_do_flush();
+
 	/* Handle case where we are called by netpoll with a budget of 0 */
 	if (rx_work_done < budget || !budget) {
 		if (!qede_poll_is_more_work(fp)) {
@@ -1457,9 +1461,6 @@ int qede_poll(struct napi_struct *napi, int budget)
 		qede_update_tx_producer(fp->xdp_tx);
 	}
 
-	if (fp->xdp_xmit & QEDE_XDP_REDIRECT)
-		xdp_do_flush_map();
-
 	return rx_work_done;
 }
 
-- 
2.34.1

