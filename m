Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D561647ADA
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:39:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiLIAjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLIAjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:39:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916191A38B;
        Thu,  8 Dec 2022 16:39:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F143D620F5;
        Fri,  9 Dec 2022 00:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170FEC433EF;
        Fri,  9 Dec 2022 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670546390;
        bh=mu+QBJKsBbOEPe3vwUNFXgdSpmtahH0lZ/7jz8cGUtg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c+V1MIkJQ1+4wlqIwSgEgYrDMdSdTDElGCQrQSGaMfd8N1WrHjLLmyPXFFCf1qwSo
         xkHkbo6twikXnSyq9XeGiKD+hyrClpNIinTbcKvzhrNAewOA9WfIBGvoeZ4ySg/dyU
         aSMOQ8QcGb6d3cw74rZ3kM0NJca2rLD1Vvkx86vBO7o1JWzX0QTS0hBE1KvIkrEbc6
         b6EtWISwZX8Vrymlkg1t+MVsZPzxRG6CVbYf9ef6YeTMUGbfLMpcG3YItGOUeAITcp
         cAt7c3LWhuUx2Y9svTaoNkYP+pjgjIVk478tH+DimuqEn0CS44iTgu2GZ2sRda19ge
         y6ZeR7cmNnifg==
Date:   Thu, 8 Dec 2022 16:39:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev.dump@gmail.com,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <20221208163949.3833fe7b@kernel.org>
In-Reply-To: <Y5HKczFwRnfRVtnR@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
        <20221206184740.28cb7627@kernel.org>
        <10bb01d90a45$77189060$6549b120$@gmail.com>
        <20221207152157.6185b52b@kernel.org>
        <Y5HKczFwRnfRVtnR@nanopsycho>
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

On Thu, 8 Dec 2022 12:28:51 +0100 Jiri Pirko wrote:
> >I think we discussed using serial numbers.  
> 
> Can you remind it? Do you mean serial number of pin?

Serial number of the ASIC, board or device.
Something will have a serno, append to that your pin id of choice -
et voila!

> >Are you saying within the driver it's somehow easier? The driver state
> >is mostly per bus device, so I don't see how.  
> 
> You can have some shared data for multiple instances in the driver code,
> why not?

The question is whether it's easier.
Easier to ensure quality of n implementations in random drivers. 
Or one implementation in the core, with a lot of clever people
paying attention and reviewing the code.

> >> There are many problems with that approach, and the submitted patch is not
> >> explaining any of them. E.g. it contains the dpll_muxed_pin_register but no
> >> free 
> >> counterpart + no flows.  
> >
> >SMOC.  
> 
> Care to spell this out. I guess you didn't mean "South Middlesex
> Opportunity Council" :D

Simple matter of coding.
