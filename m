Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42095745BE
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 09:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237484AbiGNHPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 03:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237121AbiGNHPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 03:15:00 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB19357E3;
        Thu, 14 Jul 2022 00:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1657782887; x=1689318887;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=35WuII/EC61wobzGDYsfz1aMrY82iRk2q8VNpEasuGg=;
  b=TBYN9TIslQH37UpzSM8wNKp8es/ar1fHdvOKwBKFLPRZEAYUFfQG5Trv
   8pmTI8de8FkaSSTEVgddv9FPCbV+wps0cGVJN0cTAbw0uBvYeLKJcOT8E
   H1NhDsHrGKtrnBOHIZTC11eNy88ym5EADzgCTGbWcQkI4WjMpcaXHq+ii
   0=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 14 Jul 2022 00:14:47 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 00:14:46 -0700
Received: from zijuhu-gv.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 14 Jul 2022 00:14:44 -0700
From:   Zijun Hu <quic_zijuhu@quicinc.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <luiz.von.dentz@intel.com>, <quic_zijuhu@quicinc.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v1] Bluetooth: Fix cvsd sco setup failure
Date:   Thu, 14 Jul 2022 15:14:40 +0800
Message-ID: <1657782880-28234-1-git-send-email-quic_zijuhu@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A cvsd sco setup failure issue is reported as shown by
below btmon log, it firstly tries to set up cvsd esco with
S3/S2/S1 configs sequentially, but these attempts are all
failed with error code "Unspecified Error (0x1f)", then it
tries to set up cvsd sco with D1 config, unfortunately, it
still fails to set up sco with error code
"Invalid HCI Command Parameters (0x12)", this error code
terminates attempt with remaining D0 config and marks overall
sco/esco setup failure.

It is wrong D1/D0 @retrans_effort 0x01 within @esco_param_cvsd
that causes D1 config failure with error code
"Invalid HCI Command Parameters (0x12)", D1/D0 sco @retrans_effort
must not be 0x01 based on spec, so fix this issue by changing D1/D0
@retrans_effort from 0x01 to 0xff as present @sco_param_cvsd.

< HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3405 [hci0]
        Handle: 3
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 10
        Setting: 0x0060
          Input Coding: Linear
          Input Data Format: 2's complement
          Input Sample Size: 16-bit
          # of bits padding at MSB: 0
          Air Coding Format: CVSD
        Retransmission effort: Optimize for power consumption (0x01)
        Packet type: 0x0380
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4               #3406 [hci0]
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3408 [hci0]
        Status: Unspecified Error (0x1f)
        Handle: 4
        Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
        Link type: eSCO (0x02)
        Transmission interval: 0x00
        Retransmission window: 0x00
        RX packet length: 0
        TX packet length: 0
        Air mode: CVSD (0x02)
< HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3409 [hci0]
        Handle: 3
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 7
        Setting: 0x0060
          Input Coding: Linear
          Input Data Format: 2's complement
          Input Sample Size: 16-bit
          # of bits padding at MSB: 0
          Air Coding Format: CVSD
        Retransmission effort: Optimize for power consumption (0x01)
        Packet type: 0x0380
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4               #3410 [hci0]
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3416 [hci0]
        Status: Unspecified Error (0x1f)
        Handle: 4
        Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
        Link type: eSCO (0x02)
        Transmission interval: 0x00
        Retransmission window: 0x00
        RX packet length: 0
        TX packet length: 0
        Air mode: CVSD (0x02)
< HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3417 [hci0]
        Handle: 3
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 7
        Setting: 0x0060
          Input Coding: Linear
          Input Data Format: 2's complement
          Input Sample Size: 16-bit
          # of bits padding at MSB: 0
          Air Coding Format: CVSD
        Retransmission effort: Optimize for power consumption (0x01)
        Packet type: 0x03c8
          EV3 may be used
          2-EV3 may not be used
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4               #3419 [hci0]
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3426 [hci0]
        Status: Unspecified Error (0x1f)
        Handle: 4
        Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
        Link type: eSCO (0x02)
        Transmission interval: 0x00
        Retransmission window: 0x00
        RX packet length: 0
        TX packet length: 0
        Air mode: CVSD (0x02)
< HCI Command: Setup Synchrono.. (0x01|0x0028) plen 17  #3427 [hci0]
        Handle: 3
        Transmit bandwidth: 8000
        Receive bandwidth: 8000
        Max latency: 65535
        Setting: 0x0060
          Input Coding: Linear
          Input Data Format: 2's complement
          Input Sample Size: 16-bit
          # of bits padding at MSB: 0
          Air Coding Format: CVSD
        Retransmission effort: Optimize for power consumption (0x01)
        Packet type: 0x03c4
          HV3 may be used
          2-EV3 may not be used
          3-EV3 may not be used
          2-EV5 may not be used
          3-EV5 may not be used
> HCI Event: Command Status (0x0f) plen 4               #3428 [hci0]
      Setup Synchronous Connection (0x01|0x0028) ncmd 1
        Status: Success (0x00)
> HCI Event: Synchronous Connect Comp.. (0x2c) plen 17  #3429 [hci0]
        Status: Invalid HCI Command Parameters (0x12)
        Handle: 0
        Address: 14:3F:A6:47:56:15 (OUI 14-3F-A6)
        Link type: SCO (0x00)
        Transmission interval: 0x00
        Retransmission window: 0x00
        RX packet length: 0
        TX packet length: 0
        Air mode: u-law log (0x00)

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Tested-by: Zijun Hu <quic_zijuhu@quicinc.com>
---
 net/bluetooth/hci_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 7829433d54c1..2627d5ac15d6 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -45,8 +45,8 @@ static const struct sco_param esco_param_cvsd[] = {
 	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x000a,	0x01 }, /* S3 */
 	{ EDR_ESCO_MASK & ~ESCO_2EV3, 0x0007,	0x01 }, /* S2 */
 	{ EDR_ESCO_MASK | ESCO_EV3,   0x0007,	0x01 }, /* S1 */
-	{ EDR_ESCO_MASK | ESCO_HV3,   0xffff,	0x01 }, /* D1 */
-	{ EDR_ESCO_MASK | ESCO_HV1,   0xffff,	0x01 }, /* D0 */
+	{ EDR_ESCO_MASK | ESCO_HV3,   0xffff,	0xff }, /* D1 */
+	{ EDR_ESCO_MASK | ESCO_HV1,   0xffff,	0xff }, /* D0 */
 };
 
 static const struct sco_param sco_param_cvsd[] = {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project

