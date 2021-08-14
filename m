Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258AF3EC194
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 11:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237652AbhHNJTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 05:19:39 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:49608 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237613AbhHNJTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 05:19:38 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d19 with ME
        id hMJz250060zjR6y03MK6ip; Sat, 14 Aug 2021 11:19:09 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sat, 14 Aug 2021 11:19:09 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 0/7] add the netlink interface for CAN-FD Transmitter Delay Compensation (TDC)
Date:   Sat, 14 Aug 2021 18:17:43 +0900
Message-Id: <20210814091750.73931-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
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
released ethtool-netlink interface.
Ref: https://lore.kernel.org/linux-can/20210407081557.m3sotnepbgasarri@pengutronix.de/

ethtool uses nested attributes (c.f. NLA_NESTED type in validation
policy). A bit of trivia: the NLA_NESTED type was introduced in
version 2.6.15 of the kernel and thus actually predates Socket CAN.
Ref: commit bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")

Since then, Stephan shared additional remarks for improvement which
are addressed in revision v4 of this series:
Ref: https://lore.kernel.org/linux-can/75fa87a71a3f5fd7d7407a2c514b71690e56eb4e.camel@esd.eu/

The first patch allow a user to turn off a feature even if not
supported (e.g. allow "ip link set can0 type can bitrate 500000 fd
off" even if fd is not supported). This feature will be used later by
the fifth patch of the series.

The second patch allows TDCV and TDCO to be zero (previously, those
values were assigned a special meaning).

The third patch fixes the unit of the TDC parameters. In fact, those
should be measured in clock period (a.k.a. minimum time quantum) and
not in time quantum as it is done in current implementation.

The fourth patch addresses the concern of Marc and Stefan concerning
some devices which use a TDCO value relative to the Sample Point (so
far, the TDC implementation used the formula SSP = TDCV + TDCO). To do
so, an helper function to convert TDCO from an absolute value to a
value relative to the sample point is added.

The fifth patch is the real thing: the TDC netlink interface.

The sixth patch allows to retrieve TDCV from the device through a
callback function.

The seventh and last patch does a bit of cleanup in the ES58x driver
to remove some redundant TDC information from the documentation.

** Changelog **

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

Vincent Mailhol (7):
  can: netlink: allow user to turn off unsupported features
  can: bittiming: allow TDC{V,O} to be zero and add
    can_tdc_const::tdc{v,o,f}_min
  can: bittiming: change unit of TDC parameters to clock periods
  can: dev: add can_tdc_get_relative_tdco() helper function
  can: netlink: add interface for CAN-FD Transmitter Delay Compensation
    (TDC)
  can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from
    device
  can: etas_es58x: clean-up documentation of struct es58x_fd_tx_conf_msg

 drivers/net/can/dev/bittiming.c           |  19 ++-
 drivers/net/can/dev/netlink.c             | 192 +++++++++++++++++++++-
 drivers/net/can/usb/etas_es58x/es58x_fd.c |   7 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.h |  23 +--
 include/linux/can/bittiming.h             |  80 ++++++---
 include/linux/can/dev.h                   |  34 ++++
 include/uapi/linux/can/netlink.h          |  31 +++-
 7 files changed, 332 insertions(+), 54 deletions(-)

-- 
2.31.1

