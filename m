Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB4B361588
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhDOWdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234764AbhDOWdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:33:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F3A7610FB;
        Thu, 15 Apr 2021 22:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618526002;
        bh=/gOqZg+Pg164K/IJSTPjixvLEaBlytjs/HR6s1fHt/o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cY+KIXFb3pQGfPiWc8RJ/iL+gVCdRdQ6WgsByRIy8C3p+IM2dxdoCn9cMEGTKeOyN
         ep+Qp3xPkIbmqf3t24rTlhidZYai+2eJ3Xtk+DQNN6VZHkFEwf3oMrvHQZMuW9j7x+
         oDd/sNENqzbeVQ5LmnYvowjoU2+Rf/H3tNE/LW1H8Caf+u4PiqDYUGqrvFMJKZwwSz
         yuDOsoT7ki/r5FFsdJqs+n5OEAYy1kZ12QDibcQkjNOxTp/H80Qez2ZeJUK8eJTvKK
         kce8CCFijDREtqy8IZzmEULEx9aAbFEf7wE75zUYa5Ya1rwSbsMM9NcyhZm281OY8D
         dkW1r/sPGPUlA==
Message-ID: <1652e284aea7ff3240d28a22d0dd09c50aed405a.camel@kernel.org>
Subject: Re: [PATCH net-next 3/6] ethtool: add FEC statistics
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com, corbet@lwn.net,
        linux-doc@vger.kernel.org
Date:   Thu, 15 Apr 2021 15:33:21 -0700
In-Reply-To: <20210415082144.260cf3ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210414034454.1970967-1-kuba@kernel.org>
         <20210414034454.1970967-4-kuba@kernel.org>
         <723b2858c61898df02e57bb2aaa4c4b4b3c30c50.camel@kernel.org>
         <20210415082144.260cf3ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-15 at 08:21 -0700, Jakub Kicinski wrote:
> On Wed, 14 Apr 2021 23:25:43 -0700 Saeed Mahameed wrote:
> > On Tue, 2021-04-13 at 20:44 -0700, Jakub Kicinski wrote:
> > > ethtool_link_ksettings *);
> > > +       void    (*get_fec_stats)(struct net_device *dev,
> > > +                                struct ethtool_fec_stats
> > > *fec_stats);  
> > 
> > why void ? some drivers need to access the FW and it could be an
> > old
> > FW/device where the fec stats are not supported.
> 
> When stats are not supported just returning is fine. Stats are
> initialized to -1, core will not dump them into the netlink message 
> if driver didn't assign anything.
> 
> > and sometimes e.g. in mlx5 case FW can fail for FW related
> > businesses
> > :)..
> 
> Can do. I was wondering if the entity reading the stats (from user
> space) can do anything useful with the error, and didn't really come 
> up with anything other than printing an error. Which the kernel can 
> do as well. OTOH if there are multiple stats to read and one of them
> fails its probably better to return partial results than fail 
> the entire op. Therefore I went for no error - if something fails - 
> the stats will be missing.
> 
> Does that make any sense? Or do you think errors are rare enough that
> it's okay if they are fatal? (with the caveat that -EOPNOTSUPP should
> be ignored).

Agreed, Thanks for the explanation
but you still need to handle the error internally in the driver,
otherwise the command returns garbage or 0 if you didn't check return
status. 

