Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A307730B225
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBAVgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:36:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4873 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbhBAVgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 16:36:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6018744a0000>; Mon, 01 Feb 2021 13:36:10 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 21:36:09 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next v2 0/6] Support devlink port add delete
Date:   Mon, 1 Feb 2021 23:35:45 +0200
Message-ID: <20210201213551.8503-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210129165608.134965-1-parav@nvidia.com>
References: <20210129165608.134965-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612215370; bh=P9zszs5TZirFxZ9JKx6knJ2dGHzYiEETHJB41nwZdnA=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=K8jS5vKgAagnDWqMayTqER1ntDx8u4dCNVcliAOyV4o2+XdW/lWBOqXkVdpFccK6G
         mAlE0aw9pXScTnKhCWk6pmHs7rY/9+TF/PXRO5gIRztg7xKITauKW1856cC3R6yTWO
         jHqDzzfxWYgJ6xJ7VntDSq6QGEKEEHp+B+mmodtMZIbVu9+WL3P3TT7d/RU4nt97Kt
         IciELyvCVwxB9Qnqst6t6+rtCnc3gYDGnilo5EpKAI3bA5zbaVsOM7XhjrqBJ+O+FE
         7ymuLhEv8Zrc0erdihhJUj+L0gEPSW/+oh8dOEhRo3dt2aCXiwRE4yjKGjaaa3vgBs
         4ktfu0xS1tU1g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset implements devlink port add, delete and function state
management commands.

An example sequence for a PCI SF:

Set the device in switchdev mode:
$ devlink dev eswitch set pci/0000:06:00.0 mode switchdev

View ports in switchdev mode:
$ devlink port show
pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 s=
plittable false

Add a subfunction port for PCI PF 0 with sfnumber 88:
$ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfn=
um 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Show a newly added port:
$ devlink port show pci/0000:06:00.0/32768
pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf contro=
ller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached

Set the function state to active:
$ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:8=
8 state active

Show the port in JSON format:
$ devlink port show pci/0000:06:00.0/32768 -jp
{
    "port": {
        "pci/0000:06:00.0/32768": {
            "type": "eth",
            "netdev": "ens2f0npf0sf88",
            "flavour": "pcisf",
            "controller": 0,
            "pfnum": 0,
            "sfnum": 88,
            "splittable": false,
            "function": {
                "hw_addr": "00:00:00:00:88:88",
                "state": "active",
                "opstate": "attached"
            }
        }
    }
}

Set the function state to active:
$ devlink port function set pci/0000:06:00.0/32768 state inactive

Delete the port after use:
$ devlink port del pci/0000:06:00.0/32768

Patch summary:
Patch-1 updates kernel headers
Patch-2 introduces string to number map helper and uses it for port
flavour
Patch-3 shows PCI SF port attributes
Patch-4 adds devlink commands to add and delete a port along with man
page
Patch-5 shows function state and operational state to user
Patch-6 enables user to set function state and adds man page
documentation


Parav Pandit (6):
  devlink: Update kernel headers
  devlink: Introduce and use string to number mapper
  devlink: Introduce PCI SF port flavour and attribute
  devlink: Supporting add and delete of devlink port
  devlink: Support get port function state
  devlink: Support set of port function state

 devlink/devlink.c            | 260 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/devlink.h |  25 ++++
 include/utils.h              |   9 ++
 lib/utils.c                  |  41 ++++++
 man/man8/devlink-port.8      | 127 +++++++++++++++++
 5 files changed, 429 insertions(+), 33 deletions(-)

--=20
2.26.2

