Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AACB5F6DE7
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiJFTGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbiJFTGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:06:33 -0400
X-Greylist: delayed 108 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 06 Oct 2022 12:06:26 PDT
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB00A0272
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:06:25 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=localhost.localdomain)
        by syslogsrv with esmtp (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1ogWCD-0004PG-M0; Thu, 06 Oct 2022 22:06:13 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>
Cc:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: prestera: span: do not unbind things things that were never bound
Date:   Thu,  6 Oct 2022 22:06:00 +0300
Message-Id: <20221006190600.881740-1-maksym.glubokiy@plvision.eu>
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

Fixes: 13defa275eef ("net: marvell: prestera: Add matchall support")
Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_span.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_span.c b/drivers/net/ethernet/marvell/prestera/prestera_span.c
index f0e9d6ea88c5..1005182ce3bc 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_span.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_span.c
@@ -107,7 +107,7 @@ static int prestera_span_put(struct prestera_switch *sw, u8 span_id)
 
 	entry = prestera_span_entry_find_by_id(sw->span, span_id);
 	if (!entry)
-		return false;
+		return -ENOENT;
 
 	if (!refcount_dec_and_test(&entry->ref_count))
 		return 0;
@@ -151,6 +151,9 @@ int prestera_span_rule_del(struct prestera_flow_block_binding *binding,
 {
 	int err;
 
+	if (binding->span_id == PRESTERA_SPAN_INVALID_ID)
+		return -ENOENT;
+
 	err = prestera_hw_span_unbind(binding->port, ingress);
 	if (err)
 		return err;
-- 
2.25.1

