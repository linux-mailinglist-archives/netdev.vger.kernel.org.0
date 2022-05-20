Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5466552E499
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 07:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245523AbiETF7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 01:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbiETF7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 01:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6CE714AA74
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 22:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D739461D6D
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D24C385A9;
        Fri, 20 May 2022 05:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653026386;
        bh=CF1gyXPHx4nunW7HIQ4oaZKriA3jpyZPgRsquQHSi7A=;
        h=From:To:Cc:Subject:Date:From;
        b=DqodoMfb2t+N1xHJQWJ01onog58hrU72CEGT9rJR68Z8W8Xcg/qxe1CzV/NhQbO+H
         9xq63bWbiw/HuPbsbLmghVn7TKI+chsdT1MX0bovZmhx7pV4tawK+3QPZH9DOOTDDE
         cXkZsfW/+NxkZT8zo7PziIOK/xd/ACSrONyp4KYqKTaHw/TszqKoBYCgk5wwhptB4g
         Vcv6p+WPdhy3lG/XuHjB16DnzUK96uDoVGlmn1sixiF/JY+Ue16oNWG4Wx0IPsX+2j
         V5nL3vCQAHHa36WU0r4BbFakjFDpmZ0IXnlCz69WoUD42nxW0Qy62J8G2lrbz9Jbm0
         xsriuKMuzE23w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        keescook@chromium.org, Jakub Kicinski <kuba@kernel.org>,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, matthias.bgg@gmail.com
Subject: [PATCH net-next] eth: mtk_eth_soc: silence the GCC 12 array-bounds warning
Date:   Thu, 19 May 2022 22:59:40 -0700
Message-Id: <20220520055940.2309280-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
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
index 45ba0970504a..611f7b4d4eb8 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -11,3 +11,8 @@ mtk_eth-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_debugfs.o
 endif
 obj-$(CONFIG_NET_MEDIATEK_SOC_WED) += mtk_wed_ops.o
 obj-$(CONFIG_NET_MEDIATEK_STAR_EMAC) += mtk_star_emac.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1 builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_mtk_ppe.o += $(call cc-disable-warning, array-bounds)
+endif
-- 
2.34.3

