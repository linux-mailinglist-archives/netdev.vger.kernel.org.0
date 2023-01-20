Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49482674B25
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjATEpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjATEou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:44:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B321C45B2;
        Thu, 19 Jan 2023 20:40:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28B29B827E5;
        Fri, 20 Jan 2023 02:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09285C433D2;
        Fri, 20 Jan 2023 02:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674180787;
        bh=u8dDbUFYR8RUADRQA+v5qkFQmMRfE3fJTqgVtTQnp/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WYyX6YOOHZaWyXRWUXni84h+JsR7JfjGMrkhXUvCj0IsO0kh//xbmJXvbZg5MTZrh
         pz5qocLlxJpVclIaMyhibX/mVtekVPvp6rcuOhfZUzxs8Z+dwOY0B0tzVivT93hzDF
         r95nOW2okayrhOvw9FS7W5OSNEv3ERPqMtRos+Gg3Nrfvlw5gjArzl/uHuEElBr6hv
         NVW6ZR82bfaXolqbzE3NITEx0M4Pw/mn3te9H1j350Q/PmtpbTWDIS0gzgsp7Xqy0s
         o98SpJuvAo4VTCiEXR11x7rC8sErh2r2nAdCA2McPNV+g7O3r9OttnjzhogkNP12dM
         SPxu733SA1KOg==
Date:   Thu, 19 Jan 2023 18:13:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20230119181306.3b8491b1@kernel.org>
In-Reply-To: <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
References: <20230119003613.111778-1-kuba@kernel.org>
        <20230119003613.111778-2-kuba@kernel.org>
        <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
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

On Thu, 19 Jan 2023 21:29:22 +0100 Johannes Berg wrote:
> On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
> > 
> > +Answer requests
> > +---------------
> > +
> > +Older families do not reply to all of the commands, especially NEW / ADD
> > +commands. User only gets information whether the operation succeeded or
> > +not via the ACK. Try to find useful data to return. Once the command is
> > +added whether it replies with a full message or only an ACK is uAPI and
> > +cannot be changed. It's better to err on the side of replying.
> > +
> > +Specifically NEW and ADD commands should reply with information identifying
> > +the created object such as the allocated object's ID (without having to
> > +resort to using ``NLM_F_ECHO``).  
> 
> I'm a bit on the fence on this recommendation (as written).
> 
> Yeah, it's nice to reply to things ... but!
> 
> In userspace, you often request and wait for the ACK to see if the
> operation succeeded. This is basically necessary. But then it's
> complicated to wait for *another* message to see the ID.

Maybe you're looking at this from the perspective of a person tired 
of manually writing the user space code?

If the netlink message handling code is all auto-generated it makes 
no difference to the user...

> We've actually started using the "cookie" in the extack to report an ID
> of an object/... back, see uses of nl_set_extack_cookie_u64() in the
> tree.

... and to the middle-layer / RPC / auto-generated library pulling
stuff out from protocol messages and interpreting them in a special 
way is a typical netlink vortex of magic :(

> So I'm not sure I wholeheartedly agree with the recommendation to send a
> separate answer. We've done that, but it's ugly on both sender side in
> the kernel (requiring an extra message allocation, ideally at the
> beginning of the operation so you can fail gracefully, etc.) and on the
> receiver (having to wait for another message if the operation was
> successful; possibly actually having to check for that message *before*
> the ACK arrives.)

Right, response is before ACK. It's not different to a GET command,
really.

> > +Support dump consistency
> > +------------------------
> > +
> > +If iterating over objects during dump may skip over objects or repeat
> > +them - make sure to report dump inconsistency with ``NLM_F_DUMP_INTR``.  
> 
> That could be a bit more fleshed out on _how_ to do that, if it's not
> somewhere else?

I was thinking about adding a sentence like "To avoid consistency
issues store your objects in an Xarray and correctly use the ID during
iteration".. but it seems to hand-wavy. Really the coder needs to
understand dumps quite well to get what's going on, and then the
consistency is kinda obvious. IDK. Almost nobody gets this right :(

> > +checks
> > +------
> > +
> > +Documentation for the ``checks`` sub-sections of attribute specs.
> > +
> > +unterminated-ok
> > +~~~~~~~~~~~~~~~
> > +
> > +Accept strings without the null-termination (for legacy families only).
> > +Switches from the ``NLA_NUL_STRING`` to ``NLA_STRING`` policy type.  
> 
> Should we even document all the legacy bits in such a prominent place?
> 
> (or just move it after max-len/min-len?)

This is kernel-only info (checks) so I figured it's good enough until
someone takes a more serious stab at supporting legacy families.

> > +Attribute type nests
> > +--------------------
> > +
> > +New Netlink families should use ``multi-attr`` to define arrays.  
> 
> Unrelated to this particular document, but ...
> 
> I'm all for this, btw, but maybe we should have a way of representing in
> the policy that an attribute is used as multi-attr for an array, and a
> way of exposing that in the policy export? Hmm. Haven't thought about
> this for a while.

Informational-only or enforced? Enforcing this now would be another
backward-compat nightmare :(

FWIW I have a set parked on a branch to add "required" bit to policies,
so for per-op policies one can reject requests with missing attrs
during validation.
