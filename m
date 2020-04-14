Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17121A8D02
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 22:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633519AbgDNU6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 16:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633509AbgDNU56 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Apr 2020 16:57:58 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA18B20644;
        Tue, 14 Apr 2020 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586897877;
        bh=LXAWfPur+JOlBNahRVCBAAsy+QLYz5DcMP8nwPJ3zlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RQHPL1U/2k9xDwXe1ctXo9dOb/1M3o3bVruDxOzHU8hmLv5O6NKQlSsYnu8nBh9Gp
         Scu++PkO4t0RSiCtKoj31/GKmZ+6fpqQJpvnU5hc0yz6PLCYuWZEXbp/BYCfOvPzEV
         r2fdozb2loaK1aaE0XOX49/KFcPt2Stux3bDojUw=
Date:   Tue, 14 Apr 2020 16:57:55 -0400
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
Message-ID: <20200414205755.GF1068@sasha-vm>
References: <20200411231413.26911-1-sashal@kernel.org>
 <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com>
 <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200414015627.GA1068@sasha-vm>
 <CAJ3xEMh=PGVSddBWOX7U6uAuazJLFkCpWQNxhg7dDRgnSdQ=xA@mail.gmail.com>
 <20200414110911.GA341846@kroah.com>
 <CAJ3xEMhnXZB-HU7aL3m9A1N_GPxgOC3U4skF_qWL8z3wnvSKPw@mail.gmail.com>
 <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <a89a592a-5a11-5e56-a086-52b1694e00db@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 04:49:20PM +0100, Edward Cree wrote:
>On 14/04/2020 16:16, Sasha Levin wrote:
>> Are you suggesting that a commit without a fixes tag is never a fix?
>Because fixes are much more likely than non-fixes to have a Fixes tag,
> the absence of a fixes tag is Bayesian evidence that a commit is not
> a fix.  It's of course not incontrovertible evidence, since (as you
> note) some fixes do not have a Fixes tag, but it does increase the
> amount of countervailing evidence needed to conclude a commit is a fix.
>In this case it looks as if the only such evidence was that the commit
> message included the phrase "NULL pointer dereference".

I've pointed out that almost 50% of commits tagged for stable do not
have a fixes tag, and yet they are fixes. You really deduce things based
on coin flip probability?

$ git log --oneline -i --grep "fixes:" v4.19..stable/linux-4.19.y | wc -l
6235
$ git log --oneline v4.19..stable/linux-4.19.y | wc -l
12877

Look at that, most fixes in -stable *don't* have a fixes tag. Shouldn't
your argument be the opposite? If a patch has a fixes tag, it's probably
not a fix?

"it does increase the amount of countervailing evidence needed to
conclude a commit is a fix" - Please explain this argument given the
above.

>> Fixes can (and should) come in during a merge window as well. They are
>> not put on hold until the -rc releases.
>In networking-land, fixes generally go through David's 'net' tree, rather
> than 'net-next'; the only times a fix goes to net-next are when

This is great, but the kernel is more than just net/. Note that I also
do not look at net/ itself, but rather drivers/net/ as those end up with
a bunch of missed fixes.

>a) the code it's fixing is only in net-next; i.e. it's a fix to a previous
> patch from the same merge window.  In this case the fix should not be
> backported, since the code it's fixing will not appear in stable kernels.
>b) the code has changed enough between net and net-next that different
> fixes are appropriate for the two trees.  In this case, only the fix that
> went to 'net' should be backported (since it's the one that's appropriate
> for net, it's probably more appropriate for stable trees too); the fix
> that went to 'net-next' should not.
>Or's original phrasing was that this patch "was pushed to net-next", which
> is not quite exactly the same thing as -next vs. -rc (though it's similar
> because of David's system of closing net-next for the duration of the
> merge window).  And this, again, is quite strong Bayesian evidence that
> the patch should not be selected for stable.
>
>To be honest, that this needs to be explained to you does not inspire
> confidence in the quality of your autoselection process...

Nothing like a personal attack or two to try and make a point?

-- 
Thanks,
Sasha
