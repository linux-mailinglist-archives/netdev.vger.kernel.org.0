Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91FDD2DB174
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgLOQao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:30:44 -0500
Received: from smtp.h3c.com ([60.191.123.56]:23020 "EHLO h3cspam01-ex.h3c.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730015AbgLOQao (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:30:44 -0500
X-Greylist: delayed 4628 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2020 11:30:42 EST
Received: from h3cspam01-ex.h3c.com (localhost [127.0.0.2] (may be forged))
        by h3cspam01-ex.h3c.com with ESMTP id 0BFFDeEv059183
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 23:13:40 +0800 (GMT-8)
        (envelope-from gao.yanB@h3c.com)
Received: from DAG2EX08-IDC.srv.huawei-3com.com ([10.8.0.71])
        by h3cspam01-ex.h3c.com with ESMTP id 0BFFBUSo058450;
        Tue, 15 Dec 2020 23:11:30 +0800 (GMT-8)
        (envelope-from gao.yanB@h3c.com)
Received: from localhost.localdomain (10.99.212.201) by
 DAG2EX08-IDC.srv.huawei-3com.com (10.8.0.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 15 Dec 2020 23:11:34 +0800
From:   Gao Yan <gao.yanB@h3c.com>
To:     <paulus@samba.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Gao Yan <gao.yanB@h3c.com>
Subject: [PATCH] net: remove disc_data_lock in ppp line discipline
Date:   Tue, 15 Dec 2020 23:00:54 +0800
Message-ID: <20201215150054.570-1-gao.yanB@h3c.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.99.212.201]
X-ClientProxiedBy: BJSMTP02-EX.srv.huawei-3com.com (10.63.20.133) To
 DAG2EX08-IDC.srv.huawei-3com.com (10.8.0.71)
X-DNSRBL: 
X-MAIL: h3cspam01-ex.h3c.com 0BFFBUSo058450
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tty layer provide tty->ldisc_sem lock to protect tty->disc_data;
For examlpe, when cpu A is running ppp_synctty_ioctl that
hold the tty->ldisc_sem, so if cpu B calls ppp_synctty_close,
it will wait until cpu A release tty->ldisc_sem. So I think it is
unnecessary to have the disc_data_lock;

cpu A                           cpu B
tty_ioctl                       tty_reopen
 ->hold tty->ldisc_sem            ->hold tty->ldisc_sem(write), failed
 ->ld->ops->ioctl                 ->wait...
 ->release tty->ldisc_sem         ->wait...OK,hold tty->ldisc_sem
                                    ->tty_ldisc_reinit
                                      ->tty_ldisc_close
                                        ->ld->ops->close

Signed-off-by: Gao Yan <gao.yanB@h3c.com>
---
 drivers/net/ppp/ppp_async.c   | 5 -----
 drivers/net/ppp/ppp_synctty.c | 5 -----
 2 files changed, 10 deletions(-)

diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 29a0917a8..f8cb591d6 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -127,17 +127,14 @@ static const struct ppp_channel_ops async_ops = {
  * FIXME: this is no longer true. The _close path for the ldisc is
  * now guaranteed to be sane.
  */
-static DEFINE_RWLOCK(disc_data_lock);
 
 static struct asyncppp *ap_get(struct tty_struct *tty)
 {
 	struct asyncppp *ap;
 
-	read_lock(&disc_data_lock);
 	ap = tty->disc_data;
 	if (ap != NULL)
 		refcount_inc(&ap->refcnt);
-	read_unlock(&disc_data_lock);
 	return ap;
 }
 
@@ -216,10 +213,8 @@ ppp_asynctty_close(struct tty_struct *tty)
 {
 	struct asyncppp *ap;
 
-	write_lock_irq(&disc_data_lock);
 	ap = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock_irq(&disc_data_lock);
 	if (!ap)
 		return;
 
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 0f338752c..8cdf7268c 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -129,17 +129,14 @@ ppp_print_buffer (const char *name, const __u8 *buf, int count)
  *
  * FIXME: Fixed in tty_io nowadays.
  */
-static DEFINE_RWLOCK(disc_data_lock);
 
 static struct syncppp *sp_get(struct tty_struct *tty)
 {
 	struct syncppp *ap;
 
-	read_lock(&disc_data_lock);
 	ap = tty->disc_data;
 	if (ap != NULL)
 		refcount_inc(&ap->refcnt);
-	read_unlock(&disc_data_lock);
 	return ap;
 }
 
@@ -215,10 +212,8 @@ ppp_sync_close(struct tty_struct *tty)
 {
 	struct syncppp *ap;
 
-	write_lock_irq(&disc_data_lock);
 	ap = tty->disc_data;
 	tty->disc_data = NULL;
-	write_unlock_irq(&disc_data_lock);
 	if (!ap)
 		return;
 
-- 
2.17.1

