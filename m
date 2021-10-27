Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF5D43CB7C
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242366AbhJ0OGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:06:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237581AbhJ0OGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:06:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27DF660F38;
        Wed, 27 Oct 2021 14:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635343422;
        bh=f+Ow0ADlK40WUEFmyZfF7nZqar2AcX92ZT6P/TxnJHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FW7/+eZiLJRKgFl95DKaYDAcBjvIHR9gY3vq9tf1RcIoc+tvm1fEILHr/G+H/3rih
         5TAQhmfwDSHOmm9iuxs0t1wT8doify8KtSIH2Qw0b50RkCtPmR06/SZLMNHmRlE7/T
         CLQggXhWog1nLr2WW9oIIiLGy39n8hKA57bZeKc+Sk6IOoJjEFlryCHfaLrEakFNmJ
         z1FiJFKhJtCDWVqgN1wrPvxol22IpO4TkeuxB876hFuecFx3XIybSyQVsiJIeYczGa
         D82PZPYp4gb3YS9HHGjAd4BtCWE/mvL5gFx7a2z/TvBNWbqieNOz102snmmkPBC7vI
         uoWbFIc5gJ0JQ==
Date:   Wed, 27 Oct 2021 07:03:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ariel Elior <aelior@marvell.com>
Cc:     Manish Chopra <manishc@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware
 7.13.20.0
Message-ID: <20211027070341.159b15fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211026193717.2657-1-manishc@marvell.com>
        <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 05:17:43 +0000 Ariel Elior wrote:
> You may recall we had a discussion on this during our last FW upgrade too.

"During our last FW upgrade" is pretty misleading here. The discussion
seems to have been after user reported that you broke their systems:

https://lore.kernel.org/netdev/ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de/

Now you want to make your users' lives even more miserable by pushing
your changes into stable.

> Please note this is not FW which resides in flash, which may or may not be
> updated during the life cycle of a specific board deployment, but rather an
> initialization sequence recipe which happens to contain FW content (as well as
> many other register and memory initializations) which is activated when driver
> loads. We do have Flash based FW as well, with which we are fully backwards and
> forwards compatible. There is no method to build the init sequence in a
> backwards compatible mode for these devices - it would basically mean
> duplicating most of the device interaction logic (control plane and data plane).
> To support these products we need to be able to update this from time to time.

And the driver can't support two versions of init sequence because...?

> Please note these devices are EOLing, and therefore this may well be the last
> update to this FW.

Solid argument.

> The only theoretical way we can think of getting around this if we
> had to is adding the entire thing as a huge header file and have the
> driver compile with it. This would detach the dependency on the FW
> file being present on disk, but has big disadvantages of making the
> compiled driver huge, and bloating the kernel with redundant headers
> filled with what is essentially a binary blob. We do make sure to add
> the FW files to the FW sub tree in advance of modifying the drivers
> to use them.

All the patch is doing is changing some offsets. Why can't you just
make the offset the driver uses dependent on the FW version?

Would be great if the engineer who wrote the code could answer that.
