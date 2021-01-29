Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA42308AB9
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhA2Q5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:57:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7084 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbhA2Q53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:57:29 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60143e500000>; Fri, 29 Jan 2021 08:56:48 -0800
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 16:56:48 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <dsahern@gmail.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>
Subject: [PATCH iproute2-next 0/5] Support devlink port add delete
Date:   Fri, 29 Jan 2021 18:56:03 +0200
Message-ID: <20210129165608.134965-1-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611939408; bh=QIqDYWipo0uHr/8RbiM998NSg5YL/b75qR2dgvXPSHU=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=lNevEnSLRe9onnHlTbCg++1v3vgCCnsRyyQo+ke/TLdyU6nov71YoUvOmp3VpDtss
         5mcY4Ui1djhst28gYMRwWnj5dEE23mfEe95rMNcpHHrsZPLzfqSnNv1oW7DJw/CboM
         HMfSW3sd8ru5DziapMlUIzjIZoXTgYsZrKAWeOVhfI+a+n5XMU3vEZi4rbW3lhqoPK
         amUIlB+DObgTiF2oFfx42OIPnqXnS2fs+qw7ELrE+RntP01pL3cjGDNiTqoV12UdF2
         2fHN0ic2LV8uyx9PBHMwUYTP2AIrCQ7XHm5BsQESTaCFkAIassRZ27HCk+SuShj1NY
         i79ilVBCtbRTw==
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
Patch-2 shows PCI SF port attributes
Patch-3 adds devlink commands to add and delete a port along with man
page
Patch-4 shows function state and operational state
Patch-5 enables user to set function state and adds man page
documentation

Parav Pandit (5):
  devlink: Update kernel headers
  devlink: Introduce PCI SF port flavour and attribute
  devlink: Supporting add and delete of devlink port
  devlink: Support get port function state
  devlink: Support set of port function state

 devlink/devlink.c            | 249 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/devlink.h |  25 ++++
 man/man8/devlink-port.8      | 127 ++++++++++++++++++
 3 files changed, 384 insertions(+), 17 deletions(-)

--=20
2.26.2

