Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD8694ED616
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233220AbiCaIsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiCaIs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:48:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F6C1F89F3
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:46:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZqRy-0000CY-VG
        for netdev@vger.kernel.org; Thu, 31 Mar 2022 10:46:39 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9E3AF579F4
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3497F579CA;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 73a7afcf;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Derek Will <derekrobertwill@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/8] can: isotp: restore accidentally removed MSG_PEEK feature
Date:   Thu, 31 Mar 2022 10:46:27 +0200
Message-Id: <20220331084634.869744-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220331084634.869744-1-mkl@pengutronix.de>
References: <20220331084634.869744-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

In commit 42bf50a1795a ("can: isotp: support MSG_TRUNC flag when
reading from socket") a new check for recvmsg flags has been
introduced that only checked for the flags that are handled in
isotp_recvmsg() itself.

This accidentally removed the MSG_PEEK feature flag which is processed
later in the call chain in __skb_try_recv_from_queue().

Add MSG_PEEK to the set of valid flags to restore the feature.

Fixes: 42bf50a1795a ("can: isotp: support MSG_TRUNC flag when reading from socket")
Link: https://github.com/linux-can/can-utils/issues/347#issuecomment-1079554254
Link: https://lore.kernel.org/all/20220328113611.3691-1-socketcan@hartkopp.net
Reported-by: Derek Will <derekrobertwill@gmail.com>
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Tested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index f6f8ba1f816d..bafb0fb5f0e0 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1050,7 +1050,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	int noblock = flags & MSG_DONTWAIT;
 	int ret = 0;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC))
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
 		return -EINVAL;
 
 	if (!so->bound)

base-commit: f9512d654f62604664251dedd437a22fe484974a
-- 
2.35.1


