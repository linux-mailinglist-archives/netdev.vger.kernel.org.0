Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8100D80FC
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbfJOU2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:28:21 -0400
Received: from valentin-vidic.from.hr ([94.229.67.141]:57683 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729049AbfJOU2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 16:28:20 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2019 16:28:20 EDT
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id BD09E3BE3; Tue, 15 Oct 2019 22:20:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1571170831;
        bh=r5jgY9ifSUvOUd+gKIcDCcH7C/V28agy969gTcxV0eA=;
        h=From:To:Cc:Subject:Date:From;
        b=iHkOuo1boWn8/LsMRocAMddV/OPGaik8ITt96W9ALN32dgiAjzcc1Ac6SVqhAXAln
         ridBilD6G2ihAVPkZImuUtOxHFoNNw4Al20QzxxNk35eIiAO4aCB5JM3xVxY3TFEZy
         jtY9h06zFu341M6o689XwDa7sH7gK8tZeUODS2+rfU5WjRl7peSI5PQh396iZaIRD8
         MnVTMb1ky7oelvurQRKbNMq/patLb7x+5EmaklQG8gaEw7POPMv8reYGZ9g8LMi0do
         YZXsr5GpbFEF+3hqlolXAMma7Kc2eO9zcHh37zKpF9qapPZiwK0Bp+kUF0t+fmC7Vi
         vT9xNMvREnWbQ==
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Chuhong Yuan <hslester96@gmail.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>,
        syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com
Subject: [PATCH] net: usb: sr9800: fix uninitialized local variable
Date:   Tue, 15 Oct 2019 22:20:20 +0200
Message-Id: <20191015202020.29114-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure res does not contain random value if the call to
sr_read_cmd fails for some reason.

Reported-by: syzbot+f1842130bbcfb335bac1@syzkaller.appspotmail.com
Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 drivers/net/usb/sr9800.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index c5d4a0060124..681e0def6356 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -335,7 +335,7 @@ static void sr_set_multicast(struct net_device *net)
 static int sr_mdio_read(struct net_device *net, int phy_id, int loc)
 {
 	struct usbnet *dev = netdev_priv(net);
-	__le16 res;
+	__le16 res = 0;
 
 	mutex_lock(&dev->phy_mutex);
 	sr_set_sw_mii(dev);
-- 
2.20.1

