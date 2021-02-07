Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0309C3122D2
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 09:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhBGIpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 03:45:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2836 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBGIpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 03:45:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601fa86a0000>; Sun, 07 Feb 2021 00:44:26 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 7 Feb
 2021 08:44:25 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 0/7] netdevsim port add, delete support
Date:   Sun, 7 Feb 2021 10:44:05 +0200
Message-ID: <20210207084412.252259-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210206125551.8616-1-parav@nvidia.com>
References: <20210206125551.8616-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612687466; bh=I3Yf9LWlaB7vvJandXXNlBmJSrW5OtmZ5Nihm9hFXKg=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=jhgJeLuyAZDxDXLjdMnEQCQdZPksMyzvlOTgxa/7VnFPmIC2mKBhUt3+PEkjZqhGH
         mH0eUlEwkgiokfoeqf9KEb0yWZCUlmZFHlGvGtC21bhOiXAhXgdK3OhzOLABrFqskN
         zhpXXxpFYaSyILARZPMVrUTW9sYUEHRzCA8zre6ndwnVwR8q7zj2ASPSEjrFyTZbPk
         rBRt3urjY7aDRbiOOACDIdPeRPti7NtHF+daNPGi6Of6/Q+nvplpRS2/jC4jHu9aTR
         qHotS2BpeBLpJ2lpViMvM+pXNCN1yY2+HgAqvHNubf30g7IEDw2amfm6ayCi/Yrxrp
         CkYenlLNR7Rgg==
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

