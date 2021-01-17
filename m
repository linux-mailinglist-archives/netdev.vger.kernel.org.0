Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BB72F932D
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729328AbhAQPBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:01:22 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:45145 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728664AbhAQPBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:01:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 17 Jan 2021 17:00:15 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 10HF0F7B029614;
        Sun, 17 Jan 2021 17:00:15 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jarod Wilson <jarod@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next V3 0/8] TLS device offload for Bond
Date:   Sun, 17 Jan 2021 16:59:41 +0200
Message-Id: <20210117145949.8632-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series opens TX and RX TLS device offload for bond interfaces.
This allows bond interfaces to benefit from capable lower devices.

We add a new ndo_sk_get_lower_dev() to be used to get the lower dev that
corresponds to a given socket.
The TLS module uses it to interact directly with the lowest device in
chain, and invoke the control operations in tlsdev_ops. This means that the
bond interface doesn't have his own struct tlsdev_ops instance and
derived logic/callbacks.

To keep simple track of the HW and SW TLS contexts, we bind each socket to
a specific lower device for the socket's whole lifetime. This is logically
valid (and similar to the SW kTLS behavior) in the following bond configuration,
so we restrict the offload support to it:

((mode == balance-xor) or (mode == 802.3ad))
and xmit_hash_policy == layer3+4.

In this design, TLS TX/RX offload feature flags of the bond device are
independent from the lower devices. They reflect the current features state,
but are not directly controllable.
This is because the bond driver is bypassed by the call to
ndo_sk_get_lower_dev(), without him knowing who the caller is.
The bond TLS feature flags are set/cleared only according to the configuration
of the mode and xmit_hash_policy.

Bypass is true only for the control flow. Packets in fast path still go through
the bond logic.

The design here differs from the xfrm/ipsec offload, where the bond driver
has his own copy of struct xfrmdev_ops and callbacks.

Regards,
Tariq

V3:
- Use "lower device" instead of "slave".
- Make TLS TX/RX devie offload feature flags non-controllable [Fixed].

V2:
- Declare RX support.
- Enhance the feature flags logic.
- Slight modifications for bond_set_xfrm_features().
- 

RFC:
- New design for the tlsdev_ops calls, introduce and use ndo_sk_get_slave()
  to interact directly with the slave netdev.
- Remove bond copy of tlsdev_ops callbacks.
- In TLS module: Use netdev_sk_get_lowest_dev(), give exceptions to some checks
  to allow bond support.


Tariq Toukan (8):
  net: netdevice: Add operation ndo_sk_get_lower_dev
  net/bonding: Take IP hash logic into a helper
  net/bonding: Implement ndo_sk_get_lower_dev
  net/bonding: Take update_features call out of XFRM funciton
  net/bonding: Implement TLS TX device offload
  net/bonding: Declare TLS RX device offload support
  net/tls: Device offload to use lowest netdevice in chain
  net/tls: Except bond interface from some TLS checks

 drivers/net/bonding/bond_main.c    | 138 +++++++++++++++++++++++++++--
 drivers/net/bonding/bond_options.c |  42 +++++++--
 include/linux/netdevice.h          |   4 +
 include/net/bonding.h              |   4 +
 net/core/dev.c                     |  33 +++++++
 net/tls/tls_device.c               |   4 +-
 net/tls/tls_device_fallback.c      |   2 +-
 7 files changed, 211 insertions(+), 16 deletions(-)

-- 
2.21.0

