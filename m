Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A192E280D
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 17:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgLXQVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 11:21:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727081AbgLXQVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 11:21:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608826776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AAfT+BsMBBm+hMNjIwD1FhtI2G3uVNwHXDU1KcG/lpc=;
        b=L0/SUZV11X7RvNO72AQziDQg3s6QJLAg7EkJ2cXLKMAA6CEnIg81nJUAic52e2FbbdtQie
        Ms02sB0sJpq2pyjaSG1Ob7usqWqFjtoNB23RyvFFiSkWhcLUaxbMXGP1kIeWNgDddK8ooQ
        MCROiVoyCCmfx+iYDzC0lEE7bkC2HKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-388-vj3Ex3tKPvipUzpXQJ4qiw-1; Thu, 24 Dec 2020 11:19:34 -0500
X-MC-Unique: vj3Ex3tKPvipUzpXQJ4qiw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0AD07107ACF5;
        Thu, 24 Dec 2020 16:19:33 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E50C5D747;
        Thu, 24 Dec 2020 16:19:22 +0000 (UTC)
Date:   Thu, 24 Dec 2020 17:19:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v5 bpf-next 2/2] net: xdp: introduce xdp_prepare_buff
 utility routine
Message-ID: <20201224171921.0461fe24@carbon>
In-Reply-To: <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
References: <cover.1608670965.git.lorenzo@kernel.org>
        <45f46f12295972a97da8ca01990b3e71501e9d89.1608670965.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 22:09:29 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce xdp_prepare_buff utility routine to initialize per-descriptor
> xdp_buff fields (e.g. xdp_buff pointers). Rely on xdp_prepare_buff() in
> all XDP capable drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  |  7 +++----
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  5 +----
>  .../net/ethernet/cavium/thunder/nicvf_main.c  |  8 ++++----
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  6 ++----
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 14 +++++--------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 12 +++++------
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |  9 +++++----
>  drivers/net/ethernet/intel/igb/igb_main.c     | 12 +++++------
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 12 +++++------
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 12 +++++------
>  drivers/net/ethernet/marvell/mvneta.c         |  7 ++-----
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 +++-----
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |  6 ++----
>  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |  5 +----
>  .../ethernet/netronome/nfp/nfp_net_common.c   |  8 ++++----
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    |  6 ++----
>  drivers/net/ethernet/sfc/rx.c                 |  7 ++-----
>  drivers/net/ethernet/socionext/netsec.c       |  6 ++----
>  drivers/net/ethernet/ti/cpsw.c                | 16 +++++----------
>  drivers/net/ethernet/ti/cpsw_new.c            | 16 +++++----------
>  drivers/net/hyperv/netvsc_bpf.c               |  5 +----
>  drivers/net/tun.c                             |  5 +----
>  drivers/net/veth.c                            |  8 ++------
>  drivers/net/virtio_net.c                      | 12 ++++-------
>  drivers/net/xen-netfront.c                    |  6 ++----
>  include/net/xdp.h                             | 12 +++++++++++
>  net/bpf/test_run.c                            |  7 ++-----
>  net/core/dev.c                                | 20 +++++++++----------
>  28 files changed, 105 insertions(+), 152 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

