Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FCF54D7F4
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348385AbiFPCHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347776AbiFPCHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:07:37 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00A031C0;
        Wed, 15 Jun 2022 19:07:27 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 8D99820C3274; Wed, 15 Jun 2022 19:07:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8D99820C3274
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655345247;
        bh=uDiFCpUJB7ov/Y1grAR0LzvmAxSNvBtHZIJICK5io/0=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=AaxrItD6UUMwgAmNsmiiM8etgqWtdoZU25qJMRkPwdiQY7XQmvoDYpVbs3PfxOI6a
         OyTnFYRiIfQv0HPc7Z9kPonlQrsuhuqI7xNtbbAPPP6Iku8xzCNUqevReVoRFhmMuL
         5jxHUDAdpZrS67kWYwbhNA2ok9Mqr26z0Ux1MeyU=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v4 00/12] Introduce Microsoft Azure Network Adapter (MANA) RDMA driver
Date:   Wed, 15 Jun 2022 19:07:08 -0700
Message-Id: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

This patchset implements a RDMA driver for Microsoft Azure Network
Adapter (MANA). In MANA, the RDMA device is modeled as an auxiliary device
to the Ethernet device.

The first 11 patches modify the MANA Ethernet driver to support RDMA driver.
The last patch implementes the RDMA driver.

The user-mode of the driver is being reviewed at:
https://github.com/linux-rdma/rdma-core/pull/1177


Ajay Sharma (3):
  net: mana: Set the DMA device max segment size
  net: mana: Define data structures for protection domain and memory
    registration
  net: mana: Define and process GDMA response code
    GDMA_STATUS_MORE_ENTRIES

Long Li (9):
  net: mana: Add support for auxiliary device
  net: mana: Record the physical address for doorbell page region
  net: mana: Handle vport sharing between devices
  net: mana: Add functions for allocating doorbell page from GDMA
  net: mana: Export Work Queue functions for use by RDMA driver
  net: mana: Record port number in netdev
  net: mana: Move header files to a common location
  net: mana: Define max values for SGL entries
  RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter

 MAINTAINERS                                   |   4 +
 drivers/infiniband/Kconfig                    |   1 +
 drivers/infiniband/hw/Makefile                |   1 +
 drivers/infiniband/hw/mana/Kconfig            |   7 +
 drivers/infiniband/hw/mana/Makefile           |   4 +
 drivers/infiniband/hw/mana/cq.c               |  80 ++
 drivers/infiniband/hw/mana/main.c             | 681 ++++++++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h          | 145 ++++
 drivers/infiniband/hw/mana/mr.c               | 133 ++++
 drivers/infiniband/hw/mana/qp.c               | 501 +++++++++++++
 drivers/infiniband/hw/mana/wq.c               | 114 +++
 .../net/ethernet/microsoft/mana/gdma_main.c   |  96 ++-
 .../net/ethernet/microsoft/mana/hw_channel.c  |   6 +-
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 162 ++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |   2 +-
 .../net/ethernet/microsoft/mana/shm_channel.c |   2 +-
 .../microsoft => include/net}/mana/gdma.h     | 188 ++++-
 .../net}/mana/hw_channel.h                    |   0
 .../microsoft => include/net}/mana/mana.h     |  29 +-
 .../net}/mana/shm_channel.h                   |   0
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 include/uapi/rdma/mana-abi.h                  |  66 ++
 23 files changed, 2180 insertions(+), 45 deletions(-)
 create mode 100644 drivers/infiniband/hw/mana/Kconfig
 create mode 100644 drivers/infiniband/hw/mana/Makefile
 create mode 100644 drivers/infiniband/hw/mana/cq.c
 create mode 100644 drivers/infiniband/hw/mana/main.c
 create mode 100644 drivers/infiniband/hw/mana/mana_ib.h
 create mode 100644 drivers/infiniband/hw/mana/mr.c
 create mode 100644 drivers/infiniband/hw/mana/qp.c
 create mode 100644 drivers/infiniband/hw/mana/wq.c
 rename {drivers/net/ethernet/microsoft => include/net}/mana/gdma.h (77%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/hw_channel.h (100%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/mana.h (93%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/shm_channel.h (100%)
 create mode 100644 include/uapi/rdma/mana-abi.h

-- 
2.17.1

