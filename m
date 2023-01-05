Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9265E2E8
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 03:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjAECWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 21:22:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjAECWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 21:22:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 337584435C
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 18:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2231B81716
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 02:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C32C433D2;
        Thu,  5 Jan 2023 02:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672885339;
        bh=HjzjMbLzhl2ssW43FjBRM98AkRLrbhOXKPcFQ9siPGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n84x2teH/FzbJy79P7zP3dv5++qGtgqAWNzEMmC7iyBiBkDJ4hUe7Q2yyPBE2sNne
         A8x8VCmO5ZVJBQj+EJhaNHMmic03w2D+22pCv2WX+/GxNWVuAiJK65OQ8MH4zYxJhN
         J3Dz//kwNqIQqlUric+7fdUfBDFIuK/ExlaZhV4RTRLRNWG5Mo0a2qU6YrkfZv/Xo6
         15V2g5kpIAYLqMOW3tC6VaFarSu0S7zoDdtH3OzCxkGWO35fRAiMQYw4wPfTjweRTZ
         a9pcYS35fviBd+4knAg43bbkkqVOYdAEFEMFPwkxdgfJdokZq6c5uGQUY+r8gi19M7
         wzVOr4Ueojzvw==
Date:   Wed, 4 Jan 2023 18:22:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 05/14] devlink: use an explicit structure for
 dump context
Message-ID: <20230104182218.33ac9da5@kernel.org>
In-Reply-To: <Y7VPES6vqZWEMqwM@nanopsycho>
References: <20230104041636.226398-1-kuba@kernel.org>
        <20230104041636.226398-6-kuba@kernel.org>
        <Y7VPES6vqZWEMqwM@nanopsycho>
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

On Wed, 4 Jan 2023 11:04:01 +0100 Jiri Pirko wrote:
> Wed, Jan 04, 2023 at 05:16:27AM CET, kuba@kernel.org wrote:
> >Create a dump context structure instead of using cb->args
> >as an unsigned long array. This is a pure conversion which
> >is intended to be as much of a noop as possible.
> >Subsequent changes will use this to simplify the code.
> >
> >The two non-trivial parts are:
> > - devlink_nl_cmd_health_reporter_dump_get_dumpit() checks args[0]
> >   to see if devlink_fmsg_dumpit() has already been called (whether
> >   this is the first msg), but doesn't use the exact value, so we
> >   can drop the local variable there already
> > - devlink_nl_cmd_region_read_dumpit() uses args[0] for address
> >   but we'll use args[1] now, shouldn't matter  
> 
> I don't follow this. Where do you use args[1]? you mean
> dump->start_offset?

Yes, it used to be stored at the start of the args/cb buffer,
now it's stored after index, even tho index is not used.

> If yes, it does not matter at all and I think
> mentioning that only confuses reader (as it did for me).

I think that's fine. I want a note for myself that I knew the "binary
layouts" are changed.

> >diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
> >index e01ba7999b91..bcc930b7cfcf 100644
> >--- a/net/devlink/leftover.c
> >+++ b/net/devlink/leftover.c
> >@@ -1222,9 +1222,10 @@ static void devlink_rate_notify(struct devlink_rate *devlink_rate,
> > static int devlink_nl_cmd_rate_get_dumpit(struct sk_buff *msg,
> > 					  struct netlink_callback *cb)
> > {
> >+	struct devlink_nl_dump_state *dump = devl_dump_state(cb);  
> 
> Could this be named "state" or "dump_state"? "dump" is not what it is.

Sure...
