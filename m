Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D372E700A
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 12:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgL2Lmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 06:42:31 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55468 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726196AbgL2LmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 06:42:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 29 Dec 2020 13:41:20 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0BTBfKQe031596;
        Tue, 29 Dec 2020 13:41:20 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@nvidia.com>, andy@greyhouse.net,
        vfalico@gmail.com, j.vosburgh@gmail.com,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH RFC net-next 0/6] RFC: TLS TX HW offload for Bond
Date:   Tue, 29 Dec 2020 13:40:58 +0200
Message-Id: <20201229114104.7120-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is an RFC of the series that opens TLS TX HW offload for bond interfaces.
It allows them to benefit from capable slave devices.

To keep simple track of the HW and SW TLS contexts, we bind each socket to
a specific slave for the socket's whole lifetime. This is logically valid
(and similar to the SW kTLS behavior) in the following bond configuration, 
so we restrict the offload support to it:

((mode == balance-xor) or (mode == 802.3ad))
and xmit_hash_policy == layer3+4.

Opens/points for discussion:
- New ndo_sk_get_slave is introduced, as the existing ndo_get_xmit_slave returns
  a slave based on SKB fields, which in throry could give different results
  along the socket's lifetime.

- In this design, bond driver has no way to specify its own restrictions on
  when the TLS device offload is supported (depending on mode and xmit_policy).
  The best it can do today is return NULL in bond_sk_get_slave().
  This is not optimal, non-TLS cases might also want to call bond_sk_get_slave()
  in the future, and they might have other restrictions (for example, they might
  be okay in working with layer != LAYER34).
  That's another reason why I didn't combine ndo_sk_get_slave/ndo_get_xmit_slave
  into a single operation in this RFC.

- Patch #3 adds two explicit exceptions for bond devices in the TLS module.
  First is because a bond device supports the device offload without having
  a tls_dev_ops structure of it's own.
  Second, the TLS context is totally unaware of the bond netdev, but SKBs 
  still go through its xmit/validate functions.
  This is not very clean. What do you think?

- This bond design and implementation for the TLS device offload differs from the
  xfrm/ipsec offload. Bond does have struct xfrmdev_ops and callbacks of its own,
  communication is done via the bond and not directly to the lowest device.

Regards,
Tariq


Tariq Toukan (6):
  net: netdevice: Add operation ndo_sk_get_slave
  net/tls: Device offload to use lowest netdevice in chain
  net/tls: Except bond interface from some TLS checks
  net/bonding: Take IP hash logic into a helper
  net/bonding: Implement ndo_sk_get_slave
  net/bonding: Support TLS TX device offload

 drivers/net/bonding/bond_main.c    | 134 +++++++++++++++++++++++++++--
 drivers/net/bonding/bond_options.c |  27 ++++--
 include/linux/netdevice.h          |   4 +
 include/net/bonding.h              |   2 +
 net/core/dev.c                     |  32 +++++++
 net/tls/tls_device.c               |   4 +-
 net/tls/tls_device_fallback.c      |   3 +-
 7 files changed, 194 insertions(+), 12 deletions(-)

-- 
2.21.0

