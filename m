Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAFC622C50
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 14:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiKINYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 08:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKINYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 08:24:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283ED11165
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 05:24:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7F5961A9D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 13:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9068C433D6;
        Wed,  9 Nov 2022 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668000255;
        bh=homsu4aZZSL2CrgTZ+4wTVXsspTBzyMgK5ZCSWRPYug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sZs42djn475sZBlrh+zYWjpDJjvhHYDfFQwZLP/YWByxUX+MlSKEMQvC1u7ueLHg6
         wg11s/1SVi352uOnPtYqzcioao51AGKI5dQgwYiajAbm4zNJgSaLc94Dfkyh6v6nMu
         oFpKiidWfkINT4YVYf8SIhSWhlT+8CVQX9caUcm5vf6TYuqjNa05CxoAb+1l9gOMC5
         z9pv/FVRn9xRf47gyhQLgCRm25YoBnCDSljI7HfUsIzmGb0AQz8wgXkIvRougSr4cE
         kxgX9IPluBCkdPyCAatfMpuvnFqcC3sRZN+ekjs097gTyUSoVrIrjMu+dsOTryh0Wx
         8gyiheKFCd08g==
Date:   Wed, 9 Nov 2022 15:24:10 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Stefan Assmann <sassmann@kpanic.de>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, patryk.piotrowski@intel.com
Subject: Re: [PATCH net-next] iavf: check that state transitions happen under
 lock
Message-ID: <Y2up+sLH5qN34msN@unreal>
References: <20221028134515.253022-1-sassmann@kpanic.de>
 <Y2gHqj18Tz66k4ZN@unreal>
 <5911b8f9-590b-6e05-646a-c1bc597105d8@kpanic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5911b8f9-590b-6e05-646a-c1bc597105d8@kpanic.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 12:57:42PM +0100, Stefan Assmann wrote:
> On 06.11.22 20:14, Leon Romanovsky wrote:
> 
> > On Fri, Oct 28, 2022 at 03:45:15PM +0200, Stefan Assmann wrote:
> 
> >> Add a check to make sure crit_lock is being held during every state
> 
> >> transition and print a warning if that's not the case. For convenience
> 
> >> a wrapper is added that helps pointing out where the locking is missing.
> 
> >>
> 
> >> Make an exception for iavf_probe() as that is too early in the init
> 
> >> process and generates a false positive report.
> 
> >>
> 
> >> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> 
> >> ---
> 
> >>  drivers/net/ethernet/intel/iavf/iavf.h      | 23 +++++++++++++++------
> 
> >>  drivers/net/ethernet/intel/iavf/iavf_main.c |  2 +-
> 
> >>  2 files changed, 18 insertions(+), 7 deletions(-)
> 
> >>
> 
> >> diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
> 
> >> index 3f6187c16424..28f41bbc9c86 100644
> 
> >> --- a/drivers/net/ethernet/intel/iavf/iavf.h
> 
> >> +++ b/drivers/net/ethernet/intel/iavf/iavf.h
> 
> >> @@ -498,19 +498,30 @@ static inline const char *iavf_state_str(enum iavf_state_t state)
> 
> >>  	}
> 
> >>  }
> 
> >>  
> 
> >> -static inline void iavf_change_state(struct iavf_adapter *adapter,
> 
> >> -				     enum iavf_state_t state)
> 
> >> +static inline void __iavf_change_state(struct iavf_adapter *adapter,
> 
> >> +				       enum iavf_state_t state,
> 
> >> +				       const char *func,
> 
> >> +				       int line)
> 
> >>  {
> 
> >>  	if (adapter->state != state) {
> 
> >>  		adapter->last_state = adapter->state;
> 
> >>  		adapter->state = state;
> 
> >>  	}
> 
> >> -	dev_dbg(&adapter->pdev->dev,
> 
> >> -		"state transition from:%s to:%s\n",
> 
> >> -		iavf_state_str(adapter->last_state),
> 
> >> -		iavf_state_str(adapter->state));
> 
> >> +	if (mutex_is_locked(&adapter->crit_lock))
> 
> > 
> 
> > Please use lockdep for that, and not reinvent it.
> 
> > In you case lockdep_assert_held(&adapter->crit_lock).
> 
> 
> 
> Lockdep is mostly enabled in debug kernel but I was hoping to get
> 
> warnings in production environments as well. As those transitions don't
> 
> happen too often it shouldn't hurt performance.
> 
> 
> 
> > In addition, mutex_is_locked() doesn't check that this specific function
> 
> > is locked. It checks that this lock is used now.
> 
> 
> 
> You are correct, this check only triggers if crit_lock is not locked at
> 
> all. It would be better to check the lock owner, but I couldn't find an
> 
> easy way to do that. Better than no check IMO but we can drop it if you
> 
> don't see a benefit in it.

Yes, please drop it. AFAIK, lockdep doesn't add much overhead while enabled.

Thanks

> 
> 
> 
> Thanks for the comments!
> 
> 
> 
>   Stefan
> 
