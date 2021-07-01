Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4683B9614
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbhGASWo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Jul 2021 14:22:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39564 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbhGASWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 14:22:40 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lz1IB-0006iC-D2; Thu, 01 Jul 2021 18:20:03 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id EF88C5FDD5; Thu,  1 Jul 2021 11:20:01 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id E83A7A040B;
        Thu,  1 Jul 2021 11:20:01 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     joamaki@gmail.com
cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com
Subject: Re: [PATCH bpf-next v2 0/4] XDP bonding support
In-reply-to: <20210624091843.5151-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210624091843.5151-1-joamaki@gmail.com>
Comments: In-reply-to joamaki@gmail.com
   message dated "Thu, 24 Jun 2021 09:18:39 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31458.1625163601.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 01 Jul 2021 11:20:01 -0700
Message-ID: <31459.1625163601@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

joamaki@gmail.com wrote:

>From: Jussi Maki <joamaki@gmail.com>
>
>This patchset introduces XDP support to the bonding driver.
>
>The motivation for this change is to enable use of bonding (and
>802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
>XDP and also to transparently support bond devices for projects that
>use XDP given most modern NICs have dual port adapters.  An alternative
>to this approach would be to implement 802.3ad in user-space and
>implement the bonding load-balancing in the XDP program itself, but
>is rather a cumbersome endeavor in terms of slave device management
>(e.g. by watching netlink) and requires separate programs for native
>vs bond cases for the orchestrator. A native in-kernel implementation
>overcomes these issues and provides more flexibility.
>
>Below are benchmark results done on two machines with 100Gbit
>Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
>16-core 3950X on receiving machine. 64 byte packets were sent with
>pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
>ice driver, so the tests were performed with iommu=off and patch [2]
>applied. Additionally the bonding round robin algorithm was modified
>to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
>of cache misses were caused by the shared rr_tx_counter. Fix for this
>has been already merged into net-next. The statistics were collected 
>using "sar -n dev -u 1 10".
>
> -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
> without patch (1 dev):
>   XDP_DROP:              3.15%      48.6Mpps
>   XDP_TX:                3.12%      18.3Mpps     18.3Mpps
>   XDP_DROP (RSS):        9.47%      116.5Mpps
>   XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
> -----------------------
> with patch, bond (1 dev):
>   XDP_DROP:              3.14%      46.7Mpps
>   XDP_TX:                3.15%      13.9Mpps     13.9Mpps
>   XDP_DROP (RSS):        10.33%     117.2Mpps
>   XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
> -----------------------
> with patch, bond (2 devs):
>   XDP_DROP:              6.27%      92.7Mpps
>   XDP_TX:                6.26%      17.6Mpps     17.5Mpps
>   XDP_DROP (RSS):       11.38%      117.2Mpps
>   XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
> --------------------------------------------------------------

	To be clear, the fact that the performance numbers for XDP_DROP
and XDP_TX are lower for "with patch, bond (1 dev)" than "without patch
(1 dev)" is expected, correct?

	-J

>RSS: Receive Side Scaling, e.g. the packets were sent to a range of
>destination IPs.
>
>[1]: https://cilium.io/blog/2021/05/20/cilium-110#standalonelb
>[2]: https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/T/#t
>[3]: https://lore.kernel.org/bpf/CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com/
>
>Patch 1 prepares bond_xmit_hash for hashing xdp_buff's
>Patch 2 adds hooks to implement redirection after bpf prog run
>Patch 3 implements the hooks in the bonding driver. 
>Patch 4 modifies devmap to properly handle EXCLUDE_INGRESS with a slave device.
>
>v1->v2:
>- Split up into smaller easier to review patches and address cosmetic 
>  review comments.
>- Drop the INDIRECT_CALL optimization as it showed little improvement in tests.
>- Drop the rr_tx_counter patch as that has already been merged into net-next.
>- Separate the test suite into another patch set. This will follow later once a
>  patch set from Magnus Karlsson is merged and provides test utilities that can
>  be reused for XDP bonding tests. v2 contains no major functional changes and
>  was tested with the test suite included in v1.
>  (https://lore.kernel.org/bpf/202106221509.kwNvAAZg-lkp@intel.com/T/#m464146d47299125d5868a08affd6d6ce526dfad1)
>
>---
>
>Jussi Maki (4):
>  net: bonding: Refactor bond_xmit_hash for use with xdp_buff
>  net: core: Add support for XDP redirection to slave device
>  net: bonding: Add XDP support to the bonding driver
>  devmap: Exclude XDP broadcast to master device
>
> drivers/net/bonding/bond_main.c | 431 +++++++++++++++++++++++++++-----
> include/linux/filter.h          |  13 +-
> include/linux/netdevice.h       |   5 +
> include/net/bonding.h           |   1 +
> kernel/bpf/devmap.c             |  34 ++-
> net/core/filter.c               |  25 ++
> 6 files changed, 445 insertions(+), 64 deletions(-)
>
>-- 
>2.27.0

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
