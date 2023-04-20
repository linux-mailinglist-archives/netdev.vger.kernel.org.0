Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D362B6E956E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbjDTNLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjDTNLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:11:22 -0400
Received: from hust.edu.cn (unknown [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8F940C6;
        Thu, 20 Apr 2023 06:11:20 -0700 (PDT)
Received: from wjk.. ([10.12.190.56])
        (user=wangjikai@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33KD8iYo011467-33KD8iYp011467
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 20 Apr 2023 21:09:14 +0800
From:   Wang Jikai <wangjikai@hust.edu.cn>
To:     Jakub Kicinski <kuba@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Wang Jikai <wangjikai@hust.edu.cn>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 1/2] wifi: mt7601u: delete dead code checking debugfs returns
Date:   Thu, 20 Apr 2023 13:08:14 +0000
Message-Id: <20230420130815.8425-1-wangjikai@hust.edu.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-FEAS-AUTH-USER: wangjikai@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch reports that:
drivers/net/wireless/mediatek/mt7601u/debugfs.c:130
mt7601u_init_debugfs() warn: 'dir' is an error pointer or valid".

Debugfs code is not supposed to need error checking so instead of
changing this to if (IS_ERR()) the correct thing is to just delete
the dead code.

Fixes: c869f77d6abb ("add mt7601u driver")
Signed-off-by: Wang Jikai <wangjikai@hust.edu.cn>
---
The issue is found by static analysis and remains untested.
---
 drivers/net/wireless/mediatek/mt7601u/debugfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/debugfs.c b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
index 230b0e1061a7..dbddf256921b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt7601u/debugfs.c
@@ -127,8 +127,6 @@ void mt7601u_init_debugfs(struct mt7601u_dev *dev)
 	struct dentry *dir;
 
 	dir = debugfs_create_dir("mt7601u", dev->hw->wiphy->debugfsdir);
-	if (!dir)
-		return;
 
 	debugfs_create_u8("temperature", 0400, dir, &dev->raw_temp);
 	debugfs_create_u32("temp_mode", 0400, dir, &dev->temp_mode);
-- 
2.34.1

