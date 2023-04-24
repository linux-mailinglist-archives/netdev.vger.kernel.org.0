Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B7E6ED1A7
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 17:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbjDXPpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 11:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjDXPpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 11:45:41 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE28B6EAB;
        Mon, 24 Apr 2023 08:45:37 -0700 (PDT)
Received: from liber-MS-7D42.. ([10.12.190.56])
        (user=gangecen@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33OFSRmo021659-33OFSRmp021659
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 24 Apr 2023 23:28:32 +0800
From:   Gencen Gan <gangecen@hust.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Gan Gecen <gangecen@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] net: amd: Fix link leak when verifying config failed
Date:   Mon, 24 Apr 2023 23:28:01 +0800
Message-Id: <20230424152805.188004-1-gangecen@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: gangecen@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After failing to verify configuration, it returns directly without
releasing link, which may cause memory leak.

Paolo Abeni thinks that the whole code of this driver is quite 
"suboptimal" and looks unmainatained since at least ~15y, so he 
suggests that we could simply remove the whole driver, please 
take it into consideration.

Simon Horman suggests that the fix label should be set to 
"Linux-2.6.12-rc2" considering that the problem has existed
since the driver was introduced and the commit above doesn't
seem to exist in net/net-next.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Gan Gecen <gangecen@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
v4->v5: I have made some mistakes on patch rules, sorry for that.
v3->v4: Modify the 'Fixes:' tag to make it more accurate.
v2->v3: Add Fixes tag and add a suggestion about this driver.
v1->v2: Fix the whitespace-damaged bug.
 drivers/net/ethernet/amd/nmclan_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 823a329a921f..0dd391c84c13 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -651,7 +651,7 @@ static int nmclan_config(struct pcmcia_device *link)
     } else {
       pr_notice("mace id not found: %x %x should be 0x40 0x?9\n",
 		sig[0], sig[1]);
-      return -ENODEV;
+      goto failed;
     }
   }
 
-- 
2.34.1

