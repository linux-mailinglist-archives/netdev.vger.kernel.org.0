Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D49E6EA6D7
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbjDUJXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbjDUJXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:23:36 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C9310D0;
        Fri, 21 Apr 2023 02:23:33 -0700 (PDT)
Received: from wjk.. ([10.12.190.56])
        (user=wangjikai@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33L9M1k7026707-33L9M1k8026707;
        Fri, 21 Apr 2023 17:22:06 +0800
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
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2] wifi: mt7601u: delete dead code checking debugfs returns
Date:   Fri, 21 Apr 2023 09:22:00 +0000
Message-Id: <20230421092200.24456-1-wangjikai@hust.edu.cn>
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

Signed-off-by: Wang Jikai <wangjikai@hust.edu.cn>
---
v1 -> v2: not add redundant removal of debugfs dir. remove fixes
tag.

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

