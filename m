Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B884689341
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjBCJPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:15:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjBCJPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:15:41 -0500
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096998E49E
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:15:36 -0800 (PST)
X-QQ-mid: bizesmtp68t1675415731tshkj236
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 03 Feb 2023 17:15:22 +0800 (CST)
X-QQ-SSF: 01400000000000H0Y000B00A0000000
X-QQ-FEAT: xQoAiglG4R4EnMwB/sPawCUzzU0YbooivbYwtaHW7vg2NWNEmR6gTFzYek0O+
        +wVK+plaadR4NpNXN72UY5rqfUjXrmLPrk8Ktk4SgTVTWkzhXgs3LyMlF5KOfHKFeZY1Lm3
        YSw7Noo/tv39Laxo2ZbYQIChYZ6+qjEex7VsB5Dhu88aujpsbu39HLOQPIQK50Kh4YmWrCw
        x+rkE1whz7d4kg+OXmlB1n289gYeponQYdFaKcN7aZlAoFF30d90YnRxtBT55/wGrZEnNCw
        kLgH7AbnYrCEK9pgekyM0+xkoQ70wveDyiGqltPfNyKyKnvsXRyQNOE+gc5E4c+7UXg7m/T
        YsPUXzlaYxgB3ExH/CzljtVK9Hlufza+eul0/NRZ1RC5l4M2DoAEd8wbrLNL6TbIL2ZPaow
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 00/10] Wangxun interrupt and RxTx support
Date:   Fri,  3 Feb 2023 17:11:25 +0800
Message-Id: <20230203091135.3294377-1-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Configure interrupt, setup RxTx ring, support to receive and transmit
packets.

change log:
v3:
- Use upper_32_bits() to avoid compile warning.
- Remove useless codes.
v2:
- Andrew Lunn: https://lore.kernel.org/netdev/Y86kDphvyHj21IxK@lunn.ch/
- Add a judgment when allocate dma for descriptor.

Jiawen Wu (6):
  net: txgbe: Add interrupt support
  net: libwx: Configure Rx and Tx unit on hardware
  net: libwx: Allocate Rx and Tx resources
  net: txgbe: Setup Rx and Tx ring
  net: libwx: Support to receive packets in NAPI
  net: txgbe: Support Rx and Tx process path

Mengyuan Lou (4):
  net: libwx: Add irq flow functions
  net: ngbe: Add irqs request flow
  net: libwx: Add tx path to process packets
  net: ngbe: Support Rx and Tx process path

 drivers/net/ethernet/wangxun/Kconfig          |    1 +
 drivers/net/ethernet/wangxun/libwx/Makefile   |    2 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c    |  675 +++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |    5 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 2004 +++++++++++++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h   |   32 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  314 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  249 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   18 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  271 ++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   21 +
 11 files changed, 3574 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.h

-- 
2.27.0

