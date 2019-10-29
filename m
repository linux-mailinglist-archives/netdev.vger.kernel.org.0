Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC892E9320
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 23:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfJ2WsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 18:48:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43599 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfJ2WsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 18:48:10 -0400
Received: by mail-pf1-f196.google.com with SMTP id 3so118802pfb.10
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 15:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LQ8Qq7jCZpxsKtLYDFTpehYmUC9HA19Dv23SRX5tr0Y=;
        b=D+47El4njGa+rVKveuA304hGPrxRVZEOG4+ThZ+OgTA2ti7ygzy2LcTSJG+JnTP1RL
         1KAksUSOAOP/jiGquelX6euedqRzqJuC6oLmNuB1FPoWMtaz5pNbuClyU2H8//v3/G3K
         BJCf4eBKKgxUjJZv+AUCNOqsHVD6ycXSBFAkk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LQ8Qq7jCZpxsKtLYDFTpehYmUC9HA19Dv23SRX5tr0Y=;
        b=ACPP+4FWJZ6ed/xQQJo+BOHw83sCJNRUi9sT3ThoEf1KelQDWHijtoFk2nH0/LPM3q
         3cZPJ1JsWce7VHVs8NpTYJtAbrpjegzCeARbXZOrkAQnbYZaSCGJIqqKGOnF03HDDEZk
         AHJPkH8f7+8eNcQiC2RpAi+k0/zA+Nicwcf0S2V5el3UF6cOI75WconTVuIVVcZ/n5Sg
         ptoL4NhS021vSLI56OY7DFmQMAn94RIfKGVVPjJEswNHOe6mUgyLqzuTRYSzVqkZHvbs
         U1Wr/gKE99fbXnsIacPzSCjJHl3bEXInvAT3X0hC23Fv6uuKhXtVUPdnab1nJyEvFldk
         2BEQ==
X-Gm-Message-State: APjAAAUhPpUecC9xHYt68wPPNdPO1UsD0vO4WCZok88ZnNJQ5mQDOtXF
        Jp1OCS+9yJYmcGK3ATlES8DrCw+Hj6M=
X-Google-Smtp-Source: APXvYqxR452ixoOqB9MdhuF8AoQ916LwgIgccEmyoBHPIHalW51Ehhi0QpmMQ5l0LjPLP71VpIzqFQ==
X-Received: by 2002:a63:4e13:: with SMTP id c19mr30498840pgb.225.1572389288371;
        Tue, 29 Oct 2019 15:48:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id t15sm160672pfh.31.2019.10.29.15.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 15:48:05 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] treewide: Use sizeof_member() macro
Date:   Tue, 29 Oct 2019 15:47:53 -0700
Message-Id: <20191029224756.28618-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v3: resend, adjusted for minimizing linux-next interference
v2: https://lore.kernel.org/lkml/20191010232345.26594-1-keescook@chromium.org
v1: https://lore.kernel.org/lkml/201909261026.6E3381876C@keescook

This is basically a resend of the heads-up for this tree I'm carrying
for the v5.5 merge window to replace the various struct member sizeof
macros with sizeof_member(). The CC list was insane, so I trimmed it to
the major areas that get touched.

Linus, if Alexey's argument on naming[1] does not convince you, please
advise on what you want the final macro to be named and I will adjust. :)

Dave, I converted your "no objection"[2] into an Acked-by; please yell
if this is not desired.

Thanks!

-Kees

[1] https://www.openwall.com/lists/kernel-hardening/2019/07/02/2
[2] https://lore.kernel.org/lkml/20191002.132121.402975401040540710.davem@davemloft.net

