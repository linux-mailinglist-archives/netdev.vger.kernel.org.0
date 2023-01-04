Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B520B65CD9E
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 08:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbjADHbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 02:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjADHbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 02:31:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8678A450
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 23:30:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D9DDCE129C
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 07:30:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEFCC433D2;
        Wed,  4 Jan 2023 07:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672817453;
        bh=lFYoUVqHj6tlGcNUOZEuJpGGwp7meS6IQuw4OMoNHc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XverRD4Q3nIWRS9tIxBmggPaCTZ4TaLFZhygCkywQEKOY8xqnqRm4ABWSQHTO9YWl
         nk/wU3CrY202mYQCUJT9okdv8je8NlnV5w2D9CWMxFSnglG+S6P+uHWvDhrB1ItkUx
         Ao3DwHa8SNelOFrXdrrSgkTeTYN0uoJ1Q9mx9O4mWd+T20ni+2TBp3KLc61wy0Tokg
         BAvNN7y2/oAULVO2nrOEWxZKSjvIRgGME9vn63CE+WS/5G5BeWrz0LM0yi/KhjBpAZ
         7rszhIaz/itIHHtUM2l/ElXEjrPSfmBTR1CAnzs1rJw9pWvnaSwp6omuImwqo4AbE1
         EWO/I80DX5S2w==
Date:   Wed, 4 Jan 2023 09:30:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/3] igc: remove I226 Qbv BaseTime restriction
Message-ID: <Y7UrKJn54RQPaxJu@unreal>
References: <20230103230503.1102426-1-anthony.l.nguyen@intel.com>
 <20230103230503.1102426-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103230503.1102426-2-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 03:05:01PM -0800, Tony Nguyen wrote:
> From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> 
> Remove the Qbv BaseTime restriction for I226 so that the BaseTime can be
> scheduled to the future time. A new register bit of Tx Qav Control
> (Bit-7: FutScdDis) was introduced to allow I226 scheduling future time as
> Qbv BaseTime and not having the Tx hang timeout issue.
> 
> Besides, according to datasheet section 7.5.2.9.3.3, FutScdDis bit has to
> be configured first before the cycle time and base time.
> 
> Indeed the FutScdDis bit is only active on re-configuration, thus we have
> to set the BASET_L to zero and then only set it to the desired value.
> 
> Please also note that the Qbv configuration flow is moved around based on
> the Qbv programming guideline that is documented in the latest datasheet.
> 
> Co-developed-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_base.c    | 29 +++++++++++++
>  drivers/net/ethernet/intel/igc/igc_base.h    |  2 +
>  drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
>  drivers/net/ethernet/intel/igc/igc_main.c    |  5 ++-
>  drivers/net/ethernet/intel/igc/igc_tsn.c     | 44 +++++++++++++-------
>  5 files changed, 65 insertions(+), 16 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
