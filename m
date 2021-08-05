Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931C03E1AE9
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240189AbhHESCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233016AbhHESCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 14:02:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5236760E96;
        Thu,  5 Aug 2021 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628186548;
        bh=AZj4JmN/N5elWfE7nTxhmcna7JfDIXrkufu9lK3jRyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=itsgFtLBc+BylJgoU+IFkfBJesGvVcb9Ck5GtU0nRIMTVk12igT0qaBXCa6m9A6Yg
         RGMIEUpXV9QDnMDwsJThbXCZ0gGoLkmkSTrCTPtBfvkO+UDZDORc/euNE7b8MCvE+l
         GeIp/AAkdIfgwj+/EQhZQH6Zm3EelI6++CpHRFdrV1/XL7dDcyR3M1Ldc7iXbRbPmt
         dIv/P0V0bCHcwRn8PK05tls7QJwB+5MsRA4WDYwo7UkMbSeo4O0qWp+T6EIK4foGsz
         ksu8+HoLfJw7NuqD+FrSCbAlgw3Yn9tlfjJ5tGUCipjkQxBVgXTchuARtfKSlcinQj
         Jc3Uoz+jbS2zA==
Date:   Thu, 5 Aug 2021 21:02:23 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when adding
 or deleting ports
Message-ID: <YQwnr/qel0oktItP@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
 <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQvs4wRIIEDG6Dcu@unreal>
 <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQv2v5cTqLvoPc4n@unreal>
 <20210805082756.0b4e61d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQwhf+3oeqOv/OMU@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQwhf+3oeqOv/OMU@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 08:35:59PM +0300, Leon Romanovsky wrote:
> On Thu, Aug 05, 2021 at 08:27:56AM -0700, Jakub Kicinski wrote:
> > On Thu, 5 Aug 2021 17:33:35 +0300 Leon Romanovsky wrote:
> > > On Thu, Aug 05, 2021 at 07:23:42AM -0700, Jakub Kicinski wrote:
> > > > > This is what devlink_reload_disable() returns, so I kept same error.
> > > > > It is not important at all.
> > > > > 
> > > > > What about the following change on top of this patch?  
> > > > 
> > > > LGTM, the only question is whether we should leave in_reload true 
> > > > if nsim_dev->fail_reload is set.  
> > > 
> > > I don't think so, it will block add/delete ports.
> > 
> > As it should, given add/delete ports takes the port_list_lock which is
> > destroyed by down but not (due to the forced failure) re-initialized by
> > up.
> > 
> > If we want to handle adding ports while down we can just bump port
> > count and return, although I don't think there's a practical need
> > to support that.
> 
> Sorry, but for me netdevsim looks like complete dumpster. It was
> intended for fast prototyping, but ended to be huge pile of debugfs
> entries and selftest to execute random flows.
> 
> Do you want me to move in_reload = false line to be after if (nsim_dev->fail_reload)
> check?

BTW, the current implementation where in_reload before if, actually
preserves same behaviour as was with devlink_reload_enable() implementation.

Thanks

> 
> Thanks
