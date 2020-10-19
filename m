Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7BE29281A
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 15:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgJSNYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 09:24:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:53894 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbgJSNYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 09:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1552CACAC;
        Mon, 19 Oct 2020 13:24:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 937BC60563; Mon, 19 Oct 2020 15:24:46 +0200 (CEST)
Date:   Mon, 19 Oct 2020 15:24:46 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Danielle Ratson <danieller@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Message-ID: <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019122643.GC11282@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 02:26:43PM +0200, Jiri Pirko wrote:
> Mon, Oct 19, 2020 at 01:04:22PM CEST, mkubecek@suse.cz wrote:
> >
> >It would be quite easy to extend the ethtool command line parser to
> >allow also
> >
> >  ethtool -s <dev> advertise <mode> ...
> >
> >in addition to already supported
> >
> >  ethtool -s <dev> advertise <mask>
> >  ethtool -s <dev> advertise <mask>/<mask>
> >  ethtool -s { <mode> { on | off } } ...

This should have been

  ethtool -s <dev> advertise { <mode> { on | off } } ...

> >Parser converting simple list of values into a maskless bitset is
> >already there so it would be only matter of checking if there are at
> >least two arguments and second is "on" or "off" and using corresponding
> >parser. I think it would be useful independently of this series.
> 
> Understood. So basically you will pass some selectors on cmdline and the
> uapi would stay intact.
> How do you imagine the specific lane number selection should look like
> on the cmdline?

As I said, I meant the extension suggested in my mail as independent of
what this series is about. For lanes count selector, I find proposed

  ethtool -s <dev> ... lanes <lanes_num> ...

the most natural.

From purely syntactic/semantic point of view, there are three types of
requests:

  (1) enable specific set of modes, disable the rest
  (2) enable/disable specific modes, leave the rest as they are
  (3) enable modes matching a condition (and disable the rest)

What I proposed was to allow the use symbolic names instead of masks
(which are getting more and more awful with each new mode) also for (1),
like they can already be used for (2).

The lanes selector is an extension of (3) which I would prefer not to
mix with (1) or (2) within one command line, i.e. either "advertise" or
"speed / duplex / lanes".

IIUC Jakub's and Andrew's comments were not so much about the syntax and
semantic (which is quite clear) but rather about the question if the
requests like "advertise exactly the modes with (100Gb/s speed and) two
lanes" would really address a real life need and wouldn't be more often
used as shortcuts for "advertise 100000baseKR2/Full". (On the other
hand, I suspect existing speed and duplex selectors are often used the
same way.)

Michal
