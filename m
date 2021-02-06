Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC57311D3C
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 13:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBFM4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 07:56:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16280 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFM4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Feb 2021 07:56:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601e91e50000>; Sat, 06 Feb 2021 04:56:05 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 6 Feb
 2021 12:56:04 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 0/7] netdevsim port add, delete support
Date:   Sat, 6 Feb 2021 14:55:44 +0200
Message-ID: <20210206125551.8616-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612616165; bh=I3Yf9LWlaB7vvJandXXNlBmJSrW5OtmZ5Nihm9hFXKg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=PIKR6YtqGQNpZ+MJsfnmRW4kiCZ/MQtJwI2cZBs9ODGaDUv3TwFU2CE16kkLvuiYa
         cq6N8UBdpJd6vrcCjMcbe62xC8WYv675ATkEtLhf+zU8YidnBitxQlSN0tsT6+eYR9
         RsP3gXfGARHt7FBHqrdGkwXOlp1HjmOed9fu0AccIyXD3jYPit4V0mOlitqmuYlxRX
         RSF2vPxzLF+59ex8Vf2EmrgKfqNVDONb85/zdM8qiwm73cd+NIqJ+bjR0+RePL4ZiI
         J0nXqQRlCINWdAz65/RlNLMA5k67PDvYAg5D73oOX8Qmq6eFEFH8NWutgQ8TbZ92s1
         sV0CzY6yvZ8Ug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series simulates one or more PCI PF and SF port addition and function
configuration functionality.

Example sequence:
Create a device with ID=3D10 and one physical port.
$ echo "10 1" > /sys/bus/netdevsim/new_device

Add PCI PF port:
$ devlink port add netdevsim/netdevsim10 flavour pcipf pfnum 2
netdevsim/netdevsim10/1: type eth netdev eth1 flavour pcipf controller 0 pf=
num 2 external false splittable false
  function:
    hw_addr 00:00:00:00:00:00

$ devlink port add netdevsim/netdevsim10 flavour pcisf pfnum 2
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false
  function:
    hw_addr 00:00:00:00:00:00

Show devlink port:
$ devlink port show netdevsim/netdevsim10/2
netdevsim/netdevsim10/2: type eth netdev eth2 flavour pcisf controller 0 pf=
num 2 sfnum 0 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Set the MAC address and activate the function:
$ devlink port function set netdevsim/netdevsim10/2 hw_addr 00:11:22:33:44:=
55 state active

Show the port and function attributes in JSON format:
$ devlink port show netdevsim/netdevsim10/2 -jp
{
    "port": {
        "netdevsim/netdevsim10/2": {
            "type": "eth",
            "netdev": "eth2",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 2,
            "sfnum": 0,
            "splittable": false,
            "function": {
                "hw_addr": "00:11:22:33:44:55",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

Delete PCI SF and PF ports:
$ devlink port del netdevsim/netdevsim10/2

Patch summary:
patch-1 adds support for adding/remove PCI PF port
patch-2 adds support for adding/remove PCI SF port
patch-3 simulates MAC address query
patch-4 simulates setting MAC address
patch-5 simulates state query
patch-6 simulates setting state
patch-7 adds tests

Parav Pandit (7):
  netdevsim: Add support for add and delete of a PCI PF port
  netdevsim: Add support for add and delete PCI SF port
  netdevsim: Simulate get hardware address of a PCI port
  netdevsim: Simulate set hardware address of a PCI port
  netdevsim: Simulate port function state for a PCI port
  netdevsim: Simulate port function set state for a PCI port
  netdevsim: Add netdevsim port add test cases

 drivers/net/netdevsim/Makefile                |   2 +-
 drivers/net/netdevsim/dev.c                   |  14 +
 drivers/net/netdevsim/netdevsim.h             |  38 ++
 drivers/net/netdevsim/port_function.c         | 521 ++++++++++++++++++
 .../drivers/net/netdevsim/devlink.sh          |  72 ++-
 5 files changed, 645 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/netdevsim/port_function.c

--=20
2.26.2

