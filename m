Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B71D3707F2
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 18:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhEAQr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 May 2021 12:47:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:41948 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230195AbhEAQry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 May 2021 12:47:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E6EC2AF4E;
        Sat,  1 May 2021 16:47:03 +0000 (UTC)
Subject: Re: [RFC PATCH v4 00/27] NVMeTCP Offload ULP and QEDN Device Driver
To:     Shai Malin <smalin@marvell.com>, netdev@vger.kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org
Cc:     "David S . Miller davem @ davemloft . net --cc=Jakub Kicinski" 
        <kuba@kernel.org>, aelior@marvell.com, mkalderon@marvell.com,
        okulkarni@marvell.com, pkushwaha@marvell.com, malin1024@gmail.com
References: <20210429190926.5086-1-smalin@marvell.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <abf99c45-c896-b135-56c5-601e7e6ffa61@suse.de>
Date:   Sat, 1 May 2021 18:47:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210429190926.5086-1-smalin@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/21 9:08 PM, Shai Malin wrote:
> With the goal of enabling a generic infrastructure that allows NVMe/TCP
> offload devices like NICs to seamlessly plug into the NVMe-oF stack, this
> patch series introduces the nvme-tcp-offload ULP host layer, which will
> be a new transport type called "tcp-offload" and will serve as an
> abstraction layer to work with vendor specific nvme-tcp offload drivers.
> 
> NVMeTCP offload is a full offload of the NVMeTCP protocol, this includes
> both the TCP level and the NVMeTCP level.
> 
> The nvme-tcp-offload transport can co-exist with the existing tcp and
> other transports. The tcp offload was designed so that stack changes are
> kept to a bare minimum: only registering new transports.
> All other APIs, ops etc. are identical to the regular tcp transport.
> Representing the TCP offload as a new transport allows clear and manageable
> differentiation between the connections which should use the offload path
> and those that are not offloaded (even on the same device).
> 
> 
> The nvme-tcp-offload layers and API compared to nvme-tcp and nvme-rdma:
> 
> * NVMe layer: *
> 
>         [ nvme/nvme-fabrics/blk-mq ]
>               |
>          (nvme API and blk-mq API)
>               |
>               |			
> * Vendor agnostic transport layer: *
> 
>        [ nvme-rdma ] [ nvme-tcp ] [ nvme-tcp-offload ]
>               |        |             |
>             (Verbs)
>               |        |             |
>               |     (Socket)
>               |        |             |
>               |        |        (nvme-tcp-offload API)
>               |        |             |
>               |        |             |
> * Vendor Specific Driver: *
> 
>               |        |             |
>             [ qedr ]
>                        |             |
>                     [ qede ]
>                                      |
>                                    [ qedn ]
> 
> 
> Performance:
> ============
> With this implementation on top of the Marvell qedn driver (using the
> Marvell FastLinQ NIC), we were able to demonstrate the following CPU
> utilization improvement:
> 
> On AMD EPYC 7402, 2.80GHz, 28 cores:
> - For 16K queued read IOs, 16jobs, 4qd (50Gbps line rate):
>    Improved the CPU utilization from 15.1% with NVMeTCP SW to 4.7% with
>    NVMeTCP offload.
> 
> On Intel(R) Xeon(R) Gold 5122 CPU, 3.60GHz, 16 cores:
> - For 512K queued read IOs, 16jobs, 4qd (25Gbps line rate):
>    Improved the CPU utilization from 16.3% with NVMeTCP SW to 1.1% with
>    NVMeTCP offload.
> 
> In addition, we were able to demonstrate the following latency improvement:
> - For 200K read IOPS (16 jobs, 16 qd, with fio rate limiter):
>    Improved the average latency from 105 usec with NVMeTCP SW to 39 usec
>    with NVMeTCP offload.
>    
>    Improved the 99.99 tail latency from 570 usec with NVMeTCP SW to 91 usec
>    with NVMeTCP offload.
> 
> The end-to-end offload latency was measured from fio while running against
> back end of null device.
> 
> 
> Upstream plan:
> ==============
> Following this RFC, the series will be sent in a modular way so that changes
> in each part will not impact the previous part.
> 
> - Part 1 (Patches 1-7):
>    The qed infrastructure, will be sent to 'netdev@vger.kernel.org'.
> 
> - Part 2 (Patch 8-15):
>    The nvme-tcp-offload patches, will be sent to
>    'linux-nvme@lists.infradead.org'.
> 
> - Part 3 (Packet 16-27):
>    The qedn patches, will be sent to 'linux-nvme@lists.infradead.org'.
>   
> 
> Queue Initialization Design:
> ============================
> The nvme-tcp-offload ULP module shall register with the existing
> nvmf_transport_ops (.name = "tcp_offload"), nvme_ctrl_ops and blk_mq_ops.
> The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> with the following ops:
> - claim_dev() - in order to resolve the route to the target according to
>                  the paired net_dev.
> - create_queue() - in order to create offloaded nvme-tcp queue.
> 
> The nvme-tcp-offload ULP module shall manage all the controller level
> functionalities, call claim_dev and based on the return values shall call
> the relevant module create_queue in order to create the admin queue and
> the IO queues.
> 
> 
> IO-path Design:
> ===============
> The nvme-tcp-offload shall work at the IO-level - the nvme-tcp-offload
> ULP module shall pass the request (the IO) to the nvme-tcp-offload vendor
> driver and later, the nvme-tcp-offload vendor driver returns the request
> completion (the IO completion).
> No additional handling is needed in between; this design will reduce the
> CPU utilization as we will describe below.
> 
> The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> with the following IO-path ops:
> - init_req()
> - send_req() - in order to pass the request to the handling of the
>                 offload driver that shall pass it to the vendor specific device.
> - poll_queue()
> 
> Once the IO completes, the nvme-tcp-offload vendor driver shall call
> command.done() that will invoke the nvme-tcp-offload ULP layer to
> complete the request.
> 
> 
> TCP events:
> ===========
> The Marvell FastLinQ NIC HW engine handle all the TCP re-transmissions
> and OOO events.
> 
> 
> Teardown and errors:
> ====================
> In case of NVMeTCP queue error the nvme-tcp-offload vendor driver shall
> call the nvme_tcp_ofld_report_queue_err.
> The nvme-tcp-offload vendor driver shall register to nvme-tcp-offload ULP
> with the following teardown ops:
> - drain_queue()
> - destroy_queue()
> 
> 
> The Marvell FastLinQ NIC HW engine:
> ====================================
> The Marvell NIC HW engine is capable of offloading the entire TCP/IP
> stack and managing up to 64K connections per PF, already implemented and
> upstream use cases for this include iWARP (by the Marvell qedr driver)
> and iSCSI (by the Marvell qedi driver).
> In addition, the Marvell NIC HW engine offloads the NVMeTCP queue layer
> and is able to manage the IO level also in case of TCP re-transmissions
> and OOO events.
> The HW engine enables direct data placement (including the data digest CRC
> calculation and validation) and direct data transmission (including data
> digest CRC calculation).
> 
> 
> The Marvell qedn driver:
> ========================
> The new driver will be added under "drivers/nvme/hw" and will be enabled
> by the Kconfig "Marvell NVM Express over Fabrics TCP offload".
> As part of the qedn init, the driver will register as a pci device driver
> and will work with the Marvell fastlinQ NIC.
> As part of the probe, the driver will register to the nvme_tcp_offload
> (ULP) and to the qed module (qed_nvmetcp_ops) - similar to other
> "qed_*_ops" which are used by the qede, qedr, qedf and qedi device
> drivers.
>    
> 
> QEDN Future work:
> =================
> - Support extended HW resources.
> - Digest support.
> - Devlink support for device configuration and TCP offload configurations.
> - Statistics
> 
>   
> Long term future work:
> ======================
> - The nvme-tcp-offload ULP target abstraction layer.
> - The Marvell nvme-tcp-offload "qednt" target driver.
> 
> 
> Changes since RFC v1:
> =====================
> - Fix nvme_tcp_ofld_ops return values.
> - Remove NVMF_TRTYPE_TCP_OFFLOAD.
> - Add nvme_tcp_ofld_poll() implementation.
> - Fix nvme_tcp_ofld_queue_rq() to check map_sg() and send_req() return
>    values.
> 
> Changes since RFC v2:
> =====================
> - Add qedn - Marvell's NVMeTCP HW offload vendor driver init and probe
>    (patches 8-11).
> - Fixes in controller and queue level (patches 3-6).
>    
> Changes since RFC v3:
> =====================
> - Add the full implementation of the nvme-tcp-offload layer including the
>    new ops: setup_ctrl(), release_ctrl(), commit_rqs() and new flows (ASYNC
>    and timeout).
> - Add nvme-tcp-offload device maximums: max_hw_sectors, max_segments.
> - Add nvme-tcp-offload layer design and optimization changes.
> - Add the qedn full implementation for the conn level, IO path and error
>    handling.
> - Add qed support for the new AHP HW.
> 
> 
> Arie Gershberg (3):
>    nvme-fabrics: Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS
>      definitions
>    nvme-tcp-offload: Add controller level implementation
>    nvme-tcp-offload: Add controller level error recovery implementation
> 
> Dean Balandin (3):
>    nvme-tcp-offload: Add device scan implementation
>    nvme-tcp-offload: Add queue level implementation
>    nvme-tcp-offload: Add IO level implementation
> 
> Nikolay Assa (2):
>    qed: Add IP services APIs support
>    qedn: Add qedn_claim_dev API support
> 
> Omkar Kulkarni (1):
>    qed: Add qed-NVMeTCP personality
> 
> Prabhakar Kushwaha (6):
>    qed: Add support of HW filter block
>    qedn: Add connection-level slowpath functionality
>    qedn: Add support of configuring HW filter block
>    qedn: Add support of Task and SGL
>    qedn: Add support of NVME ICReq & ICResp
>    qedn: Add support of ASYNC
> 
> Shai Malin (12):
>    qed: Add NVMeTCP Offload PF Level FW and HW HSI
>    qed: Add NVMeTCP Offload Connection Level FW and HW HSI
>    qed: Add NVMeTCP Offload IO Level FW and HW HSI
>    qed: Add NVMeTCP Offload IO Level FW Initializations
>    nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP
>    nvme-tcp-offload: Add Timeout and ASYNC Support
>    qedn: Add qedn - Marvell's NVMeTCP HW offload vendor driver
>    qedn: Add qedn probe
>    qedn: Add IRQ and fast-path resources initializations
>    qedn: Add IO level nvme_req and fw_cq workqueues
>    qedn: Add IO level fastpath functionality
>    qedn: Add Connection and IO level recovery flows
> 
>   MAINTAINERS                                   |   10 +
>   drivers/net/ethernet/qlogic/Kconfig           |    3 +
>   drivers/net/ethernet/qlogic/qed/Makefile      |    5 +
>   drivers/net/ethernet/qlogic/qed/qed.h         |   16 +
>   drivers/net/ethernet/qlogic/qed/qed_cxt.c     |   32 +
>   drivers/net/ethernet/qlogic/qed/qed_cxt.h     |    1 +
>   drivers/net/ethernet/qlogic/qed/qed_dev.c     |  151 +-
>   drivers/net/ethernet/qlogic/qed/qed_hsi.h     |    4 +-
>   drivers/net/ethernet/qlogic/qed/qed_ll2.c     |   31 +-
>   drivers/net/ethernet/qlogic/qed/qed_mcp.c     |    3 +
>   drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c |    3 +-
>   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c |  868 +++++++++++
>   drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h |  114 ++
>   .../qlogic/qed/qed_nvmetcp_fw_funcs.c         |  372 +++++
>   .../qlogic/qed/qed_nvmetcp_fw_funcs.h         |   43 +
>   .../qlogic/qed/qed_nvmetcp_ip_services.c      |  239 +++
>   drivers/net/ethernet/qlogic/qed/qed_ooo.c     |    5 +-
>   drivers/net/ethernet/qlogic/qed/qed_sp.h      |    5 +
>   .../net/ethernet/qlogic/qed/qed_sp_commands.c |    1 +
>   drivers/nvme/Kconfig                          |    1 +
>   drivers/nvme/Makefile                         |    1 +
>   drivers/nvme/host/Kconfig                     |   16 +
>   drivers/nvme/host/Makefile                    |    3 +
>   drivers/nvme/host/fabrics.c                   |    7 -
>   drivers/nvme/host/fabrics.h                   |    7 +
>   drivers/nvme/host/tcp-offload.c               | 1330 +++++++++++++++++
>   drivers/nvme/host/tcp-offload.h               |  209 +++
>   drivers/nvme/hw/Kconfig                       |    9 +
>   drivers/nvme/hw/Makefile                      |    3 +
>   drivers/nvme/hw/qedn/Makefile                 |    4 +
>   drivers/nvme/hw/qedn/qedn.h                   |  435 ++++++
>   drivers/nvme/hw/qedn/qedn_conn.c              |  999 +++++++++++++
>   drivers/nvme/hw/qedn/qedn_main.c              | 1153 ++++++++++++++
>   drivers/nvme/hw/qedn/qedn_task.c              |  977 ++++++++++++
>   include/linux/qed/common_hsi.h                |    1 +
>   include/linux/qed/nvmetcp_common.h            |  616 ++++++++
>   include/linux/qed/qed_if.h                    |   22 +
>   include/linux/qed/qed_nvmetcp_if.h            |  244 +++
>   .../linux/qed/qed_nvmetcp_ip_services_if.h    |   29 +
>   39 files changed, 7947 insertions(+), 25 deletions(-)
>   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
>   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
>   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
>   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
>   create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
>   create mode 100644 drivers/nvme/host/tcp-offload.c
>   create mode 100644 drivers/nvme/host/tcp-offload.h
>   create mode 100644 drivers/nvme/hw/Kconfig
>   create mode 100644 drivers/nvme/hw/Makefile
>   create mode 100644 drivers/nvme/hw/qedn/Makefile
>   create mode 100644 drivers/nvme/hw/qedn/qedn.h
>   create mode 100644 drivers/nvme/hw/qedn/qedn_conn.c
>   create mode 100644 drivers/nvme/hw/qedn/qedn_main.c
>   create mode 100644 drivers/nvme/hw/qedn/qedn_task.c
>   create mode 100644 include/linux/qed/nvmetcp_common.h
>   create mode 100644 include/linux/qed/qed_nvmetcp_if.h
>   create mode 100644 include/linux/qed/qed_nvmetcp_ip_services_if.h
> 
I would structure this patchset slightly different, in putting the 
NVMe-oF implementation at the start of the patchset; this will be where 
you get most of the comment, and any change there will potentially 
reflect back on the driver implementation, too.

Something to consider for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
