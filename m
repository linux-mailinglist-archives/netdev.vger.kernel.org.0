Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249F24443E5
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhKCOzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhKCOzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:55:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A32861076;
        Wed,  3 Nov 2021 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635951152;
        bh=2ejPaC8nAbCqgFnAaWVP9eUosgR9R+nUhiI69+13fTY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kG4v5djEQqsQA7etuAOMYuTgbcvxjjc5OpfSblKw1f8p9XIv92fGHFlpuvcgDmhBq
         JB7V4e/cLdqkKV9Ezs4dRREX1IHRS+S6IBnjVygRzk82EGY6y3WtWSZ3DdP3ktgcZb
         whCoLo6BXOotV1HVAHjtan1twUuUpuS8Qc0lo2PsIj3LYzcoEZ7jSu76375tSVReUd
         6ju79JjcFXu5+yLniCxD3ynmK6Nhzyw8OBWS5usTZV4qXxkITS0pCNGxr7rYT3P4Ef
         lr0EXXWJZ/70DAGNUWdo3GEXMkaQ7Oz00Mh603UittRy4EsfKzQrUC6sAS3OCL2Qe+
         4a2X0jxMaGYag==
Date:   Wed, 3 Nov 2021 07:52:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     leon@kernel.org, idosch@idosch.org, edwin.peer@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [RFC 0/5] devlink: add an explicit locking API
Message-ID: <20211103075231.0a53330c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYJQZIJPdy3WnQ1S@nanopsycho>
References: <20211030231254.2477599-1-kuba@kernel.org>
        <YYJQZIJPdy3WnQ1S@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 10:03:32 +0100 Jiri Pirko wrote:
> Hi Jakub.
> 
> I took my time to read this thread and talked with Leon as well.
> My original intention of locking in devlink was to maintain the locking
> inside devlink.c to avoid the rtnl_lock-scenario.
> 
> However, I always feared that eventually we'll get to the point,
> when it won't be possible to maintain any longer. I think may be it.

Indeed, the two things I think we can avoid from rtnl_lock pitfalls 
is that lock should be per-instance and that we should not wait for
all refs to be gone at unregister time.

Both are rather trivial to achieve with devlink.

> In general, I like your approach. It is very clean and explicit. The
> driver knows what to do, in which context it is and it can behave
> accordingly. In theory or course, but the reality of drivers code tells
> us often something different :)

Right. I'll convert a few more drivers but the real test will be
seeing if potential races are gone - hard to measure.

> One small thing I don't fully undestand is the "opt-out" scenario which
> makes things a bit tangled. But perhaps you can explain it a bit more.

Do you mean the .lock_flags? That's a transitional thing so that people
can convert drivers callback by callback to make prettier patch sets. 
I may collapse all those flags into one, remains to be seen how useful
it is when I create proper patches. This RFC is more of a code dump.

The whole opt-out is to create the entire new API at once, and then
convert drivers one-by-one (or allow the maintainers who care to do 
it themselves). I find that easier and more friendly than slicing 
the API and drivers multiple times.

Long story short I expect the opt-out would be gone by the time 5.17
merge window rolls around.

> Leon claims that he thinks that he would be able to solve the locking
> scheme leaving all locking internal to devlink.c. I suggest to give
> him a week or 2 to present the solution. If he is not successful, lets
> continue on your approach.
> 
> What do you think?

I do worry a little bit that our goals differ. Seems like Leon wants to
fix devlink for devlink and I want drivers to be able to lean on it.

But I'm not attached to the exact approach or code, so as long as
nobody is attached to theirs more RFCs can only help.

Please be courteous and send as RFCs, tho.
