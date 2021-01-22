Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA222FFA8C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 03:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbhAVCiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 21:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbhAVCfd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 21:35:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2917C2310A;
        Fri, 22 Jan 2021 02:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611282893;
        bh=EurQiJQecWoCTnrD1RDfuad/c8ytvbujTWZ5ZsQhxJA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K54Z278X8aF8l229ddHSNdOZhhINLL5Aa58v6H6FAgf7UPj5jQ3o6IqdGsF28dpXv
         +V9ceo2lWKQ8yi/glUteqv3Q/UwVpkPvdkqnSFBbS4w+zz91+2/qY/0bMNVjbUmcSR
         ERIGVT7Mlply/he9na5UfGSs5Zf1LSRRHqVB8U8smpXpaZZHH6phw0UrkSQFeTWZ+t
         +3X2m9oFAAq6SX65UpuhRyKdPpg+SCizoESrQF3kuuGs3gkEoTFJaYaCBkQJU2fot3
         mFqVtHBWHMLL6J0/pjx/2JaaFZtx1Vz4ELdEBt9MRxIrMeE0tg9FoNEcYJ+kWsShvo
         5f2zST0fESyDg==
Date:   Thu, 21 Jan 2021 18:34:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        saeed@kernel.org, Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net] team: postpone features update to avoid deadlock
Message-ID: <20210121183452.47f0cffa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121112937.11b72ea6@ceranb>
References: <20210120122354.3687556-1-ivecera@redhat.com>
        <CAM_iQpUqdm-mpSUdsxEtLnq6GwhN=YL+ub--8N0aGxtM+PRfAQ@mail.gmail.com>
        <20210121112937.11b72ea6@ceranb>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 11:29:37 +0100 Ivan Vecera wrote:
> On Wed, 20 Jan 2021 15:18:20 -0800
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Wed, Jan 20, 2021 at 4:56 AM Ivan Vecera <ivecera@redhat.com> wrote:  
> > > Team driver protects port list traversal by its team->lock mutex
> > > in functions like team_change_mtu(), team_set_rx_mode(),

The set_rx_mode part can't be true, set_rx_mode can't sleep and
team->lock is a mutex.

> > > To fix the problem __team_compute_features() needs to be postponed
> > > for these cases.    
> > 
> > Is there any user-visible effect after deferring this feature change?
>
> An user should not notice this change.

I think Cong is right, can you expand a little on your assertion?
User should be able to assume that the moment syscall returns the
features had settled.

What does team->mutex actually protect in team_compute_features()?
All callers seem to hold RTNL at a quick glance. This is a bit of 
a long shot but isn't it just tryin to protect the iteration over 
ports which could be under RCU?

More crude idea would be to wrap the mutex_unlock(&team->lock) into 
a helper which checks if something tried to change features while it
was locked. rtnl_unlock()-style.
