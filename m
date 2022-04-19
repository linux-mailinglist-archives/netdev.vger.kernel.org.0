Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97675071B6
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 17:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353845AbiDSP2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 11:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353848AbiDSP2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 11:28:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66AE13F81
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 08:26:01 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ngpjr-0001Jw-Tn
        for netdev@vger.kernel.org; Tue, 19 Apr 2022 17:25:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 78D4266AD7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 08B9766AB0;
        Tue, 19 Apr 2022 15:25:56 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8cd308b3;
        Tue, 19 Apr 2022 15:25:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Srinivas Neeli <sneeli@xilinx.com>
Subject: [PATCH net-next 02/17] can: bittiming: can_calc_bittiming(): prefer small bit rate pre-scalers over larger ones
Date:   Tue, 19 Apr 2022 17:25:39 +0200
Message-Id: <20220419152554.2925353-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419152554.2925353-1-mkl@pengutronix.de>
References: <20220419152554.2925353-1-mkl@pengutronix.de>
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

The CiA (CAN in Automation) lists in their Newsletter 1/2018 in the
"Recommendation for the CAN FD bit-timing" [1] article several
recommendations, one of them is:

| Recommendation 3: Choose BRPA and BRPD as low as possible

[1] https://can-newsletter.org/uploads/media/raw/f6a36d1461371a2f86ef0011a513712c.pdf

With the current bit timing algorithm Srinivas Neeli noticed that on
the Xilinx Versal ACAP board the CAN data bit timing parameters are
not calculated optimally. For most bit rates, the bit rate
prescaler (BRP) is != 1, although it's possible to configure the
requested with a bit rate with a prescaler of 1:

| Data Bit timing parameters for xilinx_can_fd2i with 79.999999 MHz ref clock (cmd-line) using algo 'v4.8'
|  nominal                                  real  Bitrt    nom   real  SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP  Error
| 12000000     12   2    2    2   1   1 11428571   4.8%  75.0%  71.4%   4.8%
| 10000000     25   1    1    1   1   2  9999999   0.0%  75.0%  75.0%   0.0%
|  8000000     12   3    3    3   1   1  7999999   0.0%  75.0%  70.0%   6.7%
|  5000000     50   1    1    1   1   4  4999999   0.0%  75.0%  75.0%   0.0%
|  4000000     62   1    1    1   1   5  3999999   0.0%  75.0%  75.0%   0.0%
|  2000000    125   1    1    1   1  10  1999999   0.0%  75.0%  75.0%   0.0%
|  1000000    250   1    1    1   1  20   999999   0.0%  75.0%  75.0%   0.0%

The bit timing parameter calculation algorithm iterates effectively
from low to high BRP values. It selects a new best parameter set, if
the sample point error of the current parameter set is equal or less
to old best parameter set.

If the given hardware constraints (clock rate and bit timing parameter
constants) don't allow a sample point error of 0, the algorithm will
first find a valid bit timing parameter set with a low BRP, but then
will accept parameter sets with higher BRPs that have the same sample
point error.

This patch changes the algorithm to only accept a new parameter set,
if the resulting sample point error is lower. This leads to the
following data bit timing parameter for the Versal ACAP board:

| Data Bit timing parameters for xilinx_can_fd2i with 79.999999 MHz ref clock (cmd-line) using algo 'can-next'
|  nominal                                  real  Bitrt    nom   real  SampP
|  Bitrate TQ[ns] PrS PhS1 PhS2 SJW BRP  Bitrate  Error  SampP  SampP  Error
| 12000000     12   2    2    2   1   1 11428571   4.8%  75.0%  71.4%   4.8%
| 10000000     12   2    3    2   1   1  9999999   0.0%  75.0%  75.0%   0.0%
|  8000000     12   3    3    3   1   1  7999999   0.0%  75.0%  70.0%   6.7%
|  5000000     12   5    6    4   1   1  4999999   0.0%  75.0%  75.0%   0.0%
|  4000000     12   7    7    5   1   1  3999999   0.0%  75.0%  75.0%   0.0%
|  2000000     12  14   15   10   1   1  1999999   0.0%  75.0%  75.0%   0.0%
|  1000000     25  14   15   10   1   2   999999   0.0%  75.0%  75.0%   0.0%

Note: Due to HW constraints a data bit rate of 1 MBit/s with BRP = 1 is not possible.

Link: https://lore.kernel.org/all/20220318144913.873614-1-mkl@pengutronix.de
Link: https://lore.kernel.org/all/20220113203004.jf2rqj2pirhgx72i@pengutronix.de
Cc: Srinivas Neeli <sneeli@xilinx.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 2103bcca9012..c1e76f0a5064 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -116,7 +116,7 @@ int can_calc_bittiming(const struct net_device *dev, struct can_bittiming *bt,
 
 		can_update_sample_point(btc, sample_point_nominal, tseg / 2,
 					&tseg1, &tseg2, &sample_point_error);
-		if (sample_point_error > best_sample_point_error)
+		if (sample_point_error >= best_sample_point_error)
 			continue;
 
 		best_sample_point_error = sample_point_error;
-- 
2.35.1


