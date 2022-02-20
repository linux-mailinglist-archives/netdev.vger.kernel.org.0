Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB3E4BCE7C
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 13:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243794AbiBTMhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 07:37:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237584AbiBTMh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 07:37:29 -0500
X-Greylist: delayed 912 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Feb 2022 04:37:02 PST
Received: from m12-13.163.com (m12-13.163.com [220.181.12.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 193A31CFF8;
        Sun, 20 Feb 2022 04:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=VfNAl
        9/DiJ/AOEvq/afPXFSM9dLg0z47O2GF4wGlOnA=; b=YvLChohVrS4RYATpW55E9
        sLq7qEZdOMf8hKllF0VVHCxeTyGl/0Xm51QZcRnRoNGFFcvKYaqyPdOrpe8wfEd6
        NicgIRaJ88I4OAPQDTuPjBN2X0NZfyHmQNVrXaAw9iY5wvdZg6zuDVTZndw4E0Sr
        Z7RKyHBIYAFCsD0tdaAzfE=
Received: from localhost (unknown [223.74.153.176])
        by smtp9 (Coremail) with SMTP id DcCowACn1WEwMhJism6+Dg--.219S2;
        Sun, 20 Feb 2022 20:21:08 +0800 (CST)
From:   wudaemon <wudaemon@163.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     chenhao288@hisilicon.com, arnd@arndb.de, wudaemon@163.com,
        shenyang39@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ksz884x: use time_before in netdev_open for compatibility
Date:   Sun, 20 Feb 2022 12:21:01 +0000
Message-Id: <20220220122101.5017-1-wudaemon@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcCowACn1WEwMhJism6+Dg--.219S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryUKryDKF1ftFy7ZFWUurg_yoW3Grb_ur
        12gFsxKw4FkF1Fvws7KF45A3yF9r4DXrs5ZF42qFWSqr95Xr9rC34kGrW7Kw18Wr15JF98
        WrW2qa4Sva42qjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRt6pPDUUUUU==
X-Originating-IP: [223.74.153.176]
X-CM-SenderInfo: 5zxgtvxprqqiywtou0bp/1tbisAytbVUMRbDqJwABsc
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

use time_before instead of direct compare for compatibility

Signed-off-by: wudaemon <wudaemon@163.com>
---
 drivers/net/ethernet/micrel/ksz884x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index d024983815da..fd3cb9ce438f 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -5428,7 +5428,7 @@ static int netdev_open(struct net_device *dev)
 		if (rc)
 			return rc;
 		for (i = 0; i < hw->mib_port_cnt; i++) {
-			if (next_jiffies < jiffies)
+			if (time_before(next_jiffies, jiffies))
 				next_jiffies = jiffies + HZ * 2;
 			else
 				next_jiffies += HZ * 1;
-- 
2.25.1

