Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF48679186
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjAXHEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:04:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAXHD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:03:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F0B6A5D
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 23:03:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B19A4B80F10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986F5C433EF;
        Tue, 24 Jan 2023 07:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674543835;
        bh=/XiPOB//eMcdFLt7koD2d4Qv1aKx1X3AJdAIcoD/EKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ECTDmMmUHzN6tYwNvwdcdXLlG//E8D8Kh1wb7zB0wPtgYsEabvXID4g1JUate+fgA
         uHsKVOGazPwS/yaXXy53kcYg/AJaUDlgS5IzZ25KrlHiVm4oS0rixhxptWeEDIeE7f
         O8gaQGyJjnZjeqfAdGs0LTnIUISXKHIL+fxDR4bZOpBVjyduG9C6/QSdeOGZM096FG
         xv3qvIEf0fbgoxF6Z/w2Kv0MXl/LEwVVbkCHeQEWDtE8cJtK/DIE2Dx1WUYb9gORwO
         k7RmFffLaUlQMK3ETA6SbMhyRuFG0AIZwcmfw7KsmilrccRW8EDYyLU7G2/TPewnck
         ffnJnhZTEEhMg==
Date:   Tue, 24 Jan 2023 08:59:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        netdev@vger.kernel.org, jiri@nvidia.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 1/1] ice: move devlink port creation/deletion
Message-ID: <Y8+B0UctSryV4VPk@unreal>
References: <20230124005714.3996270-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124005714.3996270-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 04:57:14PM -0800, Tony Nguyen wrote:
> From: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
> 
> Commit a286ba738714 ("ice: reorder PF/representor devlink
> port register/unregister flows") moved the code to create
> and destroy the devlink PF port. This was fine, but created
> a corner case issue in the case of ice_register_netdev()
> failing. In that case, the driver would end up calling
> ice_devlink_destroy_pf_port() twice.
> 
> Additionally, it makes no sense to tie creation of the devlink
> PF port to the creation of the netdev so separate out the
> code to create/destroy the devlink PF port from the netdev
> code. This makes it a cleaner interface.
> 
> Fixes: a286ba738714 ("ice: reorder PF/representor devlink port register/unregister flows")
> Signed-off-by: Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
> Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
> There will be a merge conflict when rebasing with next-next.
> 
> Resolution:
> static void ice_remove(struct pci_dev *
>   		ice_remove_arfs(pf);
>   	ice_setup_mc_magic_wake(pf);
>   	ice_vsi_release_all(pf);
>  -	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);
>  +	mutex_destroy(&hw->fdir_fltr_lock);
> + 	ice_devlink_destroy_pf_port(pf);
>   	ice_set_wake(pf);
>   	ice_free_irq_msix_misc(pf);
>   	ice_for_each_vsi(pf, i) {
> 
>  drivers/net/ethernet/intel/ice/ice_lib.c  |  3 ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 25 +++++++++++++++--------
>  2 files changed, 17 insertions(+), 11 deletions(-)

If you seek cleaner interface, you will be better separate
ice_vsi_release_all() to many small building blocks, so unwind will be
symmetrical to probe.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
