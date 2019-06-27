Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E735897B
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 20:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfF0SIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 14:08:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:44554 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726519AbfF0SIG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 14:08:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B6F5AB8C;
        Thu, 27 Jun 2019 18:08:05 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E0CC9E00E0; Thu, 27 Jun 2019 20:08:03 +0200 (CEST)
Date:   Thu, 27 Jun 2019 20:08:03 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627180803.GJ27240@unicorn.suse.cz>
References: <20190627094327.GF2424@nanopsycho>
 <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 11:14:31AM -0600, David Ahern wrote:
> > 4) There are two cases that can happen during rename:
> >    A) The name is shorter than IFNAMSIZ
> >       -> both IFLA_NAME and IFLA_NAME_EXT would contain the same string:
> >          original IFLA_NAME     = eth0
> >          original IFLA_NAME_EXT = eth0
> >          renamed  IFLA_NAME     = enp5s0f1npf0vf1
> >          renamed  IFLA_NAME_EXT = enp5s0f1npf0vf1
> >    B) The name is longer tha IFNAMSIZ
> >       -> IFLA_NAME would contain the original one, IFLA_NAME_EXT would 
> >          contain the new one:
> >          original IFLA_NAME     = eth0
> >          original IFLA_NAME_EXT = eth0
> >          renamed  IFLA_NAME     = eth0
> >          renamed  IFLA_NAME_EXT = enp131s0f1npf0vf22
> 
> so kernel side there will be 2 names for the same net_device?

It often feels as a deficiency that unlike block devices where we can
keep one name and create multiple symlinks based on different naming
schemes, network devices can have only one name. There are aliases but
AFAIK they are only used (and can be only used) for SNMP. IMHO this
limitation is part of the mess that left us with so-called "predictable
names" which are in practice neither persistent nor predictable.

So perhaps we could introduce actual aliases (or altnames or whatever we
would call them) for network devices that could be used to identify
a network device whenever both kernel and userspace tool supports them.
Old (and ancient) tools would have to use the one canonical name limited
to current IFNAMSIZ, new tools would allow using any alias which could
be longer.

Michal
