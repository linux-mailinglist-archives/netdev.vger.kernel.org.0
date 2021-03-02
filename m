Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E7132A334
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378037AbhCBIyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:54:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:39636 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1835866AbhCBGX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 01:23:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D963FAFD7;
        Tue,  2 Mar 2021 06:22:17 +0000 (UTC)
From:   Jiri Slaby <jslaby@suse.cz>
To:     gregkh@linuxfoundation.org
Cc:     linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 14/44] net: caif: inline register_ldisc
Date:   Tue,  2 Mar 2021 07:21:44 +0100
Message-Id: <20210302062214.29627-14-jslaby@suse.cz>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302062214.29627-1-jslaby@suse.cz>
References: <20210302062214.29627-1-jslaby@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

register_ldisc only calls tty_register_ldisc. Inline register_ldisc into
the only caller of register_ldisc, i.e. caif_ser_init. Now,
caif_ser_init is symmetric to caif_ser_exit in this regard.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/caif/caif_serial.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 675c374b32ee..da6fffb4d5a8 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -389,18 +389,6 @@ static struct tty_ldisc_ops caif_ldisc = {
 	.write_wakeup =	ldisc_tx_wakeup
 };
 
-static int register_ldisc(void)
-{
-	int result;
-
-	result = tty_register_ldisc(N_CAIF, &caif_ldisc);
-	if (result < 0) {
-		pr_err("cannot register CAIF ldisc=%d err=%d\n", N_CAIF,
-			result);
-		return result;
-	}
-	return result;
-}
 static const struct net_device_ops netdev_ops = {
 	.ndo_open = caif_net_open,
 	.ndo_stop = caif_net_close,
@@ -443,7 +431,10 @@ static int __init caif_ser_init(void)
 {
 	int ret;
 
-	ret = register_ldisc();
+	ret = tty_register_ldisc(N_CAIF, &caif_ldisc);
+	if (ret < 0)
+		pr_err("cannot register CAIF ldisc=%d err=%d\n", N_CAIF, ret);
+
 	debugfsdir = debugfs_create_dir("caif_serial", NULL);
 	return ret;
 }
-- 
2.30.1

