Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867911B0B2A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgDTMyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728950AbgDTMxv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:53:51 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAE1C206DD;
        Mon, 20 Apr 2020 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587387231;
        bh=AqeoMsaREBe+ByYuI8OlaAnafpi4yqJaR+sdlU66q9E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gExvF0YWY7t5RpU5+awzuSaCYAQbIPLTySe7GqX5OKMa9TZjZIOx+lrtjiXGgPd4O
         fsWs7So0kA9LO2Mqb/p+Fxleb/Gk2qx/dYRSPvMHlCcCTPLY4aR/iimh6lWug8aj57
         GVWFQTN+uvqBcbzidArAttUIrfcTRfZ+k/NKNwAo=
Date:   Mon, 20 Apr 2020 08:53:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Or Gerlitz <gerlitz.or@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for
 representors
Message-ID: <20200420125349.GI1809@sasha-vm>
References: <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
 <20200414205755.GF1068@sasha-vm>
 <41174e71-00e1-aebf-b67d-1b24731e4ab3@solarflare.com>
 <20200416000009.GL1068@sasha-vm>
 <779d89c8-1e49-fbb6-8b4f-824767d70cc2@solarflare.com>
 <20200416184924.GN1068@sasha-vm>
 <c9496a54-1b68-5d49-6866-d357c75f7a82@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9496a54-1b68-5d49-6866-d357c75f7a82@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 12:45:36PM +0100, Edward Cree wrote:
>On 16/04/2020 19:49, Sasha Levin wrote:
>> Just a question while I process your explanation (thanks for doing it!):
>> wouldn't this be done by the neural network?
>Yes, in the basic case.  (Hopefully we're agreed that this is a long way
> from "I'm not sure what a fixes tag has to do with inclusion in a stable
> tree.", which is how this whole brouhaha started.)

My point was more that having or not having a fixes tag on it's own
doesn't guarantee inclusion in the stable trees - that's why we have and
explicit stable tag. What was said was (for me) the equivalent of "my
commit message contains the word 'panic', why wasn't it picked?"

A Fixes tag affects the probability of a commit being picked up by
AUTOSEL, yes, but it's not a reliable way to include or exclude patches
from the stable tree.

It may also sound counter-intuitive but my long term plan (hope) is for
AUTOSEL to die because maintainers got better at tagging patches. I
don't want to keep doing this forever :)

>> It learns what a stable worthy commit is (and what isn't), and applies
>> weights based on these findings, right? So if it learns that most
>> non-stable commits don't have a fixes tag, it's likely to use that and
>> "require" other inputs to have enough weight to compensate over a
>> missing fixes tag so that it'll pass the threshold, no?
>Yes.  The problem comes when there are other inputs the NN doesn't have,
> that ought to screen off some of the information it's using.  This is
> probably best illustrated by an unrealistic extreme case...

It's actually not that unrealistic. We have a few subsystems that
do a great job with patch selection, and I usually don't find any other
patches to pick up from there, while some other subsystems in the kernel
require us to pick almost every patch that flows in there (think files
that contain device quirks for example).

I've tried to address that by also including the modified filename into
the inputs of the NN, so that the NN is better at acting differently
based on the subsystem/filename being patched.

For mlx5, for example, there are two ways it would differentiate it from
everything else:

 - Commit subject lines usually start with net/mlx5, which is used as
   input to the NN.
 - Filenames touch drivers/net/ethernet/mellanox/mlx5/*

Anyway, yes - I understand your bigger point here around missing
information from the NN. I'd like to think that based on previous
experience it does a good job of balancing everything, but I might be
mistaken.

>Let's imagine hypothetically that the maintainer of drivers/blub is an
> absolutely perfect judge of which patches should go to -stable, and
> that the transmission path from him to the stable trees never loses a
> patch.  This would mean that every autosel patch in drivers/blub is
> necessarily a false positive, because all the 'true positives' it might
> have found have already been taken out of the pool, so to speak.  But
> if the NN is just trained to discriminate patches on whether they end
> up going to stable, it won't see any difference between a drivers/blub
> patch that the maintainer sent to stable straight away and a
> drivers/wibble patch that the latter's less diligent maintainer didn't
> forward and that only got picked up later when a stable kernel user
> encountered the bug it was fixing.
>As long as the NN doesn't have that piece of information, it's going to
> either generate lots of false positives in drivers/blub or lots of
> false negatives in drivers/wibble.
>Now obviously drivers/blub doesn't exist, no maintainer is 100% perfect
> at -stable submissions; but any difference will produce the same
> effect on a smaller scale, with the 'blubbish' maintainers seeing a
> high false positive fraction while from the 'wibblesome' maintainer's
> point of view autosel is working great.  And since the 'blubs' are the
> ones who're putting effort of their own into stable selection already,
> they get aggrieved at having to also put effort into catching the
> false positives from a system that doesn't seem to be doing much for
> them, and everyone ends up shouting at each other as we're seeing here.
>
>(Do you want me to do another worked numerical example demonstrating the
> above, or does it make enough sense in words not to need one?)

Nope, the example above works, thanks!

-- 
Thanks,
Sasha
