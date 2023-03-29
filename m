Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8781A6CD920
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 14:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjC2MIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 08:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjC2MIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 08:08:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC770268B
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 05:08:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 595FF61CE3
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 12:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D158C433D2;
        Wed, 29 Mar 2023 12:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680091702;
        bh=Fa/Y940PPi+0NkDE1dGeeGoeLgHAxq1UI4wI2N+JRE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YRZP35nP5QaAfAEbon/Sf4A0Wu+S7lUVKY+BbN8H+Mkqu9m/P5arjVE9D9fBR/r5R
         HQFfQXke2l0CFM7pfUfNuSsKCM82BB8ZCYFaxtIf+xSlFHvAHYbx8d/GVRhHAI0WDW
         XO1TlYmveO5XObiJSUTBuytKzyXe8tu/68oqBzOBHaRnH///Nw03K0/m72v/v1Nwpw
         yiV1T/syxDqb7PE4O5MxybemHi/jmamGPkfj2V0MsKo1JysZs8+p6PO70OmemkwOqL
         o5LNSh8YbUhSBoWRAbMfnVIqKkpfCN32yV3jzPy93bhg1h2pwWyuiTExgvMTIMeNC0
         YNTlTBYURtueg==
Date:   Wed, 29 Mar 2023 15:08:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        Brett Creeley <brett.creeley@intel.com>,
        Robert Malz <robertx.malz@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Piotr Raczynski <piotr.raczynski@intel.com>,
        Jakub Andrysiak <jakub.andrysiak@intel.com>
Subject: Re: [PATCH net 2/4] ice: Fix ice_cfg_rdma_fltr() to only update
 relevant fields
Message-ID: <20230329120818.GQ831478@unreal>
References: <20230328172035.3904953-1-anthony.l.nguyen@intel.com>
 <20230328172035.3904953-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328172035.3904953-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 10:20:33AM -0700, Tony Nguyen wrote:
> From: Brett Creeley <brett.creeley@intel.com>
> 
> The current implementation causes ice_vsi_update() to update all VSI
> fields based on the cached VSI context. This also assumes that the
> ICE_AQ_VSI_PROP_Q_OPT_VALID bit is set. This can cause problems if the
> VSI context is not correctly synced by the driver. Fix this by only
> updating the fields that correspond to ICE_AQ_VSI_PROP_Q_OPT_VALID.
> Also, make sure to save the updated result in the cached VSI context
> on success.
> 
> Fixes: 348048e724a0 ("ice: Implement iidc operations")
> Co-developed-by: Robert Malz <robertx.malz@intel.com>
> Signed-off-by: Robert Malz <robertx.malz@intel.com>
> Signed-off-by: Brett Creeley <brett.creeley@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Reviewed-by: Piotr Raczynski <piotr.raczynski@intel.com>
> Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_switch.c | 26 +++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
