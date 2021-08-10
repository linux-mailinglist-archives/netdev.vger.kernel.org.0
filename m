Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A9F3E86CB
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhHJXxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhHJXxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 19:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9387560F38;
        Tue, 10 Aug 2021 23:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628639600;
        bh=Q5guoRN1yQDj+60Z+Dgg/ukOwCqoMx/EGLhf5mLyiGs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r1pWaQNTblIxJYz59sv6mCoqpj+uajcaFH5TKH32XgAd8KDvpvgUZdx4kToW8uroj
         ywsUT3wxedtfOx4efWyXiv/omDBgEpgf4PNqC/ktljjFjrjVIXuRH1NvgsXd1k40pU
         +cNdmXyDdFgMPTlFrf5DUxi8kgA8LMa2Bm8cFUkcsjG7iDWmgsFlDEtRZzhloSEpII
         WVuRRRSD5cApHLCsG6xdbhAESlz27Eup8JuDBiqffR06e5IIYA1p70dy4nAR5VSMHC
         zVgg7Ao2dCw+PLxuuhfGvlVSqkCHq/Le9lzVYSY6QdP1WL5hOKlT7E7/B18t+aeU5P
         akNaONJtmCX6A==
Date:   Tue, 10 Aug 2021 16:53:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org,
        Michael Guralnik <michaelgur@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 0/5] Move devlink_register to be near
 devlink_reload_enable
Message-ID: <20210810165318.323eae24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1628599239.git.leonro@nvidia.com>
References: <cover.1628599239.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Aug 2021 16:37:30 +0300 Leon Romanovsky wrote:
> This series prepares code to remove devlink_reload_enable/_disable API
> and in order to do, we move all devlink_register() calls to be right
> before devlink_reload_enable().
> 
> The best place for such a call should be right before exiting from
> the probe().
> 
> This is done because devlink_register() opens devlink netlink to the
> users and gives them a venue to issue commands before initialization
> is finished.
> 
> 1. Some drivers were aware of such "functionality" and tried to protect
> themselves with extra locks, state machines and devlink_reload_enable().
> Let's assume that it worked for them, but I'm personally skeptical about
> it.
> 
> 2. Some drivers copied that pattern, but without locks and state
> machines. That protected them from reload flows, but not from any _set_
> routines.
> 
> 3. And all other drivers simply didn't understand the implications of early
> devlink_register() and can be seen as "broken".

What are those implications for drivers which don't implement reload?
Depending on which parts of devlink the drivers implement there may well
be nothing to worry about.

Plus devlink instances start out with reload disabled. Could you please
take a step back and explain why these changes are needed.

> In this series, we focus on items #1 and #2.
> 
> Please share your opinion if I should change ALL other drivers to make
> sure that devlink_register() is the last command or leave them in an
> as-is state.

Can you please share the output of devlink monitor and ip monitor link
before and after?  The modified drivers will not register ports before
they register the devlink instance itself.
