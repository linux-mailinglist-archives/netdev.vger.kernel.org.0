Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789CA264972
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 18:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgIJQNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 12:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgIJQLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 12:11:35 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14FF3C061757;
        Thu, 10 Sep 2020 09:11:33 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id n13so6840268edo.10;
        Thu, 10 Sep 2020 09:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YxVn4Zbme0obY4xg7KEutnAEvJ86ItKrhQOb0G4NIT0=;
        b=PXNIrZm4N4a9wacThF0t8skTVZkBcy//jIg99gs5FlLylbGtIxtmGHee7gkUuyonwh
         rDt9yf6zjELtKDAgRzCFOAPUmlR7BrI3E/vYHO1M82lxfKbGW+ay0CxodxILA7kFexGQ
         i9W2jUUUdO8AvogeD1qK0C1Dgw/u0TVFAwwPW3q8XeY4w6x9iEGE9C2WmZPjJum5UF++
         GO1Xsnj9ZTI9RtxLPimMi0lRE3rsXkTGGfiIMqs8R+AVUyi5n+zSyN0rSBglpa77Lz12
         OTFdKPdTQH+EiFNnZvxrP2v5RnJ/IXQK8YNjV89YmE6JJtmtbASZWm7MYdYVGiPTmhbf
         QaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YxVn4Zbme0obY4xg7KEutnAEvJ86ItKrhQOb0G4NIT0=;
        b=tkPqVZ5pNCCMu/un25ZyinvfDXjjio4tsvQIqAYXpqCsb19vpJ54DqXqcz8fOBgwo8
         qs96lUnZVBgQMEqFT6kijz/UUiKl1gDNfMYHakdU3Iad4B2RL193VftVgebEFsgJ/Z5y
         tOntulILXNVbIvu3TCHhot1zM4+YWn1xxC5mDfd2fVdqCtit0C2xsdcAT4uWtSBFPSy7
         lHcASJiPeeT7lHnzO6K/9WYy9xyf0zDIQMpM75aRwBNJmoQ4e9msJUXsHf8P/ojYq9pf
         JgBbQjWPFxrGOyCubtQFnbbqPdz2FcF3yQoQjY4uG049mBMgxTB1MkVuRNX9Hew0n98l
         fZnw==
X-Gm-Message-State: AOAM532sceo/0JY8wmn7+fT3bK0qKTIn+VDPxf524+YPPcPDa083YUkB
        VeMw8QKLSVwDdo3ywd9Yn1q6d1l5grE=
X-Google-Smtp-Source: ABdhPJytt1pyCAzdvEg6IQfDRSf25DP0w7m3e7RnygYQeTF1lSbbh5GTtg3q8WHvXgTVda6eQ9zvjQ==
X-Received: by 2002:a05:6402:44e:: with SMTP id p14mr10319607edw.1.1599754290148;
        Thu, 10 Sep 2020 09:11:30 -0700 (PDT)
Received: from ogabbay-VM.habana-labs.com ([213.57.90.10])
        by smtp.gmail.com with ESMTPSA id k8sm7282911ejz.60.2020.09.10.09.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 09:11:28 -0700 (PDT)
From:   Oded Gabbay <oded.gabbay@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org
Subject: [PATCH 00/15] Adding GAUDI NIC code to habanalabs driver
Date:   Thu, 10 Sep 2020 19:11:11 +0300
Message-Id: <20200910161126.30948-1-oded.gabbay@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch-set adds support for initializing and using the GAUDI NIC ports,
functioning as scale-out interconnect when doing distributed Deep Learning
training. The training can be performed over tens of thousands of GAUDIs
and it is done using the RDMA-over-converged-Ethernet (RoCE) v2 protocol.

Each GAUDI exposes 10x100GbE ports that are designed to scale-out the
inter-GAUDI communication by integrating a complete communication engine
on-die. This native integration allows users to use the same scaling
technology, both inside the server and rack (termed as scale-up), as well
as for scaling across racks (scale-out). The racks can be connected
directly between GAUDI processors, or through any number of standard
Ethernet switches.

