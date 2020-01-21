Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C09D1446FF
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 23:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAUWKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 17:10:36 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44722 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728139AbgAUWKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 17:10:36 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id DDD5229980; Tue, 21 Jan 2020 17:10:35 -0500 (EST)
Message-Id: <cover.1579641728.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH net v2 00/12] Fixes for SONIC ethernet driver
Date:   Wed, 22 Jan 2020 08:22:08 +1100
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

Various SONIC driver problems have become apparent over the years,
including tx watchdog timeouts, lost packets and duplicated packets.

The problems are mostly caused by bugs in buffer handling, locking and
(re-)initialization code.

This patch series resolves these problems.

This series has been tested on National Semiconductor hardware (macsonic),
qemu-system-m68k (macsonic) and qemu-system-mips64el (jazzsonic).

The emulated dp8393x device used in QEMU also has bugs.
I have fixed the bugs that I know of in a series of patches at,
https://github.com/fthain/qemu/commits/sonic
---
Changed since v1:
 - Minor revisions as described in commit logs.
 - Deferred net-next patches.


Finn Thain (12):
  net/sonic: Add mutual exclusion for accessing shared state
  net/sonic: Clear interrupt flags immediately
  net/sonic: Use MMIO accessors
  net/sonic: Fix interface error stats collection
  net/sonic: Fix receive buffer handling
  net/sonic: Avoid needless receive descriptor EOL flag updates
  net/sonic: Improve receive descriptor status flag check
  net/sonic: Fix receive buffer replenishment
  net/sonic: Quiesce SONIC before re-initializing descriptor memory
  net/sonic: Fix command register usage
  net/sonic: Fix CAM initialization
  net/sonic: Prevent tx watchdog timeout

 drivers/net/ethernet/natsemi/sonic.c | 380 ++++++++++++++++-----------
 drivers/net/ethernet/natsemi/sonic.h |  44 +++-
 2 files changed, 262 insertions(+), 162 deletions(-)

-- 
2.24.1

