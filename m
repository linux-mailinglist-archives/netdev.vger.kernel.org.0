Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40992A1964
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgJaSRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:17:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726736AbgJaSRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:17:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYvR3-004XPS-V5; Sat, 31 Oct 2020 19:17:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: driver: hamradio: Fix potential unterminated string
Date:   Sat, 31 Oct 2020 19:17:00 +0100
Message-Id: <20201031181700.1081693-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With W=1 the following error is reported:

In function ‘strncpy’,
    inlined from ‘hdlcdrv_ioctl’ at drivers/net/hamradio/hdlcdrv.c:600:4:
./include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ specified bound 32 equals destination size [-Wstringop-truncation]
  297 | #define __underlying_strncpy __builtin_strncpy
      |                              ^
./include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
  307 |  return __underlying_strncpy(p, q, size);

Replace strncpy with strlcpy to guarantee the string is terminated.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/hamradio/hdlcdrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index e7413a643929..9e0058154ac3 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -597,7 +597,7 @@ static int hdlcdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 
 	case HDLCDRVCTL_DRIVERNAME:
 		if (s->ops && s->ops->drvname) {
-			strncpy(bi.data.drivername, s->ops->drvname, 
+			strlcpy(bi.data.drivername, s->ops->drvname,
 				sizeof(bi.data.drivername));
 			break;
 		}
-- 
2.28.0

