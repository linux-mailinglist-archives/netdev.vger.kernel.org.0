Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6163E682298
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjAaDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjAaDMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:12:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B685A5248
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:12:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC9861381
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E205C433D2;
        Tue, 31 Jan 2023 03:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675134726;
        bh=KHlKMZtZJV4dMdOu36Nyi7XTMcy73URSuKXgB/dmJS0=;
        h=From:To:Cc:Subject:Date:From;
        b=r1N7Lp8ySEZX6obNKJdIPnMSSxhpso7T1ucl3PpTexgyySM6RtX4w/F4D5BssOzn3
         N0AqEomiXlBG/N9KBxQ8IbOeajwNv/BVmOD4N5Tr8ICx+o8a7YaTk5mIvoFWweMvjG
         ByutpO3ytXE7Qkcx4qB08UvbjAzx/lrkq70QMlNtSyVbdtryeQeAsKmwl52689hWPL
         yby5o8aIKxIvL9/5H4+kcRX1WG4MJ0v4/YE2l9CIhXJk46WtZ+OLwWiYz/y0G+vMBa
         e9uiBUU0n2XDMkkoF/f8MsOT0QPCl2/MtRbLVx3DIRzgx2UJboq7XFfhaHZ9lZMsPd
         VUWIUKvkOOXug==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net-next 00/15] mlx5 updates 2023-01-30
Date:   Mon, 30 Jan 2023 19:11:46 -0800
Message-Id: <20230131031201.35336-1-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Add fast update encryption key, bulk allocation and recycling.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 90e8ca0abb05ada6c1e2710eaa21688dafca26f2:

  Merge branch 'devlink-next' (2023-01-30 08:37:46 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2023-01-30

for you to fetch changes up to f741db1a5171ebb93289258e64e69c2a780e3103:

  net/mlx5e: kTLS, Improve connection rate by using fast update encryption key (2023-01-30 19:10:06 -0800)

----------------------------------------------------------------
mlx5-updates-2023-01-30

Add fast update encryption key

Jianbo Liu Says:
================

Data encryption keys (DEKs) are the keys used for data encryption and
decryption operations. Starting from version 22.33.0783, firmware is
optimized to accelerate the update of user keys into DEK object in
hardware. The support for bulk allocation and destruction of DEK
objects is added, and the bulk allocated DEKs are uninitialized, as
the bulk creation requires no input key. When offload
encryption/decryption, user gets one object from a bulk, and updates
key by a new "modify DEK" command. This command is the same as create
DEK object, but requires no heavy context memory allocation in
firmware, which consumes most cpu cycles of the create DEK command.

DEKs are cached internally by the NIC, so invalidating internal NIC
caches is required before reusing DEKs. The SYNC_CRYPTO command is
added to support it. DEK object can be reused, the keys in it can be
updated after this command is executed.

This patchset enhances the key creation and destruction flow, to get
use of this new feature. Any user, for example, ktls, ipsec and
macsec, can use it to offload keys. But, only ktls uses it, as others
don't need many keys, and caching two many DEKs in pool is wasteful.

There are two new data struts added:
    a. DEK pool. One pool is created for each key type. The bulks by
the type, are placed in the pool's different bulk lists, according to
the number of available and in_used DEKs in the bulk.
    b. DEK bulk. All DEKs in one bulk allocation are store here. There
are two bitmaps to indicate the state of each DEK.

New APIs are then added. When user need a DEK object,
    a. Fetch one bulk with avail DEKs, from the partial_list or
avail_list, otherwise create new one.
    b. Pick one DEK, and set its need_sync and in_used bits to 1.
Move the bulk to full_list if no more available keys, or put it to
partial_list if the bulk is newly created.
    c. Update DEK object's key with user key, by the "modify DEK"
command.
    d. Return DEK struct to user, then it gets the object id and fills
it into the offload commands.
When user free a DEK,
    a. Set in_use bit to 0. If all need_sync bits are 1 and all in_use
bits of this bulk are 0, move it to sync_list.
    b. If the number of DEKs, which are freed by users, is over the
threshold (128), schedule a workqueue to do the sync process.

For the sync process, the SYNC_CRYPTO command is executed first. Then,
for each bulks in partial_list, full_list and sync_list, reset
need_sync bits of the freed DEK objects. If all need_sync bits in one
bulk are zero, move it to avail_list.

We already supported TIS pool to recycle the TISes. With this series
and TIS pool, TLS CPS performance is improved greatly.
And we tested https on the system:
    CPU: dual AMD EPYC 7763 64-Core processors
    RAM: 512G
    DEV: ConnectX-6 DX, with FW ver 22.33.0838 and TLS_OPTIMISE=true
TLS CPS performance numbers are:
    Before: 11k connections/sec
    After: 101 connections/sec

================

----------------------------------------------------------------
Jianbo Liu (14):
      net/mlx5: Add IFC bits for general obj create param
      net/mlx5: Add IFC bits and enums for crypto key
      net/mlx5: Change key type to key purpose
      net/mlx5: Prepare for fast crypto key update if hardware supports it
      net/mlx5: Add const to the key pointer of encryption key creation
      net/mlx5: Refactor the encryption key creation
      net/mlx5: Add new APIs for fast update encryption key
      net/mlx5: Add support SYNC_CRYPTO command
      net/mlx5: Add bulk allocation and modify_dek operation
      net/mlx5: Use bulk allocation for fast update encryption key
      net/mlx5: Reuse DEKs after executing SYNC_CRYPTO command
      net/mlx5: Add async garbage collector for DEK bulk
      net/mlx5: Keep only one bulk of full available DEKs
      net/mlx5e: kTLS, Improve connection rate by using fast update encryption key

Tariq Toukan (1):
      net/mlx5: Header file for crypto

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   3 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |   6 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |  29 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |  11 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  21 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  17 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  10 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |   6 +
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   | 755 ++++++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.h   |  34 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  12 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   1 +
 include/linux/mlx5/device.h                        |   4 +
 include/linux/mlx5/driver.h                        |   2 +
 include/linux/mlx5/mlx5_ifc.h                      | 163 ++++-
 17 files changed, 992 insertions(+), 86 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
