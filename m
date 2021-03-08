Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFBA33132D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhCHQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:16:09 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:45951 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhCHQQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:16:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1615220164; x=1646756164;
  h=references:from:to:cc:subject:in-reply-to:message-id:
   date:mime-version;
  bh=QnZxt7C/YjFhJGi33JA2KQw8ELI2CjicoGiLIdtgcRk=;
  b=gjkrSX6ilcSnNkwRJcbDAemaHRxzyXhJImrVAHV/qv4xkqIsG43s8Ekv
   LQKnTYKRQ/aPeI0iOlVAb4smpDZkFq0qajWZht0tdFlL/E8nG0dassGTS
   lWjOVLAt59a+4CnNxgCuBJfGz4a0P5VES4OfhdZ9kv35o7ERhjveHRhx3
   8=;
X-IronPort-AV: E=Sophos;i="5.81,232,1610409600"; 
   d="scan'208";a="96766043"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 08 Mar 2021 16:15:49 +0000
Received: from EX13D28EUB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 8F2B1A2169;
        Mon,  8 Mar 2021 16:15:47 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.146) by
 EX13D28EUB001.ant.amazon.com (10.43.166.50) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 8 Mar 2021 16:15:35 +0000
References: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <brouer@redhat.com>, <toke@redhat.com>,
        <freysteinn.alfredsson@kau.se>, <lorenzo.bianconi@redhat.com>,
        <john.fastabend@gmail.com>, <jasowang@redhat.com>,
        <mst@redhat.com>, <thomas.petazzoni@bootlin.com>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>,
        <ilias.apalodimas@linaro.org>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <michael.chan@broadcom.com>,
        <madalin.bucur@nxp.com>, <ioana.ciornei@nxp.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <saeedm@nvidia.com>, <grygorii.strashko@ti.com>,
        <ecree.xilinx@gmail.com>, <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
In-Reply-To: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
Message-ID: <pj41zlczw9ei5h.fsf@u68c7b5b1d2d758.ant.amazon.com>
Date:   Mon, 8 Mar 2021 18:15:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.146]
X-ClientProxiedBy: EX13D20UWA004.ant.amazon.com (10.43.160.62) To
 EX13D28EUB001.ant.amazon.com (10.43.166.50)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> We want to change the current ndo_xdp_xmit drop semantics 
> because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet 
> driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports 
> a tx
> error and it will just return to devmap caller the number of 
> successfully
> transmitted frames. It will be devmap responsability to free 
> dropped
> frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
>
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> More details about the new ndo_xdp_xmit design can be found here 
> [0].
>
> [0] 
> https://github.com/xdp-project/xdp-project/blob/master/areas/core/redesign01_ndo_xdp_xmit.org
>
> Changes since v2:
> - drop wrong comment in ena driver
> - simplify drop condition using unlikey in the for condition of 
> devmap code
> - rebase on top of bpf-next
> - collect acked-by/reviewed-by
>
> Changes since v1:
> - rebase on top of bpf-next
> - add driver maintainers in cc
> - add Edward's ack
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 21 
>  ++++++-------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 20 
>  +++++--------
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 12 ++++----
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 --
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 15 +++++-----
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 15 +++++-----
>  drivers/net/ethernet/intel/igb/igb_main.c     | 11 ++++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 11 ++++---
>  drivers/net/ethernet/marvell/mvneta.c         | 13 ++++----
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 ++++----
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 15 ++++------
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    | 19 +++++-------
>  drivers/net/ethernet/sfc/tx.c                 | 15 +---------
>  drivers/net/ethernet/socionext/netsec.c       | 16 +++++-----
>  drivers/net/ethernet/ti/cpsw.c                | 14 ++++-----
>  drivers/net/ethernet/ti/cpsw_new.c            | 14 ++++-----
>  drivers/net/ethernet/ti/cpsw_priv.c           | 11 +++----
>  drivers/net/tun.c                             | 15 ++++++----
>  drivers/net/veth.c                            | 28 
>  +++++++++--------
>  drivers/net/virtio_net.c                      | 25 
>  ++++++++--------
>  drivers/net/xen-netfront.c                    | 18 +++++------
>  kernel/bpf/devmap.c                           | 30 
>  ++++++++-----------
>  22 files changed, 153 insertions(+), 200 deletions(-)
>
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 102f2c91fdb8..5c062c51b4cb 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -300,7 +300,7 @@ static int ena_xdp_xmit_frame(struct 
> ena_ring *xdp_ring,
>  

Acked-by: Shay Agroskin <shayagr@amazon.com>

for ena-drivers. Also reviewed all non-driver specific code, lgtm.
Thank you for this work Lorenzo.
