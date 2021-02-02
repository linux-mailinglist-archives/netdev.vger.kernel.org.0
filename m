Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77A030B472
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 02:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbhBBBIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 20:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:49512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhBBBIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 20:08:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8D7164ED5;
        Tue,  2 Feb 2021 01:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612228089;
        bh=HfTcAnfQ4iAzb7u15VeHndW50x4z6oxpZsDgOo9+EFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QJBV4DsrK9C/1XWMcVnH4bUYUs9Ajo9+pgdMv/WXxW1iqNeSAZVY7g0EqENbpG2sn
         RsaZOljtTP4CopKZMhPiD93dZpm0xOmVe18UX8VL9m6uyDNrsqrO0x1SEgCYpW3oMr
         /0LoOXujelFJHeqZom4fu1Y2snvYy/VDWEUS1qfDseSncOut7o372FVw28pB1c7l8H
         2286RQf0S1RhaJUf2HLOowjubyVmO9f7gQvxxso9x0TMO8pFxuofXgGsdMCzr4Nw8f
         37lxAfblyDknCv0vccwwXXVv5brGduFwVsA/u2L9sC42JjVyQYWih5F3o1vnsJVMpG
         A4gnc2JrEZAjg==
Date:   Mon, 1 Feb 2021 17:08:06 -0800
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
Message-ID: <20210201170806.1861e49a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKOOJTzRs5xLwGHFDvCAhK8v88stoPhzrbg-hPBte9c+ia0yxg@mail.gmail.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
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
        <20210201142029.4b7bd903@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKOOJTzRs5xLwGHFDvCAhK8v88stoPhzrbg-hPBte9c+ia0yxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 16:14:05 -0800 Edwin Peer wrote:
> > > Yes, there would be multiple link modes that map to the same speed and
> > > lane combination, but that doesn't mean you need to accept them if the
> > > media doesn't match what's plugged in also. In the above scenario, the
> > > supported mask should not list SR because CR is physically plugged in.
> > > That way, the user knows what options are legal and the kernel knows
> > > what it can reject.  
> >
> > If the modes depend on what's plugged in - what happens if cable gets
> > removed? We (you, Danielle, I) can agree what we think is best, but
> > history teaches us that doesn't matter in long run. We had a similar
> > conversation when it comes to FEC. There simply is no way for upstream
> > developers to review the behavior is correct.  
> 
> Given that supported is only defined in the context of autoneg today,
> once could still specify. But again, you raise a fair concern.
> 
> The asymmetry in interface is still ugly though, you get to decide
> which ugly is worse. :P

Let's move with this series as is. We can see how prevalent the use of
link_mode is on get side first.
