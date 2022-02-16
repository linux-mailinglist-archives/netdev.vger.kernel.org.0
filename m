Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B87B54B83AF
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbiBPJJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:09:07 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:54962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiBPJJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E19255AF;
        Wed, 16 Feb 2022 01:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C332CB81E3A;
        Wed, 16 Feb 2022 09:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDE4C340EC;
        Wed, 16 Feb 2022 09:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645002531;
        bh=udCSocfnhULxJJ2WBnOj8nfkE1v29GJAaXaRt+uZ/lo=;
        h=From:To:Cc:Subject:Date:From;
        b=V2gbGQ7YtlUwUZ8YUCWz0LWk/esFt4s4T1G5o8QsvHi/d0iVR59yILpYELhQAZtNJ
         cQR6GQmspn9x/9qxUNk6kg2FML5zT/bFBETZDbxOQO4FwXegr499mjPFG2gLC+lEWk
         lIqDjSCLahB09/QPYhXGAGzlZgiwFcZKS1FUeRbMT50aGdH1HOOKR0TvtgWqQsccs1
         xIxvpAGxL+J2jUSR5DURZx53cFiWHVurv3XhcoQmiJp7cWsthHQ8xcRMIf+klFVeMr
         DN8luZCdn8XF31oU2SFp+3rgl3BluKH/GRt1VM+e/DCt/EzvpHZwQcvIT9Bgk9OYTm
         TcouMs9rLttTw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKGIq-008HM9-6T; Wed, 16 Feb 2022 09:08:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Subject: [PATCH 0/2] net: mvpp2: Survive CPU hotplug events
Date:   Wed, 16 Feb 2022 09:08:43 +0000
Message-Id: <20220216090845.1278114-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@linuxfoundation.org, mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org, tglx@linutronix.de, john.garry@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I recently realised that playing with CPU hotplug on a system equiped
with a set of MVPP2 devices (Marvell 8040) was fraught with danger and
would result in a rapid lockup or panic.

As it turns out, the per-CPU nature of the MVPP2 interrupts are
getting in the way. A good solution for this seems to rely on the
kernel's managed interrupt approach, where the core kernel will not
move interrupts around as the CPUs for down, but will simply disable
the corresponding interrupt.

Converting the driver to this requires a bit of refactoring in the IRQ
subsystem to expose the required primitive, as well as a bit of
surgery in the driver itself.

Note that although the system now survives such event, the driver
seems to assume that all queues are always active and doesn't inform
the device that a CPU has gone away. Someout who actually understand
this driver should have a look at it.

Patches on top of 5.17-rc3, lightly tested on a McBin.

Marc Zyngier (2):
  genirq: Extract irq_set_affinity_masks() from
    devm_platform_get_irqs_affinity()
  net: mvpp2: Convert to managed interrupts to fix CPU HP issues

 drivers/base/platform.c                       | 20 +-----
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 -
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 67 ++++++++++---------
 include/linux/interrupt.h                     |  8 +++
 kernel/irq/affinity.c                         | 27 ++++++++
 5 files changed, 72 insertions(+), 51 deletions(-)

-- 
2.30.2

