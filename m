Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B96D2B3516
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 14:44:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbgKONnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 08:43:19 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41357 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726438AbgKONnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 08:43:18 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 15 Nov 2020 15:43:13 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AFDhDYP028844;
        Sun, 15 Nov 2020 15:43:13 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 0/2] TLS TX HW offload for Bond
Date:   Sun, 15 Nov 2020 15:42:49 +0200
Message-Id: <20201115134251.4272-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series opens TLS TX HW offload for bond interfaces.
This allows bond interfaces to benefit from capable slave devices.

The first patch adds real_dev field in TLS context structure, and aligns
usages in TLS module and supporting drivers.
The second patch opens the offload for bond interfaces.

For the configuration above, SW kTLS keeps picking the same slave
To keep simple track of the HW and SW TLS contexts, we bind each socket to
a specific slave for the socket's whole lifetime. This is logically valid
(and similar to the SW kTLS behavior) in the following bond configuration, 
so we restrict the offload support to it:

((mode == balance-xor) or (mode == 802.3ad))
and xmit_hash_policy == layer3+4.

Regards,
Tariq

Tariq Toukan (2):
  net/tls: Add real_dev field to TLS context
  bond: Add TLS TX offload support

 drivers/net/bonding/bond_main.c               | 203 +++++++++++++++++-
 drivers/net/bonding/bond_options.c            |  10 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |   2 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |   2 +-
 include/net/bonding.h                         |   4 +
 include/net/tls.h                             |   1 +
 net/tls/tls_device.c                          |   2 +
 net/tls/tls_device_fallback.c                 |   2 +-
 8 files changed, 216 insertions(+), 10 deletions(-)

-- 
2.21.0

