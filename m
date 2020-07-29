Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE2623269C
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgG2VHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgG2VHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:07:11 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECE8D206D4;
        Wed, 29 Jul 2020 21:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596056830;
        bh=M/zi3Ba/rJ5poH34D/CQvvQgxq8zobEznQ2SvzhMlik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o9KjevY6+Emau0YuzRccD1dHbz/j03rXBXUALm/KBHKG9XUgmdVX5PYD5am8msgca
         wve3ZCS8VCY93WPI6BIuJODhNPK4rsfUSSarBB64rrzn8p7Zzi/xQAosENePHcsSKl
         SxNhyWnWW48ncBAbJxiPRQ8JiOZtjr2ZJT3fNfv4=
Date:   Wed, 29 Jul 2020 14:07:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-2-git-send-email-moshe@mellanox.com>
        <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200728135808.GC2207@nanopsycho>
        <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
        <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
        <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 17:54:08 +0300 Moshe Shemesh wrote:
> On 7/28/2020 11:06 PM, Jakub Kicinski wrote:
> > On Tue, 28 Jul 2020 12:18:30 -0700 Jacob Keller wrote:  
> >> On 7/28/2020 11:44 AM, Jakub Kicinski wrote:  
> >>>  From user perspective what's important is what the reset achieves (and
> >>> perhaps how destructive it is). We can define the reset levels as:
> >>>
> >>> $ devlink dev reload pci/0000:82:00.0 net-ns-respawn
> >>> $ devlink dev reload pci/0000:82:00.0 driver-param-init
> >>> $ devlink dev reload pci/0000:82:00.0 fw-activate
> >>>
> >>> combining should be possible when user wants multiple things to happen:
> >>>
> >>> $ devlink dev reload pci/0000:82:00.0 fw-activate driver-param-init  
> >> Where today "driver-param-init" is the default behavior. But didn't we
> >> just say that mlxsw also does the equivalent of fw-activate?  
> > Actually the default should probably be the combination of
> > driver-param-init and net-ns-respawn.  
> 
> What about the support of these combinations, one device needs to reset 
> fw to apply the param init, while another device can apply param-init
> without fw reset, but has to reload the driver for fw-reset.
> 
> So the support per driver will be a matrix of combinations ?

Note that there is no driver reload in my examples, driver reload is
likely not user's goal. Whatever the driver needs to reset to satisfy
the goal is fair game IMO.

It's already the case that some drivers reset FW for param init and some
don't and nobody is complaining.

We should treat constraints separate (in this set we have the live
activation which is a constraint on the reload operation).

> > My expectations would be that the driver must perform the lowest
> > reset level possible that satisfies the requested functional change.
> > IOW driver may do more, in fact it should be acceptable for the
> > driver to always for a full HW reset (unless --live or other
> > constraint is specified).  
> 
> OK, but some combinations may still not be valid for specific driver 
> even if it tries lowest level possible.

Can you give an example?
