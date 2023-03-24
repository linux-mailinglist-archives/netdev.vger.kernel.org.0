Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7006C762D
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 04:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjCXDPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 23:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjCXDPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 23:15:18 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE57AF3B;
        Thu, 23 Mar 2023 20:15:17 -0700 (PDT)
Received: from pride-PowerEdge-R740.. ([172.16.0.254])
        (user=u201912584@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 32O3E84U023389-32O3E84V023389
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 24 Mar 2023 11:14:14 +0800
From:   SongJingyi <u201912584@hust.edu.cn>
To:     Yangbo Lu <yangbo.lu@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        SongJingyi <u201912584@hust.edu.cn>,
        Dan Carpenter <error27@gmail.com>,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ptp_qoriq: fix memory leak in probe()
Date:   Fri, 24 Mar 2023 11:14:06 +0800
Message-Id: <20230324031406.1895159-1-u201912584@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: u201912584@hust.edu.cn
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that:
drivers/ptp/ptp_qoriq.c ptp_qoriq_probe()
warn: 'base' from ioremap() not released.

Fix this by revising the parameter from 'ptp_qoriq->base' to 'base'.
This is only a bug if ptp_qoriq_init() returns on the
first -ENODEV error path.
For other error paths ptp_qoriq->base and base are the same.
And this change makes the code more readable.

Fixes: 7f4399ba405b ("ptp_qoriq: fix NULL access if ptp dt node missing")
Signed-off-by: SongJingyi <u201912584@hust.edu.cn>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
 drivers/ptp/ptp_qoriq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 61530167efe4..350154e4c2b5 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -637,7 +637,7 @@ static int ptp_qoriq_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
-	iounmap(ptp_qoriq->base);
+	iounmap(base);
 no_ioremap:
 	release_resource(ptp_qoriq->rsrc);
 no_resource:
-- 
2.34.1

