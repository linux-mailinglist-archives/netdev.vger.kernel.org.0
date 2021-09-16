Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1082140DBBF
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhIPNx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:53:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235830AbhIPNx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DAEB60EB4;
        Thu, 16 Sep 2021 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631800326;
        bh=8ELhNZODoBEnLGmVtTcOezvWfOBIyyv5HdPY1TeJV+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tsSVmF47v39BfdWENa8eDDjjWXd1w54uLiCVo0OyD/iwal2WWQUWRKElcy9tGmzet
         ZSL2SC2x/5W+CyvSCbBy3lp2ksaLuT7f3EPo1d8KtsWT70jlmSvDcfXMGrMZJpjAtH
         X3sPJcyYS4dcFlOneQnnYq1ZoMt+M04v/w1hqd5T0C4dqPSYjiUt1EWFehxNhMXcHF
         I3FNx/YV3+zgFOr6+VwUVICNBS+9bPQw4T+zuB92XUA8k1iZA5SDYEZLrAzs9NwpSc
         Gt0eeNtedigIl82YUE97pe6kAKzqMf6YLl0GKDz5IRdfTAJdLJZ5Y7zLfC8fVmcmKZ
         x59mD59iuEpuw==
Date:   Thu, 16 Sep 2021 16:52:02 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: Delete not-used devlink APIs
Message-ID: <YUNMAi0Qjj5Dxiiw@unreal>
References: <a45674a8cb1c1e0133811d95756357b787673e52.1631788678.git.leonro@nvidia.com>
 <20210916063318.7275cadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916063318.7275cadf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 06:33:18AM -0700, Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 13:38:33 +0300 Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Devlink core exported generously the functions calls that were used
> > by netdevsim tests or not used at all.
> > 
> > Delete such APIs with one exception - devlink_alloc_ns(). That function
> > should be spared from deleting because it is a special form of devlink_alloc()
> > needed for the netdevsim.
> 
> Do you have a reason to do this or are you just cleaning up?

Yes for both questions. The trigger was my need to move parameter
notifications to be delayed till devlink register (like you asked). At
some point of time, I realized that devlink_*_publish() API is rubbish
and can be deleted (integrated into devlink_register). So I started to
cleanup as much as possible.

> 
> The fmsg functions are not actually removed, just unexported.
> Are there out of tree drivers abusing them?

I don't know, but exported symbols pollute symbols table and the less we
have there, the better will be for everyone.

> 
> The port_param functions are "symmetric" with the global param 
> ones. Removing them makes the API look somewhat incomplete.

There is no value in having "complete" API that no one uses.

> 
> Obviously the general guidance is that we shouldn't export 
> functions which have no upstream users but that applies to 
> meaningful APIs. For all practical purposes this is just a 
> sliver of an API, completeness gives nice warm feelings.

It is misleading, I have much more warm feeling when I see API that is
used. Once it will be needed, the next developer will copy/paste it
pretty fast.

> 
> Anyway, just curious what made you do this. I wouldn't do it 
> myself but neither am I substantially opposed.

Move of devlink_register() to be last command in the devlink init flow
and removal of devlink_*_publish() calls as an outcome of that.

Thanks
