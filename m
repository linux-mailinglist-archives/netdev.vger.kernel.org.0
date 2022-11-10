Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2CC624145
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiKJLVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:21:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKJLVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:21:08 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3448C6BDF2;
        Thu, 10 Nov 2022 03:21:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668079267; x=1699615267;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GhT/Zr0Wca7qowe9mj2q8ImjgUUA/WGKHLK1MIIF7K0=;
  b=i0rS+HdE/RBDCNkQcV/iRXyuvS2AS0Aralu21qzoyqCh4EM+zqw/tKHp
   jcdlp200X9j6L/YeSyZwGCRIidJ1wYxUbQfBfvtrxE3Og5DX03NLsBetE
   eZJoNjmWO9yUZJZns1r753yoLa9YeKJpWtoFxFi7Y4QeJzSmRfFkeE4Tp
   uc4+eZJkgVHdkgGsxwCbPJRc1nIdXH9rlfeyzgOxVEogbWbYl1p/4w+LW
   kShcCJhI0l4fRVF9b19FNpwYNyA3QMzjj2+6hDdYSo39z7it1Sb1cgE89
   9ByW6wwdtHlE7ZqrQPTNhvDhfMO2GaUonfKpiy7TVpY8EiOnNNVwsKtkw
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="338038012"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="338038012"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 03:21:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="812007998"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="812007998"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga005.jf.intel.com with ESMTP; 10 Nov 2022 03:21:02 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 2AABL0Zq032554;
        Thu, 10 Nov 2022 11:21:01 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.co,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add xdp support
Date:   Thu, 10 Nov 2022 12:17:47 +0100
Message-Id: <20221110111747.1176760-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
References: <20221109204613.3669905-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Wed, 9 Nov 2022 21:46:09 +0100

> Add support for xdp in lan966x driver. Currently only XDP_PASS and
> XDP_DROP are supported.
> 
> The first 2 patches are just moving things around just to simplify
> the code for when the xdp is added.
> Patch 3 actually adds the xdp. Currently the only supported actions
> are XDP_PASS and XDP_DROP. In the future this will be extended with
> XDP_TX and XDP_REDIRECT.
> Patch 4 changes to use page pool API, because the handling of the
> pages is similar with what already lan966x driver is doing. In this
> way is possible to remove some of the code.
> 
> All these changes give a small improvement on the RX side:
> Before:
> iperf3 -c 10.96.10.1 -R
> [  5]   0.00-10.01  sec   514 MBytes   430 Mbits/sec    0         sender
> [  5]   0.00-10.00  sec   509 MBytes   427 Mbits/sec              receiver
> 
> After:
> iperf3 -c 10.96.10.1 -R
> [  5]   0.00-10.02  sec   540 MBytes   452 Mbits/sec    0         sender
> [  5]   0.00-10.01  sec   537 MBytes   450 Mbits/sec              receiver

A bit confusing name 'max_mtu' which in fact represents the max
frame len + skb overhead (4th patch), but it's more of a personal
taste probably.

For the series:

Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Nice stuff! I hear time to time that XDP is for 10G+ NICs only, but
I'm not a fan of such, and this series proves once again XDP fits
any hardware ^.^

> 
> ---
> v2->v3:
> - inline lan966x_xdp_port_present
> - update max_len of page_pool_params not to be the page size anymore but
>   actually be rx->max_mtu.
> 
> v1->v2:
> - rebase on net-next, once the fixes for FDMA and MTU were accepted
> - drop patch 2, which changes the MTU as is not needed anymore
> - allow to run xdp programs on frames bigger than 4KB
> 
> Horatiu Vultur (4):
>   net: lan966x: Add define IFH_LEN_BYTES
>   net: lan966x: Split function lan966x_fdma_rx_get_frame
>   net: lan966x: Add basic XDP support
>   net: lan96x: Use page_pool API
> 
>  .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
>  .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 181 +++++++++++-------
>  .../ethernet/microchip/lan966x/lan966x_ifh.h  |   1 +
>  .../ethernet/microchip/lan966x/lan966x_main.c |   7 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  33 ++++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  |  76 ++++++++
>  7 files changed, 236 insertions(+), 66 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> 
> -- 
> 2.38.0

Thanks,
Olek
