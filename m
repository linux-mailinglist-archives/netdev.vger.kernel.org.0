Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4841C47BA8F
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhLUHOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:14:52 -0500
Received: from smtpbg128.qq.com ([106.55.201.39]:54429 "EHLO smtpbg587.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229999AbhLUHOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 02:14:52 -0500
X-QQ-mid: bizesmtp42t1640070871txh3hbcu
Received: from localhost.localdomain (unknown [118.121.67.96])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 21 Dec 2021 15:14:29 +0800 (CST)
X-QQ-SSF: 01000000002000D0K000B00A0000000
X-QQ-FEAT: Lg5IqoGaTUhVQ2PxsNgh24m9G4JSUp6rcIlsD2Oot6qF+nC9j4GJ6erQryVdw
        hJrJdwy67hmHc4b6Hz833B2nlD0BLoXntdwuTcL66KrdrqIuG8/NYO/Ry8TX2fqXRf6ttCm
        oHQIvnCAUx0MZV+Jt2FV6TLRFwNGOF7FT5GQju90xxrXPWcUgkvTAlSrNJ/NtpDkYxBYhro
        NAvipqhD/LHO23bcub/aGAChkq7Upcip2LAC9ieLjDQ4H6dRMkwzM1BTSPyiidMpA2sUvzJ
        9wfhtU5NQElgZ62VxIC3BQp3eGEu8x6jpZTtccKbSr7zK26y/tHb7kqw6B+KWXinQx3fBUJ
        fwa04gk6cgkTi0e8VJOBDAHdZ0gGFAK8IQncC4gDjI9WOwoljQ=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, arnd@arndb.de, wangborong@cdjrlc.com,
        jgg@ziepe.ca, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dl2k: replace strlcpy with strscpy
Date:   Tue, 21 Dec 2021 15:14:26 +0800
Message-Id: <20211221071426.733023-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The strlcpy should not be used because it doesn't limit the source
length. So that it will lead some potential bugs.

But the strscpy doesn't require reading memory from the src string
beyond the specified "count" bytes, and since the return value is
easier to error-check than strlcpy()'s. In addition, the implementation
is robust to the string changing out from underneath it, unlike the
current strlcpy() implementation.

Thus, replace strlcpy with strscpy.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/ethernet/dlink/dl2k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/dlink/dl2k.c b/drivers/net/ethernet/dlink/dl2k.c
index a301f7e6a440..2c67a857a42f 100644
--- a/drivers/net/ethernet/dlink/dl2k.c
+++ b/drivers/net/ethernet/dlink/dl2k.c
@@ -1235,8 +1235,8 @@ static void rio_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 {
 	struct netdev_private *np = netdev_priv(dev);
 
-	strlcpy(info->driver, "dl2k", sizeof(info->driver));
-	strlcpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
+	strscpy(info->driver, "dl2k", sizeof(info->driver));
+	strscpy(info->bus_info, pci_name(np->pdev), sizeof(info->bus_info));
 }
 
 static int rio_get_link_ksettings(struct net_device *dev,
-- 
2.34.1

