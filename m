Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21211618868
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 20:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbiKCTQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 15:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiKCTQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 15:16:50 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DECFF1D306;
        Thu,  3 Nov 2022 12:16:48 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 9DBBE20B9F81; Thu,  3 Nov 2022 12:16:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9DBBE20B9F81
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1667503008;
        bh=kadn+aTf3nW20UCiL7FSGugZ1f36OZduTmq6RjMWCWQ=;
        h=From:To:Cc:Subject:Date:Reply-To:From;
        b=EPwRK0Eu0s1m8QfOiv2DXRMPZhHvxaaLj88sjHqt59UdZ5H7vMKf/MqKc1CvgcvLA
         5jIsw7cU+k7hI3HKH0nr7P/7ycaj6g/D800LCw9j7vsIaoz7e2zNCCPqTUjeJh7fTs
         tKKIlrnFi2COMblXApZYP4EARmd75etsD21y8lSU=
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
Subject: [Patch v10 00/12] Introduce Microsoft Azure Network Adapter (MANA) RDMA driver
Date:   Thu,  3 Nov 2022 12:16:18 -0700
Message-Id: <1667502990-2559-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
  net: mana: Define and process GDMA response code
    GDMA_STATUS_MORE_ENTRIES
  net: mana: Define data structures for protection domain and memory
    registration

Long Li (9):
  net: mana: Add support for auxiliary device
  net: mana: Record the physical address for doorbell page region
  net: mana: Handle vport sharing between devices
  net: mana: Export Work Queue functions for use by RDMA driver
  net: mana: Record port number in netdev
  net: mana: Move header files to a common location
  net: mana: Define max values for SGL entries
  net: mana: Define data structures for allocating doorbell page from
    GDMA
  RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter

 MAINTAINERS                                   |  10 +
 drivers/infiniband/Kconfig                    |   1 +
 drivers/infiniband/hw/Makefile                |   1 +
 drivers/infiniband/hw/mana/Kconfig            |  10 +
 drivers/infiniband/hw/mana/Makefile           |   4 +
 drivers/infiniband/hw/mana/cq.c               |  79 +++
 drivers/infiniband/hw/mana/device.c           | 117 ++++
 drivers/infiniband/hw/mana/main.c             | 521 ++++++++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h          | 162 ++++++
 drivers/infiniband/hw/mana/mr.c               | 197 +++++++
 drivers/infiniband/hw/mana/qp.c               | 506 +++++++++++++++++
 drivers/infiniband/hw/mana/wq.c               | 115 ++++
 drivers/net/ethernet/microsoft/Kconfig        |   1 +
 .../net/ethernet/microsoft/mana/gdma_main.c   |  40 +-
 .../net/ethernet/microsoft/mana/hw_channel.c  |   6 +-
 .../net/ethernet/microsoft/mana/mana_bpf.c    |   2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 175 +++++-
 .../ethernet/microsoft/mana/mana_ethtool.c    |   2 +-
 .../net/ethernet/microsoft/mana/shm_channel.c |   2 +-
 .../microsoft => include/net}/mana/gdma.h     | 158 +++++-
 .../net}/mana/hw_channel.h                    |   0
 .../microsoft => include/net}/mana/mana.h     |  23 +-
 include/net/mana/mana_auxiliary.h             |  10 +
 .../net}/mana/shm_channel.h                   |   0
 include/uapi/rdma/ib_user_ioctl_verbs.h       |   1 +
 include/uapi/rdma/mana-abi.h                  |  66 +++
 26 files changed, 2164 insertions(+), 45 deletions(-)
 create mode 100644 drivers/infiniband/hw/mana/Kconfig
 create mode 100644 drivers/infiniband/hw/mana/Makefile
 create mode 100644 drivers/infiniband/hw/mana/cq.c
 create mode 100644 drivers/infiniband/hw/mana/device.c
 create mode 100644 drivers/infiniband/hw/mana/main.c
 create mode 100644 drivers/infiniband/hw/mana/mana_ib.h
 create mode 100644 drivers/infiniband/hw/mana/mr.c
 create mode 100644 drivers/infiniband/hw/mana/qp.c
 create mode 100644 drivers/infiniband/hw/mana/wq.c
 rename {drivers/net/ethernet/microsoft => include/net}/mana/gdma.h (80%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/hw_channel.h (100%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/mana.h (95%)
 create mode 100644 include/net/mana/mana_auxiliary.h
 rename {drivers/net/ethernet/microsoft => include/net}/mana/shm_channel.h (100%)
 create mode 100644 include/uapi/rdma/mana-abi.h

-- 
2.17.1

