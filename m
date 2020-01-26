Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34CAD1499D6
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbgAZJos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:44:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbgAZJos (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 04:44:48 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EE6F2071A;
        Sun, 26 Jan 2020 09:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580031887;
        bh=aZkkJOXaYwJ+AFjo1jRUosCaAC+R6oMBmZcyop6jTPY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=niSF4tzni/xSxWTRQYk7PfqnTYgCs3RMVsmY7vGyWBOiWVFq0X2/z0Gy5nrqAF48E
         ctzM0+WUwMSoFlSfZpMq5LaEjCDvJRBtCaBvSqfWDpxXicz3DTh6xjqZMV4DC9A0Zl
         6gRr1pTBoeoTA/jtznsvuxB+8X5hHgiKsBnsxx1g=
Date:   Sun, 26 Jan 2020 11:44:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next v1] net/core: Replace driver version to be
 kernel version
Message-ID: <20200126094444.GE2993@unreal>
References: <20200125161401.40683-1-leon@kernel.org>
 <b0f73391-d7f5-1efe-2927-bed02668f8c5@gmail.com>
 <20200125184958.GA2993@unreal>
 <20200125192435.GD2993@unreal>
 <3ef38b44-a584-d6c4-5d3b-ed2fdfb743ee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ef38b44-a584-d6c4-5d3b-ed2fdfb743ee@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 07:11:49PM -0800, Florian Fainelli wrote:
>
>
> On 1/25/2020 11:24 AM, Leon Romanovsky wrote:
> > On Sat, Jan 25, 2020 at 08:49:58PM +0200, Leon Romanovsky wrote:
> >> On Sat, Jan 25, 2020 at 08:55:01AM -0800, Florian Fainelli wrote:
> >>>
> >>>
> >>> On 1/25/2020 8:14 AM, Leon Romanovsky wrote:
> >>>> From: Leon Romanovsky <leonro@mellanox.com>
> >>>>
> >>>> In order to stop useless driver version bumps and unify output
> >>>> presented by ethtool -i, let's overwrite the version string.
> >>>>
> >>>> Before this change:
> >>>> [leonro@erver ~]$ ethtool -i eth0
> >>>> driver: virtio_net
> >>>> version: 1.0.0
> >>>> After this change:
> >>>> [leonro@server ~]$ ethtool -i eth0
> >>>> driver: virtio_net
> >>>> version: 5.5.0-rc6+
> >>>>
> >>>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>> ---
> >>>>  Changelog:
> >>>>  v1: Resend per-Dave's request
> >>>>      https://lore.kernel.org/linux-rdma/20200125.101311.1924780619716720495.davem@davemloft.net
> >>>>      No changes at all and applied cleanly on top of "3333e50b64fe Merge branch 'mlxsw-Offload-TBF'"
> >>>>  v0: https://lore.kernel.org/linux-rdma/20200123130541.30473-1-leon@kernel.org
> >>>
> >>> There does not appear to be any explanation why we think this is a good
> >>> idea for *all* drivers, and not just the ones that are purely virtual?
> >>
> >> We beat this dead horse too many times already, latest discussion and
> >> justification can be found in that thread.
> >> https://lore.kernel.org/linux-rdma/20200122152627.14903-1-michal.kalderon@marvell.com/T/#md460ff8f976c532a89d6860411c3c50bb811038b
> >>
> >> However, it was discussed in ksummit mailing list too and overall
> >> agreement that version exposed by in-tree modules are useless and
> >> sometimes even worse. They mislead users to expect some features
> >> or lack of them based on this arbitrary string.
> >>
> >>>
> >>> Are you not concerned that this is ABI and that specific userland may be
> >>> relying on a specific info format and we could now be breaking their
> >>> version checks? I do not disagree that the version is not particularly
> >>> useful for in-tree kernel, but this is ABI, and breaking user-space is
> >>> usually a source of support questions.
> >>
> >> See this Linus's response:
> >> "The unified policy is pretty much that version codes do not matter, do
> >> not exist, and do not get updated.
> >>
> >> Things are supposed to be backwards and forwards compatible, because
> >> we don't accept breakage in user space anyway. So versioning is
> >> pointless, and only causes problems."
> >> https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
> >>
> >> I also don't think that declaring every print in the kernel as ABI is
> >> good thing to do. We are not breaking binary ABI and continuing to
> >> supply some sort of versioning, but in unified format and not in wild
> >> west way like it is now.
> >>
> >> So bottom line, if some REAL user space application (not test suites) relies
> >> on specific version reported from ethtool, it is already broken and can't work
> >> sanely for stable@, distros and upstream kernels.
> >
> > And about support questions,
> > I'm already over-asked to update our mlx5 driver version every time some
> > of our developers adds new feature (every week or two), which is insane.
> > So I prefer to have one stable solution in the kernel.
>
> Fair enough, can you spin a new version which provides this background
> discussion and links into your commit message?

Thanks for the feedback, I'm doing it now.

> --
> Florian
