Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDF0F440D59
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 07:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhJaGe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 02:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJaGeZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 02:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42AB60ED5;
        Sun, 31 Oct 2021 06:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635661914;
        bh=k6wzRQ34RdAPStCifsgHlx/PjT87DqEKVrbkjLAQRTQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3dmFP/1Zk60J4xE8Xg/N8+1LlYdSJ9+YKkDDS03Y33Dld9k+5B1qOOvgPRpOKrGy
         oJSXxZVBBDQ1W5zTAZBxxVn2I3nWtWCtgeiFK7Fl8RM1PUrucf7IkmWAyRuQTvIeH4
         lDSi3l6jJGo8qNpOklbvvnCi6ee0l2jeBSg39s4T/8MhzX1imwb/+2BNTggUFbnQm6
         zMEpQqn/aKNLsP6qkgSXJb9YXwyTCQJJX6cZFhWouNuDzTYCXDYgLDdJsWuVf7gGlP
         /yyy1XHIchLaEnhBqHQrSE7Oh1GVRBDZiCFbybkm21kQ2TuRrzs/7QkvaQWqd71F+9
         CfF81Gh3TL+GA==
Date:   Sun, 31 Oct 2021 08:31:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 4/4] ethtool: don't drop the rtnl_lock half
 way thru the ioctl
Message-ID: <YX44VqMfYDaDFi5r@unreal>
References: <20211030171851.1822583-1-kuba@kernel.org>
 <20211030171851.1822583-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211030171851.1822583-5-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 30, 2021 at 10:18:51AM -0700, Jakub Kicinski wrote:
> devlink compat code needs to drop rtnl_lock to take
> devlink->lock to ensure correct lock ordering.
> 
> This is problematic because we're not strictly guaranteed
> that the netdev will not disappear after we re-lock.
> It may open a possibility of nested ->begin / ->complete
> calls.
> 
> Instead of calling into devlink under rtnl_lock take
> a ref on the devlink instance and make the call after
> we've dropped rtnl_lock.
> 
> We (continue to) assume that netdevs have an implicit
> reference on the devlink returned from ndo_get_devlink_port
> 
> Note that ndo_get_devlink_port will now get called
> under rtnl_lock. That should be fine since none of
> the drivers seem to be taking serious locks inside
> ndo_get_devlink_port.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/net/devlink.h |  8 ++++----
>  net/core/devlink.c    | 45 +++++++------------------------------------
>  net/ethtool/ioctl.c   | 36 ++++++++++++++++++++++++++++++----
>  3 files changed, 43 insertions(+), 46 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
