Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFF8B59A802
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiHSVzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHSVzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:55:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1F7B7ED8
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBE5617AD
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 21:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B453FC433D6;
        Fri, 19 Aug 2022 21:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660946101;
        bh=2y8zfuR53HsCdJQT+JPJCUKX96OvlxY4bQz1LtJXa/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fGukmHrlqDuhtU62OOQZLamEeDz9SCrHWo6JsyllGUQXssNAvNyW9FfO0AcIWdPtK
         +1LVNFy9EMd0kCG8fpBQ5PUcB2pnL6g7j/6X0z4t8pDApwsSYAdWwAjMOTiTFGl0Iu
         hxMBQhuhMW5OvaIh7zp4/QzmD//ydqk46EIpXWkGLjmdzizg60zcYg2I9OM6zzOQFx
         9JizhMp/70mzrQ7jnp7Yjb0w2uXk08hQxLNygoGXWpuTKmEMIyvOEkUfZ6NN8drHA3
         bkPQxLw9/tb8PsMPNAecTFO68nO8psz10fLLW4AalKMy1J+RmCeqKb2seB0iZ2jsx8
         l04RYSZdAvynw==
Date:   Fri, 19 Aug 2022 14:54:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <20220819145459.1a7c6a61@kernel.org>
In-Reply-To: <Yv9F4EpjURQF0Dnd@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
        <20220818130042.535762-5-jiri@resnulli.us>
        <20220818195301.27e76539@kernel.org>
        <Yv9F4EpjURQF0Dnd@nanopsycho>
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

On Fri, 19 Aug 2022 10:12:16 +0200 Jiri Pirko wrote:
> Fri, Aug 19, 2022 at 04:53:01AM CEST, kuba@kernel.org wrote:
> >On Thu, 18 Aug 2022 15:00:42 +0200 Jiri Pirko wrote:  
> >> Allow driver to mark certain version obtained by info_get() op as
> >> "flash update default". Expose this information to user which allows him
> >> to understand what version is going to be affected if he does flash
> >> update without specifying the component. Implement this in netdevsim.  
> >
> >My intuition would be that if you specify no component you're flashing
> >the entire device. Is that insufficient? Can you explain the use case?  
> 
> I guess that it up to the driver implementation. I can imagine arguments
> for both ways. Anyway, there is no way to restrict this in kernel, so
> let that up to the driver.

To be clear - your intent is to impose more structure on the relation
between the dev info and dev flash, right? But just "to be safe",
there's no immediate need to do this?

The entire dev info / dev flash interface was driven by practical needs
of the fleet management team @Facebook / Meta.

What would make the changes you're making more useful here would be if
instead of declaring the "default" component, we declared "overall"
component. I.e. the component which is guaranteed to encompass all the
other versions in "stored", and coincidentally is also the default
flashed one.

That way the FW version reporting can be simplified to store only one
version.
