Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536AB6B96A4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjCNNpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbjCNNpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:45:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F93BA2244
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:41:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E3CE6177F
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27320C433EF;
        Tue, 14 Mar 2023 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678801316;
        bh=VCuNCB2Nd8eqzlmT6DA3mxSqfFZWH83oN+2wy1z5LdE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KQqrTp+OUZEVsFyt015+WkDtnhcpftGNnw3HRKRjHVn4RhY+6/X/6FjHTfZf5kmSQ
         Q3kbGTMGlONPmaWke15x8vt6wzPROosCooh/ga4T5TaBtL6GauN759wQuI6IH4u7UM
         Slnn0ti6ZwYVinFOoAOBSi5ntzuAvlitiyh6mG/XvUgG7ZFTdLAp4L6Plx6aeOV3HZ
         4WLJVbQx3hg6IxZABg00DZCG54x8MTDZIuX8QgM4nFpYNpne1x6/5h0H3xPKilnS4F
         ZMg72amtf2/vKZFHyhwZSNyxmHb95NALtBNiK/ZYiX3PmAjSbgWnpYPGNepk+DHDgQ
         k03ZbGhZ15aNw==
Date:   Tue, 14 Mar 2023 15:41:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Jacob Keller <jacob.e.keller@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marek Szlosek <marek.szlosek@intel.com>
Subject: Re: [PATCH net-next 02/14] ice: convert ice_mbx_clear_malvf to void
 and use WARN
Message-ID: <20230314134151.GG36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230313182123.483057-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313182123.483057-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:21:11AM -0700, Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The ice_mbx_clear_malvf function checks for a few error conditions before
> clearing the appropriate data. These error conditions are really warnings
> that should never occur in a properly initialized driver. Every caller of
> ice_mbx_clear_malvf just prints a dev_dbg message on failure which will
> generally be ignored.
> 
> Convert this function to void and switch the error return values to
> WARN_ON. This will make any potentially misconfiguration more visible and
> makes future refactors that involve changing how we store the malicious VF
> data easier.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Marek Szlosek <marek.szlosek@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_sriov.c  |  6 ++----
>  drivers/net/ethernet/intel/ice/ice_vf_lib.c | 12 ++++--------
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.c | 16 +++++++---------
>  drivers/net/ethernet/intel/ice/ice_vf_mbx.h |  2 +-
>  4 files changed, 14 insertions(+), 22 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
