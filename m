Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F80DE5924
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 09:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfJZHwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 03:52:21 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:60902 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725996AbfJZHwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 03:52:21 -0400
Received: from mse-fl2.zte.com.cn (unknown [10.30.14.239])
        by Forcepoint Email with ESMTPS id DAD3DE01D7A104C0546D;
        Sat, 26 Oct 2019 15:52:16 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl2.zte.com.cn with ESMTP id x9Q7q3oK076541;
        Sat, 26 Oct 2019 15:52:03 +0800 (GMT-8)
        (envelope-from zhang.lin16@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019102615524640-139284 ;
          Sat, 26 Oct 2019 15:52:46 +0800 
From:   zhanglin <zhang.lin16@zte.com.cn>
To:     davem@davemloft.net
Cc:     ast@kernel.org, daniel@iogearbox.net, jakub.kicinski@netronome.com,
        hawk@kernel.org, john.fastabend@gmail.com, mkubecek@suse.cz,
        jiri@mellanox.com, pablo@netfilter.org, f.fainelli@gmail.com,
        maxime.chevallier@bootlin.com, lirongqing@baidu.com,
        vivien.didelot@gmail.com, linyunsheng@huawei.com,
        natechancellor@gmail.com, arnd@arndb.de, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        jiang.xuexin@zte.com.cn, zhanglin <zhang.lin16@zte.com.cn>
Subject: [PATCH] net: Zeroing the structure ethtool_wolinfo in ethtool_get_wol()
Date:   Sat, 26 Oct 2019 15:54:16 +0800
Message-Id: <1572076456-12463-1-git-send-email-zhang.lin16@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-10-26 15:52:46,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-10-26 15:52:09,
        Serialize complete at 2019-10-26 15:52:09
X-MAIL: mse-fl2.zte.com.cn x9Q7q3oK076541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memset() the structure ethtool_wolinfo that has padded bytes
but the padded bytes have not been zeroed out.

Signed-off-by: zhanglin <zhang.lin16@zte.com.cn>
---
 net/core/ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index aeabc48..563a845 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -1471,11 +1471,13 @@ static int ethtool_reset(struct net_device *dev, char __user *useraddr)
 
 static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
 {
-	struct ethtool_wolinfo wol = { .cmd = ETHTOOL_GWOL };
+	struct ethtool_wolinfo wol;
 
 	if (!dev->ethtool_ops->get_wol)
 		return -EOPNOTSUPP;
 
+	memset(&wol, 0, sizeof(struct ethtool_wolinfo));
+	wol.cmd = ETHTOOL_GWOL;
 	dev->ethtool_ops->get_wol(dev, &wol);
 
 	if (copy_to_user(useraddr, &wol, sizeof(wol)))
-- 
2.15.2

