Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A403DF3A1
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 19:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbhHCRKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 13:10:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:16898 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237657AbhHCRKm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 13:10:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10065"; a="213466132"
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="213466132"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:16 -0700
X-IronPort-AV: E=Sophos;i="5.84,292,1620716400"; 
   d="scan'208";a="521327092"
Received: from shyamasr-mobl.amr.corp.intel.com ([10.209.65.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2021 10:10:15 -0700
From:   Kishen Maloor <kishen.maloor@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, hawk@kernel.org,
        magnus.karlsson@intel.com
Cc:     Kishen Maloor <kishen.maloor@intel.com>
Subject: [RFC bpf-next 0/5] SO_TXTIME support in AF_XDP
Date:   Tue,  3 Aug 2021 13:10:01 -0400
Message-Id: <20210803171006.13915-1-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background

This change adds kernel and userspace support for SO_TXTIME
in AF_XDP to include a specific TXTIME (aka "Launch Time")
with XDP frames issued from userspace XDP applications.

This feature may be used in conjunction with application-based traffic
shaping methods to delay less critical traffic and prioritize
latency sensitive packets to meet a desired QoS.

Implementation notes

The timestamp is stored in the XDP metadata area and passed down
to the NIC driver to configure the launch time.
The timestamp is internally conveyed to the sk_buff destined to generic 
mode NIC drivers. Alternatively, it may be read via a new Zero-Copy 
driver API.

The structure of XDP metadata that stores the TXTIME takes a form
(Shown below) that is aligned to ongoing work in the community
for describing XDP metadata using BTF:

struct xdp_user_tx_metadata {
        __u64 timestamp;
        __u32 md_valid;
        __u32 btf_id;
};

On the control path from userspace XDP applications, this change
repurposes the SO_TXTIME socket option to harness this 
feature, and adopts the above metadata struct for storing the TXTIME.

The (libbpf) userspace API has been expanded with two helper functons:

- int xsk_socket__enable_so_txtime(struct xsk_socket *xsk, bool enable)
   
   Sets the SO_TXTIME option on the AF_XDP socket (using setsockopt()).

- void xsk_umem__set_md_txtime(void *umem_area, __u64 chunkAddr,
                               __s64 txtime)
   
   Packages the application supplied TXTIME into the above md struct 
   and stores it in the XDP metadata area, which precedes the XDP frame.

In practice, a userspace XDP application must ensure the following:

* Store the XDP packet at the location following the XDP metadata area:
   uint8_t *pkt = xsk_umem__get_data(xsk.buffer, chunkAddr) +
                                     sizeof(struct xdp_user_tx_metadata);

* Correctly set the pkt addr in the TX descriptor:
   tx_desc->addr = chunkAddr + sizeof(struct xdp_user_tx_metadata);

* Signal the kernel that it included metadata by setting the TX 
  descriptor options:
   tx_desc->options = XDP_DESC_OPTION_METADATA;

In the NIC driver, a new XSK Zero-Copy Driver API:
s64 xsk_buff_get_txtime(struct xsk_buff_pool *pool, struct xdp_desc *desc)
is used to retrieve and consume a Launch Time provided by the userspace XDP
application.

Accompanying the kernel and userspace changes are the following updates:

* Launch Time support along the XDP ZC path in the IGC driver by exercising
  the new XSK ZC driver API.

* SO_TXTIME support in the xdpsock sample application to illustrate the
  userspace API.

Jithu Joseph (3):
  igc: Launchtime support in XDP Tx ZC path
  samples/bpf/xdpsock_user.c: Make get_nsecs() generic
  samples/bpf/xdpsock_user.c: Launchtime/TXTIME API usage

Kishen Maloor (2):
  net: xdp: SO_TXTIME support in AF_XDP
  libbpf: SO_TXTIME support in AF_XDP

 drivers/net/ethernet/intel/igc/igc_main.c | 49 ++++++++++++++-
 include/net/xdp_sock.h                    |  1 +
 include/net/xdp_sock_drv.h                | 10 +++
 include/net/xsk_buff_pool.h               |  1 +
 include/uapi/linux/if_xdp.h               |  2 +
 include/uapi/linux/xdp_md_std.h           | 14 +++++
 net/xdp/xsk.c                             | 51 +++++++++++++++-
 net/xdp/xsk.h                             |  2 +
 net/xdp/xsk_buff_pool.c                   | 23 +++++++
 net/xdp/xsk_queue.h                       |  4 +-
 samples/bpf/xdpsock_user.c                | 74 ++++++++++++++++++++---
 tools/include/uapi/linux/if_xdp.h         |  2 +
 tools/include/uapi/linux/xdp_md_std.h     | 14 +++++
 tools/lib/bpf/xsk.h                       | 27 ++++++++-
 14 files changed, 258 insertions(+), 16 deletions(-)
 create mode 100644 include/uapi/linux/xdp_md_std.h
 create mode 100644 tools/include/uapi/linux/xdp_md_std.h

-- 
2.24.3 (Apple Git-128)

