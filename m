Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486B33A2057
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFIWo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:44:29 -0400
Received: from mga06.intel.com ([134.134.136.31]:8605 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229534AbhFIWo1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:44:27 -0400
IronPort-SDR: jehhj9TcKCxYstg5ySf54G7n7zy8cNm5kP2kTU2paK5AklU+bMJ1+MAWvAkr9b+SpPlo76tehN
 mQ6AvMoobYKg==
X-IronPort-AV: E=McAfee;i="6200,9189,10010"; a="266339107"
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="266339107"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2021 15:42:31 -0700
IronPort-SDR: cjahPWS7kAOnONc+xPuTzBMz7/8tIAEV9notWVbFXzN8kcOFbjF/fm2GqrVzfGUMLNKybQeVbw
 qi2XpqevSUgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,261,1616482800"; 
   d="scan'208";a="450112114"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jun 2021 15:42:29 -0700
Date:   Thu, 10 Jun 2021 00:29:58 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        j.vosburgh@gmail.com, andy@greyhouse.net, vfalico@gmail.com,
        andrii@kernel.org
Subject: Re: [PATCH bpf-next 1/3] net: bonding: Add XDP support to the
 bonding driver
Message-ID: <20210609222958.GA15209@ranger.igk.intel.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210609135537.1460244-2-joamaki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609135537.1460244-2-joamaki@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 01:55:35PM +0000, Jussi Maki wrote:
> XDP is implemented in the bonding driver by transparently delegating
> the XDP program loading, removal and xmit operations to the bonding
> slave devices. The overall goal of this work is that XDP programs
> can be attached to a bond device *without* any further changes (or
> awareness) necessary to the program itself, meaning the same XDP
> program can be attached to a native device but also a bonding device.
> 
> Semantics of XDP_TX when attached to a bond are equivalent in such
> setting to the case when a tc/BPF program would be attached to the
> bond, meaning transmitting the packet out of the bond itself using one
> of the bond's configured xmit methods to select a slave device (rather
> than XDP_TX on the slave itself). Handling of XDP_TX to transmit
> using the configured bonding mechanism is therefore implemented by
> rewriting the BPF program return value in bpf_prog_run_xdp. To avoid
> performance impact this check is guarded by a static key, which is
> incremented when a XDP program is loaded onto a bond device. This
> approach was chosen to avoid changes to drivers implementing XDP. If
> the slave device does not match the receive device, then XDP_REDIRECT
> is transparently used to perform the redirection in order to have
> the network driver release the packet from its RX ring.  The bonding
> driver hashing functions have been refactored to allow reuse with
> xdp_buff's to avoid code duplication.
> 
> The motivation for this change is to enable use of bonding (and
> 802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
> XDP and also to transparently support bond devices for projects that
> use XDP given most modern NICs have dual port adapters.  An alternative
> to this approach would be to implement 802.3ad in user-space and
> implement the bonding load-balancing in the XDP program itself, but
> is rather a cumbersome endeavor in terms of slave device management
> (e.g. by watching netlink) and requires separate programs for native
> vs bond cases for the orchestrator. A native in-kernel implementation
> overcomes these issues and provides more flexibility.
> 
> Below are benchmark results done on two machines with 100Gbit
> Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
> 16-core 3950X on receiving machine. 64 byte packets were sent with
> pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
> ice driver, so the tests were performed with iommu=off and patch [2]
> applied. Additionally the bonding round robin algorithm was modified
> to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
> of cache misses were caused by the shared rr_tx_counter (see patch
> 2/3). The statistics were collected using "sar -n dev -u 1 10".
> 
>  -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
>  without patch (1 dev):
>    XDP_DROP:              3.15%      48.6Mpps
>    XDP_TX:                3.12%      18.3Mpps     18.3Mpps
>    XDP_DROP (RSS):        9.47%      116.5Mpps
>    XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
>  -----------------------
>  with patch, bond (1 dev):
>    XDP_DROP:              3.14%      46.7Mpps
>    XDP_TX:                3.15%      13.9Mpps     13.9Mpps
>    XDP_DROP (RSS):        10.33%     117.2Mpps
>    XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
>  -----------------------
>  with patch, bond (2 devs):
>    XDP_DROP:              6.27%      92.7Mpps
>    XDP_TX:                6.26%      17.6Mpps     17.5Mpps
>    XDP_DROP (RSS):       11.38%      117.2Mpps
>    XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
>  --------------------------------------------------------------
> 
> RSS: Receive Side Scaling, e.g. the packets were sent to a range of
> destination IPs.
> 
> [1]: https://cilium.io/blog/2021/05/20/cilium-110#standalonelb
> [2]: https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/T/#t
> [3]: https://lore.kernel.org/bpf/CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com/
> 
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c | 441 ++++++++++++++++++++++++++++----
>  include/linux/filter.h          |  13 +-
>  include/linux/netdevice.h       |   5 +
>  include/net/bonding.h           |   1 +
>  kernel/bpf/devmap.c             |  34 ++-
>  net/core/filter.c               |  37 ++-
>  6 files changed, 467 insertions(+), 64 deletions(-)
> 

Could this patch be broken down onto smaller chunks that would be easier
to review? Also please apply the Reverse Christmas Tree rule.

