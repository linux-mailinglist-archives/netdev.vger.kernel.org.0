Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9516EADF8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjDUP0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUP0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:26:02 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB68686A9;
        Fri, 21 Apr 2023 08:26:00 -0700 (PDT)
Received: from van1shing-pc.localdomain ([10.12.182.0])
        (user=silver_code@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33LFAE1Q025521-33LFAE1R025521
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 21 Apr 2023 23:10:16 +0800
From:   Wang Zhang <silver_code@hust.edu.cn>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Wang Zhang <silver_code@hust.edu.cn>,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] net: ethernet: mediatek: remove return value check of `mtk_wed_hw_add_debugfs`
Date:   Fri, 21 Apr 2023 23:10:09 +0800
Message-Id: <20230421151010.130695-1-silver_code@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: silver_code@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that:
mtk_wed_hw_add_debugfs() warn: 'dir' is an error pointer or valid

Debugfs checks are generally not supposed to be checked
for errors and it is not necessary here.

fix it by just deleting the dead code.

Signed-off-by: Wang Zhang <silver_code@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
This issue is found by static analyzer. The patched code has passed
Smatch checker, but remains untested on mediatek soc.
---
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index 56f663439721..b244c02c5b51 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -252,8 +252,6 @@ void mtk_wed_hw_add_debugfs(struct mtk_wed_hw *hw)
 
 	snprintf(hw->dirname, sizeof(hw->dirname), "wed%d", hw->index);
 	dir = debugfs_create_dir(hw->dirname, NULL);
-	if (!dir)
-		return;
 
 	hw->debugfs_dir = dir;
 	debugfs_create_u32("regidx", 0600, dir, &hw->debugfs_reg);
-- 
2.34.1

