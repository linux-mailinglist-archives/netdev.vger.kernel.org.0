Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0085B4F95D8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiDHMf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiDHMf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:35:26 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC063408B1;
        Fri,  8 Apr 2022 05:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649421202; x=1680957202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XRRTHcC3vib6U8pYsXScDVRRZguO7b/FSE9Su8vSm/M=;
  b=bWzSEBFm26TNweia8ol7JU5R0vs//P7U0Ap5x+LqkBGETB03c6wTAg4d
   Jz/jKRJHCTAJY+y2cayWfqTGyFYUdODGPExoIt9jZRWFbkQLoq3qNKLz8
   pvud4cYBzxBseWZf2V3Gigr1Lznlqmw92LNrWvL0lYyAT0sOZ96fEraR8
   xjPDCsMSl05HHgtH0os1N1iZy12mQUlcQirNXSXzAsgGKUAoPjqMS9VBh
   oLeyC33IRYS6U8qW7Fa0y39/GsZs0aPh9bo6FpBhZargfh5zWHWHhKUcf
   hxM2f6+etlIGLq5zGcaj++7Yro1Nk2eNeZKAOEU4cXqEVtE7Zu9rbUNXk
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="249111951"
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="249111951"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 05:33:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,245,1643702400"; 
   d="scan'208";a="525361097"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga006.jf.intel.com with ESMTP; 08 Apr 2022 05:33:19 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 238CXHcv017340;
        Fri, 8 Apr 2022 13:33:17 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Brett Creeley <brett@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net] ice: arfs: fix use-after-free when freeing @rx_cpu_rmap
Date:   Fri,  8 Apr 2022 14:31:20 +0200
Message-Id: <20220408123120.1829671-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404161509.3489310-1-alexandr.lobakin@intel.com>
References: <20220404161509.3489310-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>
Date: Mon, 4 Apr 2022 18:15:09 +0200

> The CI testing bots triggered the following splat:
> 
> [  718.203054] BUG: KASAN: use-after-free in free_irq_cpu_rmap+0x53/0x80
> [  718.206349] Read of size 4 at addr ffff8881bd127e00 by task sh/20834
> [  718.212852] CPU: 28 PID: 20834 Comm: sh Kdump: loaded Tainted: G S      W IOE     5.17.0-rc8_nextqueue-devqueue-02643-g23f3121aca93 #1
> [  718.219695] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0012.070720200218 07/07/2020
> [  718.223418] Call Trace:
> [  718.227139]
> [  718.230783]  dump_stack_lvl+0x33/0x42
> [  718.234431]  print_address_description.constprop.9+0x21/0x170
> [  718.238177]  ? free_irq_cpu_rmap+0x53/0x80
> [  718.241885]  ? free_irq_cpu_rmap+0x53/0x80
> [  718.245539]  kasan_report.cold.18+0x7f/0x11b
> [  718.249197]  ? free_irq_cpu_rmap+0x53/0x80
> [  718.252852]  free_irq_cpu_rmap+0x53/0x80
> [  718.256471]  ice_free_cpu_rx_rmap.part.11+0x37/0x50 [ice]
> [  718.260174]  ice_remove_arfs+0x5f/0x70 [ice]
> [  718.263810]  ice_rebuild_arfs+0x3b/0x70 [ice]
> [  718.267419]  ice_rebuild+0x39c/0xb60 [ice]
> [  718.270974]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  718.274472]  ? ice_init_phy_user_cfg+0x360/0x360 [ice]
> [  718.278033]  ? delay_tsc+0x4a/0xb0
> [  718.281513]  ? preempt_count_sub+0x14/0xc0
> [  718.284984]  ? delay_tsc+0x8f/0xb0
> [  718.288463]  ice_do_reset+0x92/0xf0 [ice]
> [  718.292014]  ice_pci_err_resume+0x91/0xf0 [ice]
> [  718.295561]  pci_reset_function+0x53/0x80
> <...>
> [  718.393035] Allocated by task 690:
> [  718.433497] Freed by task 20834:
> [  718.495688] Last potentially related work creation:
> [  718.568966] The buggy address belongs to the object at ffff8881bd127e00
>                 which belongs to the cache kmalloc-96 of size 96
> [  718.574085] The buggy address is located 0 bytes inside of
>                 96-byte region [ffff8881bd127e00, ffff8881bd127e60)
> [  718.579265] The buggy address belongs to the page:
> [  718.598905] Memory state around the buggy address:
> [  718.601809]  ffff8881bd127d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> [  718.604796]  ffff8881bd127d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
> [  718.607794] >ffff8881bd127e00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> [  718.610811]                    ^
> [  718.613819]  ffff8881bd127e80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> [  718.617107]  ffff8881bd127f00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
> 
> This is due to that free_irq_cpu_rmap() is always being called
> *after* (devm_)free_irq() and thus it tries to work with IRQ descs
> already freed. For example, on device reset the driver frees the
> rmap right before allocating a new one (the splat above).
> Make rmap creation and freeing function symmetrical with
> {request,free}_irq() calls i.e. do that on ifup/ifdown instead
> of device probe/remove/resume. These operations can be performed
> independently from the actual device aRFS configuration.
> Also, make sure ice_vsi_free_irq() clears IRQ affinity notifiers
> only when aRFS is disabled -- otherwise, CPU rmap sets and clears
> its own and they must not be touched manually.
> 
> Fixes: 28bf26724fdb0 ("ice: Implement aRFS")
> Co-developed-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>

Bah, forgot to mention in v2 that it's an urgent fix. Tony, are you
okay with posting it to netdev or allowing it to go directly to
-net? It's been tested by Ivan already (I had also asked Konrad, but
he hasn't replied yet).

> ---
> From v1[0]:
>  - remove the obsolete `!vsi->arfs_fltr_list` check from
>    ice_free_cpu_rx_rmap() leading to a leak and trace (Ivan).
> 
> [0] https://lore.kernel.org/netdev/20220404132832.1936529-1-alexandr.lobakin@intel.com
> ---

--- 8< ---

> -- 
> 2.35.1

Thanks,
Al
