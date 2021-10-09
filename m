Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06219427A7B
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 15:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhJINPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 09:15:25 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:62987 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhJINPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 09:15:21 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id ZC9zmoEn4UGqlZCA6m2idT; Sat, 09 Oct 2021 15:13:16 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 09 Oct 2021 15:13:16 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 0/3] report the controller capabilities through the netlink interface
Date:   Sat,  9 Oct 2021 22:13:01 +0900
Message-Id: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
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
actually be derived from the other ctrlmode fields. So I added two
extra patches to the series: one to replace that field with a function
and one to repack struct can_priv and fill the hole created after
removing can_priv::ctrlmode_priv.

Please note that the first two patches are not required by the third
one. I am just grouping everything in the same series because the
patches all revolve around the controller modes.


** Changelog **

v1 -> v2:

  - Add a first patch to replace can_priv::ctrlmode_static by the
    inline function can_get_static_ctrlmode()

  - Add a second patch to reorder the fields of struct can_priv for
    better packing (save eight bytes on x86_64 \o/)

  - Rewrite the comments of the third patch "can: netlink: report the
    CAN controller mode supported flags" (no changes on the code
    itself).


Vincent Mailhol (3):
  can: dev: replace can_priv::ctrlmode_static by
    can_get_static_ctrlmode()
  can: dev: reorder struct can_priv members for better packing
  can: netlink: report the CAN controller mode supported flags

 drivers/net/can/dev/dev.c        |  5 +++--
 drivers/net/can/dev/netlink.c    |  7 +++++--
 include/linux/can/dev.h          | 18 +++++++++++++-----
 include/uapi/linux/can/netlink.h |  5 ++++-
 4 files changed, 25 insertions(+), 10 deletions(-)

-- 
2.32.0

