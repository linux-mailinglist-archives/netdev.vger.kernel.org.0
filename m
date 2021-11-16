Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538B3452326
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348537AbhKPBUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:20:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379088AbhKPBS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 20:18:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A373C60EFD;
        Tue, 16 Nov 2021 01:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637025331;
        bh=0rU25y9mfqYWLV3BhAiFyo4w9g9gaiidlE6bigX0mBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=REovxO3KbPtssXEeiYftyj5SZLgJVkPvZfC1FGpcVlNrIguMJM/9DZlokiH8Zfn5I
         vGO4EVRW4tJulBTG21EYn1EFV0drnnY9GypRkpPSAR02PcWClAwYQEkXv+g5APU4cd
         MR7UmrVj4NgB5f/E2NH2deReQz4JR6hNna3mqs6Mkw4nnSLUEJKkVrwCyooYNCSCb8
         32I3c4j2TbdCQuYY2pwJs0jHa1UjAL35q9QESF9pzZ5pP5XiRR8/kvR2e5gJYicdB9
         s4uaO3ZbMvLOVLzAmVWJeRJ62uLY55ffA96makjb3YVg3ijoL8JsAdvFAGbZZBOKEm
         UD0uZY3tO1WNA==
Date:   Mon, 15 Nov 2021 17:15:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Amit Cohen <amcohen@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] devlink: Remove extra assertion from flash
 notification logic
Message-ID: <20211115171530.432f5753@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZKmlzhu0gtKpvXW@unreal>
References: <1d750b6f4991c16995c4d0927b709eb23647ff85.1636999616.git.leonro@nvidia.com>
        <20211115101437.33bd531f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZKmlzhu0gtKpvXW@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 20:27:35 +0200 Leon Romanovsky wrote:
> On Mon, Nov 15, 2021 at 10:14:37AM -0800, Jakub Kicinski wrote:
> > On Mon, 15 Nov 2021 20:07:47 +0200 Leon Romanovsky wrote:  
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > The mlxsw driver calls to various devlink flash routines even before
> > > users can get any access to the devlink instance itself. For example,
> > > mlxsw_core_fw_rev_validate() one of such functions.
> > > 
> > > It causes to the WARN_ON to trigger warning about devlink not
> > > registered, while the flow is valid.  
> > 
> > So the fix is to remove the warning and keep generating notifications
> > about objects which to the best understanding of the user space do not
> > exist?  
> 
> If we delay this mlxsw specific notification, the user will get
> DEVLINK_CMD_FLASH_UPDATE and DEVLINK_CMD_FLASH_UPDATE_END at the
> same time. I didn't like this, probably users won't like it either,
> so decided to go with less invasive solution as possible.

I'd drop these notifications, the user didn't ask to flash the device,
it's just code reuse in the driver, right?
