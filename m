Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF3C753F2
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 18:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387616AbfGYQ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 12:27:09 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38555 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390694AbfGYQ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 12:27:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so14478049pgu.5
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 09:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=pxdbOf0Nki6B1btebdWgnUPEN0JkVWiS45Kq9LIwV/A=;
        b=JnFohEhL2h8TnPrrShSkTs3qv4rKyjyoVIewI/m+LMDTN54hy6+lQX+DrbZyQOaXgD
         zPnv1HMbHzhFOqIaBffdwZB3doZn6CxHrqa06+XN7Lc6Em13lXeSuaCAXLzjnTOqncTV
         pim/OtUM2D8RHdHu6UQG1azEiBqOZpW1w0I8DssranNnfA57+lVgPFudLZ8Q7zNXVu5I
         72tZCMtKh6E+U4RP/kcLNU0xRK+nWPeacuuksciH3fD2IABXXXS1X9dDt6e6bltgdCCp
         XSFK+W6q1KXgLd+NaunuzqlTys7Vul6gVRuta5rMERv+iM+/vMMqZ7qIFw4fDcDkIvJP
         GRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=pxdbOf0Nki6B1btebdWgnUPEN0JkVWiS45Kq9LIwV/A=;
        b=pxK+niQtEHP5nFtv8OYitp2oBT6li6Kp5ImunDUlnbP3q9TCP9XaLailh2x4ukS+oe
         tVCrwy7BMwVV5R3q+PS1cOt75POuNfewWi0x5bwUNgnII4YVqL2ORrYFECZe/2NIZ751
         cEVgiR/9Tv37PqcICuCv5FlI3uSOTiaWFEm/6YLTV76OoTB2Abv9RNISuss18N1JwCgA
         K15gA0oPyhRIFeH68e9xSlGRniDv4EK44eHGopMZaMRVeBCrAjl2au564UZaKR1kKtap
         NfbZcXuR2N3y09Cj27TKT9lbCuYGOGw56iti6tpBhay3cftEm/nCmgsKpThqOgdEgtvX
         saoQ==
X-Gm-Message-State: APjAAAWQZe3+YL4XWcVUFJ4FJnwXzaN7b/P1TojaElmHs5acK4FuF64T
        LAfKn6P8LJ3NTGjUPcWPcmQ=
X-Google-Smtp-Source: APXvYqxGXFuFvlNsrnvzLR2IvzOM14KIDJ3otrufibSew3sFUCbOz4+GMq2KgK954eWGI1kRpCiM2Q==
X-Received: by 2002:a62:63c7:: with SMTP id x190mr16882817pfb.181.1564072019961;
        Thu, 25 Jul 2019 09:26:59 -0700 (PDT)
Received: from [172.20.174.128] ([2620:10d:c090:180::1:622f])
        by smtp.gmail.com with ESMTPSA id y22sm59821464pfo.39.2019.07.25.09.26.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 09:26:58 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Matthew Wilcox" <willy@infradead.org>
Cc:     davem@davemloft.net, hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v3 0/7] Convert skb_frag_t to bio_vec
Date:   Thu, 25 Jul 2019 09:26:57 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <9BBB1B3F-F8AD-4DAC-9EF9-91DF1C1B8D5D@gmail.com>
In-Reply-To: <20190723030831.11879-1-willy@infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; markup=markdown
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 22 Jul 2019, at 20:08, Matthew Wilcox wrote:

> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>
> The skb_frag_t and bio_vec are fundamentally the same (page, offset,
> length) tuple.  This patch series unifies the two, leaving the
> skb_frag_t typedef in place.  This has the immediate advantage that
> we already have iov_iter support for bvecs and don't need to add
> support for iterating skbuffs.  It enables a long-term plan to use
> bvecs more broadly within the kernel and should make network-storage
> drivers able to do less work converting between skbuffs and biovecs.
>
> It will consume more memory on 32-bit kernels.  If that proves
> problematic, we can look at ways of addressing it.
>
> v3: Rebase on latest Linus with net-next merged.
>   - Reorder the uncontroversial 'Use skb accessors' patches first so you
>     can apply just those two if you want to hold off on the full
>     conversion.
>   - Convert all the users of 'struct skb_frag_struct' to skb_frag_t.

Thanks for doing this!  One step closer to simplifying code.

For the series:
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>



