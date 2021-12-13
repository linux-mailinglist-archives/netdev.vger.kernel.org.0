Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341E0473119
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240254AbhLMQCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:02:47 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:55119 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235246AbhLMQCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:02:47 -0500
Received: from localhost.localdomain ([106.133.22.31])
        by smtp.orange.fr with ESMTPA
        id wnmbm1mzFk3HQwnmimkNaJ; Mon, 13 Dec 2021 17:02:44 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Mon, 13 Dec 2021 17:02:44 +0100
X-ME-IP: 106.133.22.31
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 0/4] report the controller capabilities through the netlink interface
Date:   Tue, 14 Dec 2021 01:02:22 +0900
Message-Id: <20211213160226.56219-1-mailhol.vincent@wanadoo.fr>
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

v5 -> v6:

  - Add back patches 1, 2 and 3 because those were removed from the
    testing branch of linux-can-next since.

  - Rebase the series on the latest version of net-next.

  - Fix a typo in the comments of the forth patch: guaruanty ->
    guaranty.

v4 -> v5:

  - Implement IFLA_CAN_CTRLMODE_EXT in order to fix forward
    compatibility issues as suggested by Marc in:
    https://lore.kernel.org/linux-can/20211029124608.u7zbprvojifjpa7j@pengutronix.de/T/#m78118c94072083a6f8d2f0f769b120f847ac1384

v3 -> v4:

  - Tag the union in struct can_ctrlmode as packed.

  - Remove patch 1, 2 and 3 from the series because those were already
    added to the testing branch of linux-can-next (and no changes
    occurred on those first three patches).

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
 drivers/net/can/dev/netlink.c     | 33 +++++++++++++++++++++++++++++--
 drivers/net/can/m_can/m_can.c     | 10 +++++++---
 drivers/net/can/rcar/rcar_canfd.c |  4 +++-
 include/linux/can/dev.h           | 24 +++++++++++++++-------
 include/uapi/linux/can/netlink.h  | 13 ++++++++++++
 6 files changed, 74 insertions(+), 15 deletions(-)


base-commit: 64445dda9d8384975eca54e3f01886fca61e1db6
prerequisite-patch-id: 84ffb60366d113cfbf6fb8e415217d9e09fadefd
-- 
2.32.0

