Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8037979074
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfG2QMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:12:15 -0400
Received: from inva020.nxp.com ([92.121.34.13]:37696 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbfG2QMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 12:12:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id D0D7A1A0374;
        Mon, 29 Jul 2019 18:12:13 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C1EB61A0156;
        Mon, 29 Jul 2019 18:12:13 +0200 (CEST)
Received: from fsr-ub1464-137.ea.freescale.net (fsr-ub1464-137.ea.freescale.net [10.171.82.114])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5A102205F3;
        Mon, 29 Jul 2019 18:12:13 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, jiri@mellanox.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH 0/5] staging: fsl-dpaa2/ethsw: add the .ndo_fdb_dump callback
Date:   Mon, 29 Jul 2019 19:11:47 +0300
Message-Id: <1564416712-16946-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 1.9.1
Reply-to: ioana.ciornei@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds some features and small fixes in the
FDB table manipulation area.

First of all, we implement the .ndo_fdb_dump netdev callback so that all
offloaded FDB entries, either static or learnt, are available to the user.
This is necessary because the DPAA2 switch does not emit interrupts when a
new FDB is learnt or deleted, thus we are not able to keep the software
bridge state and the HW in sync by calling the switchdev notifiers.

The patch set also adds the .ndo_fdb_[add|del] callbacks in order to
facilitate adding FDB entries not associated with any master device.

One interesting thing that I observed is that when adding an FDB entry
associated with a bridge (ie using the 'master' keywork appended to the
bridge command) and then dumping the FDB entries, there will be duplicates
of the same entry: one listed by the bridge device and one by the
driver's .ndo_fdb_dump).
It raises the question whether this is the expected behavior or not.

Another concern is regarding the correct/desired machanism for drivers to
signal errors back to switchdev on adding or deleting an FDB entry.
In the switchdev documentation, there is a TODO in the place of this topic.

Ioana Ciornei (5):
  staging: fsl-dpaa2/ethsw: remove unused structure
  staging: fsl-dpaa2/ethsw: notify switchdev of offloaded entry
  staging: fsl-dpaa2/ethsw: add .ndo_fdb_dump callback
  staging: fsl-dpaa2/ethsw: check added_by_user flag
  staging: fsl-dpaa2/ethsw: add .ndo_fdb[add|del] callbacks

 drivers/staging/fsl-dpaa2/ethsw/TODO       |   1 -
 drivers/staging/fsl-dpaa2/ethsw/dpsw-cmd.h |  15 ++-
 drivers/staging/fsl-dpaa2/ethsw/dpsw.c     |  51 +++++++++
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h     |  56 ++++-----
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c    | 178 ++++++++++++++++++++++++++++-
 5 files changed, 265 insertions(+), 36 deletions(-)

-- 
1.9.1

