Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240DB69E8B9
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 21:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjBUUAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 15:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjBUUAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 15:00:23 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CB92914E;
        Tue, 21 Feb 2023 12:00:17 -0800 (PST)
Received: from maxwell ([109.42.115.188]) by mrelayeu.kundenserver.de
 (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MqqLB-1oi0cp2xij-00mwY7; Tue, 21 Feb 2023 20:59:50 +0100
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net V2] net: stmmac: Premature loop termination check was
 ignored
Date:   Tue, 21 Feb 2023 20:58:30 +0100
Message-ID: <87356y7pse.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:PGSPSIWFzfFaZ6WQFk04hnkrL2Jr+FcXFWwVHu3dZurDPzXBb8W
 MEiFKk3Fs9MqaIpz2ZNHez+WdZY5pmgWk5dBjeMkgP1APdnpiwHk8vu3pC+p5hUaO/xoqoX
 SA8ectum9QkFYpa07y3YvQUwzhjX06GlmzexGgukvabZWturdbRfzvJT2mEbTJe3M33l6gN
 eR1jOIqJAugsKtJMeEKFg==
UI-OutboundReport: notjunk:1;M01:P0:IvducrWJ2gA=;sj6aQA6LBDhuosVehFMn9CkCfV+
 TuKyhZyizukGLSoLYW78SuZ7Cm18vUWvP7wvjDZoXOixSI76xnnFuuIPHm3m9XEIRu4Zi5EvQ
 /5bOP8ysHXZMYXoy3QKwtQzFqULJiUJerxe0p0XKTGjE69P0dsqPo96DXeLBFIzZDEVWeh9qx
 dbXEF/dlvnesjWyLOqJCQs/1U1kKenbLBtBzeUCNvJfqFtCdzTgDFzv6PTYibKM/v/F+ohnd+
 TyCijV0pR03YHdgjaQw4F0c5wt3AiKw4OlW//uIaJTsBMSuTw1k4hFc2v2tE71xPfeTk4sOOy
 +Zeq/xbtebg06AMMn4pXrtIxjK2ZjMR+evjObP1kW1NZFXJmGcZJXxa2qwupXZdMPkonBO1iZ
 kZpYoahZsQ+Qe2wN5JF04cj6JMbP7yJ0j+ot4gxRGa+yZBPEfrW2gWN+aNJLUIHqe8n9YaopY
 P5DdjV21uq78Lq8RG19c4i6ujTYJlnWrMITxqBo6QFbUm7jIPnfug88C+N+BSOdvOeNyQAVv5
 nicdGetivvcivvcF9K1ejXn3WSG+mycU6N1TKkPtUwZmHSr345UmQZqeUducRZk8SV96P6wty
 GlLY6K5wcPe8qdEVXospVWd5Hciw/2zfxdZ/06ktzPVZ/P1idiWjol7I6+Bu3/Zze//Roxig/
 xoHo9OXzj7s+AmoqsbUbWngLK2ioOUVrgzXTdosIqg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The premature loop termination check makes sense only in case of the
jump to read_again where the count may have been updated. But
read_again did not include the check.

Fixes: bba2556efad6 (net: stmmac: Enable RX via AF_XDP zero-copy)
Fixes: ec222003bd94 (net: stmmac: Prepare to add Split Header support)
Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
V2: Added fixes tags for both commits that introduced the issues

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1a5b8dab5e9b..de98c009866a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5031,10 +5031,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		entry = next_entry;
 		buf = &rx_q->buf_pool[entry];
@@ -5221,10 +5221,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			len = 0;
 		}
 
+read_again:
 		if (count >= limit)
 			break;
 
-read_again:
 		buf1_len = 0;
 		buf2_len = 0;
 		entry = next_entry;
-- 
2.39.2
