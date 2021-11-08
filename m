Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81054449921
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbhKHQMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:12:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236099AbhKHQME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:12:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D052761038;
        Mon,  8 Nov 2021 16:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636387760;
        bh=7CNd4po5W6zKOYXmUQ878mG5xFvVcTmoqKd54bOk1r0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZCLj7zfW+rzumbTsnoFv2Y2/ZOX2pdyesCg3TT8ruFXHBiyx0sfbVWSxiAbEBag7M
         rv99zogpjQq6s8Fmb4G6/r+k463yGaYR3HpACbj13x3fR5nACjA5OVUdNlWbX+443J
         5aZ1KOSFwY33NFX/95Fej58yhvxt0bxzAjT+nGqBIb3UxnEjvB050HSgIJfYLwmzRO
         WUKoO0WYpAabuhuKK0aHL1e+NL7v2gwkEUhXb0ezJr74B+qtZZK47HSzsx394isoYM
         q9CjJivL+sUNLNuFEimRtQkjiW/REgF/mgKhbY9tf1rnZ0GY1dfbSWvB6iBGSGi6x+
         BlbJ2DcP3du6A==
Date:   Mon, 8 Nov 2021 08:09:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211108080918.2214996c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YYgSzEHppKY3oYTb@unreal>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
        <YYABqfFy//g5Gdis@nanopsycho>
        <YYBTg4nW2BIVadYE@shredder>
        <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
        <YYgJ1bnECwUWvNqD@shredder>
        <YYgSzEHppKY3oYTb@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Nov 2021 19:54:20 +0200 Leon Romanovsky wrote:
> > >  (3) should we let drivers take refs on the devlink instance?  
> > 
> > I think it's fine mainly because I don't expect it to be used by too
> > many drivers other than netdevsim which is somewhat special. Looking at
> > the call sites of devlink_get() in netdevsim, it is only called from
> > places (debugfs and trap workqueue) that shouldn't be present in real
> > drivers.  
> 
> Sorry, I'm obligated to ask. In which universe is it ok to create new
> set of API that no real driver should use?

I think it's common sense. We're just exporting something to make our
lives easier somewhere else in the three. Do you see a way in which
taking refs on devlink can help out-of-tree code?

BTW we can put the symbols in a namespace or under a kconfig, to aid
reviews of drivers using them if you want.
