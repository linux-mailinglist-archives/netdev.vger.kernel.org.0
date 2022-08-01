Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6821587083
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 20:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiHASsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 14:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiHASsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 14:48:47 -0400
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FE722BC5;
        Mon,  1 Aug 2022 11:48:45 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc23b.ng.seznam.cz (email-smtpc23b.ng.seznam.cz [10.23.18.31])
        id 736aac4d97c67f7372b70d23;
        Mon, 01 Aug 2022 20:47:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seznam.cz; s=beta;
        t=1659379672; bh=9CamfPYkJOzMOKA5AU+cRNOsEzCQl374F+aCZ9LZ32A=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:X-szn-frgn:X-szn-frgc;
        b=ehICipKR+EIxjLJJl0JC2nGpKiRAifnzt44IcKR8xzovXj7p38VDZHwy4LIGnxQw8
         lhtlMlJhq3fkgoJXhdVbbE572HiwYPJUZEPnjkd65oUyV20fizQvntPsRnYS8aJZon
         amNfv0YJe0OGHPGUTNMmb+wcEmHWLvbKKupLEIMA=
Received: from localhost.localdomain (2a02:8308:900d:2400:95cc:114a:1ae8:6a72 [2a02:8308:900d:2400:95cc:114a:1ae8:6a72])
        by email-relay1.ng.seznam.cz (Seznam SMTPD 1.3.137) with ESMTP;
        Mon, 01 Aug 2022 20:47:49 +0200 (CEST)  
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
Subject: [PATCH v2 0/3] can: ctucanfd: hardware rx timestamps reporting
Date:   Mon,  1 Aug 2022 20:46:53 +0200
Message-Id: <20220801184656.702930-1-matej.vasilevski@seznam.cz>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-szn-frgn: <da8c169a-015b-4d2d-b56a-6473bdff3755>
X-szn-frgc: <0>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is the v2 patch for CTU CAN FD hardware timestamps reporting.

This patch series is based on the latest net-next, as I need the patch
- 9e7c9b8eb719 can: ctucanfd: Update CTU CAN FD IP core registers to match version 3.x.
and the patch below to avoid git conflict (both this and my patch
introduce ethtool_ops)
- 409c188c57cd can: tree-wide: advertise software timestamping capabilities

Changes in v2: (compared to the RFC I've sent in May)
- Removed kconfig option to enable/disable timestamps.
- Removed dt parameters ts-frequency and ts-used-bits. Now the user
  only needs to add the timestamping clock phandle to clocks, and even
  that is optional.
- Added SIOCSHWTSTAMP ioctl to enable/disable timestamps.
- Adressed comments from the RFC review.

Matej Vasilevski (3):
  can: ctucanfd: add HW timestamps to RX and error CAN frames
  dt-bindings: can: ctucanfd: add another clock for HW timestamping
  doc: ctucanfd: RX frames timestamping for platform devices

 .../bindings/net/can/ctu,ctucanfd.yaml        |  23 +-
 .../can/ctu/ctucanfd-driver.rst               |  13 +-
 drivers/net/can/ctucanfd/Makefile             |   2 +-
 drivers/net/can/ctucanfd/ctucanfd.h           |  20 ++
 drivers/net/can/ctucanfd/ctucanfd_base.c      | 214 +++++++++++++++++-
 drivers/net/can/ctucanfd/ctucanfd_timestamp.c |  87 +++++++
 6 files changed, 345 insertions(+), 14 deletions(-)
 create mode 100644 drivers/net/can/ctucanfd/ctucanfd_timestamp.c


base-commit: 0a324c3263f1e456f54dd8dc8ce58575aea776bc
-- 
2.25.1

