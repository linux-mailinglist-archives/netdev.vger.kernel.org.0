Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429DA4F8BC1
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiDGX3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 19:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiDGX3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 19:29:05 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9D1267F9B;
        Thu,  7 Apr 2022 16:27:00 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1649374017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16Wm5toPM4kAJCuxIXvu2q58XH/MGF2r50DMfTvAbJ0=;
        b=zQl8Xb55m/PzcH1z8OBaTXDEGh5P6zp4UoiI3CayAWBXEexzQamzky/2SoF2mHwvaXTJLz
        6wh0Rd67vsU1mor8dFkySo069KqTF+u7gfGY0Ej2TpzLNifuY7u/ZOSp+WmzB4VQJMMJ0b
        LrSJqF5LV803fxPHRFr0JPFMqhTfQ79QXJiwny1TG0TSAsonCH3BGhd9I6YiXE5xvfSYKy
        YzNus3AKevUD9PfwRNlcI49Dt7YUozcXf3J2iKqSt0DU3Gdlwbl2K2zkdKqeLsLzKi/5rg
        CB+yhcmjN5M5hgj/ve7H8445eGQBR5yiobGMoDVWvRwaEd4GQ2xHOh+AVAwKGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1649374017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=16Wm5toPM4kAJCuxIXvu2q58XH/MGF2r50DMfTvAbJ0=;
        b=HGCCE5bNMMDMKUM8JNgVXr0Khy3LhmuSUKwD0Ngo4ahODDcqfgiO0xtBl5wrGLdava0d9r
        VV7vpDL8D7NqYuCg==
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer: add a function to adjust timeouts to be
 upper bound
In-Reply-To: <Yk1i3WrcVIICAiF0@samus.usersys.redhat.com>
References: <YkfzZWs+Nj3hCvnE@sparkplug.usersys.redhat.com>
 <871qyb35q4.ffs@tglx> <Yk1i3WrcVIICAiF0@samus.usersys.redhat.com>
Date:   Fri, 08 Apr 2022 01:26:56 +0200
Message-ID: <8735iolbjz.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06 2022 at 11:52, Artem Savkov wrote:

> On Tue, Apr 05, 2022 at 05:33:23PM +0200, Thomas Gleixner wrote:
>> On Sat, Apr 02 2022 at 08:55, Artem Savkov wrote:
>> > Is it possible to determine the upper limit of error margin here? My
>> > assumption is it shouldn't be very big, so maybe it would be enough to
>> > account for this when adjusting timeout at the edge of a level.
>> > I know this doesn't sound good but I am running out of ideas here.
>> 
>> Let's just take a step back.
>> 
>> So we know, that the maximal error margin in the wheel is 12.5%, right?
>> That means, if you take your relative timeout and subtract 12.5% then
>> you are in the right ballpark and the earliest expiry will not be before
>> that point obviously, but it's also guaranteed not to expire later than
>> the original timeout. Obviously this will converge towards the early
>> expiry the longer the timeouts are, but it's bound.
>
> Ok, I was trying to avoid a "hole" where any timeout < LVL_GRAN(lvl)
> would be always substantially (LVL_GRAN(lvl) - LVL_GRAN(lvl - 1)) early
> but looks like this is unavoidable with this approach.

Right, but where is the problem you are trying to solve? Does it matter
whether the keepalive timer fires after 28 minutes or after 30 minutes?

Not really. All you are about that it does not fire 2 minutes late. So
what?

>> Also due to the properties of the wheel, the lag of base::clk will
>> obviously only affect those levels where lag >= LVL_GRAN(level).
>
> Is this true? Won't it be enough for the lag to be just
> lag >= (LVL_START(lvl) - adjusted_timeout) for the cases when we cross
> level boundary on adjustment?

The corner case is at the next boundary level. The resulting worst case
there is one jiffy, which is below noise level :)

Thanks,

        tglx
