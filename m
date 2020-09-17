Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BA926E22F
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgIQRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:20:51 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11028 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgIQRUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:20:35 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f639a880001>; Thu, 17 Sep 2020 10:19:04 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 10:20:33 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 10:20:33 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 17:20:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Date:   Thu, 17 Sep 2020 20:20:12 +0300
Message-ID: <20200917172020.26484-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200917081731.8363-8-parav@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600363144; bh=zvuS8s0qxZ5cKsy1wxygzQ59kQ4ObXSo+U0oboEg5kE=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=WawXX1GCVfRz7G9O/r0J8MOumiiiAAWLcTal6/mNoCIwD71TGJLxAEMhAjdpKZACR
         SSzg6bFMt5AU6gncNX7U6jR/tzgukeOJB4RmFH1PPdqR9ddpjQhgjQBH5fn3xp7q57
         pIMAi5hdk1SdFgCsHuJFWqhOBO7BE4xqsOV54j4pup5ej6aENMb8vRSyABtx8HB3v4
         QU2NeNGDiMzhfuHG092G7kmjWKaaKOLm+sUGQl2ohhX1C4WxDelINxNd/OztgAP9MJ
         DLIzaZDZU0chiAYznK0WWVrOcSGaucECcpfHhLyhzFF1zqtWyqa7ZLmAGzUre4+zSf
         9eiImRc2ziQNg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub,

Similar to PCI VF, PCI SF represents portion of the device.
PCI SF is represented using a new devlink port flavour.

This short series implements small part of the RFC described in detail at [=
1] and [2].

It extends
(a) devlink core to expose new devlink port flavour 'pcisf'.
(b) Expose new user interface to add/delete devlink port.
(c) Extends netdevsim driver to simulate PCI PF and SF ports
(d) Add port function state attribute

Patch summary:
Patch-1 Extends devlink to expose new PCI SF port flavour
Patch-2 Extends devlink to let user add, delete devlink Port
Patch-3 Prepare code to handle multiple port attributes
Patch-4 Extends devlink to let user get, set function state
Patch-5 Extends netdevsim driver to simulate PCI PF ports
Patch-6 Extends netdevsim driver to simulate hw_addr get/set
Patch-7 Extends netdevsim driver to simulate function state get/set
Patch-8 Extends netdevsim driver to simulate PCI SF ports

[1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
[2] https://marc.info/?l=3Dlinux-netdev&m=3D158555928517777&w=3D2

---
Changelog:
v1->v2:
 - Fixed extra semicolon at end of switch case reportec by coccinelle

Parav Pandit (8):
  devlink: Introduce PCI SF port flavour and port attribute
  devlink: Support add and delete devlink port
  devlink: Prepare code to fill multiple port function attributes
  devlink: Support get and set state of port function
  netdevsim: Add support for add and delete of a PCI PF port
  netdevsim: Simulate get/set hardware address of a PCI port
  netdevsim: Simulate port function state for a PCI port
  netdevsim: Add support for add and delete PCI SF port

 drivers/net/netdevsim/Makefile        |   3 +-
 drivers/net/netdevsim/dev.c           |  14 +
 drivers/net/netdevsim/netdevsim.h     |  32 ++
 drivers/net/netdevsim/port_function.c | 498 ++++++++++++++++++++++++++
 include/net/devlink.h                 |  75 ++++
 include/uapi/linux/devlink.h          |  13 +
 net/core/devlink.c                    | 230 ++++++++++--
 7 files changed, 840 insertions(+), 25 deletions(-)
 create mode 100644 drivers/net/netdevsim/port_function.c

--=20
2.26.2

