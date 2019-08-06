Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AC982AD7
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 07:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfHFFU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 01:20:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:51512 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfHFFU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 01:20:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E4E64B03A;
        Tue,  6 Aug 2019 05:20:24 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 731BEE0442; Tue,  6 Aug 2019 07:20:02 +0200 (CEST)
Date:   Tue, 6 Aug 2019 07:20:02 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, f.fainelli@gmail.com,
        andrew@lunn.ch, davem@davemloft.net, linville@redhat.com,
        cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
Message-ID: <20190806052002.GD31971@unicorn.suse.cz>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
 <20190805080448.GA31971@unicorn.suse.cz>
 <20190805105216.GB31482@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805105216.GB31482@t480s.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 10:52:16AM -0400, Vivien Didelot wrote:
> Hi Michal!
> 
> On Mon, 5 Aug 2019 10:04:48 +0200, Michal Kubecek <mkubecek@suse.cz> wrote:
> > On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
> > > Usually kernel drivers set the regs->len value to the same length as
> > > info->regdump_len, which was used for the allocation. In case where
> > > regs->len is smaller than the allocated info->regdump_len length,
> > > we may assume that the dump contains a nested set of registers.
> > > 
> > > This becomes handy for kernel drivers to expose registers of an
> > > underlying network conduit unfortunately not exposed to userspace,
> > > as found in network switching equipment for example.
> > > 
> > > This patch adds support for recursing into the dump operation if there
> > > is enough room for a nested ethtool_drvinfo structure containing a
> > > valid driver name, followed by a ethtool_regs structure like this:
> > > 
> > >     0      regs->len                        info->regdump_len
> > >     v              v                                        v
> > >     +--------------+-----------------+--------------+-- - --+
> > >     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
> > >     +--------------+-----------------+--------------+-- - --+
> > > 
> > > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > > ---
> > 
> > I'm not sure about this approach. If these additional objects with their
> > own registers are represented by a network device, we can query their
> > registers directly. If they are not (which, IIUC, is the case in your
> > use case), we should use an appropriate interface. AFAIK the CPU ports
> > are already represented in devlink, shouldn't devlink be also used to
> > query their registers?
> 
> Yet another interface wasn't that much appropriate for DSA, making the
> stack unnecessarily complex.

AFAICS, there is already devlink support in dsa and CPU ports are
presented as devlink ports. So it wouldn't be a completely new
interface.

> In fact we are already glueing the statistics of the CPU port into the
> master's ethtool ops (both physical ports are wired together).

The ethtool statistics (in general) are one big mess, I don't think it's
an example worth following; rather one showing us what to avoid.

> Adding support for nested registers dump in ethtool makes it simple to
> (pretty) dump CPU port's registers without too much userspace
> addition.

It is indeed convenient for pretty print - but very hard to use for any
automated processing. My point is that CPU port is not represented by
a network device but it is already represented by a devlink port so that
it makes much more sense to tie its register dump to that object than to
add add it to register dump of port's master.

In the future, I would like to transform the ethtool register dump from
current opaque block of data to an actual dump of registers. It is
unfortunate that drivers are already mixing information specific to
a network device with information common for the whole physical device.
Adding more data which is actually related to a different object would
only make things worse.

Michal Kubecek
