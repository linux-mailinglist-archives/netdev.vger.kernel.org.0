Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A7630F68E
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 16:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbhBDPj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 10:39:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237407AbhBDPi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 10:38:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E026D64F44;
        Thu,  4 Feb 2021 15:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612453098;
        bh=Za7/JigMay2H08zCfoFaKH8zh1lEWxdc4RaDwMpdQ7I=;
        h=From:To:Cc:Subject:Date:From;
        b=kemxjGicQXB92hwsg4Zbdb9VO+WIvTBz89JBR9RjL2Ja4B/jzb2jbe2eS5v+4QTU8
         YtZAuHmDjYWGgXzl4bqSdy2ATeZSXJZGG6y1VIfT2nmwPi2+qUiN9+vr5e8MzSfuNI
         5EXN+9B5lXijENQjFr3I1G803hYukok+eb/yGahk3ozXEQtqQvz0Ep/zy3sexbfRb7
         pOFqph1mxON9pYoZSq9f/Q3j/jJUF1FOFE7lqOSJozoZYuZP5Pio9+FWx4Elgamu9Q
         c4LWHikKPTTzumMmftTTlAzodyPsoc95fUji+KbtvowHMRxg2IoCIHuzHRcCm1Uq8E
         U20M9ESkV+1KA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Yufeng Mo <moyufeng@huawei.com>,
        Jian Shen <shenjian15@huawei.com>,
        Yonglong Liu <liuyonglong@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH] net: hns3: avoid -Wpointer-bool-conversion warning
Date:   Thu,  4 Feb 2021 16:38:06 +0100
Message-Id: <20210204153813.1520736-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang points out a redundant sanity check:

drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c:497:28: error: address of array 'filp->f_path.dentry->d_iname' will always evaluate to 'true' [-Werror,-Wpointer-bool-conversion]

This can never fail, so just remove the check.

Fixes: 04987ca1b9b6 ("net: hns3: add debugfs support for tm nodes, priority and qset info")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 6978304f1ac5..c5958754f939 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -494,9 +494,6 @@ static ssize_t hns3_dbg_read(struct file *filp, char __user *buffer,
 	ssize_t size = 0;
 	int ret = 0;
 
-	if (!filp->f_path.dentry->d_iname)
-		return -EINVAL;
-
 	read_buf = kzalloc(HNS3_DBG_READ_LEN, GFP_KERNEL);
 	if (!read_buf)
 		return -ENOMEM;
-- 
2.29.2

