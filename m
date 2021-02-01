Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D6430B194
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbhBAUaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229646AbhBAUaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 15:30:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5292764E9E;
        Mon,  1 Feb 2021 20:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612211380;
        bh=JxIcDfor9jP7Fad9DG/ZI3rtmesf9j4WlqIJAzvyISA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V1jaGcuJ+Lg/qXVL6Ebwe10DWb+ow90fJuhWHg2ogEF7AH5qUp8hKFYQucdpsOmdr
         DNo6TAjb3lmcUQ7096f8GQ0hvJ/W6tApBYZCBsq7Lvn7ISOTvt56zGyT0RYQ/59iYK
         TWPodjDud/JneWiPSXkirgnN5BmkokTHdJLg589EbNlQm1O+QCVqe/ic+8PRmBy+4v
         u65o1mOWslzxq8dAo1YtT+0LzdX8Tqa8ooXHGogT+DRo4PHvHEHPmupGKjetqkKteT
         T9CVi8pd90gXaQMXfLk/u9KIopm6+fpzC7C/RJeg3eVBDpUiZjqcNw8+s90rJl1GGJ
         88g5UwpVNitKA==
Date:   Mon, 1 Feb 2021 12:29:39 -0800
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
Message-ID: <20210201122939.09c18efa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKOOJTw2Z_SdPNsDeTanSatBLZ7=vh2FGjn_NASVUK2hbK7Q3Q@mail.gmail.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
        <20210120093713.4000363-3-danieller@nvidia.com>
        <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
        <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTx_JHcaL9Wh2ROkpXVSF3jZVsnGHTSndB42xp61PzP9Vg@mail.gmail.com>
        <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
        <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
        <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz>
        <DM6PR12MB4516868A5BD4C2EED7EF818BD8B79@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTy2wSmBjRnbhmD6xQgy1GAdiXAxoRX7APNto4gDYUWNRw@mail.gmail.com>
        <DM6PR12MB45168B7B3516A37854812767D8B69@DM6PR12MB4516.namprd12.prod.outlook.com>
        <CAKOOJTw2Z_SdPNsDeTanSatBLZ7=vh2FGjn_NASVUK2hbK7Q3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 10:14:35 -0800 Edwin Peer wrote:
> On Mon, Feb 1, 2021 at 5:49 AM Danielle Ratson <danieller@nvidia.com> wrote:
> > Ok, ill send another version with the symmetrical side. Ethtool
> > will try to compose a supported link_mode from the parameters from
> > user space and will choose randomly between the supported ones.
> > Sounds ok?  
> 
> I think it should be deterministic. It should be possible to select
> the appropriate mode either based on the current media type or the
> current link mode (which implies a media type). Alternatively, if the
> user space request only specifies a subset, such as speed, fall back
> to the existing behaviour and don't supply the request to the driver
> in the form of a compound link mode in those cases (perhaps indicating
> this by not setting the capability bit). The former approach has the
> potential to tidy up drivers if we decide that drivers providing the
> capability can ignore the other fields and rely solely on link mode,
> the latter is no worse than what we have today.

The media part is beginning to sound concerning. Every time we
under-specify an interface we end up with #vendors different
interpretations. And since HW is programmed by FW in most high 
speed devices we can't even review the right thing is done.

At least it's clear what setting a number of lanes means.
