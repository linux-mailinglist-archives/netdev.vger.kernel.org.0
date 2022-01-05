Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E7E485A4B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 21:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244246AbiAEUyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 15:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244240AbiAEUyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 15:54:51 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E55C06118A
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 12:54:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n5DJ3-0000e2-7A
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 21:54:49 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 1B3836D1F10
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 20:54:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A8F076D1EFC;
        Wed,  5 Jan 2022 20:54:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id aa124207;
        Wed, 5 Jan 2022 20:54:44 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: [PATCH net 2/2] can: isotp: convert struct tpcon::{idx,len} to unsigned int
Date:   Wed,  5 Jan 2022 21:54:43 +0100
Message-Id: <20220105205443.1274709-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105205443.1274709-1-mkl@pengutronix.de>
References: <20220105205443.1274709-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In isotp_rcv_ff() 32 bit of data received over the network is assigned
to struct tpcon::len. Later in that function the length is checked for
the maximal supported length against MAX_MSG_LENGTH.

As struct tpcon::len is an "int" this check does not work, if the
provided length overflows the "int".

Later on struct tpcon::idx is compared against struct tpcon::len.

To fix this problem this patch converts both struct tpcon::{idx,len}
to unsigned int.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220105132429.1170627-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index df6968b28bf4..02cbcb2ecf0d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,8 +119,8 @@ enum {
 };
 
 struct tpcon {
-	int idx;
-	int len;
+	unsigned int idx;
+	unsigned int len;
 	u32 state;
 	u8 bs;
 	u8 sn;
-- 
2.34.1


