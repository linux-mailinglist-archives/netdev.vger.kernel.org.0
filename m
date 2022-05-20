Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D419152F3F3
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345808AbiETTrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiETTrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1227E1CA;
        Fri, 20 May 2022 12:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BAB0B82B7D;
        Fri, 20 May 2022 19:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B0C385A9;
        Fri, 20 May 2022 19:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653076023;
        bh=1h3BDBR66ZfNzUY14/QxZgGwkL8f2aEHXApH0sV2FCU=;
        h=From:To:Cc:Subject:Date:From;
        b=APkCh74MUVxww7ejm7ll/yzkJYHOlUQJxPa4Mhn3vpcojyw2M09AQPj0Bmq1FH6b/
         hIP55T6qG9RN1dalRn7fyNzWnl6JPOt9nYRb+YkyKGF9Fm/Fb6oIrqFjYWl6OkeqR0
         6wyzqdULl/+NSnCOMyTDm6kOlQMKRgk0qb0NYf/iHvqeClId4z754feHdy+bfyc51T
         vAxL/+Z2fWGe/+8tFX6gytEodzfsd1r8rB36D8ArJWz5Cp0r3crYSRKfqq2ldpK7+c
         iyiPySgT1oU6RbMQmrob+H6fh5T4gK/Q/GPr3bop29EmHOLTetVlQIam+GcX6Swhjk
         N4oUCREnvBvCg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkl@pengutronix.de
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>,
        wg@grandegger.com, linux-can@vger.kernel.org
Subject: [PATCH net-next] can: kvaser_usb: silence a GCC 12 -Warray-bounds warning
Date:   Fri, 20 May 2022 12:46:59 -0700
Message-Id: <20220520194659.2356903-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver does a lot of casting of smaller buffers to
struct kvaser_cmd_ext, GCC 12 does not like that:

drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:489:65: warning: array subscript ‘struct kvaser_cmd_ext[0]’ is partly outside array bounds of ‘unsigned char[32]’ [-Warray-bounds]
drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:489:23: note: in expansion of macro ‘le16_to_cpu’
  489 |                 ret = le16_to_cpu(((struct kvaser_cmd_ext *)cmd)->len);
      |                       ^~~~~~~~~~~

Temporarily silence this warning (move it to W=1 builds).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Hi Marc, are you planning another -next PR? Can we take this
directly?

CC: wg@grandegger.com
CC: mkl@pengutronix.de
CC: linux-can@vger.kernel.org
---
 drivers/net/can/usb/kvaser_usb/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb/Makefile b/drivers/net/can/usb/kvaser_usb/Makefile
index cf260044f0b9..b20d951a0790 100644
--- a/drivers/net/can/usb/kvaser_usb/Makefile
+++ b/drivers/net/can/usb/kvaser_usb/Makefile
@@ -1,3 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_CAN_KVASER_USB) += kvaser_usb.o
 kvaser_usb-y = kvaser_usb_core.o kvaser_usb_leaf.o kvaser_usb_hydra.o
+
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_kvaser_usb_hydra.o += -Wno-array-bounds
+endif
-- 
2.34.3

