Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DAF52F411
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353351AbiETT4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344894AbiETT4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:56:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78FCB7CB15
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 12:56:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE337CE2CDF
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 19:56:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F59C34116;
        Fri, 20 May 2022 19:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653076573;
        bh=JmGPiXCc1no9OKyKuSnuRr38KzHGO/M4lw7vH5aLkcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SS+eZ8ktuTltIk+EmcYqGdFyWJAHLinjorZ0U2fI9mjOjj+HAQg71wak1x/P7KTMo
         Q/SDLl4odIBc4QU4xBtoM43t7+N/+282Q9ild47/IyYn6QEERLppOlFUTJ6Q4jfMYs
         VrUA8hvfE5GnSgrFSQYX6bKg2YrlT0civen73WivxHfFfY5WNmh+iL0HN3ZYJeCKfB
         bk1xrD4q6XNna4Hh0/DCAeMXJw6F922U5t9/hZOzOiYLYwgP4gdvi820GRJZWc7nh8
         oOddJtayZKuyDlEN4DHaFuWxlzM6S5wdCOpvWQcJJrgEXIbNuDEZKSQeWVL9jaumk4
         bM5fc8LcQR9kQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, nbd@nbd.name,
        john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
Subject: [PATCH net-next v2 1/3] eth: mtk_eth_soc: silence the GCC 12 array-bounds warning
Date:   Fri, 20 May 2022 12:56:03 -0700
Message-Id: <20220520195605.2358489-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520195605.2358489-1-kuba@kernel.org>
References: <20220520195605.2358489-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 gets upset because in mtk_foe_entry_commit_subflow()
this driver allocates a partial structure. The writes are
within bounds.

Silence these warnings for now, our build bot runs GCC 12
so we won't allow any new instances.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nbd@nbd.name
CC: john@phrozen.org
CC: sean.wang@mediatek.com
CC: Mark-MC.Lee@mediatek.com
CC: matthias.bgg@gmail.com
---
 drivers/net/ethernet/mediatek/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index 45ba0970504a..fe66ba8793cf 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -11,3 +11,8 @@ mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
 endif
 obj-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_ops.o
 obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_mtk_ppe.o += -Wno-array-bounds
+endif
-- 
2.34.3

