Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBB126D658
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 10:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgIQIXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 04:23:03 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1657 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgIQIWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 04:22:55 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 04:22:55 EDT
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f631b7f0006>; Thu, 17 Sep 2020 01:17:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 01:17:47 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 17 Sep 2020 01:17:47 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 08:17:46 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 0/8] devlink: Add SF add/delete devlink ops
Date:   Thu, 17 Sep 2020 11:17:23 +0300
Message-ID: <20200917081731.8363-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600330623; bh=KbOVsYU6uT2Nz/sH55CuLQN4mra5NsjmcjFMV2LSyb0=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=J2s7UHHHidH2QpAdz/ITa8cRRbgWlQ7jQv0uJphjIwTEnCrQ5LJNoGhEpIkpv/6KR
         pezul+kI2yvtVNG/Rld0lbQrMCrz6Jg+7R61Ds63r/q1usawJ/ovg9qRieXIG5jaHl
         3xEfDA+6+rNDFnevU9RTQwVYhYqWJBT3qXLUmPc1DsXlnZ+6PRKnEiAV7mdDvqQYvW
         +78K1dgntz1h/hyLoxhoqA29bIN/25OlePXhc6woc2JcTbbP+nT1U1rs0S0eB15CeD
         XZnS0weBDcl2lGtxid4pIUTI9LDCR+zCGZzBYhoZCj3vbMy4+QcwrpIEU0wG107owC
         9QUOfJf+dVXIQ==
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

