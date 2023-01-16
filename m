Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A3166BEA8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbjAPNG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbjAPNGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:06:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 819283ABB;
        Mon, 16 Jan 2023 05:06:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 320BBB80E37;
        Mon, 16 Jan 2023 13:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9ECC433EF;
        Mon, 16 Jan 2023 13:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673874365;
        bh=rNdp8EhsRlR5Ld3e2m1Ss4Ma8PuD1081i4b85L/XLws=;
        h=From:To:Cc:Subject:Date:From;
        b=IEbq92PfyqWg1QDwxKyyWT4dZQl4cCMHxgcSytzpU6C+EQ8kHuwbL/i4b4s4lSHe9
         6AWMyv617QjAgpBTPasIqxYjGgeR9wh0T5T3rerp3l4jTTm8vgaIT8iznUz38gMp9j
         ifQqOFD4SdOOTenk2PqaNWRPr6HRr6t9scWWpkCFDaA/vIH11jBcQPDGoKFY3dQTOy
         L+2Ok+ApFxP6iVtXTZcfVNYq+DWhcWBN9fHzlLD79cN3fGbOFxslD8InNf+KGMTKgU
         2BqHGnr9Z1r1MmJyR4JIH8tWicS/dLAKXcPBA2SykiC/XFWCR0jjNiqHAGDKTHfJq1
         9Ggv8K4bc352Q==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bryan Tan <bryantan@vmware.com>, Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Date:   Mon, 16 Jan 2023 15:05:47 +0200
Message-Id: <cover.1673873422.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From Israel,

The purpose of this patchset is to add support for inline
encryption/decryption of the data at storage protocols like nvmf over
RDMA (at a similar way like integrity is used via unique mkey).

This patchset adds support for plaintext keys. The patches were tested
on BF-3 HW with fscrypt tool to test this feature, which showed reduce
in CPU utilization when comparing at 64k or more IO size. The CPU utilization
was improved by more than 50% comparing to the SW only solution at this case.

How to configure fscrypt to enable plaintext keys:
 # mkfs.ext4 -O encrypt /dev/nvme0n1
 # mount /dev/nvme0n1 /mnt/crypto -o inlinecrypt
 # head -c 64 /dev/urandom > /tmp/master_key
 # fscryptctl add_key /mnt/crypto/ < /tmp/master_key
 # mkdir /mnt/crypto/test1
 # fscryptctl set_policy 152c41b2ea39fa3d90ea06448456e7fb /mnt/crypto/test1
   ** “152c41b2ea39fa3d90ea06448456e7fb” is the output of the
      “fscryptctl add_key” command.
 # echo foo > /mnt/crypto/test1/foo

Notes:
 - At plaintext mode only, the user set a master key and the fscrypt
   driver derived from it the DEK and the key identifier.
 - 152c41b2ea39fa3d90ea06448456e7fb is the derived key identifier
 - Only on the first IO, nvme-rdma gets a callback to load the derived DEK. 

There is no special configuration to support crypto at nvme modules.

Thanks

Israel Rukshin (13):
  net/mlx5: Introduce crypto IFC bits and structures
  net/mlx5: Introduce crypto capabilities macro
  RDMA: Split kernel-only create QP flags from uverbs create QP flags
  RDMA/core: Add cryptographic device capabilities
  RDMA/core: Add DEK management API
  RDMA/core: Introduce MR type for crypto operations
  RDMA/core: Add support for creating crypto enabled QPs
  RDMA/mlx5: Add cryptographic device capabilities
  RDMA/mlx5: Add DEK management API
  RDMA/mlx5: Add AES-XTS crypto support
  nvme: Introduce a local variable
  nvme: Add crypto profile at nvme controller
  nvme-rdma: Add inline encryption support

 drivers/infiniband/core/device.c              |   3 +
 drivers/infiniband/core/mr_pool.c             |   2 +
 drivers/infiniband/core/uverbs_std_types_qp.c |  12 +-
 drivers/infiniband/core/verbs.c               |  91 ++++++-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h          |   4 +-
 drivers/infiniband/hw/mlx4/qp.c               |   4 +-
 drivers/infiniband/hw/mlx5/Makefile           |   1 +
 drivers/infiniband/hw/mlx5/crypto.c           | 115 +++++++++
 drivers/infiniband/hw/mlx5/crypto.h           |  46 ++++
 drivers/infiniband/hw/mlx5/main.c             |   5 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   5 +-
 drivers/infiniband/hw/mlx5/mr.c               |  33 +++
 drivers/infiniband/hw/mlx5/qp.c               |  15 +-
 drivers/infiniband/hw/mlx5/wr.c               | 164 +++++++++++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |   6 +
 .../net/ethernet/mellanox/mlx5/core/main.c    |   1 +
 drivers/nvme/host/core.c                      |  10 +-
 drivers/nvme/host/nvme.h                      |   4 +
 drivers/nvme/host/rdma.c                      | 236 +++++++++++++++++-
 include/linux/mlx5/device.h                   |   4 +
 include/linux/mlx5/mlx5_ifc.h                 |  36 ++-
 include/rdma/crypto.h                         | 118 +++++++++
 include/rdma/ib_verbs.h                       |  46 +++-
 include/trace/events/rdma_core.h              |  33 +++
 26 files changed, 954 insertions(+), 44 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/crypto.c
 create mode 100644 drivers/infiniband/hw/mlx5/crypto.h
 create mode 100644 include/rdma/crypto.h

-- 
2.39.0

