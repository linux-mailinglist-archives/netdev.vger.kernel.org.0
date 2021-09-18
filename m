Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0AC04105BE
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239654AbhIRJ63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:58:29 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:61300 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbhIRJ62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:58:28 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id RX5Zmuh4X1yYBRX5hm0kCs; Sat, 18 Sep 2021 11:57:03 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 18 Sep 2021 11:57:03 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 0/6] add the netlink interface for CAN-FD Transmitter Delay Compensation (TDC)
Date:   Sat, 18 Sep 2021 18:56:31 +0900
Message-Id: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main goal of this series is to add a netlink interface for the TDC
parameters using netlink nested attributes. The series also contains a
few fix on the current TDC implementation.

This series completes the implementation of the Transmitter Delay
Compensation (TDC) in the kernel which started in March with those two
patches:
  - commit 289ea9e4ae59 ("can: add new CAN FD bittiming parameters:
    Transmitter Delay Compensation (TDC)")
  - commit c25cc7993243 ("can: bittiming: add calculation for CAN FD
    Transmitter Delay Compensation (TDC)")

The netlink interface was missing from this series because the initial
patch needed rework in order to make it more flexible for future
changes.

At that time, Marc suggested to take inspiration from the recently
released ethtool-netlink interface (Ref [1]).

ethtool uses nested attributes (c.f. NLA_NESTED type in validation
policy). A bit of trivia: the NLA_NESTED type was introduced in
version 2.6.15 of the kernel and thus actually predates Socket CAN.
Ref: commit bfa83a9e03cf ("[NETLINK]: Type-safe netlink
messages/attributes interface")

Since then, Stephan shared additional remarks for improvement which
are addressed in revision v4 of this series [2].

The first patch allows TDCV and TDCO to be zero. Previously, those
zero values were assigned a special meaning. The replace that special
meaning, two additional ctrmode flags are added: CAN_CTRLMODE_TDC_AUTO
and CAN_CTRLMODE_TDC_MANUAL.

The second patch fixes the unit of the TDC parameters. In fact, those
should be measured in clock period (a.k.a. minimum time quantum) and
not in time quantum as it is done in current implementation.

The third patch modifies the prototype of can_calc_tdco() so that the
data bittiming struct is passed as an argument instead of retrieving
it from priv. This will prevent inconsistent configuration from
occurring in case of early return.

The fourth patch is the real thing: the TDC netlink interface.

The fifth patch allows to retrieve TDCV from the device when in
TDC_AUTO mode. This is done through a callback function.

The sixth and last patch addresses the concerns of Marc and Stefan
that some devices which use a TDCO value relative to the Sample Point
(so far, the TDC implementation used the formula SSP = TDCV +
TDCO). To do so, an helper function to convert TDCO from an absolute
value to a value relative to the sample point is added.


I prepared another patch series for iproute2-next. The series is
available at [3] and can be helpful for tests.


[1] https://lore.kernel.org/linux-can/20210407081557.m3sotnepbgasarri@pengutronix.de/
[2] https://lore.kernel.org/linux-can/75fa87a71a3f5fd7d7407a2c514b71690e56eb4e.camel@esd.eu/
[3] https://lore.kernel.org/linux-can/20210814101728.75334-1-mailhol.vincent@wanadoo.fr

** Changelog **

v5 -> v6:

  - fix a typo (double space) in
    include/linux-can/dev.h:can_get_relative_tdco().
  - clear garbage values in struct can_tdc. Under certain conditions,
    some of the TDC parameters are irrelevant (example: can_tdc::tdcv
    when in auto mode). In the previous patch, those parameters were
    left untouched. We now clear any of the parameters which become
    irrelevant.
  - fix a bug which allowed to have both CAN_CTRLMODE_TDC_AUTO and
    CAN_CTRLMODE_TDC_MANUAL to be set at the same time. Now, each time
    one of those flag is provided, we make sure to turn the other one
    off.
  - in drivers/net/can/netlink.c:can_tdc_changelink(), store all the
    TDC parameters in a temporary structure and copy them all at once
    at the end of the function. This prevent TDC to be in an
    inconsistent state if the function had to return early due to out
    of bands parameters.
  - similarly to above fix: clear the TDC flags
    (CAN_CTRLMODE_TDC_{AUTO,MANUAL}) if
    drivers/net/can/netlink.c:can_tdc_changelink() return an error
    code. This way, we are not left with inconsistent value.
  - removed the first and last patch of the series because those have
    already been accepted in below pull request:
    https://lore.kernel.org/linux-can/162939960964.18233.15653984142298230559.git-patchwork-notify@kernel.org/T/#t
  - do not modify the TDC parameters if the databittiming parameters
    are not provided. The new logic is now as follow:
      * data bittiming not provided: TDC parameters unchanged
      * data bittiming provided: (unchanged from current behavior)
          + tdc-mode not provided: do can_calc_tdco (fully automated)
          + tdc-mode auto and tdco provided: TDC_AUTO
          + tdc-mode manual and both of tdcv and tdco provided: TDC_MANUAL

Link: https://lore.kernel.org/linux-can/20210815033248.98111-1-mailhol.vincent@wanadoo.fr/T/#t

v4 -> v5:
  - move to can_validate() all of the checks on TDC parameters that do
    not need access to priv.
  - in can_tdc_get_size(), field IFLA_CAN_TDCV was not taken in
    account for size calculation when in automatic mode.
  - if can_tdc_is_enabled(priv) returns true, we know that one of
    either CAN_CTRLMODE_TDC_AUTO or CAN_CTRLMODE_TDC_MANUAL is
    set. After confirming that CAN_CTRLMODE_TDC_MANUAL if off, we then
    implicitly know that CAN_CTRLMODE_TDC_AUTO is set and do not need
    to check it again. Remove such redundant check in
    can_tdc_fill_info().

v3 -> v4:
  - add a patch to the series to change the unit from time quantum to
    clock period (a.k.a. minimum time quantum).
  - add a callback function to retrieve TDCV from the device.

v2 -> v3:
  - allows both TDCV and TDCO to be zero.
  - introduce the can_tdc_get_relative_tdco() helper function
  - other path of the series modified accordingly to above changes.

RFC v1 -> v2:
  The v2 fixes several issue in can_tdc_get_size() and
  can_tdc_fill_info(). Namely: can_tdc_get_size() returned an
  incorrect size if TDC was not implemented and can_tdc_fill_info()
  did not include a fail path with nla_nest_cancel().

Vincent Mailhol (6):
  can: bittiming: allow TDC{V,O} to be zero and add
    can_tdc_const::tdc{v,o,f}_min
  can: bittiming: change unit of TDC parameters to clock periods
  can: bittiming: change can_calc_tdco()'s prototype to not directly
    modify priv
  can: netlink: add interface for CAN-FD Transmitter Delay Compensation
    (TDC)
  can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from
    device
  can: dev: add can_tdc_get_relative_tdco() helper function

 drivers/net/can/dev/bittiming.c           |  28 +--
 drivers/net/can/dev/netlink.c             | 221 +++++++++++++++++++++-
 drivers/net/can/usb/etas_es58x/es58x_fd.c |   7 +-
 include/linux/can/bittiming.h             |  89 ++++++---
 include/linux/can/dev.h                   |  34 ++++
 include/uapi/linux/can/netlink.h          |  31 ++-
 6 files changed, 365 insertions(+), 45 deletions(-)

-- 
2.32.0

