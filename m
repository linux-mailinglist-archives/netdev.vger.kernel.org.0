Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5ED27E702
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 12:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgI3Kte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 06:49:34 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1526 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgI3Kte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 06:49:34 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f74628b0000>; Wed, 30 Sep 2020 03:48:43 -0700
Received: from localhost.localdomain (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Sep
 2020 10:49:31 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 0/6] mlxsw: PFC and headroom selftests
Date:   Wed, 30 Sep 2020 12:49:06 +0200
Message-ID: <cover.1601462261.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601462923; bh=8v+/sjKcO4uHxoCEdRB8WCJ0FuNexSvL4UQbk3jRyaE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         Content-Transfer-Encoding:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=MbMqBxv7sdZ7anMVHOSXS8APYS5Ypjm3DFK9FMakvXV917Hbpn1il49MWBKw2B+iv
         GSTjS/wzgtTxvA8TdRVsdq30kthdRnOhygKLK166h5/VYrh2CwtW9WX0PTlI7sdIyz
         GXPmFZahczl8oo6BZKRP9v8pbbWncq1uqIaNU34epSCpgUxNIw8jvh3I08928THQbb
         pa5AjGrQvqMO852q1svcYi71S6aGKWIkfQxH78t4ZJ1vUOj7ENXl1BGSpS0QcjydVv
         yg2lUFfnXEkUFEQXSD658AYXmvqxxxfU8RjWvDp+EZKlN2THYINr4A2xtTUQTRz/LS
         Bya3H8DOOsuSA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recent changes in the headroom management code made it clear that an
automated way of testing this functionality is needed. This patchset brings
two tests: a synthetic headroom behavior test, which verifies mechanics of
headroom management. And a PFC test, which verifies whether this behavior
actually translates into a working lossless configuration.

Both of these tests rely on mlnx_qos[1], a tool that interfaces with Linux
DCB API. The tool was originally written to work with Mellanox NICs, but
does not actually rely on anything Mellanox-specific, and can be used for
mlxsw as well as for any other NIC-like driver. Unlike Open LLDP it does
support buffer commands and permits a fire-and-forget approach to
configuration, which makes it very handy for writing of selftests.

Patches #1-#3 extend the selftest devlink_lib.sh in various ways. Patch #4
then adds a helper wrapper for mlnx_qos to mlxsw's qos_lib.sh.

Patch #5 adds a test for management of port headroom.

Patch #6 adds a PFC test.

[1] https://github.com/Mellanox/mlnx-tools/

Petr Machata (6):
  selftests: forwarding: devlink_lib: Split devlink_..._set() into save
    & set
  selftests: forwarding: devlink_lib: Add devlink_cell_size_get()
  selftests: forwarding: devlink_lib: Support port-less topologies
  selftests: mlxsw: qos_lib: Add a wrapper for running mlnx_qos
  selftests: mlxsw: Add headroom handling test
  selftests: mlxsw: Add a PFC test

 .../drivers/net/mlxsw/qos_ets_strict.sh       |   9 +
 .../drivers/net/mlxsw/qos_headroom.sh         | 379 ++++++++++++++++
 .../selftests/drivers/net/mlxsw/qos_lib.sh    |  14 +
 .../drivers/net/mlxsw/qos_mc_aware.sh         |   5 +
 .../selftests/drivers/net/mlxsw/qos_pfc.sh    | 403 ++++++++++++++++++
 .../selftests/drivers/net/mlxsw/sch_ets.sh    |   6 +
 .../drivers/net/mlxsw/sch_red_core.sh         |   1 +
 .../selftests/net/forwarding/devlink_lib.sh   |  72 +++-
 8 files changed, 876 insertions(+), 13 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_headroom.=
sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh

--=20
2.20.1

