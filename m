Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353CE43D1AB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbhJ0Taz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240761AbhJ0Taw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:30:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A896103C;
        Wed, 27 Oct 2021 19:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635362906;
        bh=kcw33ieZ+6BozOAl8u0SxgljaLwMgNC0cYSj85UdbCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fbrt5wEcS5wh0pSsC+fjfTCFbaOY74aJ0JndrUwGj8kjDz/WGgkl81qQNF1lNCABu
         ZX2eSq7qeeVnsVyb5+kEx6GUYvzB56h88YcGk+MmW3iZwV2A2/mXc+nxGLgPB4aO4x
         BGKH6XshQAkMal5FTDBYc1tpD2NoVlOc3zwTM9rnMqFrBHMbhzXwHj5uROk/f3zUtY
         21ZD7YNRJxjR5/zVBEJP8O+bJkxZp28kix2nydBKeoqgK9W2M4F59oMEUj59LTY19d
         wZZ/bF4k9JCE1WlIJI7LFxQUN0593gQAgEnBXg/XHt++a0ZTUU+eTOuH8oxmU/0JPt
         f3S0froNksEsQ==
Date:   Wed, 27 Oct 2021 12:28:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <20211027122824.5bebb9a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXmlXSs0jXl2k1Y9@unreal>
References: <YXelYVqeqyVJ5HLc@shredder>
        <YXertDP8ouVbdnUt@unreal>
        <YXgMK2NKiiVYJhLl@shredder>
        <YXgpgr/BFpbdMLJp@unreal>
        <20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXhXT/u9bFADwEIo@unreal>
        <20211026125602.7a8f8b7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXjqHc9eCpYy03Ym@unreal>
        <20211027071723.12bd0b29@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YXlthf7pEU/OdnS0@unreal>
        <YXmlXSs0jXl2k1Y9@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 22:15:41 +0300 Leon Romanovsky wrote:
> One of the outcomes is that such chain usually prevents from us to ensure
> proper locking annotation.
> 
> Let's take as an example devlink_trap_policers_register().
> In some drivers, it is called before device_register() and we don't need
> any locks at all, because we are in initialization flow.
> 
> In mlxsw, it is called during devlink reload, and we don't really need to
> lock it too, because we were supposed to lock everything for the reload.
> 
> However, for the mlxsw, we created devlink_trap_policers_register() to be
> dynamic, so we must lock devlink->lock, as we don't know how other users
> of this API will use it.
> 
> In the reality, no one uses it dynamically except mlxsw and we stuck
> with function that calls to useless lock without us able to properly
> annotate it with an invitation to misuse.
> 
> It is an example of layering problem, there are many more subtle issues
> like this that require some cabal knowledge of proper locks to make it
> is safe.

Now that you made me express my opinion I started feeling attached to
my way of thinking :) Let me try to convert devlink core, netdevsim and
nfp to devlink instance locking and see how far I can get...
