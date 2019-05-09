Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A50DF18771
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEIJIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:08:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:46118 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725847AbfEIJIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 05:08:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 61AA6B7B1;
        Thu,  9 May 2019 09:08:50 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     dmitry.bezrukov@aquantia.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 1/3] aqc111: fix endianness issue in aqc111_change_mtu
Date:   Thu,  9 May 2019 11:08:16 +0200
Message-Id: <20190509090818.9257-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the MTU is large enough, the first write to the device
is just repeated. On BE architectures, however, the first
word of the command will be swapped a second time and garbage
will be written. Avoid that.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/aqc111.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index aff995be2a31..408df2d335e3 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -453,6 +453,8 @@ static int aqc111_change_mtu(struct net_device *net, int new_mtu)
 		reg16 = 0x1420;
 	else if (dev->net->mtu <= 16334)
 		reg16 = 0x1A20;
+	else
+		return 0;
 
 	aqc111_write16_cmd(dev, AQ_ACCESS_MAC, SFR_PAUSE_WATERLVL_LOW,
 			   2, &reg16);
-- 
2.16.4

