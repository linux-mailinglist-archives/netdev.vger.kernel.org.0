Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA1259B04B
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 22:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbiHTUL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 16:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHTUL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 16:11:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0C0645C
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 13:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31235B80B27
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 20:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92956C433C1;
        Sat, 20 Aug 2022 20:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661026281;
        bh=FPdu5uWgLlx/Cyozp7jUXNPkaf77tbdlm2mkXAV0bZQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C6Yh5a45gwKe/I/7qytwGrRTWCXbbcv71THBFuJEc8ywdOeNE/WmTg2JaOQKbgFA5
         SwIvp2Zc+lsGDX3fOOKZykvF6W1UwtQNml+mfnzAbh4X6DzrEzU5c+RmDPd1Wj6OUL
         SQE3A4BBdEEqMdkLNGol4nciOveM5sxP/mCjkGHmaFT4Oazb6AGsW5uuIE4Iz7qmMv
         lm+HzakXZCGJl0VbIknGXNDjyzDqAyObF15GOcgVQZ7WRlkhUR/EA+lHmHxx79IwvN
         sQwOmC46NErMVh8934UuWMJP1UeYo28dmpTcO3hulBBAJEjIk1sCTGlJoklHBWv/1V
         Cziwg10HihxcA==
Date:   Sat, 20 Aug 2022 13:11:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <20220820131115.35dc83ee@kernel.org>
In-Reply-To: <YwB0yeXEDxHm5Sxx@nanopsycho>
References: <20220818130042.535762-1-jiri@resnulli.us>
        <20220818130042.535762-5-jiri@resnulli.us>
        <20220818195301.27e76539@kernel.org>
        <Yv9F4EpjURQF0Dnd@nanopsycho>
        <20220819145459.1a7c6a61@kernel.org>
        <YwB0yeXEDxHm5Sxx@nanopsycho>
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

On Sat, 20 Aug 2022 07:44:41 +0200 Jiri Pirko wrote:
> >The entire dev info / dev flash interface was driven by practical needs
> >of the fleet management team @Facebook / Meta.
> >
> >What would make the changes you're making more useful here would be if
> >instead of declaring the "default" component, we declared "overall"
> >component. I.e. the component which is guaranteed to encompass all the
> >other versions in "stored", and coincidentally is also the default
> >flashed one.  
> 
> It is just semantics.

You say that like it's a synonym for irrelevance. Semantics are
*everything* for the uAPI :)

> Default is what we have now and drivers are using
> it. How, that is up to the driver. I see no way how to enforce this, do
> you?

Not sure I understand. We document the thing clearly as "this is the
overall and must include all parts of stored FW", name it appropriately.
If someone sneaks in code which abuses the value for something else,
nothing we can do, like with every driver API we have.

The "default" gives user information but to interpret that information
user is presupposed to know the semantics of the components. Of what
use is knowing that default is component A if I don't know that it's
the component I want to flash. And if so why don't I just say
"component A"?

> But anyway, I can split the patchset in 2:
> 1) sanitize components
> 2) default/overall/whatever
> If that would help.

Sure thing, seems like a practical approach.

On second thought the overall may not be practical, there are sometimes
critical components on the board you don't really want to flash unless
you really have to. CPLDs and stuff. So perhaps we should scratch (2)
altogether until we have a clear need...
