Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1376E4BD1
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 16:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjDQOsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 10:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjDQOsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 10:48:31 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C85FE8;
        Mon, 17 Apr 2023 07:48:30 -0700 (PDT)
Received: from liber-MS-7D42.. ([10.12.190.56])
        (user=gangecen@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33HElrYQ010631-33HElrYR010631
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 17 Apr 2023 22:48:00 +0800
From:   Gencen Gan <gangecen@hust.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Gecen Gan <gangecen@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: amd: Fix link leak when verifying config failed
Date:   Mon, 17 Apr 2023 22:47:50 +0800
Message-Id: <20230417144750.3976715-1-gangecen@hust.edu.cn>
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

From: Gecen Gan <gangecen@hust.edu.cn>

After failing to verify configuration, it returns directly without 
releasing link, which may cause memory leak.

Signed-off-by: Gecen Gan <gangecen@hust.edu.cn>
---
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
-     return -ENODEV;
+     goto failed;
    }
  }

-- 
2.34.1
