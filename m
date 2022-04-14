Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DD750089B
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 10:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbiDNIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 04:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239558AbiDNIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 04:45:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D712965796;
        Thu, 14 Apr 2022 01:43:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A5536208B;
        Thu, 14 Apr 2022 08:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3406C385A5;
        Thu, 14 Apr 2022 08:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649925791;
        bh=iHZqK4K6Vu+KtomeHU+dePQzrkU7Y2MgGUiDicf1Wms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YfpsG3DHQxvqsl7laZpVeqMWas0uw1WWEfQ7MdGYXDkI0ZdQnz/wgk09mSVBb2cp+
         uGskG3PDsJrK3Z8JEcgBj4VxDusYggKK5JoLf8MzikpDfm7rLDUcQv5qWLWuQXJAz7
         AETSy1Xar9DIGuU+nARBCnLJkDXTKWFu+1dY/4Jp2bsY+luai/i7tHt4D547WhPFi/
         WjbNX37dYJtr5eh7qViBy/zt2jXJziDaxiq0sawamgjY7vg4voXnK5E/LaV0lp9ET+
         pWBh3d0F3tyBLP7Z3Pjo/93FqilmSqUNCoI7keU14fNphnYJMQ8LngUZOnQSyDnGSk
         4qKTDEfb58k2Q==
Date:   Thu, 14 Apr 2022 10:42:59 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp
 checking loop
Message-ID: <20220414104259.0b928249@kernel.org>
In-Reply-To: <20220414072934.GA10025@linux.intel.com>
References: <20220413040115.2351987-1-tee.min.tan@intel.com>
        <20220413125915.GA667752@hoboy.vegasvil.org>
        <20220414072934.GA10025@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Apr 2022 15:29:34 +0800 Tan Tee Min wrote:
> > > --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > > +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> > > @@ -279,10 +279,11 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
> > >  			/* Check if timestamp is OK from context descriptor */
> > >  			do {
> > >  				ret = dwmac4_rx_check_timestamp(next_desc);
> > > -				if (ret < 0)
> > > +				if (ret <= 0)
> > >  					goto exit;
> > >  				i++;
> > >  
> > > +				fsleep(1);  
> > 
> > This is nutty.  Why isn't this code using proper deferral mechanisms
> > like work or kthread?  
> 
> Appreciate your comment.
> The dwmac4_wrback_get_rx_timestamp_status() is called by stmmac_rx()
> function which is scheduled by NAPI framework.
> Do we still need to create deferred work inside NAPI work?
> Would you mind to explain it more in detail?

fsleep() is a big hammer, can you try cpu_relax() and bumping the max
loop count a little?
