Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5BD674CB4
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjATFpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjATFpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:45:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DA9F8
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 21:45:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E66161E1B
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74343C433EF;
        Fri, 20 Jan 2023 05:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674193518;
        bh=GTrI+ceeC+lwXuxpSEzroCr2PdqpazZnmz3TaFhMlms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TdiMUgPhxNBpwAjmqCtJvb/qVxSYq20Ph1q4+jR6t5TgruzbtHzPQL/3Scmw37dQq
         dHqF4HwJZiC54cGObXmjCzWvfK7HRluDr9PPjYRb51Akv9NWiFmVbi1SvQPtEJdS1l
         dLGg1xFSAmi/X9M0+nKvkpP09hpdgp6zxt78ybESpBMCmayHSeHZ5qIZy7qXWsD6m1
         /T/PL+NcvZMsNwj41/zAqmNr70wPMogIOOhdyIzVZr9HmFq2scaPAekuYQUvCbvPIx
         EQ6seoGM29mP2D86pXGNFApv245P3hkR9Hgj00F4f4ON/+ke9zeErjc8XgStIopavN
         bRpR1bQuwA6Rg==
Date:   Thu, 19 Jan 2023 21:45:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <20230119214516.59adab05@kernel.org>
In-Reply-To: <87k01hu6fb.fsf@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
        <20230118183602.124323-4-saeed@kernel.org>
        <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
        <20230119194631.1b9fef95@kernel.org>
        <87tu0luadz.fsf@nvidia.com>
        <20230119200343.2eb82899@kernel.org>
        <87pmb9u90j.fsf@nvidia.com>
        <20230119210842.5faf1e44@kernel.org>
        <87k01hu6fb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan 2023 21:22:00 -0800 Rahul Rameshbabu wrote:
> > Hm, so are you saying that:
> >
> > adjtime(delta):
> > 	clock += delta
> >
> > but:
> >
> > adjfreq(delta):  
> 
> Did you mean adjphase here?

Yes, sorry

> > 	on clock tick & while delta > 0:
> > 		clock += small_value
> > 		delta -= small_value
> >
> > because from looking at mlx5 driver code its unclear whether the
> > implementation does a precise but one shot adjustment or gradual
> > adjustments.  
> 
> The pseudo code your drafted is accurate otherwise. The lack of clarity
> in our driver comes from leaving the responsibility of that smooth
> gradual transition (to keep in sync with the clock frequency while
> running) up to the device.

Ah, I see. That makes sense. This is how system clocks react too 
or is it a local PTP invention? I think it may be worth documenting 
in ptp_clock_kernel.h, most driver authors may not understand 
the difference between adjtime and adjphase :(
