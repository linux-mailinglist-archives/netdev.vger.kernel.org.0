Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 265C160DD2F
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 10:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbiJZIkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 04:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiJZIkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 04:40:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6232ED5C
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 01:40:13 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1onbxL-0006am-SZ
        for netdev@vger.kernel.org; Wed, 26 Oct 2022 10:40:11 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 416A210A07E
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:40:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 5ECFF10A064;
        Wed, 26 Oct 2022 08:40:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 97b34878;
        Wed, 26 Oct 2022 08:40:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, "Daniel S. Trevitz" <dan@sstrev.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/29] can: add termination resistor documentation
Date:   Wed, 26 Oct 2022 10:39:39 +0200
Message-Id: <20221026084007.1583333-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026084007.1583333-1-mkl@pengutronix.de>
References: <20221026084007.1583333-1-mkl@pengutronix.de>
MIME-Version: 1.0
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

From: "Daniel S. Trevitz" <dan@sstrev.com>

Add documentation for how to use and setup the switchable termination
resistor support for CAN controllers.

Signed-off-by: Daniel Trevitz <dan@sstrev.com>
Link: https://lore.kernel.org/all/3441354.44csPzL39Z@daniel6430
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 Documentation/networking/can.rst | 33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/networking/can.rst b/Documentation/networking/can.rst
index ebc822e605f5..90121deef217 100644
--- a/Documentation/networking/can.rst
+++ b/Documentation/networking/can.rst
@@ -1148,6 +1148,39 @@ tuning on deep embedded systems'. The author is running a MPC603e
 load without any problems ...
 
 
+Switchable Termination Resistors
+--------------------------------
+
+CAN bus requires a specific impedance across the differential pair,
+typically provided by two 120Ohm resistors on the farthest nodes of
+the bus. Some CAN controllers support activating / deactivating a
+termination resistor(s) to provide the correct impedance.
+
+Query the available resistances::
+
+    $ ip -details link show can0
+    ...
+    termination 120 [ 0, 120 ]
+
+Activate the terminating resistor::
+
+    $ ip link set dev can0 type can termination 120
+
+Deactivate the terminating resistor::
+
+    $ ip link set dev can0 type can termination 0
+
+To enable termination resistor support to a can-controller, either
+implement in the controller's struct can-priv::
+
+    termination_const
+    termination_const_cnt
+    do_set_termination
+
+or add gpio control with the device tree entries from
+Documentation/devicetree/bindings/net/can/can-controller.yaml
+
+
 The Virtual CAN Driver (vcan)
 -----------------------------
 

base-commit: a526a3cc9c8d426713f8bebc18ebbe39a8495d82
-- 
2.35.1


