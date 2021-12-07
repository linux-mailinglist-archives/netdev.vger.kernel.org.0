Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453A646AEF5
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378185AbhLGAYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:24:42 -0500
Received: from aposti.net ([89.234.176.197]:52430 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378150AbhLGAYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:24:42 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>
Subject: [PATCH 0/5] Rework pm_ptr() and *_PM_OPS macros
Date:   Tue,  7 Dec 2021 00:20:57 +0000
Message-Id: <20211207002102.26414-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset reworks the pm_ptr() macro I introduced a few versions
ago, so that it is not conditionally defined.

It applies the same treatment to the *_PM_OPS macros. Instead of
modifying the existing ones, which would mean a 2000+ patch bomb, this
patchset introduce two new macros to replace the now deprecated
UNIVERSAL_DEV_PM_OPS() and SIMPLE_DEV_PM_OPS().

The point of all of this, is to progressively switch from a code model
where PM callbacks are all protected behind CONFIG_PM guards, to a code
model where PM callbacks are always seen by the compiler, but discarded
if not used.

Patch [4/5] and [5/5] are just examples to illustrate the use of the new
macros. As such they don't really have to be merged at the same time as
the rest and can be delayed until a subsystem-wide patchset is proposed.

- Patch [4/5] modifies a driver that already used the pm_ptr() macro,
  but had to use the __maybe_unused flag to avoid compiler warnings;
- Patch [5/5] modifies a driver that used a #ifdef CONFIG_PM guard
  around its suspend/resume functions.

Paul Cercueil (5):
  r8169: Avoid misuse of pm_ptr() macro
  PM: core: Redefine pm_ptr() macro
  PM: core: Add new *_PM_OPS macros, deprecate old ones
  mmc: jz4740: Use the new PM macros
  mmc: mxc: Use the new PM macros

 drivers/mmc/host/jz4740_mmc.c             |  8 +--
 drivers/mmc/host/mxcmmc.c                 |  6 +-
 drivers/net/ethernet/realtek/r8169_main.c |  4 +-
 include/linux/pm.h                        | 80 +++++++++++++++--------
 4 files changed, 60 insertions(+), 38 deletions(-)

-- 
2.33.0

