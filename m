Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F47A5F6E2D
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbiJFT0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiJFT0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:26:20 -0400
X-Greylist: delayed 1186 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Oct 2022 12:26:12 PDT
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE029E6AD;
        Thu,  6 Oct 2022 12:26:12 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1ogWAN-0004O0-OZ; Thu, 06 Oct 2022 22:04:19 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Subject: [PATCH net] prestera: matchall: do not rollback if rule exists
Date:   Thu,  6 Oct 2022 22:04:09 +0300
Message-Id: <20221006190409.881219-1-maksym.glubokiy@plvision.eu>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Serhiy Boiko <serhiy.boiko@plvision.eu>

If you try to create a 'mirror' ACL rule on a port that already has a
mirror rule, prestera_span_rule_add() will fail with EEXIST error.

This forces rollback procedure which destroys existing mirror rule on
hardware leaving it visible in linux.

Add an explicit check for EEXIST to prevent the deletion of the existing
rule but keep user seeing error message:

  $ tc filter add dev sw1p1 ... skip_sw action mirred egress mirror dev sw1p2
  $ tc filter add dev sw1p1 ... skip_sw action mirred egress mirror dev sw1p3
  RTNETLINK answers: File exists
  We have an error talking to the kernel

Fixes: 13defa275eef ("net: marvell: prestera: Add matchall support")
Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_matchall.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
index 6f2b95a5263e..1da9c1bc1ee9 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_matchall.c
@@ -96,6 +96,8 @@ int prestera_mall_replace(struct prestera_flow_block *block,
 
 	list_for_each_entry(binding, &block->binding_list, list) {
 		err = prestera_span_rule_add(binding, port, block->ingress);
+		if (err == -EEXIST)
+			return err;
 		if (err)
 			goto rollback;
 	}
-- 
2.25.1

