Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD654F1A91
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378722AbiDDVSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378957AbiDDQIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 12:08:46 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648A11658B;
        Mon,  4 Apr 2022 09:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649088409; x=1680624409;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6PHKdli6yMieV27humJNaGY5ghRk9BdEvk/8MtJuao=;
  b=V3jSy3059janmNwaVqGt5ykXD5Ds9QeNdPfKkUi8BQA23IYd0Nt13UfA
   ZlF4PTfIiI/hGn/VjLpxpgzuSBKomvpqHiqWkihZTNafQJkFWbGhofRyu
   5UzI4t+HrMjy5Din7vHENZGY4jS8CiEg1dgvCOPrdBgBNRZ7OpMNZkS/O
   cUOrkhdflYagtesLrKSc93TarWCV8j+tKnwj6SqLPNKwWN+vKw1Li+YLQ
   NCcrffgYWtUGP+ealf1gwZeRaZvgbOHn6kp432IV2mgowBKXiYw/RHrFe
   Jhm0Ycgn1CYHV9Ky4PWwROtQ9bCa2vflXsXEzbJLfJAqpILtPY7WL4W0m
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="242691970"
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="242691970"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 09:06:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,234,1643702400"; 
   d="scan'208";a="620052269"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga004.fm.intel.com with ESMTP; 04 Apr 2022 09:06:34 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 234G6XPt009640;
        Mon, 4 Apr 2022 17:06:33 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Brett Creeley <brett@pensando.io>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ice: arfs: fix use-after-free when freeing @rx_cpu_rmap
Date:   Mon,  4 Apr 2022 18:04:27 +0200
Message-Id: <20220404160427.3487813-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404180047.2f84f2ac@ceranb>
References: <20220404132832.1936529-1-alexandr.lobakin@intel.com> <20220404180047.2f84f2ac@ceranb>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ivan Vecera <ivecera@redhat.com>
Date: Mon, 4 Apr 2022 18:00:47 +0200

> On Mon,  4 Apr 2022 15:28:32 +0200
> Alexander Lobakin <alexandr.lobakin@intel.com> wrote:
> 
> > The CI testing bots triggered the following splat:
> > 

--- 8< ---

> >  	pci_save_state(pdev);
> 
> Nacked-by: Ivan Vecera <ivecera@redhat.com>
> 
> Alex, the patch leads to the trace below. Function ice_free_cpu_rx_rmap() does
> not clear affinity notifiers at all so the WARN from free_irq().
> 
> Function ice_remove() calls first ice_remove_arfs() that effectively NULLs
> vsi->arfs_fltr_list. Then ice_vsi_free_irq() is called through
> ice_vsi_release_all() [see call stack] but ice_vsi_free_irq() does not anything
> because vsi->arfs_fltr_list == NULL. This later leads to WARN.
> 
> Could you please apply the following and add to your patch? That check does not
> make sense there.

Oooof, literally no idea how this made into the final patch. I recall
clearly I faced the same issue and fixed it, sorry <O>
Submitting v2 in a moment.

> 
> <code>
> diff --git a/drivers/net/ethernet/intel/ice/ice_arfs.c b/drivers/net/ethernet/intel/ice/ice_arfs.c
> index 97347b796066..fba178e07600 100644
> --- a/drivers/net/ethernet/intel/ice/ice_arfs.c
> +++ b/drivers/net/ethernet/intel/ice/ice_arfs.c
> @@ -577,7 +577,7 @@ void ice_free_cpu_rx_rmap(struct ice_vsi *vsi)
>  {
>         struct net_device *netdev;
>  
> -       if (!vsi || vsi->type != ICE_VSI_PF || !vsi->arfs_fltr_list)
> +       if (!vsi || vsi->type != ICE_VSI_PF)
>                 return;
>  
>         netdev = vsi->netdev;
> </code>
> 
> Call trace:
> [  383.375869] ------------[ cut here ]------------
> [  383.380874] WARNING: CPU: 22 PID: 16430 at kernel/irq/manage.c:2002 free_irq0
> [  383.388966] Modules linked in: ice(E-) rfkill intel_rapl_msr intel_rapl_commd
> [  383.458741] CPU: 22 PID: 16430 Comm: rmmod Tainted: G S      W   E     5.17.4
> [  383.466227] Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.4.4 10/071
> [  383.473709] RIP: 0010:free_irq+0x784/0xb30
> [  383.477816] Code: 0f 85 3a 03 00 00 49 8b 46 78 48 85 c0 0f 84 40 fe ff ff 41
> [  383.496560] RSP: 0018:ff11000118787788 EFLAGS: 00010282
> [  383.501787] RAX: dffffc0000000000 RBX: ff11002209fe6028 RCX: 1fe220044136f718
> [  383.508919] RDX: 0000000000000000 RSI: 0000000000000373 RDI: ff110023d0c74ec0
> [  383.516054] RBP: ff11002209b7b878 R08: 0000000000000000 R09: 0000000000000040
> [  383.523187] R10: ffffffff8d843c3e R11: ffe21c00230f0e93 R12: ff11002209b7b8c0
> [  383.530317] R13: ff11002209b7b800 R14: ff110023160681a0 R15: dffffc0000000000
> [  383.537451] FS:  00007fc0d666a740(0000) GS:ff110017f1780000(0000) knlGS:00000
> [  383.545536] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  383.551285] CR2: 00007eff211ef000 CR3: 000000024fea4001 CR4: 0000000000771ee0
> [  383.558425] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  383.565556] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  383.572695] PKRU: 55555554
> [  383.575413] Call Trace:
> [  383.577864]  <TASK>
> [  383.583126]  devm_free_irq+0x8c/0xc0
> [  383.599905]  ice_vsi_free_irq+0x76d/0xac0 [ice]
> [  383.604464]  ice_vsi_close+0x28/0xa0 [ice]
> [  383.608588]  ice_stop+0x6a/0x80 [ice]
> [  383.612281]  __dev_close_many+0x180/0x290
> [  383.625566]  dev_close_many+0x1ca/0x570
> [  383.677108]  unregister_netdevice_many+0x713/0x1210
> [  383.716741]  unregister_netdevice_queue+0x277/0x340
> [  383.726769]  unregister_netdev+0x18/0x20
> [  383.730701]  ice_vsi_release+0xbd5/0x1250 [ice]
> [  383.742862]  ice_vsi_release_all.part.48+0xea/0x2a0 [ice]
> [  383.748286]  ice_remove+0x346/0x660 [ice]
> [  383.752328]  pci_device_remove+0x9f/0x1f0
> [  383.756346]  device_release_driver_internal+0x153/0x280
> [  383.761575]  driver_detach+0xbb/0x170
> [  383.765249]  bus_remove_driver+0x15d/0x2d0
> [  383.769357]  pci_unregister_driver+0x2d/0x220
> [  383.777911]  ice_module_exit+0xc/0x32 [ice]
> [  383.782121]  __x64_sys_delete_module+0x2c7/0x480
> [  383.800599]  do_syscall_64+0x37/0x80

Thanks,
Al