The driver exposes the NIC ports to the user as standard Ethernet ports by
registering each port to the networking subsystem. This allows the user to
manage the ports with standard tools such as ifconfig, ethtool, etc. It
also enables us to connect to the Linux networking stack and thus support
standard networking protocols, such as IPv4, IPv6, TCP, etc. In addition,
we can also leverage protocols such as DCB for dynamically configuring
priorities to avoid congestion.

For each NIC port there is a matching QMAN entity. For RoCE, the user
submits workloads to the NIC through the QMAN, same as he does for the
compute engines. For regular Ethernet, the user sends and receives packets
through the standard Ethernet sockets. Those sockets are used only as a
control path. The data path that is used for AI training goes through the
RoCE interface.

It is important to note that there are some limitations and uniqueness
in GAUDI's NIC H/W, compared to other networking adapters that enforced us
to use a less-than-common driver design:

1. The NIC functionality is NOT exposed as different PCI Physical
   Functions. There is a single PF which is used for compute and
   networking, as the main goal of the NIC ports is to be used as
   intra-communication and not as standard network interfaces. This
   implies we can't connect different drivers to handle the networking
   ports because it is the same device, from the kernel POV, as the
   compute. Therefore, we must integrate the networking code into the
   main habanalabs driver.

2. Although our communication engine implements RDMA, and the driver code
   uses well-known RDMA concepts such as QP context, CQ, WQ, etc., the
   GAUDI architecture does NOT support other basic IBverbs concepts, such
   as MR and protection domain. Therefore, we can't connect to the standard
   IBverb infrastructure in the user-space and kernel (rdma-core library
   and infiniband subsystem, respectively) because the standard RDMA s/w
   and tools won't work on our H/W. Instead, we added a new IOCTL to the
   driver's existing IOCTL API. The new IOCTL exposes the available
   NIC control operations to the user (e.g. Create a QP context).

3. The die-on communication engine provides minimal offloading for standard
   Ethernet and TCP/IP protocols, as those are only used for control plane.
   E.g. the packets are copied rather than using descriptors.
   Therefore, the Ethernet performance is quite low compared to standard
   Ethernet adapters.

4. There is no virtualization support per port.

Most or all of the above limitations will hopefully be improved in future
ASIC generations.

Patch-set organization:

- Patches 1 & 2 are just adding some auto-generated register header files
  and NIC-related definitions to the interface between the driver and the
  GAUDI firmware. 

- Patch 3 adds initialization of security restrictions on the NIC engines.

- Patch 4 adds initialization of the NIC QMANs. The QMANs are needed to
  send RDMA packets through the NIC engines.

- Patches 5-11 adds the NIC driver code. It contains the basic Ethernet
  driver and H/W initialization, the NIC PHY driver code and the new NIC
  control IOCTL operations.

- Patch 12-14 adds support for debugfs, ethtool and DCB.

- Patch 15 adds the implementation of the high-level init/fini functions
  and their calls from the common code. This is the patch that actually
  enables the NIC ports and allows the user to work with them.

Thanks,
Oded


