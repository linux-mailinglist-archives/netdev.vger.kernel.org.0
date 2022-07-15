Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35E95762E6
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 15:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234625AbiGONjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 09:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiGONjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 09:39:33 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B340F5B1;
        Fri, 15 Jul 2022 06:39:32 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oCKrJ-0001SM-KU; Fri, 15 Jul 2022 15:55:53 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: prestera: acl: use proper mask for port selector
Date:   Fri, 15 Jul 2022 15:55:50 +0300
Message-Id: <20220715125550.19352-1-maksym.glubokiy@plvision.eu>
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

Adjusted as per packet processor documentation.
This allows to properly match 'indev' for clsact rules.

Fixes: 47327e198d42 ("net: prestera: acl: migrate to new vTCAM api")

Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_flower.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index d43e503c644f..4d93ad6a284c 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -167,12 +167,12 @@ static int prestera_flower_parse_meta(struct prestera_acl_rule *rule,
 	}
 	port = netdev_priv(ingress_dev);
 
-	mask = htons(0x1FFF);
-	key = htons(port->hw_id);
+	mask = htons(0x1FFF << 3);
+	key = htons(port->hw_id << 3);
 	rule_match_set(r_match->key, SYS_PORT, key);
 	rule_match_set(r_match->mask, SYS_PORT, mask);
 
-	mask = htons(0x1FF);
+	mask = htons(0x3FF);
 	key = htons(port->dev_id);
 	rule_match_set(r_match->key, SYS_DEV, key);
 	rule_match_set(r_match->mask, SYS_DEV, mask);
-- 
2.25.1

