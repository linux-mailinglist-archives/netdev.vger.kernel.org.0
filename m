Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3685B9106
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 01:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiINXku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 19:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiINXkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 19:40:46 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8E8402E5;
        Wed, 14 Sep 2022 16:40:43 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc17a.ko.seznam.cz (email-smtpc17a.ko.seznam.cz [10.53.18.18])
        id 239c9d3ac7304e0422413c54;
        Thu, 15 Sep 2022 01:40:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1663198807; bh=hBUgfXVIXBf5ZVa/8FImGGTzXRmXJS7KVcNoi1eZrPo=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
         Content-Transfer-Encoding;
        b=PQWkOAYgMoWsHtrx93bH1P4HcTfOiUj006D6OzdRfyfZwe7VHkxDSwAezlHgH3vk0
         n+Jlwq8Wvert4Hq947ags7ciioC0w4pzoVyhGEyUkDYX2rK4gexch2epNwXVxSceRt
         dHuupjLcrzRh+g943RX1RGu/pssVNJ1ecxEdf6qk=
Received: from localhost.localdomain (2a02:8308:900d:2400:4bcc:f22e:1266:5194 [2a02:8308:900d:2400:4bcc:f22e:1266:5194])
        by email-relay10.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Thu, 15 Sep 2022 01:40:05 +0200 (CEST)  
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
Subject: [PATCH v4 0/3] can: ctucanfd: hardware rx timestamps reporting
Date:   Thu, 15 Sep 2022 01:39:41 +0200
Message-Id: <20220914233944.598298-1-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
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

Hello,

this is the v4 patch for CTU CAN FD hardware timestamps reporting.
Excuse my mistake, I'm sorry for the double post, but minutes after posting
patch v3 I've realized I forgot to update the pm_runtime method in error counter routine.

Even though pm_runtime_resume_and_get and pm_runtime_get_sync should be equivalent,
I want to have the code consistent.

Changes since v3: https://lore.kernel.org/all/20220914231249.593643-1-matej.vasilevski@seznam.cz/t/#u
- use pm_runtime_resume_and_get in error counter routine ctucan_get_berr_counter

Changes since v2: https://lore.kernel.org/all/20220801184656.702930-1-matej.vasilevski@seznam.cz/t/#u
- proper timestamping clock handling
	- clocks manually enabled using clk_prepare_enable, then managed
	  by runtime PM (if runtime PM is enabled)
	- driver should work even without CONFIG_PM
- access to the timecounter is now protected by a spinlock
- harmonized with Vincent's patch - TX timestamping capability is now
  correctly reported
- work_delay_jiffies stored as unsigned long instead of u32
- max work delay limited to 3600 seconds (instead of 86k seconds)
- adressed the rest of the comments from the patch V2 review

Changes since v1: https://lore.kernel.org/all/20220512232706.24575-1-matej.vasilevski@seznam.cz/
- Removed kconfig option to enable/disable timestamps.
- Removed dt parameters ts-frequency and ts-used-bits. Now the user
  only needs to add the timestamping clock phandle to clocks, and even
  that is optional.
- Added SIOCSHWTSTAMP ioctl to enable/disable timestamps.
- Adressed comments from the RFC review.

Matej Vasilevski (3):
  dt-bindings: can: ctucanfd: add another clock for HW timestamping
  can: ctucanfd: add HW timestamps to RX and error CAN frames
  doc: ctucanfd: RX frames timestamping for platform devices

 .../bindings/net/can/ctu,ctucanfd.yaml        |  19 +-
 .../can/ctu/ctucanfd-driver.rst               |  13 +-
 drivers/net/can/ctucanfd/Makefile             |   2 +-
 drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 239 ++++++++++++++++--
 drivers/net/can/ctucanfd/ctucanfd_pci.c       |   5 +-
 drivers/net/can/ctucanfd/ctucanfd_platform.c  |   5 +-
 drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  70 +++++
 8 files changed, 344 insertions(+), 29 deletions(-)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c


base-commit: c9ae520ac3faf2f272b5705b085b3778c7997ec8
--
2.25.1