Omer Shpigelman (15):
  habanalabs/gaudi: add NIC H/W and registers definitions
  habanalabs/gaudi: add NIC firmware-related definitions
  habanalabs/gaudi: add NIC security configuration
  habanalabs/gaudi: add support for NIC QMANs
  habanalabs/gaudi: add NIC Ethernet support
  habanalabs/gaudi: add NIC PHY code
  habanalabs/gaudi: allow user to get MAC addresses in INFO IOCTL
  habanalabs/gaudi: add a new IOCTL for NIC control operations
  habanalabs/gaudi: add CQ control operations
  habanalabs/gaudi: add WQ control operations
  habanalabs/gaudi: add QP error handling
  habanalabs/gaudi: add debugfs entries for the NIC
  habanalabs/gaudi: Add ethtool support using coresight
  habanalabs/gaudi: support DCB protocol
  habanalabs/gaudi: add NIC init/fini calls from common code

 .../ABI/testing/debugfs-driver-habanalabs     |   69 +
 drivers/misc/habanalabs/common/context.c      |    1 +
 drivers/misc/habanalabs/common/device.c       |   24 +-
 drivers/misc/habanalabs/common/firmware_if.c  |   44 +
 drivers/misc/habanalabs/common/habanalabs.h   |   33 +-
 .../misc/habanalabs/common/habanalabs_drv.c   |   11 +
 .../misc/habanalabs/common/habanalabs_ioctl.c |  151 +-
 drivers/misc/habanalabs/common/pci.c          |    1 +
 drivers/misc/habanalabs/gaudi/Makefile        |    4 +
 drivers/misc/habanalabs/gaudi/gaudi.c         |  958 +++-
 drivers/misc/habanalabs/gaudi/gaudiP.h        |  333 +-
 .../misc/habanalabs/gaudi/gaudi_coresight.c   |  144 +
 drivers/misc/habanalabs/gaudi/gaudi_nic.c     | 4063 +++++++++++++++++
 drivers/misc/habanalabs/gaudi/gaudi_nic.h     |  354 ++
 .../misc/habanalabs/gaudi/gaudi_nic_dcbnl.c   |  108 +
 .../misc/habanalabs/gaudi/gaudi_nic_debugfs.c |  402 ++
 .../misc/habanalabs/gaudi/gaudi_nic_ethtool.c |  582 +++
 drivers/misc/habanalabs/gaudi/gaudi_phy.c     | 1272 ++++++
 .../misc/habanalabs/gaudi/gaudi_security.c    | 3973 ++++++++++++++++
 drivers/misc/habanalabs/goya/goya.c           |   44 +
 .../misc/habanalabs/include/common/cpucp_if.h |   34 +-
 .../include/gaudi/asic_reg/gaudi_regs.h       |   26 +-
 .../include/gaudi/asic_reg/nic0_qm0_masks.h   |  800 ++++
 .../include/gaudi/asic_reg/nic0_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic0_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic0_qpc0_masks.h  |  500 ++
 .../include/gaudi/asic_reg/nic0_qpc0_regs.h   |  710 +++
 .../include/gaudi/asic_reg/nic0_qpc1_regs.h   |  710 +++
 .../include/gaudi/asic_reg/nic0_rxb_regs.h    |  508 +++
 .../include/gaudi/asic_reg/nic0_rxe0_masks.h  |  354 ++
 .../include/gaudi/asic_reg/nic0_rxe0_regs.h   |  158 +
 .../include/gaudi/asic_reg/nic0_rxe1_regs.h   |  158 +
 .../include/gaudi/asic_reg/nic0_stat_regs.h   |  518 +++
 .../include/gaudi/asic_reg/nic0_tmr_regs.h    |  184 +
 .../include/gaudi/asic_reg/nic0_txe0_masks.h  |  336 ++
 .../include/gaudi/asic_reg/nic0_txe0_regs.h   |  264 ++
 .../include/gaudi/asic_reg/nic0_txe1_regs.h   |  264 ++
 .../include/gaudi/asic_reg/nic0_txs0_masks.h  |  336 ++
 .../include/gaudi/asic_reg/nic0_txs0_regs.h   |  214 +
 .../include/gaudi/asic_reg/nic0_txs1_regs.h   |  214 +
 .../include/gaudi/asic_reg/nic1_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic1_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic2_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic2_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic3_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic3_qm1_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic4_qm0_regs.h    |  834 ++++
 .../include/gaudi/asic_reg/nic4_qm1_regs.h    |  834 ++++
 drivers/misc/habanalabs/include/gaudi/gaudi.h |   12 +
 .../habanalabs/include/gaudi/gaudi_fw_if.h    |   24 +
 .../habanalabs/include/gaudi/gaudi_masks.h    |   15 +
 .../include/hw_ip/nic/nic_general.h           |   13 +
 include/uapi/misc/habanalabs.h                |  296 +-
 53 files changed, 27497 insertions(+), 62 deletions(-)
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic.h
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_dcbnl.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_debugfs.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_nic_ethtool.c
 create mode 100644 drivers/misc/habanalabs/gaudi/gaudi_phy.c
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_qpc1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxb_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_rxe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_stat_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_tmr_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txe1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_masks.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic0_txs1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic1_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic2_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic3_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm0_regs.h
 create mode 100644 drivers/misc/habanalabs/include/gaudi/asic_reg/nic4_qm1_regs.h
 create mode 100644 drivers/misc/habanalabs/include/hw_ip/nic/nic_general.h

-- 
2.17.1

