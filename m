Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9637A415704
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239404AbhIWDpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:45:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239600AbhIWDng (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:43:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE36661211;
        Thu, 23 Sep 2021 03:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368451;
        bh=7+NKFhM/0NHgXoyM4v241ur8GF3QZ6DTmRPsWH30Xw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvteIZOapjMSBI5S4vxgWoyg3GTx8FVC5ldd2snjx+X0nquGKSEVf7QHknK8tyvfE
         d+09feP3jhJ7snBo4E65YiOmhHXUikjG4tR1xa+td4YofIClQ86GaTwYzGbXtkFH9c
         32DC9q+tse3qX8paTXEmxPVHWMS5vlfkjgrhUKpkLvYm3vfH6y3r2x3ektieoC8tQu
         dYiAv7/sHnW7XJuJz+d1msDt37M5SEkw6N5yqPAJOuW7/1J99LE/hMmlU68iJ+2+8V
         mxBFJ6ljEG99kNBvms/PtqNi+VHGL4xj1FYh3gX1OS2gmO0y3PDDAfYcyCheC9OIo5
         aVU8ysW1TzZjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guenter Roeck <linux@roeck-us.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ajk@comnets.uni-bremen.de,
        davem@davemloft.net, kuba@kernel.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/11] net: 6pack: Fix tx timeout and slot time
Date:   Wed, 22 Sep 2021 23:40:26 -0400
Message-Id: <20210923034028.1421876-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210923034028.1421876-1-sashal@kernel.org>
References: <20210923034028.1421876-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 3c0d2a46c0141913dc6fd126c57d0615677d946e ]

tx timeout and slot time are currently specified in units of HZ.  On
Alpha, HZ is defined as 1024.  When building alpha:allmodconfig, this
results in the following error message.

  drivers/net/hamradio/6pack.c: In function 'sixpack_open':
  drivers/net/hamradio/6pack.c:71:41: error:
  	unsigned conversion from 'int' to 'unsigned char'
  	changes value from '256' to '0'

In the 6PACK protocol, tx timeout is specified in units of 10 ms and
transmitted over the wire:

    https://www.linux-ax25.org/wiki/6PACK

Defining a value dependent on HZ doesn't really make sense, and
presumably comes from the (very historical) situation where HZ was
originally 100.

Note that the SIXP_SLOTTIME use explicitly is about 10ms granularity:

        mod_timer(&sp->tx_t, jiffies + ((when + 1) * HZ) / 100);

and the SIXP_TXDELAY walue is sent as a byte over the wire.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index e510dbda77e5..96fb2a2a59f0 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -68,9 +68,9 @@
 #define SIXP_DAMA_OFF		0
 
 /* default level 2 parameters */
-#define SIXP_TXDELAY			(HZ/4)	/* in 1 s */
+#define SIXP_TXDELAY			25	/* 250 ms */
 #define SIXP_PERSIST			50	/* in 256ths */
-#define SIXP_SLOTTIME			(HZ/10)	/* in 1 s */
+#define SIXP_SLOTTIME			10	/* 100 ms */
 #define SIXP_INIT_RESYNC_TIMEOUT	(3*HZ/2) /* in 1 s */
 #define SIXP_RESYNC_TIMEOUT		5*HZ	/* in 1 s */
 
-- 
2.30.2

