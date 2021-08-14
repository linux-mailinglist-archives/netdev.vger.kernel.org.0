Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21233EC1EF
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 12:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbhHNKSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 06:18:22 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:45377 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237454AbhHNKSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 06:18:18 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d19 with ME
        id hNHf2500A0zjR6y03NHlin; Sat, 14 Aug 2021 12:17:48 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 14 Aug 2021 12:17:48 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 0/4] iplink_can: cleaning, fixes and adding TDC support.
Date:   Sat, 14 Aug 2021 19:17:24 +0900
Message-Id: <20210814101728.75334-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose is to add commandline support for Transmitter Delay
Compensation (TDC) in iproute. Other issues found during the
development of this feature also get addressed.

This patch series contains four patches which respectively:

  1. Correct the bittiming ranges in the print_usage function and add
  the units to add clarity: some parameters are in milliseconds, some
  in nano seconds, some in time quantum and the newly TDC parameters
  introduced in this series would be in clock period.

  2. factorize the many print_*(PRINT_JSON, ...) and fprintf
  occurrences in a single print_*(PRINT_ANY, ...) call and fix the
  signedness while doing that.

  3. report the value of the bitrate prescalers (brp and dbrp).

  4. adds command line support for the TDC in iproute and goes together
  with below series in the kernel:
  https://lore.kernel.org/linux-can/20210814091750.73931-1-mailhol.vincent@wanadoo.fr/T/#t

I am sending this series as RFC because the related patch series on
the kernel side have yet to be approved. Aside of that, I consider
this series to be ready. If the can: netlink patch series get accepted,
I will resend this one as is (just remove the RFC tag).

** Changelog **

From RFC v4 to RFC v5:
  * Add the unit (bps, tq, ns or ms) in print_usage()
  * Rewrote void can_print_timing_min_max() to better factorize the
    code.
  * Rewrote the commit message of the two last patches (those related
    to TDC) to either add clarification of fix inacurracies.

From v3 to RFC v4:
  * Reflect the changes made on the kernel side.

From RFC v2 to v3:
  * Dropped the RFC tag. Now that the kernel patch reach the testing
    branch, I am finaly ready.
  * Regression fix: configuring a link with only nominal bittiming
    returned -EOPNOTSUPP
  * Added two more patches to the series:
      - iplink_can: fix configuration ranges in print_usage()
      - iplink_can: print brp and dbrp bittiming variables
  * Other small fixes on formatting.

From RFC v1 to RFC v2:
  * Add an additional patch to the series to fix the issues reported
    by Stephen Hemminger
    Ref: https://lore.kernel.org/linux-can/20210506112007.1666738-1-mailhol.vincent@wanadoo.fr/T/#t

Vincent Mailhol (4):
  iplink_can: fix configuration ranges in print_usage() and add unit
  iplink_can: use PRINT_ANY to factorize code and fix signedness
  iplink_can: print brp and dbrp bittiming variables
  iplink_can: add new CAN FD bittiming parameters: Transmitter Delay
    Compensation (TDC)

 include/uapi/linux/can/netlink.h |  30 +-
 ip/iplink_can.c                  | 460 +++++++++++++++++--------------
 2 files changed, 279 insertions(+), 211 deletions(-)

-- 
2.31.1

