Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6D2FD0BB
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbhATMvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:51:07 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:30848 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388192AbhATLnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 06:43:46 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d11 with ME
        id Jzhf2400E3PnFJp03zhzdN; Wed, 20 Jan 2021 12:42:04 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Wed, 20 Jan 2021 12:42:04 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Loris Fauster <loris.fauster@ttcontrol.com>,
        Alejandro Concepcion Rodriguez <alejandro@acoro.eu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 0/3] Fix several use after free bugs
Date:   Wed, 20 Jan 2021 20:41:34 +0900
Message-Id: <20210120114137.200019-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fix three bugs which all have the same root cause.

When calling netif_rx(skb) and its variants, the skb will eventually
get consumed (or freed) and thus it is unsafe to dereference it after
the call returns.

This remark especially applies to any variable with aliases the skb
memory which is the case of the can(fd)_frame.

The pattern is as this:
    skb = alloc_can_skb(dev, &cf);
    /* Do stuff */
    netif_rx(skb);
    stats->rx_bytes += cf->len;

Increasing the stats should be done *before* the call to netif_rx()
while the skb is still safe to use.

Changes since v3:
  - Patch 1/3: move the comments for upstream after the --- scissors

Changes since v2:
  - rebase on net/master
  - Patch 1/3: Added a comment towards upstream to inform about a
    conflict which will occur when net-next and net are merged
Ref: https://lore.kernel.org/linux-can/20210120085356.m7nabbw5zhy7prpo@hardanger.blackshift.org/

Changes since v1:
  - fix a silly typo in patch 2/3 (variable len was declared twice...)

Vincent Mailhol (3):
  can: dev: can_restart: fix use after free bug
  can: vxcan: vxcan_xmit: fix use after free bug
  can: peak_usb: fix use after free bugs

 drivers/net/can/dev.c                      | 4 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 8 ++++----
 drivers/net/can/vxcan.c                    | 6 ++++--
 3 files changed, 10 insertions(+), 8 deletions(-)


base-commit: 9c30ae8398b0813e237bde387d67a7f74ab2db2d
-- 
2.26.2

