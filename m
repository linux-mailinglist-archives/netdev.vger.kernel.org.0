Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246CE686328
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbjBAJwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjBAJwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:52:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9540E4E528
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:52:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5170CB820FE
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385C9C433EF;
        Wed,  1 Feb 2023 09:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675245129;
        bh=vBhF2h+B/nFTxFrabiH4C/+hX61thN5oQtcneNFsNzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qflkzj0h1XACs4rZu11axoplKqjTDHzV3pnqSoByQ3BUDu39pBslKylizCEqgvt77
         TDj5hvr28FI9VsWspFno2TuPcg/+9+5iPm3qk4YigEwC5MNpuibzYsKuMYBhxuqsZh
         qBwvks+3sHbsAmFqI6N2a8+/DIKeCyWbsB3e4Svly93lnET6EFxAZ4z/GZsVnnryfZ
         PblN3Z3cHXlcMfOdb/bfHCa7b4atfGtSFqC2TZoVKn7v2/WWHreZ38fucIs10EjQK/
         PjYx45G1FnNKlfbUq7SXbNm8v7dlX18WLucAybwBymH2UprBa8vPHE6WaKRK2aReDm
         VDHTAcrnh9myA==
Date:   Wed, 1 Feb 2023 11:52:04 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        netdev@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 3/6] ice: fix out-of-bounds KASAN warning in virtchnl
Message-ID: <Y9o2ROr61p9umnDY@unreal>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131213703.1347761-4-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:37:00PM -0800, Tony Nguyen wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> KASAN reported:
> [ 9793.708867] BUG: KASAN: global-out-of-bounds in ice_get_link_speed+0x16/0x30 [ice]
> [ 9793.709205] Read of size 4 at addr ffffffffc1271b1c by task kworker/6:1/402
> 
> [ 9793.709222] CPU: 6 PID: 402 Comm: kworker/6:1 Kdump: loaded Tainted: G    B      OE      6.1.0+ #3
> [ 9793.709235] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.00.01.0014.070920180847 07/09/2018
> [ 9793.709245] Workqueue: ice ice_service_task [ice]
> [ 9793.709575] Call Trace:
> [ 9793.709582]  <TASK>
> [ 9793.709588]  dump_stack_lvl+0x44/0x5c
> [ 9793.709613]  print_report+0x17f/0x47b
> [ 9793.709632]  ? __cpuidle_text_end+0x5/0x5
> [ 9793.709653]  ? ice_get_link_speed+0x16/0x30 [ice]
> [ 9793.709986]  ? ice_get_link_speed+0x16/0x30 [ice]
> [ 9793.710317]  kasan_report+0xb7/0x140
> [ 9793.710335]  ? ice_get_link_speed+0x16/0x30 [ice]
> [ 9793.710673]  ice_get_link_speed+0x16/0x30 [ice]
> [ 9793.711006]  ice_vc_notify_vf_link_state+0x14c/0x160 [ice]
> [ 9793.711351]  ? ice_vc_repr_cfg_promiscuous_mode+0x120/0x120 [ice]
> [ 9793.711698]  ice_vc_process_vf_msg+0x7a7/0xc00 [ice]
> [ 9793.712074]  __ice_clean_ctrlq+0x98f/0xd20 [ice]
> [ 9793.712534]  ? ice_bridge_setlink+0x410/0x410 [ice]
> [ 9793.712979]  ? __request_module+0x320/0x520
> [ 9793.713014]  ? ice_process_vflr_event+0x27/0x130 [ice]
> [ 9793.713489]  ice_service_task+0x11cf/0x1950 [ice]
> [ 9793.713948]  ? io_schedule_timeout+0xb0/0xb0
> [ 9793.713972]  process_one_work+0x3d0/0x6a0
> [ 9793.714003]  worker_thread+0x8a/0x610
> [ 9793.714031]  ? process_one_work+0x6a0/0x6a0
> [ 9793.714049]  kthread+0x164/0x1a0
> [ 9793.714071]  ? kthread_complete_and_exit+0x20/0x20
> [ 9793.714100]  ret_from_fork+0x1f/0x30
> [ 9793.714137]  </TASK>
> 
> [ 9793.714151] The buggy address belongs to the variable:
> [ 9793.714158]  ice_aq_to_link_speed+0x3c/0xffffffffffff3520 [ice]
> 
> [ 9793.714632] Memory state around the buggy address:
> [ 9793.714642]  ffffffffc1271a00: f9 f9 f9 f9 00 00 05 f9 f9 f9 f9 f9 00 00 02 f9
> [ 9793.714656]  ffffffffc1271a80: f9 f9 f9 f9 00 00 04 f9 f9 f9 f9 f9 00 00 00 00
> [ 9793.714670] >ffffffffc1271b00: 00 00 00 04 f9 f9 f9 f9 04 f9 f9 f9 f9 f9 f9 f9
> [ 9793.714680]                             ^
> [ 9793.714690]  ffffffffc1271b80: 00 00 00 00 00 04 f9 f9 f9 f9 f9 f9 00 00 00 00
> [ 9793.714704]  ffffffffc1271c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 
> The ICE_AQ_LINK_SPEED_UNKNOWN define is BIT(15). The value is bigger
> than both legacy and normal link speed tables. Add one element (0 -
> unknown) to both tables. There is no need to explicitly set table size,
> leave it empty.
> 
> Fixes: 1d0e28a9be1f ("ice: Remove and replace ice speed defines with ethtool.h versions")
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_common.c |  9 ++++-----
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 21 ++++++++-------------
>  2 files changed, 12 insertions(+), 18 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
