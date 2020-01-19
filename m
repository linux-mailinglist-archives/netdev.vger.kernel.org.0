Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8492B1420BE
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 00:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgASXQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 18:16:33 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49722 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728841AbgASXQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 18:16:31 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id A042A28ED2; Sun, 19 Jan 2020 18:16:30 -0500 (EST)
Message-Id: <cover.1579474569.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net 00/19] Fixes for SONIC ethernet driver
Date:   Mon, 20 Jan 2020 09:56:09 +1100
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Various SONIC driver problems have become apparent over the years,
including tx watchdog timeouts, lost packets and duplicated packets.

The problems are mostly caused by bugs in buffer handling, locking and
(re-)initialization code.

This patch series resolves these problems. Several cleanup patches are
included at the beginning.

This series has been tested on National Semiconductor hardware (macsonic),
qemu-system-m68k (macsonic) and qemu-system-mips64el (jazzsonic).

The emulated dp8393x device used in QEMU also has bugs.
I have fixed the bugs that I know of in a series of patches at,
https://github.com/fthain/qemu/commits/sonic


Finn Thain (19):
  net/sonic: Remove obsolete comment
  net/sonic: Remove redundant next_tx variable
  net/sonic: Refactor duplicated code
  net/sonic: Add mutual exclusion for accessing shared state
  net/sonic: Remove redundant netif_start_queue() call
  net/macsonic: Remove interrupt handler wrapper
  net/sonic: Clear interrupt flags immediately
  net/sonic: Use MMIO accessors
  net/sonic: Remove explicit memory barriers
  net/sonic: Start packet transmission immediately
  net/sonic: Fix interface error stats collection
  net/sonic: Fix receive buffer handling
  net/sonic: Avoid needless receive descriptor EOL flag updates
  net/sonic: Improve receive descriptor status flag check
  net/sonic: Fix receive buffer replenishment
  net/sonic: Quiesce SONIC before re-initializing descriptor memory
  net/sonic: Fix command register usage
  net/sonic: Fix CAM initialization
  net/sonic: Prevent tx watchdog timeout

 drivers/net/ethernet/natsemi/jazzsonic.c |  31 +-
 drivers/net/ethernet/natsemi/macsonic.c  |  48 +--
 drivers/net/ethernet/natsemi/sonic.c     | 433 ++++++++++++++---------
 drivers/net/ethernet/natsemi/sonic.h     |  45 ++-
 drivers/net/ethernet/natsemi/xtsonic.c   |  40 +--
 5 files changed, 313 insertions(+), 284 deletions(-)

-- 
2.24.1

