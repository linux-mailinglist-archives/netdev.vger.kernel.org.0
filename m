Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7243E7B84F
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 05:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfGaDnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 23:43:20 -0400
Received: from gateway36.websitewelcome.com ([50.116.124.69]:43689 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbfGaDnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 23:43:19 -0400
X-Greylist: delayed 1295 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jul 2019 23:43:19 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 7E052400C36A9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 21:45:54 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id sfBPhPke22qH7sfBPhRtgw; Tue, 30 Jul 2019 22:21:43 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JZa60ylvm+eCKxMYHzCsmVyqzVieyNrvKXOd9GTyrWU=; b=mlDAmvPQ5ZlgygqxoD/58+hbnK
        7FVF8v2txhdly2ZA6NR1thUAFLGctTQA75DfIRl04kw1jB342fjvsDLE7UpzhZL5U0Yo7lyDGqSn8
        TYbMXSjPZmcjuJouENx0WypzRwLQ7uyMjfPoASc+PXM3IzWa/h/6s6lPi/HJzzEowk6/Xv2Nefgnc
        R7gvW8u1a2ZEr1EiUN/4F10Ky9L+aBipzoV9dyl9YT6TQWTECR3YT3bHaKRrS8rcYiiH3eNBCS9UR
        nDP/CIFqS4PHYwz8bRfo0PsR7Ysus0WtheoYETS/5veuOFDs6lN0JwrW0VpXwEgzLPRyKDRtcFnPf
        RGJ4fOiQ==;
Received: from [187.192.11.120] (port=60258 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hsfBO-003qTS-Mx; Tue, 30 Jul 2019 22:21:42 -0500
Date:   Tue, 30 Jul 2019 22:21:41 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Chas Williams <3chas3@gmail.com>
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] atm: iphase: Fix Spectre v1 vulnerability
Message-ID: <20190731032141.GA30246@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hsfBO-003qTS-Mx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:60258
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

board is controlled by user-space, hence leading to a potential
exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

drivers/atm/iphase.c:2765 ia_ioctl() warn: potential spectre issue 'ia_dev' [r] (local cap)
drivers/atm/iphase.c:2774 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2782 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2816 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2823 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2830 ia_ioctl() warn: potential spectre issue '_ia_dev' [r] (local cap)
drivers/atm/iphase.c:2845 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2856 ia_ioctl() warn: possible spectre second half.  'iadev'

Fix this by sanitizing board before using it to index ia_dev and _ia_dev

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://lore.kernel.org/lkml/20180423164740.GY17484@dhcp22.suse.cz/

Cc: stable@vger.kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/atm/iphase.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 302cf0ba1600..8c7a996d1f16 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -63,6 +63,7 @@
 #include <asm/byteorder.h>  
 #include <linux/vmalloc.h>
 #include <linux/jiffies.h>
+#include <linux/nospec.h>
 #include "iphase.h"		  
 #include "suni.h"		  
 #define swap_byte_order(x) (((x & 0xff) << 8) | ((x & 0xff00) >> 8))
@@ -2760,8 +2761,11 @@ static int ia_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg)
    }
    if (copy_from_user(&ia_cmds, arg, sizeof ia_cmds)) return -EFAULT; 
    board = ia_cmds.status;
-   if ((board < 0) || (board > iadev_count))
-         board = 0;    
+
+	if ((board < 0) || (board > iadev_count))
+		board = 0;
+	board = array_index_nospec(board, iadev_count + 1);
+
    iadev = ia_dev[board];
    switch (ia_cmds.cmd) {
    case MEMDUMP:
-- 
2.22.0

