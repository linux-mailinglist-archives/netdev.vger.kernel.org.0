Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46F1114F925
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 18:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgBARXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 12:23:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:54648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgBARXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 12:23:22 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5B4F206F0;
        Sat,  1 Feb 2020 17:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580577801;
        bh=bD2+7qVWpfecl+l4uZ4BGwYljsGIGRg6kBUn9lWjJ2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wS0RkzKmJmT2m2A6ZRwUMgVFrcfjHjAFggNZC5dSmu9S4WIfbKGPkauD9nL7Ys81O
         AwumIMbqbveBa6tZLAF1fCeFWOIgOinWZD1BQNoh+zW9giC1eFHUwlpmKEZlOT8EJa
         46GrtUMyz2M+sCidrt6PBSFt+mSTifq45o3FZKsE=
Date:   Sat, 1 Feb 2020 09:23:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net v2 2/6] netdevsim: disable devlink reload when
 resources are being used
Message-ID: <20200201092320.10a3381b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAMArcTV7jxsYEQ29Ga9Q-DeMsMnfPAtu95TU=afMA4f-eAJmHA@mail.gmail.com>
References: <20200127143015.1264-1-ap420073@gmail.com>
        <20200127200414.41a6d521@cakuba>
        <CAMArcTV7jxsYEQ29Ga9Q-DeMsMnfPAtu95TU=afMA4f-eAJmHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 18:37:58 +0900, Taehee Yoo wrote:
> > > +     mutex_lock(&nsim_bus_dev_ops_lock);  
> >
> > Not sure why we have to lock the big lock here?
> 
> The reason for using this lock is to protect "nsim_dev".
> nsim_dev_take_snapshot_write() uses nsim_dev.
> So if nsim_dev is removed while this function is being used,
> panic will occur.
> nsim_dev is protected by nsim_bus_dev_ops_lock.
> So, this lock should be used.

I see.

> But, I found deadlock because of this lock.
> Structurally, this lock couldn't be used in snapshot_write().
> So, I will find another way.

Could we perhaps use the lock in struct device? Seems like it would 
be a good fit for protecting nsim_dev?
