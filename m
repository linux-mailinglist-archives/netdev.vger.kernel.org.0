Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E80480768
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 09:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235666AbhL1IcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 03:32:14 -0500
Received: from mail-m963.mail.126.com ([123.126.96.3]:27037 "EHLO
        mail-m963.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhL1IcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 03:32:13 -0500
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Dec 2021 03:32:13 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Azxdj
        j1CNPaPOY6/HrK6QCQg9xOVBLTNVC7zi08tf+4=; b=dwkwmNVwRn8NS/D0F+fgt
        im13Tv5pH3UDZJsacdjJx7OkRQPgQzu0CsTynLQks+nPXfy7B5St1qQlFTeSEuYq
        99zYtMgAjKQ7+n0njp3yIL5Rr3x9tbvRoG4+V4qgNykTymebVgjluB1HXBmeDz8b
        73r075uIMg9UVorqMkTDqc=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp8 (Coremail) with SMTP id NORpCgCnY99axMph0YuIBA--.26886S2;
        Tue, 28 Dec 2021 16:01:31 +0800 (CST)
From:   wolfgang9277@126.com
To:     isdn@linux-pingi.de
Cc:     netdev@vger.kernel.org
Subject: [PATCH] mISDN: change function names to avoid conflicts
Date:   Tue, 28 Dec 2021 16:01:20 +0800
Message-Id: <20211228080120.2105702-1-wolfgang9277@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NORpCgCnY99axMph0YuIBA--.26886S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrWDAw15Cr4DKw43tFy7Jrb_yoW5XFyUpa
        9rXFyDCr48JayxK3yUJ3s8ZFy5Xws5C3y8KasrZ343Xr4DArWDJrn5JaySvF1kCr4S9ay3
        Ca40gw4fKFyDG37anT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8nYwUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: xzrowwpdqjmjixx6ij2wof0z/1tbi3Bt3FVpECoXIKAAAsU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wolfgang huang <huangjinhui@kylinos.cn>

As we build for mips, we meet following error. l1_init error with
multiple definition. Some architecture devices usually marked with
l1, l2, lxx as the start-up phase. so we change the mISDN function
names, align with Isdnl2_xxx.

mips-linux-gnu-ld: drivers/isdn/mISDN/layer1.o: in function `l1_init':
(.text+0x890): multiple definition of `l1_init'; \
arch/mips/kernel/bmips_5xxx_init.o:(.text+0xf0): first defined here
make[1]: *** [home/mips/kernel-build/linux/Makefile:1161: vmlinux] Error 1

Signed-off-by: wolfgang huang <huangjinhui@kylinos.cn>
Reported-by: k2ci <kernel-bot@kylinos.cn>
---
 drivers/isdn/mISDN/core.c   | 6 +++---
 drivers/isdn/mISDN/core.h   | 4 ++--
 drivers/isdn/mISDN/layer1.c | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/mISDN/core.c b/drivers/isdn/mISDN/core.c
index 55891e420446..a41b4b264594 100644
--- a/drivers/isdn/mISDN/core.c
+++ b/drivers/isdn/mISDN/core.c
@@ -381,7 +381,7 @@ mISDNInit(void)
 	err = mISDN_inittimer(&debug);
 	if (err)
 		goto error2;
-	err = l1_init(&debug);
+	err = Isdnl1_Init(&debug);
 	if (err)
 		goto error3;
 	err = Isdnl2_Init(&debug);
@@ -395,7 +395,7 @@ mISDNInit(void)
 error5:
 	Isdnl2_cleanup();
 error4:
-	l1_cleanup();
+	Isdnl1_cleanup();
 error3:
 	mISDN_timer_cleanup();
 error2:
@@ -408,7 +408,7 @@ static void mISDN_cleanup(void)
 {
 	misdn_sock_cleanup();
 	Isdnl2_cleanup();
-	l1_cleanup();
+	Isdnl1_cleanup();
 	mISDN_timer_cleanup();
 	class_unregister(&mISDN_class);
 
diff --git a/drivers/isdn/mISDN/core.h b/drivers/isdn/mISDN/core.h
index 23b44d303327..42599f49c189 100644
--- a/drivers/isdn/mISDN/core.h
+++ b/drivers/isdn/mISDN/core.h
@@ -60,8 +60,8 @@ struct Bprotocol	*get_Bprotocol4id(u_int);
 extern int	mISDN_inittimer(u_int *);
 extern void	mISDN_timer_cleanup(void);
 
-extern int	l1_init(u_int *);
-extern void	l1_cleanup(void);
+extern int	Isdnl1_Init(u_int *);
+extern void	Isdnl1_cleanup(void);
 extern int	Isdnl2_Init(u_int *);
 extern void	Isdnl2_cleanup(void);
 
diff --git a/drivers/isdn/mISDN/layer1.c b/drivers/isdn/mISDN/layer1.c
index 98a3bc6c1700..7b31c25a550e 100644
--- a/drivers/isdn/mISDN/layer1.c
+++ b/drivers/isdn/mISDN/layer1.c
@@ -398,7 +398,7 @@ create_l1(struct dchannel *dch, dchannel_l1callback *dcb) {
 EXPORT_SYMBOL(create_l1);
 
 int
-l1_init(u_int *deb)
+Isdnl1_Init(u_int *deb)
 {
 	debug = deb;
 	l1fsm_s.state_count = L1S_STATE_COUNT;
@@ -409,7 +409,7 @@ l1_init(u_int *deb)
 }
 
 void
-l1_cleanup(void)
+Isdnl1_cleanup(void)
 {
 	mISDN_FsmFree(&l1fsm_s);
 }
-- 
2.25.1

