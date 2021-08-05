Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2534B3E1BCA
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 20:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241687AbhHESzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 14:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241446AbhHESzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 14:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A656060F3A;
        Thu,  5 Aug 2021 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628189729;
        bh=c0Y49VAWYDL9aHd/TC0IBNp+E9TYi+R1sNukzF6o8ng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AKJVU4IvF08G782A7LQ8d8zYpR9WYGHOxaQz+zcl7AgWJD2ACOJjn3nWM3EkZE+vc
         efyXXxfU0qnZvyZjkzT69xN/dBVOEzLrvkWhBk3LT6jSUfvub3+pjRND9PBpRZmaoo
         vbresr+qFcu63l1eG/UHvT0QdfcP/MQIB5vYmkGZLeWCg50R6cqqNmiNlpvhdA8wwp
         bpRjh8PU6ueiz+w2GvPpuI0K3hwYjmnTdjSwXwD8aOQRws+FuPwnGJdOOD4YM851kI
         rCl3lbX1+t6DgrjC0wUF3ceiVhb1hptqtZ992mfV1AOCMG7G2DC4Hij2d/7Er2EYg2
         dwL6yqMnkzM3A==
Date:   Thu, 5 Aug 2021 11:55:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] ptp: ocp: Expose various resources on the
 timecard.
Message-ID: <20210805115528.2308fed6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210805172623.mwyh4wt3gupfiurd@bsd-mbp.dhcp.thefacebook.com>
References: <20210804033327.345759-1-jonathan.lemon@gmail.com>
        <20210804140957.1fd894dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210804235223.rkyxuvdeowcf7wgl@bsd-mbp.dhcp.thefacebook.com>
        <20210805060326.4c5fbef9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210805172623.mwyh4wt3gupfiurd@bsd-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 10:26:23 -0700 Jonathan Lemon wrote:
> > > We're not talking to the flash yet.  We're writing a new image, but don't
> > > know the image version, since it's not accessible from the FPGA blob.  So
> > > since we're don't know what the stored image is until we reboot, I've set
> > > it to 'pending' here - aka "pending reboot".  Could also be "unknown".  
> > 
> > Having the driver remember that the device was flashed is not a solid
> > indication that the image is actually different. It may be that user
> > flashed the same version, driver may get reloaded and lose the
> > indication.. Let's not make a precedent for (ab) use of the version
> > field to indicate reset required.  
> 
> I'd like to have some way to remind/tell the user that a reset is required.
> 
> Right now, I can only get the running version from the FPGA register, so
> after flashing, there's no way for me to know what's on the flash (or if 
> the flash write failed).  Setting "pending" or "reboot" works for most
> cases - but obviously fails if the driver is reloaded. 
> 
> But most users won't do rmmod/insmod, just a reboot.

I appreciate the problem of knowing if FW activation is required exists
but the way devlink API is intending to solve it is by displaying the
actual versions. Version entries are for carrying versions, not
arbitrary information.

If we assume driver does not get re-initialized / kernel kexeced etc.
we can assume other things, like for example that nothing will mess
with the filesystem. Ergo the flashing process can create a file in 
a well known location on the FS to indicate that reset is pending..
