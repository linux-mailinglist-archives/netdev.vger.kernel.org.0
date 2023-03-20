Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654A96C164C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbjCTPEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjCTPEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:04:04 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3679229402
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 08:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679324400; x=1710860400;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TRbUmWHnSkE7D/lu5e7kw8nA2AMjXdu8/aiMJ3BeZxs=;
  b=MoOMsPQ7DaKqpqc2KcHJvogAaL0zG7yweqILOiwvjvIzOGKmxpUx0AUN
   K939Y+kJKhQOT9tri2VIlHtF+Tvv50JtGq+JGW0pofVLk8SHSAZKrKm+d
   Ub5jg/aQ2W1tiBP5GN64KIp7Y4MdfscH0DxM0YmXTc/asZOOSYV//v+hK
   Knnp6jNcpNp+YOqSSM0Ol5opDhXKlClo1VVC3VT06Wa8Xa56wM88tIeMa
   YT11Na7Vo/QpxAeF/SS2C3Z+5YG9CuPE+ev7xxwB0BOAcu3sjDHPMaMw1
   XiEfbWROSAIiMHBdTQYUQWNe3Dffq2xe0cFiqv4E/Wmwb8L868p47X1Tt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="322523378"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="322523378"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 07:59:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="770219893"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="770219893"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 07:59:22 -0700
Date:   Mon, 20 Mar 2023 15:59:14 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        piotr.raczynski@intel.com,
        Mateusz Palczewski <mateusz.palczewski@intel.com>
Subject: Re: [PATCH net v2] ice: clear number of qs when rings are free
Message-ID: <ZBh0wpx9kOU1LTDI@localhost.localdomain>
References: <20230320112347.117363-1-michal.swiatkowski@linux.intel.com>
 <20230320115117.GK36557@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320115117.GK36557@unreal>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 01:51:17PM +0200, Leon Romanovsky wrote:
> On Mon, Mar 20, 2023 at 12:23:47PM +0100, Michal Swiatkowski wrote:
> > In case rebuild fails not clearing this field can lead to call trace.
> > 
> > [  +0.009792] BUG: kernel NULL pointer dereference, address: 0000000000000000
> > [  +0.000009] #PF: supervisor read access in kernel mode
> > [  +0.000006] #PF: error_code(0x0000) - not-present page
> > [  +0.000005] PGD 0 P4D 0
> > [  +0.000009] Oops: 0000 [#1] PREEMPT SMP PTI
> > [  +0.000009] CPU: 45 PID: 77867 Comm: ice-ptp-0000:60 Kdump: loaded Tainted: G S         OE      6.2.0-rc6+ #110
> > [  +0.000010] Hardware name: Dell Inc. PowerEdge R740/0JMK61, BIOS 2.11.2 004/21/2021
> > [  +0.000005] RIP: 0010:ice_ptp_update_cached_phctime+0xb0/0x130 [ice]
> > [  +0.000145] Code: fa 7e 55 48 8b 93 48 01 00 00 48 8b 0c fa 48 85 c9 74 e1 8b 51 68 85 d2 75 da 66 83 b9 86 04 00 00 00 74 d0 31 d2 48 8b 71 20 <48> 8b 34 d6 48 85 f6 74 07 48 89 86 d8 00 00 00 0f b7 b1 86 04 00
> > [  +0.000008] RSP: 0018:ffffa036cf7c7ea8 EFLAGS: 00010246
> > [  +0.000008] RAX: 174ab1a8ab400f43 RBX: ffff937cda2c01a0 RCX: ffff937cdca9b028
> > [  +0.000005] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > [  +0.000005] RBP: ffffa036cf7c7eb8 R08: 0000000000000000 R09: 0000000000000000
> > [  +0.000005] R10: 0000000000000080 R11: 0000000000000001 R12: ffff937cdc971f40
> > [  +0.000006] R13: ffff937cdc971f44 R14: 0000000000000001 R15: ffffffffc13f3210
> > [  +0.000005] FS:  0000000000000000(0000) GS:ffff93826f980000(0000) knlGS:0000000000000000
> > [  +0.000006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  +0.000006] CR2: 0000000000000000 CR3: 00000004b7310002 CR4: 00000000007726e0
> > [  +0.000006] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  +0.000004] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [  +0.000005] PKRU: 55555554
> > [  +0.000004] Call Trace:
> > [  +0.000004]  <TASK>
> > [  +0.000007]  ice_ptp_periodic_work+0x2a/0x60 [ice]
> > [  +0.000126]  kthread_worker_fn+0xa6/0x250
> > [  +0.000014]  ? __pfx_kthread_worker_fn+0x10/0x10
> > [  +0.000010]  kthread+0xfc/0x130
> > [  +0.000009]  ? __pfx_kthread+0x10/0x10
> > [  +0.000010]  ret_from_fork+0x29/0x50
> > 
> > ice_ptp_update_cached_phctime() is calling ice_for_each_rxq macro, in
> > case of rebuild fail the rx_ring is NULL and there is NULL pointer
> > dereference.
> > 
> > Also for future safety it is better to clear the size values for tx and
> > rx ring when they are cleared.
> > 
> > Fixes: 6624e780a577 ("ice: split ice_vsi_setup into smaller functions")
> > Reported-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> > Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > ---
> > v1 --> v2:
> >  * change subject to net and add fixes tag
> > ---
> >  drivers/net/ethernet/intel/ice/ice_lib.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> 
> It will be so great if all these ice_for_each_*(*, i) macros will go.
> They do nothing except hide basic for-loop.

Good point, I spent too much time searching which field is used there.
Will try to propose sth.

Thanks for review

> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