Pankaj Bharadiya (3):
  MIPS: OCTEON: Replace SIZEOF_FIELD() macro
  linux/stddef.h: Add sizeof_member() macro
  treewide: Use sizeof_member() macro

 Documentation/process/coding-style.rst        |   2 +-
 .../it_IT/process/coding-style.rst            |   2 +-
 .../zh_CN/process/coding-style.rst            |   2 +-
 arch/arc/kernel/unwind.c                      |   6 +-
 arch/arm64/include/asm/processor.h            |  10 +-
 .../cavium-octeon/executive/cvmx-bootmem.c    |   9 +-
 arch/powerpc/net/bpf_jit32.h                  |   4 +-
 arch/powerpc/net/bpf_jit_comp.c               |  16 +-
 arch/sparc/net/bpf_jit_comp_32.c              |   8 +-
 arch/x86/kernel/fpu/xstate.c                  |   2 +-
 block/blk-core.c                              |   4 +-
 crypto/adiantum.c                             |   4 +-
 crypto/essiv.c                                |   2 +-
 drivers/firmware/efi/efi.c                    |   2 +-
 drivers/gpu/drm/i915/gvt/scheduler.c          |   2 +-
 drivers/infiniband/hw/efa/efa_verbs.c         |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c             |   2 +-
 drivers/infiniband/hw/hfi1/verbs.h            |   4 +-
 .../ulp/opa_vnic/opa_vnic_ethtool.c           |   2 +-
 drivers/input/keyboard/applespi.c             |   2 +-
 drivers/md/raid5-ppl.c                        |   2 +-
 drivers/media/platform/omap3isp/isppreview.c  |  24 +--
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  |   4 +-
 .../ethernet/cavium/liquidio/octeon_console.c |  16 +-
 .../net/ethernet/emulex/benet/be_ethtool.c    |   2 +-
 .../hisilicon/hns3/hns3pf/hclge_main.c        |   2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_tm.c |   2 +-
 .../net/ethernet/huawei/hinic/hinic_ethtool.c |   8 +-
 .../net/ethernet/intel/fm10k/fm10k_ethtool.c  |   2 +-
 .../net/ethernet/intel/i40e/i40e_ethtool.c    |   2 +-
 .../net/ethernet/intel/i40e/i40e_lan_hmc.c    |   2 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |   2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |  10 +-
 .../net/ethernet/intel/ice/ice_lan_tx_rx.h    |   2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   4 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c  |   4 +-
 .../net/ethernet/intel/ixgb/ixgb_ethtool.c    |   4 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |   4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   4 +-
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/fpga/ipsec.c  |   6 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    |   4 +-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/jit.c  |  10 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c |   2 +-
 .../net/ethernet/netronome/nfp/bpf/offload.c  |   2 +-
 .../net/ethernet/netronome/nfp/flower/main.h  |   2 +-
 .../oki-semi/pch_gbe/pch_gbe_ethtool.c        |   2 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |   2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_ethtool.c   |   2 +-
 .../ethernet/samsung/sxgbe/sxgbe_ethtool.c    |   2 +-
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  |   4 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c        |   6 +-
 drivers/net/ethernet/ti/netcp_ethss.c         |  32 ++--
 drivers/net/fjes/fjes_ethtool.c               |   2 +-
 drivers/net/geneve.c                          |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |   2 +-
 drivers/net/usb/sierra_net.c                  |   2 +-
 drivers/net/usb/usbnet.c                      |   2 +-
 drivers/net/vxlan.c                           |   4 +-
 .../net/wireless/marvell/libertas/debugfs.c   |   2 +-
 drivers/net/wireless/marvell/mwifiex/util.h   |   4 +-
 drivers/s390/net/qeth_core_main.c             |   2 +-
 drivers/s390/net/qeth_core_mpc.h              |  10 +-
 drivers/scsi/aacraid/aachba.c                 |   4 +-
 drivers/scsi/be2iscsi/be_cmds.h               |   2 +-
 drivers/scsi/cxgbi/libcxgbi.c                 |   2 +-
 drivers/scsi/smartpqi/smartpqi_init.c         |   6 +-
 drivers/staging/qlge/qlge_ethtool.c           |   2 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c     |   2 +-
 drivers/usb/atm/usbatm.c                      |   2 +-
 drivers/usb/gadget/function/f_fs.c            |   2 +-
 fs/befs/linuxvfs.c                            |   2 +-
 fs/crypto/keyring.c                           |   2 +-
 fs/ext2/super.c                               |   2 +-
 fs/ext4/super.c                               |   2 +-
 fs/freevxfs/vxfs_super.c                      |   2 +-
 fs/fuse/virtio_fs.c                           |   2 +-
 fs/orangefs/super.c                           |   2 +-
 fs/ufs/super.c                                |   2 +-
 fs/verity/enable.c                            |   2 +-
 include/linux/filter.h                        |  12 +-
 include/linux/kvm_host.h                      |   2 +-
 include/linux/phy_led_triggers.h              |   2 +-
 include/linux/slab.h                          |   2 +-
 include/linux/stddef.h                        |  13 +-
 include/net/garp.h                            |   2 +-
 include/net/ip_tunnels.h                      |   6 +-
 include/net/mrp.h                             |   2 +-
 include/net/netfilter/nf_conntrack_helper.h   |   2 +-
 include/net/netfilter/nf_tables_core.h        |   2 +-
 include/net/sock.h                            |   2 +-
 ipc/util.c                                    |   2 +-
 kernel/bpf/cgroup.c                           |   2 +-
 kernel/bpf/local_storage.c                    |   4 +-
 kernel/fork.c                                 |   2 +-
 kernel/signal.c                               |  12 +-
 kernel/utsname.c                              |   2 +-
 net/802/mrp.c                                 |   6 +-
 net/batman-adv/main.c                         |   2 +-
 net/bridge/br.c                               |   2 +-
 net/caif/caif_socket.c                        |   2 +-
 net/core/dev.c                                |   2 +-
 net/core/filter.c                             | 140 +++++++++---------
 net/core/flow_dissector.c                     |  10 +-
 net/core/skbuff.c                             |   2 +-
 net/core/xdp.c                                |   4 +-
 net/dccp/proto.c                              |   2 +-
 net/ipv4/ip_gre.c                             |   4 +-
 net/ipv4/ip_vti.c                             |   4 +-
 net/ipv4/raw.c                                |   2 +-
 net/ipv4/tcp.c                                |   2 +-
 net/ipv6/ip6_gre.c                            |   4 +-
 net/ipv6/raw.c                                |   2 +-
 net/iucv/af_iucv.c                            |   2 +-
 net/netfilter/nf_tables_api.c                 |   4 +-
 net/netfilter/nfnetlink_cthelper.c            |   2 +-
 net/netfilter/nft_ct.c                        |  12 +-
 net/netfilter/nft_masq.c                      |   2 +-
 net/netfilter/nft_nat.c                       |   6 +-
 net/netfilter/nft_redir.c                     |   2 +-
 net/netfilter/nft_tproxy.c                    |   4 +-
 net/netfilter/xt_RATEEST.c                    |   2 +-
 net/netlink/af_netlink.c                      |   2 +-
 net/openvswitch/datapath.c                    |   2 +-
 net/openvswitch/flow.h                        |   4 +-
 net/rxrpc/af_rxrpc.c                          |   2 +-
 net/sched/act_ct.c                            |   4 +-
 net/sched/cls_flower.c                        |   2 +-
 net/sctp/socket.c                             |   4 +-
 net/unix/af_unix.c                            |   2 +-
 security/integrity/ima/ima_policy.c           |   4 +-
 sound/soc/codecs/hdmi-codec.c                 |   2 +-
 tools/testing/selftests/bpf/bpf_util.h        |   6 +-
 virt/kvm/kvm_main.c                           |   2 +-
 136 files changed, 340 insertions(+), 336 deletions(-)

-- 
2.17.1

