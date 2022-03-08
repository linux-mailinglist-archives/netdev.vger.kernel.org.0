Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0C14D11DF
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344750AbiCHIP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:15:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241091AbiCHIP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:15:27 -0500
Received: from zju.edu.cn (mail.zju.edu.cn [61.164.42.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BB69B864;
        Tue,  8 Mar 2022 00:12:44 -0800 (PST)
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgC3L3PoDydiMv1CAA--.28839S2;
        Tue, 08 Mar 2022 16:12:29 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, ralf@linux-mips.org,
        jreuter@yaina.de, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] ax25: Fix NULL pointer dereference in ax25_kill_by_device
Date:   Tue,  8 Mar 2022 16:12:23 +0800
Message-Id: <20220308081223.15919-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgC3L3PoDydiMv1CAA--.28839S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CF1xtry5Aw4rCFyUuF15Arb_yoW8Cw1DpF
        Z0k34fGrW7J34UCrs7GF18JF1UuF4qq3y5WF10vFy7C3s8Jr95trZ5trWUW3y3CF4rAFWU
        Za47J3y8Xa1UZaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxF
        aVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr
        4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxG
        rwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8Jw
        CI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2
        z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/1tbiAgMDAVZdtYj89QAFs5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When two ax25 devices attempted to establish connection, the requester use ax25_create(),
ax25_bind() and ax25_connect() to initiate connection. The receiver use ax25_rcv() to
accept connection and use ax25_create_cb() in ax25_rcv() to create ax25_cb, but the
ax25_cb->sk is NULL. When the receiver is detaching, a NULL pointer dereference bug
caused by sock_hold(sk) in ax25_kill_by_device() will happen. The corresponding
fail log is shown below:

===============================================================
BUG: KASAN: null-ptr-deref in ax25_device_event+0xfd/0x290
Call Trace:
...
ax25_device_event+0xfd/0x290
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x174/0x220
unregister_netdevice_many+0x1f7/0xa60
unregister_netdevice_queue+0x12f/0x170
unregister_netdev+0x13/0x20
mkiss_close+0xcd/0x140
tty_ldisc_release+0xc0/0x220
tty_release_struct+0x17/0xa0
tty_release+0x62d/0x670
...

This patch add condition check in ax25_kill_by_device(). If s->sk is
NULL, it will goto if branch to kill device.

Fixes: 4e0f718daf97 ("ax25: improve the incomplete fix to avoid UAF and NPD bugs")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 net/ax25/af_ax25.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d53cbb4e250..6bd09718077 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -87,6 +87,13 @@ static void ax25_kill_by_device(struct net_device *dev)
 	ax25_for_each(s, &ax25_list) {
 		if (s->ax25_dev == ax25_dev) {
 			sk = s->sk;
+			if (!sk) {
+				spin_unlock_bh(&ax25_list_lock);
+				s->ax25_dev = NULL;
+				ax25_disconnect(s, ENETUNREACH);
+				spin_lock_bh(&ax25_list_lock);
+				goto again;
+			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
--
2.17.1

