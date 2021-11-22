Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FEB4595A8
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 20:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239567AbhKVTk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 14:40:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:53384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231856AbhKVTkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 14:40:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF21A6044F;
        Mon, 22 Nov 2021 19:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637609864;
        bh=qkAbph6+kYQGSoqeq+eODPfEWDeS34tKdtmp694USMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mAaVjV5E4HgmKxf3wkP+TZL9OBeVQaYQRqKxarbn8aQaNPb4dE3mQbDo0SiCxNkad
         WERTPsRRtVxwnTN7IiLzEbpYwbkwE34BIMViqEepNGqgNFy0rLsZkFeHMSU66Anp1c
         +mszc5ojiR5p6EqzcIRh1CFitiTH+20cJtuk9YQaxaIW8HSDRLS0j0emgFGJWYySJe
         B7we4jMc/F2viEYafnU8yHhOlGd4UbS3aSBCzhQlHWOjYJ22VmqKvg80jTFeQD4Zz5
         wGn43eHy8V9xYkLknhz3+rYmPQgtu6cKCPCwfqIBXs17YUFA98PSrx1ahstkcTARdr
         jccUW754h2FrA==
Date:   Mon, 22 Nov 2021 11:37:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net v2] net: avoid registering new queue objects after
 device unregistration
Message-ID: <20211122113742.16705a54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163760016601.3195.14673180551504824633@kwain>
References: <20211122162007.303623-1-atenart@kernel.org>
        <20211122083144.7d15a6ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <163760016601.3195.14673180551504824633@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Nov 2021 17:56:06 +0100 Antoine Tenart wrote:
> Quoting Jakub Kicinski (2021-11-22 17:31:44)
> > On Mon, 22 Nov 2021 17:20:07 +0100 Antoine Tenart wrote:  
> > >    veth_set_channels+0x1c3/0x550
> > >    ethnl_set_channels+0x524/0x610  
> > 
> > The patch looks fine, but ethtool calls should not happen after
> > unregister IMHO. Too many drivers would be surprised. 
> > 
> > Maybe we should catch unregistered devices in ethnl_ops_begin()?  
> 
> That might be good to have indeed, I'll have a look. I'm not sure about
> other paths that could do the same: if there are, we might want to keep
> the check in this patch as well. Or WARN to catch future misuses?

My knee jerk reaction was to add a WARN() just because I can't think
why changing queue count after unregister would be needed. But it's not
really illegal and we do support it before register, so why not after
unregister..

We can venture a warning with a comment saying that this is just for
catching bad uses and see if any driver hits it on a normal path?
