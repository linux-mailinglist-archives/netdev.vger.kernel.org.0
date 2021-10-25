Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0034B439D77
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 19:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhJYRZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 13:25:37 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:61041 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbhJYRZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 13:25:37 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id f3gYmY0E4niuxf3glmufEi; Mon, 25 Oct 2021 19:23:13 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Mon, 25 Oct 2021 19:23:13 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 0/4] report the controller capabilities through the netlink interface
Date:   Tue, 26 Oct 2021 02:22:43 +0900
Message-Id: <20211025172247.1774451-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The main purpose of this series is to report the CAN controller
capabilities. The proposed method reuses the existing struct
can_ctrlmode and thus do not need a new IFLA_CAN_* entry.

While doing so, I also realized that can_priv::ctrlmode_static could
actually be derived from the other ctrlmode fields. So I added three
extra patches to the series: one to replace that field with a
function, one to add a safeguard on can_set_static_ctrlmode() and one
to repack struct can_priv and fill the hole created after removing
can_priv::ctrlmode_priv.

Please note that the first three patches are not required by the
fourth one. I am just grouping everything in the same series because
the patches all revolve around the controller modes.


** Changelog **

v2 -> v3:

  - Make can_set_static_ctrlmode() return an error and adjust the
    drivers which use this helper function accordingly.

v1 -> v2:

  - Add a first patch to replace can_priv::ctrlmode_static by the
    inline function can_get_static_ctrlmode()

  - Add a second patch to reorder the fields of struct can_priv for
    better packing (save eight bytes on x86_64 \o/)

  - Rewrite the comments of the third patch "can: netlink: report the
    CAN controller mode supported flags" (no changes on the code
    itself).

Vincent Mailhol (4):
  can: dev: replace can_priv::ctrlmode_static by
    can_get_static_ctrlmode()
  can: dev: add sanity check in can_set_static_ctrlmode()
  can: dev: reorder struct can_priv members for better packing
  can: netlink: report the CAN controller mode supported flags

 drivers/net/can/dev/dev.c         |  5 +++--
 drivers/net/can/dev/netlink.c     |  7 +++++--
 drivers/net/can/m_can/m_can.c     | 10 +++++++---
 drivers/net/can/rcar/rcar_canfd.c |  4 +++-
 include/linux/can/dev.h           | 24 +++++++++++++++++-------
 include/uapi/linux/can/netlink.h  |  5 ++++-
 6 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.32.0

