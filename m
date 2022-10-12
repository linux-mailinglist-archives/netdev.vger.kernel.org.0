Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1654F5FC09B
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 08:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJLG1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 02:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJLG1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 02:27:06 -0400
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5CB8996C;
        Tue, 11 Oct 2022 23:27:03 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc2a.ko.seznam.cz (email-smtpc2a.ko.seznam.cz [10.53.10.45])
        id 54e165dfb04db6e1553cc4b1;
        Wed, 12 Oct 2022 08:26:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1665555973; bh=wpmlIN258XfWIeGbhbj967WfqtzvizDK2ia92GmgakM=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
         Content-Transfer-Encoding;
        b=Al5Gaw89P/TEsSvIbDGeGeFw1GMFgdVVVexo3v53qe949QzwO/XFn3GwabY7spAe5
         mKDUBUzV3t1/srnkNpXZPx/1AO8LehSZ1uuB2homALrh+ZOuEvWmdta6yahvwxhACu
         IgfUHRNE6hiuAxOO2l7d6s4ERQ0imprB3VLj7iRU=
Received: from localhost.localdomain (2a02:8308:900d:2400:bba2:4592:a1de:fd80 [2a02:8308:900d:2400:bba2:4592:a1de:fd80])
        by email-relay16.ko.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Wed, 12 Oct 2022 08:26:11 +0200 (CEST)  
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
Subject: [PATCH v5 0/4] can: ctucanfd: hardware rx timestamps reporting
Date:   Wed, 12 Oct 2022 08:25:54 +0200
Message-Id: <20221012062558.732930-1-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is the v5 patch for CTU CAN FD hardware timestamps reporting.

Changes since v4: https://lore.kernel.org/all/20220914233944.598298-1-matej.vasilevski@seznam.cz/T/#u
dt-bindings:
- removed the -clk suffix, as per Krzysztof's request on patch v3 review
code:
- reverted changes to PM framework usage
	- also added dependency on PM to Kconfig
- added ctucan_remove_common() function to disable_unprepare timestamping clock
	on driver removal
- removed __maybe_unused - the fourth extra commit
- removed unnecessary bit masking of the read timestamp
- removed else branches after return
- removed ternary operators
- renamed timestamp_freq to timestamp_clk_rate
- removed unnecessary IS_ERR_OR_NULL() checks
- removed cfg.flags check to keep consistency with can_eth_ioctl_hwts()
- added lockdep_assert_held
- removed coupling to pm_enable_call variable
- increased the bit shift for work_delay_ns calculation from 1 to 2


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

Matej Vasilevski (4):
  dt-bindings: can: ctucanfd: add another clock for HW timestamping
  can: ctucanfd: add HW timestamps to RX and error CAN frames
  doc: ctucanfd: RX frames timestamping for platform devices
  can: ctucanfd: remove __maybe_unused from suspend/resume callbacks

 .../bindings/net/can/ctu,ctucanfd.yaml        |  19 +-
 .../can/ctu/ctucanfd-driver.rst               |  13 +-
 drivers/net/can/ctucanfd/Kconfig              |   2 +-
 drivers/net/can/ctucanfd/Makefile             |   2 +-
 drivers/net/can/ctucanfd/ctucanfd.h           |  25 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 229 +++++++++++++++++-
 drivers/net/can/ctucanfd/ctucanfd_pci.c       |   7 +-
 drivers/net/can/ctucanfd/ctucanfd_platform.c  |   7 +-
 drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  77 ++++++
 9 files changed, 361 insertions(+), 20 deletions(-)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c


base-commit: 0326074ff4652329f2a1a9c8685104576bd8d131
--
2.25.1
