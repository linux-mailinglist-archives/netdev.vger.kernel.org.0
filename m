Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02A25B9104
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiINXks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiINXkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:40:46 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9C9402E9;
        Wed, 14 Sep 2022 16:40:43 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc13b.ko.seznam.cz (email-smtpc13b.ko.seznam.cz [10.53.14.135])
        id 2750b258c3fc6166268d1336;
        Thu, 15 Sep 2022 01:40:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1663198820; bh=DZl/zpDC4daeyZK5+yAdaWiaFpHk14LLzJ5mzlIQIT0=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding;
        b=daHUCnY4MgnAd6VR8RJI8zrBmnq5XAclyjk5BDbJ+SzLAMx3OPUngJenQNozJvU9e
         62o3pqUTN8viTJp4i2C8pZZX+LoII7b27uCh04aSGSJ7rr9soS09ZmRFp+AVUHPnKw
         QwRl0jyiXODD6Q30HMK0L/47tfXlpqW9io7wyQos=
Received: from localhost.localdomain (2a02:8308:900d:2400:4bcc:f22e:1266:5194 [2a02:8308:900d:2400:4bcc:f22e:1266:5194])
        by email-relay10.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Thu, 15 Sep 2022 01:40:19 +0200 (CEST)  
From:   Matej Vasilevski <matej.vasilevski@seznam.cz>
To:     Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: [PATCH v4 3/3] doc: ctucanfd: RX frames timestamping for platform devices
Date:   Thu, 15 Sep 2022 01:39:44 +0200
Message-Id: <20220914233944.598298-4-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
References: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the section about timestamping RX frames with instructions
how to enable it.

Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>
---
 .../device_drivers/can/ctu/ctucanfd-driver.rst      | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
index 40c92ea272af..05a7ce0c3d9e 100644
--- a/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
+++ b/Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst
@@ -386,8 +386,17 @@ The CTU CAN FD core reports the exact timestamp when the frame has been
 received. The timestamp is by default captured at the sample point of
 the last bit of EOF but is configurable to be captured at the SOF bit.
 The timestamp source is external to the core and may be up to 64 bits
-wide. At the time of writing, passing the timestamp from kernel to
-userspace is not yet implemented, but is planned in the future.
+wide.
+
+Both platform and PCI devices can report the timestamp.
+For platform devices, add another clock phandle for timestamping clock
+in device tree bindings. If you don't add another clock, the driver
+will assume the primary clock's frequency for timestamping.
+For PCI devices, the timestamping frequency is assumed to be equal to
+the bus frequency.
+
+Timestamp reporting is disabled by default, you have to enable it with
+SIOCSHWTSTAMP ioctl call first.
 
 Handling TX
 ~~~~~~~~~~~
-- 
2.25.1

