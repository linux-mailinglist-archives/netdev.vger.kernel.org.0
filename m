Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DBD444627
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 17:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhKCQrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 12:47:31 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:59972 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbhKCQrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 12:47:31 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id iJNLmc3ywk3HQiJNWmsMn2; Wed, 03 Nov 2021 17:44:49 +0100
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Wed, 03 Nov 2021 17:44:49 +0100
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH iproute2-next 5.16 v6 0/5] iplink_can: cleaning, fixes and adding TDC support.
Date:   Thu,  4 Nov 2021 01:44:23 +0900
Message-Id: <20211103164428.692722-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
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
  the units to give more clarity: some parameters are in milliseconds,
  some in nano seconds, some in time quantum and the newly TDC
  parameters introduced in this series would be in clock period.

  2. Do some code refactoring on function print_ctrlmode().

  3. factorize the many print_*(PRINT_JSON, ...) and fprintf
  occurrences in a single print_*(PRINT_ANY, ...) call and fix the
  signedness while doing that.

  4. report the value of the bitrate prescalers (brp and dbrp).

  5. adds command line support for the TDC in iproute and goes together
  with below series in the kernel:
  https://lore.kernel.org/linux-can/20210814091750.73931-1-mailhol.vincent@wanadoo.fr/T/#t


** Changelog **

From RFC v5 to v6:
  * Dropped the RFC tag because the related patch series on the kernel
    side were pulled into net-next.
  * Remove the changes in include/uapi/linux/can/netlink.h because
    these should be pulled separately.
  * Add another patch (the second of this series) to do some cleanup
    on function print_ctrlmode().
  * Minor fixes in the patch comments (grammar, rephrasing).

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

Vincent Mailhol (5):
  iplink_can: fix configuration ranges in print_usage() and add unit
  iplink_can: code refactoring of print_ctrlmode()
  iplink_can: use PRINT_ANY to factorize code and fix signedness
  iplink_can: print brp and dbrp bittiming variables
  iplink_can: add new CAN FD bittiming parameters: Transmitter Delay
    Compensation (TDC)

 ip/iplink_can.c | 512 ++++++++++++++++++++++++++----------------------
 1 file changed, 282 insertions(+), 230 deletions(-)

-- 
2.32.0

