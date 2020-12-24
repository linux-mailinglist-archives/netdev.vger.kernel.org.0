Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8107B2E27F9
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 16:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgLXPxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 10:53:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727861AbgLXPxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 10:53:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608825103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAYd6Tfv3EXYk/sjNyYkHfmlP+djjGI2nc+mjGe127o=;
        b=WADtwe5MNZB76dsren4xBk1r9deukAbxo+CFAIb5+4dzw3mhuMIBmfIBWrV6eRE4WwtDAM
        SwCVsvs/aA7aanyqsxhiJTbbTzJRgUeVt9TmQ49DOBYF2uHRWwzZCE3abtZAjxIHNyAMGe
        RXwkkIg+xJp29pADF0gusJp7Ed8jl6E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386--k_u8b-dOLGuXq95cBkV7g-1; Thu, 24 Dec 2020 10:51:41 -0500
X-MC-Unique: -k_u8b-dOLGuXq95cBkV7g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E94C801817;
        Thu, 24 Dec 2020 15:51:39 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C55CA6B8D4;
        Thu, 24 Dec 2020 15:51:29 +0000 (UTC)
Date:   Thu, 24 Dec 2020 16:51:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, alexander.duyck@gmail.com,
        maciej.fijalkowski@intel.com, saeed@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v5 bpf-next 1/2] net: xdp: introduce xdp_init_buff
 utility routine
Message-ID: <20201224165128.1f89c988@carbon>
In-Reply-To: <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608670965.git.lorenzo@kernel.org>
References: <cover.1608670965.git.lorenzo@kernel.org>
        <7f8329b6da1434dc2b05a77f2e800b29628a8913.1608670965.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 22:09:28 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce xdp_init_buff utility routine to initialize xdp_buff fields
> const over NAPI iterations (e.g. frame_sz or rxq pointer). Rely on
> xdp_init_buff in all XDP capable drivers.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c        | 3 +--
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c       | 4 ++--
>  drivers/net/ethernet/cavium/thunder/nicvf_main.c    | 4 ++--
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c      | 4 ++--
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c    | 8 ++++----
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c         | 6 +++---
>  drivers/net/ethernet/intel/ice/ice_txrx.c           | 6 +++---
>  drivers/net/ethernet/intel/igb/igb_main.c           | 6 +++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 7 +++----
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c   | 7 +++----
>  drivers/net/ethernet/marvell/mvneta.c               | 3 +--
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c     | 8 +++++---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c          | 3 +--
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c     | 3 +--
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 4 ++--
>  drivers/net/ethernet/qlogic/qede/qede_fp.c          | 3 +--
>  drivers/net/ethernet/sfc/rx.c                       | 3 +--
>  drivers/net/ethernet/socionext/netsec.c             | 3 +--
>  drivers/net/ethernet/ti/cpsw.c                      | 4 ++--
>  drivers/net/ethernet/ti/cpsw_new.c                  | 4 ++--
>  drivers/net/hyperv/netvsc_bpf.c                     | 3 +--
>  drivers/net/tun.c                                   | 7 +++----
>  drivers/net/veth.c                                  | 8 ++++----
>  drivers/net/virtio_net.c                            | 6 ++----
>  drivers/net/xen-netfront.c                          | 4 ++--
>  include/net/xdp.h                                   | 7 +++++++
>  net/bpf/test_run.c                                  | 4 ++--
>  net/core/dev.c                                      | 8 ++++----
>  28 files changed, 68 insertions(+), 72 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

