Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579AB69E1C4
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 14:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjBUN5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 08:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbjBUN5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 08:57:24 -0500
X-Greylist: delayed 474 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Feb 2023 05:57:23 PST
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C00529E0B;
        Tue, 21 Feb 2023 05:57:23 -0800 (PST)
Received: from maxwell ([109.42.115.188]) by mrelayeu.kundenserver.de
 (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MLAAs-1pDLWN3diM-00IDz4; Tue, 21 Feb 2023 14:43:46 +0100
User-agent: mu4e 1.8.14; emacs 28.2
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: Premature loop termination check was ignored
Date:   Tue, 21 Feb 2023 14:38:27 +0100
Message-ID: <87fsaz6smr.fsf@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:UEjmjts8a3oTdsLqA0rvc+/8E/eBATSNya9dC/1ORtjI2CTbQIV
 026feQLR23g4KIE8KNi+xOP9CLdOH2OCXKfaoWA6GH2HDSTi19nBIPyzmtVl2wMYrIjCvH3
 isHWzjznLhletxDQAJCJ3eXjglO8hIlRuBFGx4NH3AuMwGPmeL/2W7tTxG5se50qeIZyDWM
 nhIs4cPTID5tfbZgbCH5A==
UI-OutboundReport: notjunk:1;M01:P0:79SNAF3zbgU=;7BTpu1ExYbUPqF6rtfvH5lDXt/J
 NT0fvRBvpIQUM5STLjEuwwmcZGT4vQmo1uXjoJMPYCUiZrcc7kOXrvBp7h4kT+x0m66Q1aH71
 yI35iuUMYsnM463ryPftmPmMhxQ1cmad14kILcxOUnOLYOj1MrMmdtR/FVOqKn+VwcTCFLjza
 oxQc4KfxLEvPkUkZgUAKFtCyCxs8TER87FCLjBed5R27v53ulkefkXRvQyY0+X5TMyJ6poR0e
 p/PmuYoEvQmI9qPry+Tavq/tJ84ed0sO4Xa1AEwC/0SuHEbG89pZH4eCKyJfQtBPLvuKexcgu
 8IcN8bsOytvxbtgm+C0fq3g5vSzapRG4iLB8ATi/xfo69hvSRh3voJU5Qk3eNQhErwUPf0MXS
 JOkQplpxNwcVKNUHJMzVmZpNnrIo8qO9lE+c7comhdH3oWQ30KeomxMfjdMFohwnROIpQtFEr
 Px+8Nwt+A6Ni5IG+4ZFJDGN5T/uQasrM1xeE6B55+lA1R9WDh+c0DMIm+duKLenyeo34Zuodo
 nrcX+qy8gCF1MYo7E/JOMQVa8iDyt1n7G9PBOqK2yik97wL6vgSMClcgn7XunLmAM4K3zPPbo
 J92wJ5WtFMIeIEWoJA8NqoxyhH46110VatzbOzPSw0k86yCKSr/Omvlzv7N3Q1WHD/JaedFPX
 VV8ITVl8gYeP7cFaRzMT2YNt+g11n1X7LSIQzXzIsw==
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

Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
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
