Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5381849D07F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 18:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243610AbiAZROi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 12:14:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:22427 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243629AbiAZROh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 12:14:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643217277; x=1674753277;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Gm+FfgFWZBrq3WACKyWlOt0mFvL4irV6PGVJCntaNGI=;
  b=bqtu/ToHhH1x54CstmZeDx0TikCxJkmbGv8arHNGicfXt83Ez9G8BgwO
   uu5+arSOIshsIvWgpkWjhYA+OJFfk/R4C9JZn1IF0mb5TA9GFJC2Kj1hJ
   88JgJeYw5IlNsFgaw7WckKXXsjxefGEA7P129yrZ9dWuELRCNurcitOG1
   sTX3QkxpcQGXmts035ISYWnddx1EPvhL4ndbSQWsGZSA7Ib7ioyJ4qnI2
   jP/kLSRLdNfUnGOi71UusjsEuQln1urhgO4Xz01oaGirocArgIAxUqX1t
   S/VtB4SM/MJTv6dqB44KsQmUu+DXXTAK0ywIeHDV5hhIGECSCaSac+SZY
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="246544813"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="246544813"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 09:13:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="495417755"
Received: from dglazex-mobl3.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.16.112])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 09:13:16 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Corinna Vinschen <vinschen@redhat.com>, intel-wired-lan@osuosl.org,
        netdev@vger.kernel.org
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: Re: [PATCH 1/2 net-next v6] igc: avoid kernel warning when changing
 RX ring parameters
In-Reply-To: <20220119145259.1790015-2-vinschen@redhat.com>
References: <20220119145259.1790015-1-vinschen@redhat.com>
 <20220119145259.1790015-2-vinschen@redhat.com>
Date:   Wed, 26 Jan 2022 09:13:16 -0800
Message-ID: <87zgnimndf.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Corinna Vinschen <vinschen@redhat.com> writes:

> Calling ethtool changing the RX ring parameters like this:
>
>   $ ethtool -G eth0 rx 1024
>
> on igc triggers kernel warnings like this:
>
> [  225.198467] ------------[ cut here ]------------
> [  225.198473] Missing unregister, handled but fix driver
> [  225.198485] WARNING: CPU: 7 PID: 959 at net/core/xdp.c:168
> xdp_rxq_info_reg+0x79/0xd0
> [...]
> [  225.198601] Call Trace:
> [  225.198604]  <TASK>
> [  225.198609]  igc_setup_rx_resources+0x3f/0xe0 [igc]
> [  225.198617]  igc_ethtool_set_ringparam+0x30e/0x450 [igc]
> [  225.198626]  ethnl_set_rings+0x18a/0x250
> [  225.198631]  genl_family_rcv_msg_doit+0xca/0x110
> [  225.198637]  genl_rcv_msg+0xce/0x1c0
> [  225.198640]  ? rings_prepare_data+0x60/0x60
> [  225.198644]  ? genl_get_cmd+0xd0/0xd0
> [  225.198647]  netlink_rcv_skb+0x4e/0xf0
> [  225.198652]  genl_rcv+0x24/0x40
> [  225.198655]  netlink_unicast+0x20e/0x330
> [  225.198659]  netlink_sendmsg+0x23f/0x480
> [  225.198663]  sock_sendmsg+0x5b/0x60
> [  225.198667]  __sys_sendto+0xf0/0x160
> [  225.198671]  ? handle_mm_fault+0xb2/0x280
> [  225.198676]  ? do_user_addr_fault+0x1eb/0x690
> [  225.198680]  __x64_sys_sendto+0x20/0x30
> [  225.198683]  do_syscall_64+0x38/0x90
> [  225.198687]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  225.198693] RIP: 0033:0x7f7ae38ac3aa
>
> igc_ethtool_set_ringparam() copies the igc_ring structure but neglects to
> reset the xdp_rxq_info member before calling igc_setup_rx_resources().
> This in turn calls xdp_rxq_info_reg() with an already registered xdp_rxq_info.
>
> Make sure to unregister the xdp_rxq_info structure first in
> igc_setup_rx_resources.
>
> Fixes: 73f1071c1d29 ("igc: Add support for XDP_TX action")
> Reported-by: Lennert Buytenhek <buytenh@arista.com>
> Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


-- 
Vinicius
