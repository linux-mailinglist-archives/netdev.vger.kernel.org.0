Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00092E7CB3
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 22:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgL3VhA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 16:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgL3VhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 16:37:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC98720729;
        Wed, 30 Dec 2020 21:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609364179;
        bh=1Ym+e+9d5Jew+tsP9PJkFg9A5av6c950ans6mHJgXCw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vHwrh2ybrA0FChpQGV7Mx22iYQ+i/H4wO85jFD5/AZioCgCI6bDeXnUYyvejlIPql
         3CZ8A8uZCmpEUfLmUZmWMepR9fFxg8+I3IWR0d0bTOqskIwx9xAPAk+WF8Cid9zfWa
         CyOJCB5rZ7LGRR8Xz3GRWWhT0y4xsDh+hT859BCMysSepK/jtLxXhMXi2O5avO05Yu
         C/HQ6j6cJMKQmBbbqpjj1xTrZFRP/u2HceOOYaezwfz9kGU4IrflkCkZhZ+5msTLLl
         /9TFITjFVR7IPMBFGO3FLq1E9hJxtWw23cGSiE52QOEmwyu/83luiUfagjlgkv/ul0
         pRqkwX/PRQ1iA==
Date:   Wed, 30 Dec 2020 13:36:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201230133618.7c242856@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228211417.m5gdnqexjzgt4ix6@chatter.i7.local>
References: <20201223153304.GD3198262@lunn.ch>
        <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201223210044.GA3253993@lunn.ch>
        <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
        <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201224180631.l4zieher54ncqvwl@chatter.i7.local>
        <fc7be127-648c-6b09-6f00-3542e0388197@gmail.com>
        <20201228202302.afkxtco27j4ahh6d@chatter.i7.local>
        <08e2b663-c144-d1bb-3f90-5e4ef240d14b@gmail.com>
        <20201228211417.m5gdnqexjzgt4ix6@chatter.i7.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 16:14:17 -0500 Konstantin Ryabitsev wrote:
> On Mon, Dec 28, 2020 at 01:05:26PM -0800, Florian Fainelli wrote:
> > On 12/28/2020 12:23 PM, Konstantin Ryabitsev wrote:  
> > > On Thu, Dec 24, 2020 at 01:57:40PM -0800, Florian Fainelli wrote:  
> > >>>> Konstantin, would you be willing to mod the kernel.org instance of
> > >>>> patchwork to populate Fixes tags in the generated mboxes?  
> > >>>
> > >>> I'd really rather not -- we try not to diverge from project upstream if at all
> > >>> possible, as this dramatically complicates upgrades.  
> > >>
> > >> Well that is really unfortunate then because the Linux developer
> > >> community settled on using the Fixes: tag for years now and having
> > >> patchwork automatically append those tags would greatly help maintainers.  
> > > 
> > > I agree -- but this is something that needs to be implemented upstream.
> > > Picking up a one-off patch just for patchwork.kernel.org is not the right way
> > > to go about this.  
> > 
> > You should be able to tune this from the patchwork administrative
> > interface and add new tags there, would not that be acceptable?  
> 
> Oh, oops, I got confused by the mention of a rejected upstream patch -- I
> didn't realize that this is already possible with a configuration setting.
> 
> Sure, I added a match for ^Fixes: -- let me know if it's not doing the right
> thing.

I used this one for a test:

https://patchwork.kernel.org/project/netdevbpf/patch/1609312994-121032-1-git-send-email-abaci-bugfix@linux.alibaba.com/

I'm not getting the Fixes tag when I download the mbox.
