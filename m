Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D912DF468
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 09:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgLTIUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 03:20:12 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:57662 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727153AbgLTIUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 03:20:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1608452410; x=1639988410;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=E1Mi5FY11B6lMDraDnelSGHfpDc7RXkrsLcWS/V/lTg=;
  b=rEVBEXBmIOZpRfhtmffS781LqQznnMseGBYHDSaU1GQ9F/HpSriP99oS
   5L9Pw79f5P2WT6R6c5VL6uaoALlf+3Abk+Pmb0RG+7EGSXaIXPKuAHTpQ
   4T5ucRzeUd/G5jnKTAqHgwozHiVbooHuzothH2dNLQHTKkndLZ/QLQRDi
   w=;
X-IronPort-AV: E=Sophos;i="5.78,434,1599523200"; 
   d="scan'208";a="105826945"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 20 Dec 2020 08:19:22 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id A8F8EA180C;
        Sun, 20 Dec 2020 08:19:21 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.68) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 20 Dec 2020 08:19:14 +0000
References: <cover.1608399672.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <brouer@redhat.com>,
        <lorenzo.bianconi@redhat.com>, <alexander.duyck@gmail.com>,
        <maciej.fijalkowski@intel.com>, <saeed@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/2] introduce xdp_init_buff/xdp_prepare_buff
In-Reply-To: <cover.1608399672.git.lorenzo@kernel.org>
Date:   Sun, 20 Dec 2020 10:18:58 +0200
Message-ID: <pj41zl8s9sq499.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.68]
X-ClientProxiedBy: EX13D18UWA004.ant.amazon.com (10.43.160.45) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce xdp_init_buff and xdp_prepare_buff utility routines to 
> initialize
> xdp_buff data structure and remove duplicated code in all XDP 
> capable
> drivers.
>
> Changes since v3:
> - use __always_inline instead of inline for 
> xdp_init_buff/xdp_prepare_buff
> - add 'const bool meta_valid' to xdp_prepare_buff signature to 
> avoid
>   overwriting data_meta with xdp_set_data_meta_invalid()
> - introduce removed comment in bnxt driver
>
> Changes since v2:
> - precompute xdp->data as hard_start + headroom and save it in a 
> local
>   variable to reuse it for xdp->data_end and xdp->data_meta in
>   xdp_prepare_buff()
>
> Changes since v1:
> - introduce xdp_prepare_buff utility routine
>
> Lorenzo Bianconi (2):
>   net: xdp: introduce xdp_init_buff utility routine
>   net: xdp: introduce xdp_prepare_buff utility routine
>
> Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
> Acked-by: Camelia Groza <camelia.groza@nxp.com>
>
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 10 ++++------

For changes in ena driver

Acked-by: Shay Agroskin <shayagr@amazon.com>

Also, wouldn't xdp_init_buff() change once the xdp_mb series is 
merged to take care of xdp.mb = 0 part ?
Maybe this series should wait until the other one is merged ?

>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  9 +++------
>  .../net/ethernet/cavium/thunder/nicvf_main.c  | 12 ++++++------
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 10 ++++------
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 
>  +++++---------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 18 
>  +++++++++---------
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 15 
>  ++++++++-------
>  drivers/net/ethernet/intel/igb/igb_main.c     | 18 
>  +++++++++---------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 19 
>  +++++++++----------
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 19 
>  +++++++++----------
>  drivers/net/ethernet/marvell/mvneta.c         | 10 +++-------
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 
>  +++++++-------
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  9 +++------
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  8 ++------
>  .../ethernet/netronome/nfp/nfp_net_common.c   | 12 ++++++------
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    |  9 +++------
>  drivers/net/ethernet/sfc/rx.c                 | 10 +++-------
>  drivers/net/ethernet/socionext/netsec.c       |  9 +++------
>  drivers/net/ethernet/ti/cpsw.c                | 18 
>  ++++++------------
>  drivers/net/ethernet/ti/cpsw_new.c            | 18 
>  ++++++------------
>  drivers/net/hyperv/netvsc_bpf.c               |  8 ++------
>  drivers/net/tun.c                             | 12 ++++--------
>  drivers/net/veth.c                            | 14 
>  +++++---------
>  drivers/net/virtio_net.c                      | 18 
>  ++++++------------
>  drivers/net/xen-netfront.c                    | 10 ++++------
>  include/net/xdp.h                             | 19 
>  +++++++++++++++++++
>  net/bpf/test_run.c                            |  9 +++------
>  net/core/dev.c                                | 18 
>  ++++++++----------
>  28 files changed, 159 insertions(+), 210 deletions(-)

