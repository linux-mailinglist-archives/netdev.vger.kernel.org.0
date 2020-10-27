Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7891C29CB90
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374533AbgJ0VxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506321AbgJ0VxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 17:53:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60EAA20759;
        Tue, 27 Oct 2020 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603835586;
        bh=1EyYbMgnXESCJrZgcJkHCPXuXy4pTAmrSIEq/ouLT6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mbcidQZXBJE42NlSwJH3ea80KKzXLMyjtONn0UScPJtprotSUKUSUKSbpeVreolfj
         vwqLSjalnB5l/YlzBUiHXS0aLTlx0PeYy2ohmJXBuCy5uGYInbc/9lZmZGDtMitjAA
         iLLTJ13hVK2RcdPRXqaXXBsO/9Ls9x9cSkaWj/CA=
Date:   Tue, 27 Oct 2020 14:53:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mkubecek@suse.cz,
        f.fainelli@gmail.com, andrew@lunn.ch, David.Laight@aculab.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next v3] ethtool: Improve compatibility between
 netlink and ioctl interfaces
Message-ID: <20201027145305.48ca1123@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201027145114.226918-1-idosch@idosch.org>
References: <20201027145114.226918-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Oct 2020 16:51:14 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> With the ioctl interface, when autoneg is enabled, but without
> specifying speed, duplex or link modes, the advertised link modes are
> set to the supported link modes by the ethtool user space utility.

> With the netlink interface, the same thing is done by the kernel, but
> only if speed or duplex are specified. In which case, the advertised
> link modes are set by traversing the supported link modes and picking
> the ones matching the specified speed or duplex.

> Fix this incompatibility problem by introducing a new flag in the
> ethtool netlink request header: 'ETHTOOL_FLAG_LEGACY'. The purpose of
> the flag is to indicate to the kernel that it needs to be compatible
> with the legacy ioctl interface. A patch to the ethtool user space
> utility will make sure the flag is set, when supported by the kernel.

I did not look at the legacy code but I'm confused by what you wrote.

IIUC for ioctl it's the user space that sets the advertised.
For netlink it's the kernel.
So how does the legacy flag make the kernel behave like it used to?

If anything LEGACY should mean - don't populate advertised at all,
user space will do it.

Also the semantics of a "LEGACY" flag are a little loose for my taste,
IMHO a new flag attr would be cleaner. ETHTOOL_A_LINKMODES_AUTO_POPULATE?
But no strong feelings.
