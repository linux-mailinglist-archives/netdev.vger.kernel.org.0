Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD2B353873
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbhDDOSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 10:18:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33334 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229633AbhDDOSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 10:18:37 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lT3a7-00Em5v-7i; Sun, 04 Apr 2021 16:18:27 +0200
Date:   Sun, 4 Apr 2021 16:18:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        eric.dumazet@gmail.com, mkubecek@suse.cz, f.fainelli@gmail.com,
        acardace@redhat.com, irusskikh@marvell.com, gustavo@embeddedor.com,
        magnus.karlsson@intel.com, ecree@solarflare.com, idosch@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com
Subject: Re: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Message-ID: <YGnKs/k0ed0NwTwe@lunn.ch>
References: <20210404081433.1260889-1-danieller@nvidia.com>
 <20210404081433.1260889-2-danieller@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210404081433.1260889-2-danieller@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 04, 2021 at 11:14:32AM +0300, Danielle Ratson wrote:
> Some drivers clear the 'ethtool_link_ksettings' struct in their
> get_link_ksettings() callback, before populating it with actual values.
> Such drivers will set the new 'link_mode' field to zero, resulting in
> user space receiving wrong link mode information given that zero is a
> valid value for the field.

That sounds like the bug, that 0 means something, not that the
structure is zeroed. It is good practice to zero structures about to
be returned to user space otherwise you could leak stack information
etc.

Do we still have time to fix the KAPI, so zero means unset? Where in
the workflow is the patch adding this feature? Is it in a released
kernel? or -rc kernel?

> Fix this by introducing a new capability bit ('cap_link_mode_supported')
> to ethtool_ops, which indicates whether the driver supports 'link_mode'
> parameter or not. Set it to true in mlxsw which is currently the only
> driver supporting 'link_mode'.
> 
> Another problem is that some drivers (notably tun) can report random
> values in the 'link_mode' field. This can result in a general protection
> fault when the field is used as an index to the 'link_mode_params' array
> [1].
> 
> This happens because such drivers implement their set_link_ksettings()
> callback by simply overwriting their private copy of
> 'ethtool_link_ksettings' struct with the one they get from the stack,
> which is not always properly initialized.
> 
> Fix this by making sure that the implied parameters will be derived from
> the 'link_mode' parameter only when the 'cap_link_mode_supported' is set.

So you left in place the kernel memory leak to user space? Or is there
an additional patch to fix tun as well?

   Andrew
