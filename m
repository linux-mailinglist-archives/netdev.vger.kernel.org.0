Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A06BC811
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCPIBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjCPIBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:01:48 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D6E3CE3E;
        Thu, 16 Mar 2023 01:01:42 -0700 (PDT)
Received: from maxwell.fritz.box ([109.42.114.157]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MmDZI-1qKbvm25dg-00iGnY; Thu, 16 Mar 2023 09:00:50 +0100
From:   Jochen Henneberg <jh@henneberg-systemdesign.com>
To:     netdev@vger.kernel.org
Cc:     Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net V2 1/2] net: stmmac: Premature loop termination check was ignored on rx
Date:   Thu, 16 Mar 2023 08:59:39 +0100
Message-Id: <20230316075940.695583-2-jh@henneberg-systemdesign.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
References: <20230316075940.695583-1-jh@henneberg-systemdesign.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dJfqpxbCayMr14ZFZm6NMfVkugOqNjZ2iAm1ZLyeMPYoZbW08Lt
 ezIrj1cTZrWHpr2CpztcBtZE2fTekHb3T9QhUeri4Wt8WKnySAuUg4bIcGA3OYMwjl5TL64
 0QebK9E1A+ExosRjclv3CIPLbXK9+nhooxmIW8ybunk1oqJsgFGRQK1GAzfyaMRLRAFm8yL
 vCzKHUO8P58D1wHOkkP5A==
UI-OutboundReport: notjunk:1;M01:P0:JxekeCwxMts=;mYRg07aZUIGOTMgzcF6FhusRbxy
 M5FCszaB2xtyZ6GAMnGLSMOt6OAJxjyt8IDhkBft2C1qNrtLO8JiNNCi+1I37J95xipWG67AR
 YVhdkVd8yZKeP1vGW/rS0AuFg0C+K5hv8077Oj5f0tJFE/7e+J4v78fP0lFlRitsDBCaES3UB
 azH72JkUGe8QPes6XT5PcyAtPl+HqjQmjAnm0ziePShDWyTnR+45nxGbebNI0RQJMzm/aszPb
 OqkxkIPp6l5bTGdlketCVg3cb2WL+cwsqnNk1nppzulJY+y64dqohoHkR3jcwT6MYRI/3ui2y
 cJzbqIT99TPi0IzTSD5SyGXaGyznCPZ2Ed6yNY9szyiBowHVYE/fhwVCGQxU5bdlIstrZAT7y
 yNXYRC3BMIYvJH11MhM5Mnu4pePCxDhP7/jE4btJRDHSi2CZ7fwj1A5+AHtCDoOP6FCMLbA+e
 nL5mIU+Qzh29/wXJzzsO3xszYy1UcoKyPHvUSh7DA87aB9iTG95h8u52PW/ERA4A/X3F1TRoU
 lIuVzjibAk+f12wXUdWaYNAw3NTVcK7Oq2tgEzMDcQ8Cvq3w04PANYHRjFMKrZYrZ3vqykYyS
 n4HQdHo/CS2ogo8C5rCvwI7pOvcDyRZKXV1VQXL3RuoD89OTJUDcmGBIh7/diwb7LiUp9ctaU
 lKt0aFx3mBJkkegvRrwxgpb6/5T5L18D6canc0/qjA==
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

Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
Signed-off-by: Jochen Henneberg <jh@henneberg-systemdesign.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e4902a7bb61e..ea51c7c93101 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
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

