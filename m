Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785B28810E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 19:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437053AbfHIRWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 13:22:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:40680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726557AbfHIRV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 13:21:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99F24AE60;
        Fri,  9 Aug 2019 17:21:58 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id CF51AE00E3; Fri,  9 Aug 2019 19:21:56 +0200 (CEST)
Date:   Fri, 9 Aug 2019 19:21:56 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     "John W. Linville" <linville@tuxdriver.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        linville@redhat.com, cphealy@gmail.com
Subject: Re: [PATCH ethtool] ethtool: dump nested registers
Message-ID: <20190809172156.GI31971@unicorn.suse.cz>
References: <20190802193455.17126-1-vivien.didelot@gmail.com>
 <20190809162336.GB8016@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809162336.GB8016@tuxdriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 12:23:36PM -0400, John W. Linville wrote:
> On Fri, Aug 02, 2019 at 03:34:54PM -0400, Vivien Didelot wrote:
> > Usually kernel drivers set the regs->len value to the same length as
> > info->regdump_len, which was used for the allocation. In case where
> > regs->len is smaller than the allocated info->regdump_len length,
> > we may assume that the dump contains a nested set of registers.
> > 
> > This becomes handy for kernel drivers to expose registers of an
> > underlying network conduit unfortunately not exposed to userspace,
> > as found in network switching equipment for example.
> > 
> > This patch adds support for recursing into the dump operation if there
> > is enough room for a nested ethtool_drvinfo structure containing a
> > valid driver name, followed by a ethtool_regs structure like this:
> > 
> >     0      regs->len                        info->regdump_len
> >     v              v                                        v
> >     +--------------+-----------------+--------------+-- - --+
> >     | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
> >     +--------------+-----------------+--------------+-- - --+
> > 
> > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> 
> I wasn't sure what to do with this one, given the disucssion that
> followed. But since Dave merged "net: dsa: dump CPU port regs through
> master" for net-next, I went ahead and queued this one for the next
> release. If that was the wrong thing to do, speak-up now!

I'm certainly not happy about it as I'm afraid it's going to give me
a headache one day. But as long as the driver packs CPU port registers
into the device's register dump, it doesn't make sense not to allow
ethtool to parse them. And I'm not sure my objections are strong enough
to request a revert of the kernel part as I'm not sure the idea of
transforming the register dump into a structured format (an actual list
of registers rather than an opaque data block) is feasible at all.

So let's keep the patch in.

Michal
