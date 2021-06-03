Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDCAB39A441
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhFCPR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:17:57 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:46338 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231553AbhFCPR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:17:57 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d75 with ME
        id CfFu2500H0zjR6y03fG8Pq; Thu, 03 Jun 2021 17:16:10 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Thu, 03 Jun 2021 17:16:10 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 0/2] add the netlink interface for CAN-FD Transmitter Delay Compensation (TDC)
Date:   Fri,  4 Jun 2021 00:15:48 +0900
Message-Id: <20210603151550.140727-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds a netlink interface for the TDC parameters using
netlink nested attributes.

The first patch remove a redundant check. The second patch is the real
thing: the TDC netlink interface.

In March, I introduced the Transmitter Delay Compensation (TDC) to the
kernel though two patches:
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

I sent a v1 as an RFC which got zero comments, so I am assuming that
the overall design is OK :)

Now, I feel confident enough to drop the RFC tag. Thanks for your review!

For those who would like to test it, please refer to this iproute2 patch:
https://lore.kernel.org/linux-can/20210507102819.1932386-1-mailhol.vincent@wanadoo.fr/t/#u

** Changelog **
The nested structure (IFLAC_CAN_TDC*) remains unchanged since RFC v1.
The v2 fixes several issue in can_tdc_get_size() and
can_tdc_fill_info(). Namely: can_tdc_get_size() returned an incorrect
size if TDC was not implemented and can_tdc_fill_info() did not
include a fail path with nla_nest_cancel().


Vincent Mailhol (2):
  can: netlink: remove redundant check in can_validate()
  can: netlink: add interface for CAN-FD Transmitter Delay Compensation
    (TDC)

 drivers/net/can/dev/netlink.c    | 140 ++++++++++++++++++++++++++++++-
 include/uapi/linux/can/netlink.h |  26 +++++-
 2 files changed, 160 insertions(+), 6 deletions(-)

-- 
2.31.1

