Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4875747E56E
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhLWP1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:27:07 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:34005 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbhLWP1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:27:04 -0500
Received: (Authenticated sender: repk@triplefau.lt)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id CDBCA1C0004;
        Thu, 23 Dec 2021 15:27:00 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH net 0/2] Fix SIOCGIFBR/SIOCSIFBR ioctl
Date:   Thu, 23 Dec 2021 16:31:37 +0100
Message-Id: <20211223153139.7661-1-repk@triplefau.lt>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SIOC{G,S}IFBR ioctls have been broken since [0], as discussed here [1]
the intent was to get them working in compat mode.

This serie is gathering patch from [2] with the one from [3].

The first patch fixes the ioctl usage so it can be backported to stable
kernel while the second one adds proper support for those ioctl in
compat mode.

This has been tested with busybox's brctl as below.

Before this serie

- 64-bit brctl:
  $ brctl show
  bridge name     bridge id               STP enabled     interfaces
  brctl: can't get bridge name for index 0: No such device or address

- 32-bit brctl on CONFIG_COMPAT=y kernel:
  $ brctl show
  brctl: SIOCGIFBR: Invalid argument

With first patch of this serie

- 64-bit brctl
  $ brctl show
  bridge name     bridge id               STP enabled     interfaces
  br0             8000.000000000000       no

- 32-bit brctl on CONFIG_COMPAT=y kernel
  $ brctl show
    brctl: SIOCGIFBR: Invalid argument

With both patches

- 64-bit brctl
  $ brctl show
  bridge name     bridge id               STP enabled     interfaces
  br0             8000.000000000000       no

- 32-bit brctl on CONFIG_COMPAT=y kernel
  $ brctl show
  bridge name     bridge id               STP enabled     interfaces
  br0             8000.000000000000       no

[0] commit 561d8352818f ("bridge: use ndo_siocdevprivate")
[1] https://lkml.org/lkml/2021/12/22/805
[2] https://lkml.org/lkml/2021/12/22/743
[3] https://lkml.org/lkml/2021/12/23/212

Thanks,

Remi Pommarel (2):
  net: bridge: fix ioctl old_deviceless bridge argument
  net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl working in compat mode

 net/bridge/br_ioctl.c | 75 ++++++++++++++++++++++++++++---------------
 net/socket.c          | 20 ++----------
 2 files changed, 52 insertions(+), 43 deletions(-)

-- 
2.33.0

