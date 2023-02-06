Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3575368BDDC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBFNTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjBFNSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:30 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9942624497
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NH-0008B0-IV
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:35 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 950C517153D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1B564171340;
        Mon,  6 Feb 2023 13:16:25 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 944f3b9f;
        Mon, 6 Feb 2023 13:16:24 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Bath <mark@baggywrinkle.co.uk>
Subject: [PATCH net-next 44/47] can: bittiming: can_sjw_set_default(): use Phase Seg2 / 2 as default for SJW
Date:   Mon,  6 Feb 2023 14:16:17 +0100
Message-Id: <20230206131620.2758724-45-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"The (Re-)Synchronization Jump Width (SJW) defines how far a
 resynchronization may move the Sample Point inside the limits defined
 by the Phase Buffer Segments to compensate for edge phase errors." [1]

In other words, this means that the SJW parameter controls the
tolerance of the CAN controller to frequency errors compared to other
CAN controllers.

If the user space does not provide an SJW parameter, the kernel
chooses a default value of 1. This has proven to be a good default
value for classic CAN controllers, but no longer for modern CAN-FD
controllers.

In the past there were CAN controllers like the sja1000 with a rather
limited range of bit timing parameters. For the standard bit rates
this results in the following bit timing parameters:

| Bit timing parameters for sja1000 with 8.000000 MHz ref clock
|                     _----+--------------=> tseg1: 1 …   16
|                    /    /     _---------=> tseg2: 1 …    8
|                   |    |     /    _-----=> sjw:   1 …    4
|                   |    |    |    /    _-=> brp:   1 …   64 (inc: 1)
|                   |    |    |   |    /
|  nominal          |    |    |   |   |     real  Bitrt    nom   real   SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP   Error  BTR0 BTR1
|  1000000    125   2    3    2   1   1  1000000   0.0%  75.0%  75.0%   0.0%   0x00 0x14
|   800000    125   3    4    2   1   1   800000   0.0%  80.0%  80.0%   0.0%   0x00 0x16
|   666666    125   4    4    3   1   1   666666   0.0%  80.0%  75.0%   6.2%   0x00 0x27
|   500000    125   6    7    2   1   1   500000   0.0%  87.5%  87.5%   0.0%   0x00 0x1c
|   250000    250   6    7    2   1   2   250000   0.0%  87.5%  87.5%   0.0%   0x01 0x1c
|   125000    500   6    7    2   1   4   125000   0.0%  87.5%  87.5%   0.0%   0x03 0x1c
|   100000    625   6    7    2   1   5   100000   0.0%  87.5%  87.5%   0.0%   0x04 0x1c
|    83333    750   6    7    2   1   6    83333   0.0%  87.5%  87.5%   0.0%   0x05 0x1c
|    50000   1250   6    7    2   1  10    50000   0.0%  87.5%  87.5%   0.0%   0x09 0x1c
|    33333   1875   6    7    2   1  15    33333   0.0%  87.5%  87.5%   0.0%   0x0e 0x1c
|    20000   3125   6    7    2   1  25    20000   0.0%  87.5%  87.5%   0.0%   0x18 0x1c
|    10000   6250   6    7    2   1  50    10000   0.0%  87.5%  87.5%   0.0%   0x31 0x1c

The attentive reader will notice that the SJW is 1 in most cases,
while the Seg2 phase is 2. Both values are given in TQ units, which in
turn is a duration in nanoseconds.

For example the 500 kbit/s configuration:

|  nominal                                  real  Bitrt    nom   real   SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP   Error  BTR0 BTR1
|   500000    125   6    7    2   1   1   500000   0.0%  87.5%  87.5%   0.0%   0x00 0x1c

the TQ is 125ns, the Phase Seg2 is "2" (== 250ns), the SJW is "1" (==
125 ns).

Looking at a more modern CAN controller like a mcp2518fd, it has wider
bit timing registers.

| Bit timing parameters for mcp251xfd with 40.000000 MHz ref clock
|                     _----+--------------=> tseg1: 2 …  256
|                    /    /     _---------=> tseg2: 1 …  128
|                   |    |     /    _-----=> sjw:   1 …  128
|                   |    |    |    /    _-=> brp:   1 …  256 (inc: 1)
|                   |    |    |   |    /
|  nominal          |    |    |   |   |     real  Bitrt    nom   real   SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP   Error      NBTCFG
|   500000     25  34   35   10   1   1   500000   0.0%  87.5%  87.5%   0.0%   0x00440900

The TQ is 25ns, the Phase Seg 2 is "10" (== 250ns), the SJW is "1" (==
25ns).

Since the kernel chooses a default SJW of 1 regardless of the TQ, this
leads to a much smaller SJW and thus much smaller tolerances to
frequency errors.

To maintain the same oscillator tolerances on controllers with wide
bit timing registers, select a default SJW value of Phase Seg2 / 2
unless Phase Seg 1 is less. This results in the following bit timing
parameters:

| Bit timing parameters for mcp251xfd with 40.000000 MHz ref clock
|                     _----+--------------=> tseg1: 2 …  256
|                    /    /     _---------=> tseg2: 1 …  128
|                   |    |     /    _-----=> sjw:   1 …  128
|                   |    |    |    /    _-=> brp:   1 …  256 (inc: 1)
|                   |    |    |   |    /
|  nominal          |    |    |   |   |     real  Bitrt    nom   real   SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP   Error      NBTCFG
|   500000     25  34   35   10   5   1   500000   0.0%  87.5%  87.5%   0.0%   0x00440904

The TQ is 25ns, the Phase Seg 2 is "10" (== 250ns), the SJW is "5" (==
125ns). Which is the same as on the sja1000 controller.

[1] http://web.archive.org/http://www.oertel-halle.de/files/cia99paper.pdf

Link: https://lore.kernel.org/all/20230202110854.2318594-15-mkl@pengutronix.de
Cc: Mark Bath <mark@baggywrinkle.co.uk>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 68287b79afe8..55714e08ca3a 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -11,8 +11,8 @@ void can_sjw_set_default(struct can_bittiming *bt)
 	if (bt->sjw)
 		return;
 
-	/* If user space provides no sjw, use 1 as default */
-	bt->sjw = 1;
+	/* If user space provides no sjw, use sane default of phase_seg2 / 2 */
+	bt->sjw = max(1U, min(bt->phase_seg1, bt->phase_seg2 / 2));
 }
 
 int can_sjw_check(const struct net_device *dev, const struct can_bittiming *bt,
-- 
2.39.1


