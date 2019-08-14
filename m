Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA948DF81
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfHNU5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 16:57:07 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:49863 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfHNU5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 16:57:07 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1M9FSx-1htJE10LW3-006Opc; Wed, 14 Aug 2019 22:57:02 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v5 15/18] compat_ioctl: ppp: move simple commands into ppp_generic.c
Date:   Wed, 14 Aug 2019 22:54:50 +0200
Message-Id: <20190814205521.122180-6-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20190814204259.120942-1-arnd@arndb.de>
References: <20190814204259.120942-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:fmDVahZ4CcjhOs+KQjFGAeeFwENq4LRdyWsKv0rqtggtBQdCebQ
 wWbcsq8NgjYrZwRjTsGXv1s7bwGqvAJ46xqweMWH/L+s61fs2bS+CYMfTP3CEAM38d/CkcJ
 CzWkG5VjpQaNdncFVHciiRkjivY5K925E6YiGJKoRpEBDbm2C0W2MErGEpJ7IJ8zYIDamTA
 en2pP+DG2us+rODng1uBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:KdTmbrqSBxg=:7w6RP3+jpxgmEpOORfKjlK
 gA+ONjUM2BroK9CLZO4Yxbj1fimuLY+ync6FY/qLOZgahDHdFVskTUQWJbMlNrhuI6fLivyYb
 fe3BfGtukX4tiBfkyP4w6QV146OOpJj3ZaqKwHxyUfrFHMV9dpWmMKg5KUKsHINwIRKmjsZmD
 YpwYar1PCu/Fzyz3J1f45w5iLdJEKqM8hKP8H0dIW1fhqas9XCWbCMe/ACcrU19oz+oJhg4js
 4ml32miZfdKjspapG2BJeCu0lLlUZ5V4TiCusWT6CGWF94kTue8F5pQ5P2HcfouOAaUDTMThs
 pzmJFWcbY1bXrtRkqOzn+EQJYKtZKP8ZxEBgmst5mWHkd9NMUpCO2SMBX/c/kD4Sl0JZdmq/w
 7gW3Z/Wlre4fjGTJTzB22msi1HB8D2K7Jod6wwW9MICJQ5VU09YIrApjAUy5lRa5mcjMVZBU3
 Ly0YOn5HCYEH8RK6iRPE29frvDvNlKvIG5NNCi2/XNBn3SFl3DsP2M/IlUUygUMT/oNg5Nndy
 binfmvbsmwtUNftdXBGj9k9qdH1ldhvkoGQGTPeZWxJZgKmOmAaaapN5yT7mbVBqlX4sSFMa6
 wzVC5Wyp7nGpnKpijQ2XNIDd0jHUYejKM19MnbL8MXZK/cfeVMRjKY/b3ff3Ypa6bMtZLad0g
 +LqExuQ/M+TXYKLfyn61CFS7QjlzjbDOKY+qM2M+PfpMZUp+hjqI2GvuHB9uueKRsWMs7v3st
 R78SOXOPSGvt3SP+JW7IfhpEL+0T9QQNraQIK1xP2it4ovzDNJsFFhxyq5iLJp2xod3nYYyO3
 MrY+PZ5DBc49CXAXtdnT1vhN5m4AA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All ppp commands that are not already handled in ppp_compat_ioctl()
are compatible, so they can now handled by calling the native
ppp_ioctl() directly.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ppp/ppp_generic.c |  4 ++++
 fs/compat_ioctl.c             | 32 --------------------------------
 2 files changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 6b4e227cb002..ea1507c7c40e 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -903,6 +903,10 @@ static long ppp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long
 	}
 	mutex_unlock(&ppp_mutex);
 
+	/* all other commands have compatible arguments */
+	if (err == -ENOIOCTLCMD)
+		err = ppp_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+
 	return err;
 }
 #endif
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index f97cf698cfdd..3d127bb6357a 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -144,38 +144,6 @@ COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
 COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
 COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
 #endif
-/* PPP stuff */
-COMPATIBLE_IOCTL(PPPIOCGFLAGS)
-COMPATIBLE_IOCTL(PPPIOCSFLAGS)
-COMPATIBLE_IOCTL(PPPIOCGASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCSASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCGUNIT)
-COMPATIBLE_IOCTL(PPPIOCGRASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCSRASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCGMRU)
-COMPATIBLE_IOCTL(PPPIOCSMRU)
-COMPATIBLE_IOCTL(PPPIOCSMAXCID)
-COMPATIBLE_IOCTL(PPPIOCGXASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCSXASYNCMAP)
-COMPATIBLE_IOCTL(PPPIOCXFERUNIT)
-/* PPPIOCSCOMPRESS is translated */
-COMPATIBLE_IOCTL(PPPIOCGNPMODE)
-COMPATIBLE_IOCTL(PPPIOCSNPMODE)
-COMPATIBLE_IOCTL(PPPIOCGDEBUG)
-COMPATIBLE_IOCTL(PPPIOCSDEBUG)
-/* PPPIOCSPASS is translated */
-/* PPPIOCSACTIVE is translated */
-COMPATIBLE_IOCTL(PPPIOCGIDLE32)
-COMPATIBLE_IOCTL(PPPIOCGIDLE64)
-COMPATIBLE_IOCTL(PPPIOCNEWUNIT)
-COMPATIBLE_IOCTL(PPPIOCATTACH)
-COMPATIBLE_IOCTL(PPPIOCDETACH)
-COMPATIBLE_IOCTL(PPPIOCSMRRU)
-COMPATIBLE_IOCTL(PPPIOCCONNECT)
-COMPATIBLE_IOCTL(PPPIOCDISCONN)
-COMPATIBLE_IOCTL(PPPIOCATTCHAN)
-COMPATIBLE_IOCTL(PPPIOCGCHAN)
-COMPATIBLE_IOCTL(PPPIOCGL2TPSTATS)
 };
 
 /*
-- 
2.20.0