>
> Matthew Wilcox (Oracle) (7):
>   net: Use skb accessors in network drivers
>   net: Use skb accessors in network core
>   net: Increase the size of skb_frag_t
>   net: Reorder the contents of skb_frag_t
>   net: Rename skb_frag page to bv_page
>   net: Rename skb_frag_t size to bv_len
>   net: Convert skb_frag_t to bio_vec
>
>  drivers/crypto/chelsio/chtls/chtls_io.c       |  6 ++--
>  drivers/hsi/clients/ssi_protocol.c            |  3 +-
>  drivers/infiniband/hw/hfi1/vnic_sdma.c        |  2 +-
>  drivers/net/ethernet/3com/3c59x.c             |  2 +-
>  drivers/net/ethernet/agere/et131x.c           |  6 ++--
>  drivers/net/ethernet/amd/xgbe/xgbe-desc.c     |  2 +-
>  drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
>  .../net/ethernet/apm/xgene/xgene_enet_main.c  |  3 +-
>  drivers/net/ethernet/atheros/alx/main.c       |  4 +--
>  .../net/ethernet/atheros/atl1c/atl1c_main.c   |  4 +--
>  .../net/ethernet/atheros/atl1e/atl1e_main.c   |  3 +-
>  drivers/net/ethernet/atheros/atlx/atl1.c      |  3 +-
>  drivers/net/ethernet/broadcom/bgmac.c         |  2 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
>  drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
>  drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
>  .../net/ethernet/cavium/liquidio/lio_main.c   | 23 ++++++-------
>  .../ethernet/cavium/liquidio/lio_vf_main.c    | 23 ++++++-------
>  .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +--
>  drivers/net/ethernet/chelsio/cxgb3/sge.c      |  2 +-
>  drivers/net/ethernet/cortina/gemini.c         |  5 ++-
>  drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
>  drivers/net/ethernet/freescale/enetc/enetc.c  |  2 +-
>  drivers/net/ethernet/freescale/fec_main.c     |  4 +--
>  drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  2 +-
>  drivers/net/ethernet/hisilicon/hns/hns_enet.c |  4 +--
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  8 ++---
>  drivers/net/ethernet/huawei/hinic/hinic_tx.c  |  2 +-
>  drivers/net/ethernet/ibm/emac/core.c          |  2 +-
>  drivers/net/ethernet/intel/e1000/e1000_main.c |  3 +-
>  drivers/net/ethernet/intel/e1000e/netdev.c    |  3 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_main.c |  5 +--
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  4 +--
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  2 +-
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c   |  4 +--
>  drivers/net/ethernet/intel/iavf/iavf_txrx.h   |  2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |  6 ++--
>  drivers/net/ethernet/intel/igb/igb_main.c     |  5 +--
>  drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
>  drivers/net/ethernet/intel/igc/igc_main.c     |  5 +--
>  drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  4 +--
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  9 ++---
>  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
>  drivers/net/ethernet/jme.c                    |  5 ++-
>  drivers/net/ethernet/marvell/mvneta.c         |  4 +--
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 ++--
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  4 +--
>  drivers/net/ethernet/mellanox/mlx4/en_tx.c    |  4 +--
>  .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  2 +-
>  drivers/net/ethernet/microchip/lan743x_main.c |  5 ++-
>  .../net/ethernet/myricom/myri10ge/myri10ge.c  | 10 +++---
>  .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ++--
>  .../ethernet/qlogic/netxen/netxen_nic_main.c  |  4 +--
>  .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  2 +-
>  drivers/net/ethernet/qualcomm/emac/emac-mac.c | 12 +++----
>  .../net/ethernet/synopsys/dwc-xlgmac-desc.c   |  2 +-
>  .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
>  drivers/net/ethernet/tehuti/tehuti.c          |  2 +-
>  drivers/net/usb/usbnet.c                      |  4 +--
>  drivers/net/vmxnet3/vmxnet3_drv.c             |  7 ++--
>  drivers/net/wireless/ath/wil6210/debugfs.c    |  3 +-
>  drivers/net/wireless/ath/wil6210/txrx.c       |  9 +++--
>  drivers/net/wireless/ath/wil6210/txrx_edma.c  |  2 +-
>  drivers/net/xen-netback/netback.c             |  4 +--
>  drivers/s390/net/qeth_core_main.c             |  2 +-
>  drivers/scsi/fcoe/fcoe_transport.c            |  2 +-
>  drivers/staging/octeon/ethernet-tx.c          |  5 ++-
>  .../staging/unisys/visornic/visornic_main.c   |  4 +--
>  drivers/target/iscsi/cxgbit/cxgbit_target.c   | 13 +++----
>  include/linux/bvec.h                          |  5 ++-
>  include/linux/skbuff.h                        | 34 ++++++-------------
>  net/core/skbuff.c                             | 26 ++++++++------
>  net/core/tso.c                                |  8 ++---
>  net/ipv4/tcp.c                                | 14 ++++----
>  net/kcm/kcmsock.c                             |  8 ++---
>  net/tls/tls_device.c                          | 14 ++++----
>  76 files changed, 202 insertions(+), 220 deletions(-)
>
> -- 
> 2.20.1
