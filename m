Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC94430B2B4
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 23:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhBAWVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 17:21:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhBAWVL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 17:21:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D99964EC6;
        Mon,  1 Feb 2021 22:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612218031;
        bh=m9kZdIUklqMfoKpttg1aD36/6pS06r4X9JCDlx1X9vg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lspAC1rZxHi8QPbxjaqeKfs/GuiEMWo1DcJYM1gOBrkve+1xvcUfQs0wscD9QaijC
         j1GQ9mr6iRpvG7/f5zX+du1kI57hlkrK3zlUZ5dSPBsb0y8e79/bGobPOQ9K4wUAmA
         9wY5M8IY/ucjoQfpuu/qBkNOHRaj+OKBOJz6Mg3UixYSPrJMijB8zbFr1bDOJXwlzr
         Hw415pbAGh4HyvotRJeivBvdxqRvekAnLPeWALFVTwXIHYbVX7gPzVd4qfdCkRQrcP
         W/VKX0nI4eE2g26xisokc+ScDG7e1extbxR3ZfGjltu3qioX61pLpw9vve280cUtWd
         CQyOnNJUEbx/g==
Date:   Mon, 1 Feb 2021 14:20:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead
 of speed and duplex parameters
Message-ID: <20210201142029.4b7bd903@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKOOJTzcEPXmU=mu8PMvzkhv1CxWbL9pnmjYeYGgJHXnFW5W_g@mail.gmail.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
        <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
        <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
        <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz>
        <DM6PR12MB4516868A5BD4C2EED7EF818BD8B79@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTy2wSmBjRnbhmD6xQgy1GAdiXAxoRX7APNto4gDYUWNRw@mail.gmail.com>
        <DM6PR12MB45168B7B3516A37854812767D8B69@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTw2Z_SdPNsDeTanSatBLZ7=vh2FGjn_NASVUK2hbK7Q3Q@mail.gmail.com>
        <20210201122939.09c18efa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKOOJTw75uLVPpzV1a85SFsO7Gz9bcfS9M1CWHQONCfMLC4H6g@mail.gmail.com>
        <20210201134156.14693076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKOOJTzcEPXmU=mu8PMvzkhv1CxWbL9pnmjYeYGgJHXnFW5W_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 13:59:45 -0800 Edwin Peer wrote:
> On Mon, Feb 1, 2021 at 1:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > Each link mode implies a very specific media type, the kernel can
> > > reject illegal combinations based on the supported bitmask before
> > > calling upon the driver to select it.  
> >
> > Are you talking about validation against a driver-supplied list of
> > HW-supported modes, or SFP-supported modes for a currently plugged
> > in module?  
> 
> Should they not be the same thing?

Okay. Does "supported modes" in ethtool for bnxt get ANDed with the
supported modes of the plugged in module?

What happens when no module is plugged in? List all?

I've surveyed this behavior a few years back and three vendors I tested
all had different interpretation on what to list in supported modes :/

> > The concern is around "what happens if user selected nnG-SR4 but user
> > plugged in nnG-CR4". The MAC/PHY/serdes settings will be identical.  
> 
> Yes, there would be multiple link modes that map to the same speed and
> lane combination, but that doesn't mean you need to accept them if the
> media doesn't match what's plugged in also. In the above scenario, the
> supported mask should not list SR because CR is physically plugged in.
> That way, the user knows what options are legal and the kernel knows
> what it can reject.

If the modes depend on what's plugged in - what happens if cable gets
removed? We (you, Danielle, I) can agree what we think is best, but
history teaches us that doesn't matter in long run. We had a similar
conversation when it comes to FEC. There simply is no way for upstream
developers to review the behavior is correct.
