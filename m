Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C630435EAA
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhJUKKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:10:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33812 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbhJUKKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:10:42 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 38E2063F38;
        Thu, 21 Oct 2021 12:06:43 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 0/8] Netfilter/IPVS fixes for net
Date:   Thu, 21 Oct 2021 12:08:13 +0200
Message-Id: <20211021100821.964677-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The following patchset contains Netfilter fixes for net:

1) Crash due to missing initialization of timer data in
   xt_IDLETIMER, from Juhee Kang.

2) NF_CONNTRACK_SECMARK should be bool in Kconfig, from Vegard Nossum.

3) Skip netdev events on netns removal, from Florian Westphal.

4) Add testcase to show port shadowing via UDP, also from Florian.

5) Remove pr_debug() code in ip6t_rt, this fixes a crash due to
   unsafe access to non-linear skbuff, from Xin Long.

6) Make net/ipv4/vs/debug_level read-only from non-init netns,
   from Antoine Tenart.

7) Remove bogus invocation to bash in selftests/netfilter/nft_flowtable.sh
   also from Florian.

There will be a relatively simple conflict between net-next and net
after this pull-request, as reported by Stephen Rothwell.

diff --cc net/netfilter/ipvs/ip_vs_ctl.c
index 29ec3ef63edc,cbea5a68afb5..000000000000
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@@ -4090,11 -4096,8 +4096,13 @@@ static int __net_init ip_vs_control_net
	tbl[idx++].data = &ipvs->sysctl_conn_reuse_mode;
	tbl[idx++].data = &ipvs->sysctl_schedule_icmp;
	tbl[idx++].data = &ipvs->sysctl_ignore_tunneled;
+	ipvs->sysctl_run_estimation = 1;
+	tbl[idx++].data = &ipvs->sysctl_run_estimation;
 +#ifdef CONFIG_IP_VS_DEBUG
 +	/* Global sysctls must be ro in non-init netns */
 +	if (!net_eq(net, &init_net))
 +		tbl[idx++].mode = 0444;
 +#endif

Please, pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks.

----------------------------------------------------------------

The following changes since commit 8d6c414cd2fb74aa6812e9bfec6178f8246c4f3a:

  net: prefer socket bound to interface when not in VRF (2021-10-07 07:27:55 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to d9aaaf223297f6146d9d7f36caca927c92ab855a:

  netfilter: ebtables: allocate chainstack on CPU local nodes (2021-10-18 00:23:57 +0200)

----------------------------------------------------------------
Antoine Tenart (1):
      netfilter: ipvs: make global sysctl readonly in non-init netns

Davidlohr Bueso (1):
      netfilter: ebtables: allocate chainstack on CPU local nodes

Florian Westphal (3):
      netfilter: nf_tables: skip netdev events generated on netns removal
      selftests: nft_nat: add udp hole punch test case
      selftests: netfilter: remove stray bash debug line

Juhee Kang (1):
      netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value

Vegard Nossum (1):
      netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xin Long (1):
      netfilter: ip6t_rt: fix rt0_hdr parsing in rt_mt6

 net/bridge/netfilter/ebtables.c                    |   4 +-
 net/ipv6/netfilter/ip6t_rt.c                       |  48 +------
 net/netfilter/Kconfig                              |   2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   5 +
 net/netfilter/nft_chain_filter.c                   |   9 +-
 net/netfilter/xt_IDLETIMER.c                       |   2 +-
 tools/testing/selftests/netfilter/nft_flowtable.sh |   1 -
 tools/testing/selftests/netfilter/nft_nat.sh       | 145 +++++++++++++++++++++
 8 files changed, 164 insertions(+), 52 deletions(-)
