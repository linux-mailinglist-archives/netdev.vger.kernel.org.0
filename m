Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A866634D14E
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 15:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhC2Ng6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 09:36:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:45673 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231466AbhC2NgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 09:36:25 -0400
IronPort-SDR: 3qr+AHR2STm+4L9s4wfAuQmjn20OfezGjpLG+TssnGKTQon2Cm7GWzPW09VdZy1WN6WOWjd/9M
 4EUvWp44z9ng==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="191578677"
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="191578677"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 06:36:23 -0700
IronPort-SDR: cN5tioQONFrg55k3SNDRwqRRxSngeQ+QAZ1KTc6kchcFbWs7jTWrznMzuJFR1iAO55eHh2Lgz/
 XuR/xoPpAUIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,287,1610438400"; 
   d="scan'208";a="411079302"
Received: from glass.png.intel.com ([10.158.65.59])
  by fmsmga008.fm.intel.com with ESMTP; 29 Mar 2021 06:36:16 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next 0/6] stmmac: Add XDP support
Date:   Mon, 29 Mar 2021 21:40:07 +0800
Message-Id: <20210329134013.9516-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the patch series to adds XDP support to stmmac driver.
Summary of the changes as follow:-

1/6: Add IRQ affinity hint to make RXQ and TXQ to be by default serviced
     by the same CPU. This is required for Intel mGbE controller which
     has independent per DMA channel RX & and TX IRQ resources.

2/6: To add capability to enable/disable Split Header (SPH) dynamically.
     Disable SPH for XDP and revert back to the SPH capability of the IP
     when XDP exits.

3/6: To rearrange TX tail pointer update into common function for reuse
     across driver.

4/6: Add basic XDP framework into stmmac driver. This patch only support
     XDP_DROP only.

5/6: Add support for XDP_TX.

6/6: Add support for XDP_REDIRECT and ndo_xdp_xmit() implementation.

To send burst traffics to DUT, we use samples/pktgen script called
pktgen_sample03_burst_single_flow.sh. Following shows the test steps
and results that are obtained using Intel mGbE controller under
preempt-rt environment. In such environment, I also have sent a patch
that fixes an issue found in xdp_return_frame() earlier:

  https://patchwork.kernel.org/project/netdevbpf/list/?series=457139

 ########################################################################

root@intel-corei7-64:~# ./xdp1 eth0
libbpf: elf: skipping unrecognized data section(16) .eh_frame
libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
proto 17:     421844 pkt/s
proto 17:     684396 pkt/s
proto 17:     684332 pkt/s
proto 17:     684074 pkt/s
proto 17:     683837 pkt/s
proto 17:     684357 pkt/s
proto 17:     684371 pkt/s
proto 17:     684419 pkt/s
proto 17:     683996 pkt/s

root@intel-corei7-64:~# ./xdp1 -S eth0
libbpf: elf: skipping unrecognized data section(16) .eh_frame
libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
proto 0:          1 pkt/s
proto 17:          1 pkt/s
proto 17:          1 pkt/s
proto 17:      65564 pkt/s
proto 17:     117450 pkt/s
proto 17:     117600 pkt/s
proto 17:     118108 pkt/s
proto 17:     118032 pkt/s
proto 17:     118092 pkt/s

root@intel-corei7-64:~# ./xdp2 eth0
libbpf: elf: skipping unrecognized data section(16) .eh_frame
libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
proto 17:          0 pkt/s
proto 17:      49338 pkt/s
proto 17:     714255 pkt/s
proto 17:     714495 pkt/s
proto 17:     710120 pkt/s
proto 17:     712892 pkt/s
proto 17:     712585 pkt/s
proto 17:     713883 pkt/s

root@intel-corei7-64:~# ./xdp2 -S eth0
libbpf: elf: skipping unrecognized data section(16) .eh_frame
libbpf: elf: skipping relo section(17) .rel.eh_frame for section(16) .eh_frame
proto 0:          0 pkt/s
proto 17:      89483 pkt/s
proto 17:      89540 pkt/s
proto 17:      89358 pkt/s
proto 17:      89797 pkt/s
proto 0:          1 pkt/s
proto 17:      89672 pkt/s

root@intel-corei7-64:~# ./xdp_redirect eth0 eth1
input: 7 output: 8
libbpf: elf: skipping unrecognized data section(20) .eh_frame
libbpf: elf: skipping relo section(21) .rel.eh_frame for section(20) .eh_frame
ifindex 8:     143805 pkt/s
ifindex 8:     676900 pkt/s
ifindex 8:     676801 pkt/s
ifindex 8:     677657 pkt/s
ifindex 8:     677916 pkt/s

