Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC934CC1F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbhC2Izp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236684AbhC2IyZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:54:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0472EC061765
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:54:04 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lQnet-0003ZT-Hh
        for netdev@vger.kernel.org; Mon, 29 Mar 2021 10:54:03 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CC1C56029AB
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:54:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EDBB560298C;
        Mon, 29 Mar 2021 08:53:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a936e47d;
        Mon, 29 Mar 2021 08:53:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        kernel test robot <lkp@intel.com>,
        Rong Chen <rong.a.chen@intel.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [net 3/3] can: uapi: can.h: mark union inside struct can_frame packed
Date:   Mon, 29 Mar 2021 10:53:55 +0200
Message-Id: <20210329085355.921447-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329085355.921447-1-mkl@pengutronix.de>
References: <20210329085355.921447-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit ea7800565a12 ("can: add optional DLC element to Classical
CAN frame structure") the struct can_frame::can_dlc was put into an
anonymous union with another u8 variable.

For various reasons some members in struct can_frame and canfd_frame
including the first 8 byes of data are expected to have the same
memory layout. This is enforced by a BUILD_BUG_ON check in af_can.c.

Since the above mentioned commit this check fails on ARM kernels
compiled with the ARM OABI (which means CONFIG_AEABI not set). In this
case -mabi=apcs-gnu is passed to the compiler, which leads to a
structure size boundary of 32, instead of 8 compared to CONFIG_AEABI
enabled. This means the the union in struct can_frame takes 4 bytes
instead of the expected 1.

Rong Chen illustrates the problem with pahole in the ARM OABI case:

| struct can_frame {
|          canid_t                    can_id;               /* 0     4 */
|          union {
|                  __u8               len;                  /* 4     1 */
|                  __u8               can_dlc;              /* 4     1 */
|          };                                               /* 4     4 */
|          __u8                       __pad;                /* 8     1 */
|          __u8                       __res0;               /* 9     1 */
|          __u8                       len8_dlc;             /* 10    1 */
|
|          /* XXX 5 bytes hole, try to pack */
|
|          __u8                       data[8]
| __attribute__((__aligned__(8))); /*    16     8 */
|
|          /* size: 24, cachelines: 1, members: 6 */
|          /* sum members: 19, holes: 1, sum holes: 5 */
|          /* forced alignments: 1, forced holes: 1, sum forced holes: 5 */
|          /* last cacheline: 24 bytes */
| } __attribute__((__aligned__(8)));

Marking the anonymous union as __attribute__((packed)) fixes the
BUILD_BUG_ON problem on these compilers.

Fixes: ea7800565a12 ("can: add optional DLC element to Classical CAN frame structure")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Rong Chen <rong.a.chen@intel.com>
Link: https://lore.kernel.org/linux-can/2c82ec23-3551-61b5-1bd8-178c3407ee83@hartkopp.net/
Link: https://lore.kernel.org/r/20210325125850.1620-3-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/can.h b/include/uapi/linux/can.h
index f75238ac6dce..c7535352fef6 100644
--- a/include/uapi/linux/can.h
+++ b/include/uapi/linux/can.h
@@ -113,7 +113,7 @@ struct can_frame {
 		 */
 		__u8 len;
 		__u8 can_dlc; /* deprecated */
-	};
+	} __attribute__((packed)); /* disable padding added in some ABIs */
 	__u8 __pad; /* padding */
 	__u8 __res0; /* reserved / padding */
 	__u8 len8_dlc; /* optional DLC for 8 byte payload length (9 .. 15) */
-- 
2.30.2


