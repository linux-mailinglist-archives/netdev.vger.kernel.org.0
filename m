Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F57C2E07B0
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgLVJEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLVJEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 04:04:20 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67FD6C0613D3;
        Tue, 22 Dec 2020 01:03:40 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608627819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0ES2PlYDmko1HTT00LSO1TZ78tyDlcM6xeI3B3a+bN4=;
        b=3hDUpSrKwbtOOHW3+jq6KVsCFYMK50VLQloRviEgK7eV309RAGZRkCy1VZ/uWuEZBAeRX8
        08z1rvtjriOE2+A6L/EPS0FSv4YjlDr52ZC9gBVEfDBRPrnUlSWGbZqdkc6G0RBLeMjP6V
        9U8ltKK093G1AVil/IPRf4P5XrlFM1QSysrT3ePvDQHjUHu5aT2gVG32v8zCHFwmrUq4m/
        9DgvMuqPSscyWDgG6/LavBgndl+J59DdkQxILypXl0yC5JVV3N0xfyKVGseAY9vQdBdOwl
        btFZjDOWpPMNjzn/BmNOvB4mlVCXdmXcA77tXeL5GflLg61TdgQ9B87EqnNijw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608627819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0ES2PlYDmko1HTT00LSO1TZ78tyDlcM6xeI3B3a+bN4=;
        b=wSxySbnLNSr5FgxI/gZpGwc2AnBYHlgYcAOhAMFWUpgrHB8ataqaEO3M5dEvdrERo9/8gA
        wdtl2wrwPo4+lkAQ==
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [RFC PATCH 0/1] net: arcnet: Fix RESET sequence
Date:   Tue, 22 Dec 2020 10:03:37 +0100
Message-Id: <20201222090338.186503-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Folks,

At drivers/net/arcnet/arcnet.c, there is:

  irqreturn_t arcnet_interrupt(int irq, void *dev_id)
  {
        ...
        if (status & RESETflag) {
                arcnet_close(dev);
                arcnet_open(dev);
        }
	...
  }

  struct net_device_ops arcnet_netdev_ops = {
        .ndo_open = arcnet_open,
        .ndo_stop = arcnet_close,
        ...
  };

which is wrong, in many ways:

  1) In general, interrupt handlers should never call ->ndo_stop() and
     ->ndo_open() functions. They are usually full of blocking calls and
     other methods that are expected to be called only from drivers
     init/exit code paths.

  2) arcnet_close() contains a del_timer_sync(). If the irq handler
     interrupts the to-be-deleted timer then call del_timer_sync(), it
     will just loop forever.

  3) arcnet_close() also calls tasklet_kill(), which has a warning if
     called from irq context.

  4) For device reset, the sequence "arcnet_close(); arcnet_open();" is
     not complete.  Some children arcnet drivers have special init/exit
     code sequences, which then embed a call to arcnet_open() and
     arcnet_close() accordingly. Check drivers/net/arcnet/com20020.c.

Included is an RFC patch to fix the points above: if the RESET flag is
encountered, a workqueue is scheduled to run the generic reset sequence.

Note: Only compile-tested, as I do not have the hardware in question.

Thanks,

8<--------------

Ahmed S. Darwish (1):
  net: arcnet: Fix RESET flag handling

 drivers/net/arcnet/arc-rimi.c     |  4 +-
 drivers/net/arcnet/arcdevice.h    |  6 +++
 drivers/net/arcnet/arcnet.c       | 69 +++++++++++++++++++++++++++++--
 drivers/net/arcnet/com20020-isa.c |  4 +-
 drivers/net/arcnet/com20020-pci.c |  2 +-
 drivers/net/arcnet/com20020_cs.c  |  2 +-
 drivers/net/arcnet/com90io.c      |  4 +-
 drivers/net/arcnet/com90xx.c      |  4 +-
 8 files changed, 81 insertions(+), 14 deletions(-)

base-commit: 2c85ebc57b3e1817b6ce1a6b703928e113a90442
--
2.29.2
