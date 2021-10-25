Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2C1439E6D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbhJYS1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233065AbhJYS1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 14:27:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 934BF60E0B;
        Mon, 25 Oct 2021 18:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635186294;
        bh=ItVLsYHxU9Aer01gU0UgBUoO2Wtd8doC0Hj80UXw3Sk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tcuBEGUEz0V8oYgpg7SdxBifzCOHBtrX1e1wNcOLC8HIZa1AgBZ9FBfFO6dNWVFmQ
         RAtcxjKdM65KoUYJ+K7ikqDwT7pVVehUMaLbEUv8uz23vWi0P1M2U8ANOtIKHGwI1s
         CVsmhUSd+if+3dTwOgdtDi5KISMi/W3LiwgUyIuk55VXSD3A5//4w1JgS3W1n6lQ+g
         k0TogHgRO0FEcQyoml/hWe4cz/xi5DkXhwU3YSL1Gst3vVO2zSiHz+RQnYGyOX2rqq
         oVPNdavsOc6FE0/yqMOqKl5zQdTXUSo1Bzjaht+B8hhVyl5AzwRaU4S9iyrdhFoJKe
         zyLS/a+n66+AA==
Date:   Mon, 25 Oct 2021 11:24:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        syzbot+93d5accfaefceedf43c1@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] netdevsim: Register and unregister devlink
 traps on probe/remove device
Message-ID: <20211025112453.089519e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YXZl4Gmq6DYSdDM3@shredder>
References: <725e121f05362da4328dda08d5814211a0725dac.1635064599.git.leonro@nvidia.com>
        <YXUhyLXsc2egWNKx@shredder>
        <YXUtbOpjmmWr71dU@unreal>
        <YXU5+XLhQ9zkBGNY@shredder>
        <YXZB/3+IR6I0b2xE@unreal>
        <YXZl4Gmq6DYSdDM3@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Oct 2021 11:08:00 +0300 Ido Schimmel wrote:
> No, it's not correct. After your patch, trap properties like action are
> not set back to the default. Regardless of what you think is the "right
> design", you cannot introduce such regressions.
> 
> Calling devlink_*_unregister() in reload_down() and devlink_*_register()
> in reload_up() is not new. It is done for multiple objects (e.g., ports,
> regions, shared buffer, etc). After your patch, netdevsim is still doing
> it.

If we want to push forward in the direction that Leon advocates we'd
have to unregister the devlink instance before reload_down(), right?

Otherwise it seems fundamentally incompatible with the idea of reload
for reconfig. And we'd be trading one partially correct model for
another partially correct model :/

> Again, please revert the two commits I mentioned. If you think they are
> necessary, you can re-submit them in the future, after proper review and
> testing of the affected code paths.