root@intel-corei7-64:~# ./xdp_redirect -S eth0 eth1
input: 7 output: 8
libbpf: elf: skipping unrecognized data section(20) .eh_frame
libbpf: elf: skipping relo section(21) .rel.eh_frame for section(20) .eh_frame
ifindex 8:          2 pkt/s
ifindex 8:          0 pkt/s
ifindex 8:      33505 pkt/s
ifindex 8:      73536 pkt/s
ifindex 8:      52512 pkt/s
ifindex 8:      97600 pkt/s
ifindex 8:      96928 pkt/s
ifindex 8:      96480 pkt/s
ifindex 8:      96760 pkt/s
ifindex 8:      96949 pkt/s
ifindex 8:      96591 pkt/s

root@intel-corei7-64:~# ./xdp_redirect_cpu --dev eth0 --cpu 0
libbpf: elf: skipping unrecognized data section(39) .eh_frame
libbpf: elf: skipping relo section(40) .rel.eh_frame for section(39) .eh_frame
libbpf: elf: skipping unrecognized data section(20) .eh_frame
libbpf: elf: skipping relo section(21) .rel.eh_frame for section(20) .eh_frame
Add-new CPU:0 as idx:0 qsize:192 prog_fd: 33 (cpus_count:1)

Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          0       667,952        0           0
XDP-RX          total   667,952        0
cpumap-enqueue    0:0   667,952        550,150     7.82       bulk-average
cpumap-enqueue  sum:0   667,952        550,150     7.82       bulk-average
cpumap_kthread  0       117,821        0           0
cpumap_kthread  total   117,821        0           0
redirect_err    total   0              0
xdp_exception   total   0              0

2nd remote XDP/eBPF prog_name: xdp_redirect_dummy
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  0       117,822        0           0
xdp-in-kthread  total   117,822        0           0

Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          0       667,871        0           0
XDP-RX          total   667,871        0
cpumap-enqueue    0:0   667,877        550,820     7.82       bulk-average
cpumap-enqueue  sum:0   667,877        550,820     7.82       bulk-average
cpumap_kthread  0       117,041        0           0
cpumap_kthread  total   117,041        0           0
redirect_err    total   0              0
xdp_exception   total   0              0

2nd remote XDP/eBPF prog_name: xdp_redirect_dummy
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  0       117,041        0           0
xdp-in-kthread  total   117,041        0           0

Running XDP/eBPF prog_name:xdp_cpu_map5_lb_hash_ip_pairs
XDP-cpumap      CPU:to  pps            drop-pps    extra-info
XDP-RX          0       667,856        0           0
XDP-RX          total   667,856        0
cpumap-enqueue    0:0   667,849        549,672     7.82       bulk-average
cpumap-enqueue  sum:0   667,849        549,672     7.82       bulk-average
cpumap_kthread  0       118,177        0           0
cpumap_kthread  total   118,177        0           0
redirect_err    total   0              0
xdp_exception   total   0              0

2nd remote XDP/eBPF prog_name: xdp_redirect_dummy
XDP-cpumap      CPU:to  xdp-pass       xdp-drop    xdp-redir
xdp-in-kthread  0       118,177        0           0
xdp-in-kthread  total   118,177        0           0

 ########################################################################

As stmmac driver is using page_pool mechanism, I waited > 1min after
each of above apps is terminated to make sure there is no stalled
pool warning prints on the terminal, and I found none which looks good
on Intel mGbE platform.

It will be great if community help tes out these patch series on your
platform and provide me feedback.

Thank you very much,
Boon Leong

Ong Boon Leong (6):
  stmmac: intel: set IRQ affinity hint for multi MSI vectors
  net: stmmac: make SPH enable/disable to be configurable
  net: stmmac: arrange Tx tail pointer update to
    stmmac_flush_tx_descriptors
  net: stmmac: Add initial XDP support
  net: stmmac: Add support for XDP_TX action
  net: stmmac: Add support for XDP_REDIRECT action

 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |   7 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  35 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 502 +++++++++++++++---
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.c  |  40 ++
 .../net/ethernet/stmicro/stmmac/stmmac_xdp.h  |  12 +
 6 files changed, 523 insertions(+), 74 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h

-- 
2.25.1

