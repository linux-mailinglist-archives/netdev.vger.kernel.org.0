Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0020149ABF
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387397AbgAZNVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:21:37 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:39277 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729247AbgAZNVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:21:36 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from maorg@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 26 Jan 2020 15:21:29 +0200
Received: from dev-l-vrt-201.mtl.labs.mlnx (dev-l-vrt-201.mtl.labs.mlnx [10.134.201.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00QDLTp3002251;
        Sun, 26 Jan 2020 15:21:29 +0200
From:   Maor Gottlieb <maorg@mellanox.com>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        jiri@mellanox.com, davem@davemloft.net
Cc:     Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        saeedm@mellanox.com, jgg@mellanox.com, leonro@mellanox.com,
        alexr@mellanox.com, markz@mellanox.com, parav@mellanox.com,
        eranbe@mellanox.com, linux-rdma@vger.kernel.org
Subject: [RFC PATCH 0/4] Introduce master_xmit_slave_get
Date:   Sun, 26 Jan 2020 15:21:22 +0200
Message-Id: <20200126132126.9981-1-maorg@mellanox.com>
X-Mailer: git-send-email 2.17.2
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series add support to get the LAG master xmit slave by
introducing new .ndo - ndo_xmit_slave_get. Every LAG module can
implement it. In this RFC, we added the support to the bond module.

The main motivation for doing this is for drivers that offload part
of the LAG functionality [1]. For example, Mellanox Connect-X hardware
implements RoCE LAG which selects the TX affinity when the resources
are created and port is remapped when it goes down [2].

Because of that and the fact that the RDMA frames are bypass the bonding
driver completely, we need a function to get the xmit slave assume
all the slaves are active.

The idea is that the same UDP header will get the same hash result so
they will be transmitted from the same port.


Thanks

[1] https://www.spinics.net/lists/netdev/msg624832.html
[2] https://www.spinics.net/lists/netdev/msg626758.html

Maor Gottlieb (4):
  net/core: Introduce master_xmit_slave_get
  bonding: Rename slave_arr to active_slaves
  bonding: Add helpers to get xmit slave
  bonding: Implement ndo_xmit_slave_get

 drivers/net/bonding/bond_alb.c  |  41 ++++--
 drivers/net/bonding/bond_main.c | 231 ++++++++++++++++++++++----------
 include/linux/netdevice.h       |   3 +
 include/net/bond_alb.h          |   4 +
 include/net/bonding.h           |   3 +-
 include/net/lag.h               |  19 +++
 6 files changed, 215 insertions(+), 86 deletions(-)

-- 
2.17.2

