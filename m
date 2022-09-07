Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8635B08EE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiIGPpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIGPpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBD34D818
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MAyR8PJJXyDlzwKroYevTctRX3Y6leqOfqXTHF2prlQ=;
        b=FEu1WXF9NTGkdNEnelu9sGT3jEmpbfi6pCXShQiSK+Io+p+I697iDiQzdkIFEodqcOwACb
        N6yzpbP73Wc7LmMKyrZc1r39TEQwyA0LVBOknluKzHgVo4ilkLAeWcX3gAYH7z3GKV5R8W
        udIXTNsq5wGNThtoUtlBbqqQm6Nun9Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-SeeSGD2ZMt64KaP2unZSug-1; Wed, 07 Sep 2022 11:45:02 -0400
X-MC-Unique: SeeSGD2ZMt64KaP2unZSug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47C341C05EAA;
        Wed,  7 Sep 2022 15:45:02 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83F04010D2A;
        Wed,  7 Sep 2022 15:45:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9E33A30721A6C;
        Wed,  7 Sep 2022 17:45:00 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to HW
 offload hints via BTF
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:00 +0200
Message-ID: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset expose the traditional hardware offload hints to XDP and
rely on BTF to expose the layout to users.

Main idea is that the kernel and NIC drivers simply defines the struct
layouts they choose to use for XDP-hints. These XDP-hints structs gets
naturally and automatically described via BTF and implicitly exported to
users. NIC drivers populate and records their own BTF ID as the last
member in XDP metadata area (making it easily accessible by AF_XDP
userspace at a known negative offset from packet data start).

Naming conventions for the structs (xdp_hints_*) is used such that
userspace can find and decode the BTF layout and match against the
provided BTF IDs. Thus, no new UAPI interfaces are needed for exporting
what XDP-hints a driver supports.

The patch "i40e: Add xdp_hints_union" introduce the idea of creating a
union named "xdp_hints_union" in every driver, which contains all
xdp_hints_* struct this driver can support. This makes it easier/quicker
to find and parse the relevant BTF types.  (Seeking input before fixing
up all drivers in patchset).


The main different from RFC-v1:
 - Drop idea of BTF "origin" (vmlinux, module or local)
 - Instead to use full 64-bit BTF ID that combine object+type ID

I've taken some of Alexandr/Larysa's libbpf patches and integrated
those.

Patchset exceeds netdev usually max 15 patches rule. My excuse is three
NIC drivers (i40e, ixgbe and mvneta) gets XDP-hints support and which
required some refactoring to remove the SKB dependencies.


---

Jesper Dangaard Brouer (10):
      net: create xdp_hints_common and set functions
      net: add net_device feature flag for XDP-hints
      xdp: controlling XDP-hints from BPF-prog via helper
      i40e: Refactor i40e_ptp_rx_hwtstamp
      i40e: refactor i40e_rx_checksum with helper
      bpf: export btf functions for modules
      btf: Add helper for kernel modules to lookup full BTF ID
      i40e: add XDP-hints handling
      net: use XDP-hints in xdp_frame to SKB conversion
      i40e: Add xdp_hints_union

Larysa Zaremba (3):
      libbpf: factor out BTF loading from load_module_btfs()
      libbpf: try to load vmlinux BTF from the kernel first
      libbpf: patch module BTF obj+type ID into BPF insns

Lorenzo Bianconi (1):
      mvneta: add XDP-hints support

Maryam Tahhan (4):
      ixgbe: enable xdp-hints
      ixgbe: add rx timestamp xdp hints support
      xsk: AF_XDP xdp-hints support in desc options
      ixgbe: AF_XDP xdp-hints processing in ixgbe_clean_rx_irq_zc


 drivers/net/ethernet/intel/i40e/i40e.h        |   1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  22 ++
 drivers/net/ethernet/intel/i40e/i40e_ptp.c    |  36 ++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 252 ++++++++++++++---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 217 +++++++++++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c  |  82 ++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |   2 +
 drivers/net/ethernet/marvell/mvneta.c         |  59 +++-
 include/linux/btf.h                           |   3 +
 include/linux/netdev_features.h               |   3 +-
 include/net/xdp.h                             | 256 +++++++++++++++++-
 include/uapi/linux/bpf.h                      |  35 +++
 include/uapi/linux/if_xdp.h                   |   2 +-
 kernel/bpf/btf.c                              |  36 ++-
 net/core/filter.c                             |  52 ++++
 net/core/xdp.c                                |  22 +-
 net/ethtool/common.c                          |   1 +
 net/xdp/xsk.c                                 |   2 +-
 net/xdp/xsk_queue.h                           |   3 +-
 tools/lib/bpf/bpf_core_read.h                 |   3 +-
 tools/lib/bpf/btf.c                           | 142 +++++++++-
 tools/lib/bpf/libbpf.c                        |  52 +---
 tools/lib/bpf/libbpf_internal.h               |   7 +-
 tools/lib/bpf/relo_core.c                     |   8 +-
 tools/lib/bpf/relo_core.h                     |   1 +
 26 files changed, 1127 insertions(+), 177 deletions(-)

--

