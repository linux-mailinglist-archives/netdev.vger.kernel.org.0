Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B292D1F59
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgLHAtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:49:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgLHAtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 19:49:35 -0500
Date:   Mon, 7 Dec 2020 16:48:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607388535;
        bh=htsTeV3zedFCZxoCo2phmUriPMTJAlxp2xgDZunwAVI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=N8+55HRwTeoX4+69LPzZKGOMlWQK4TvAN7YJB2l4PSLX9KyKp9pOTgIbzDnbyA6sT
         SItu0egVseYwjxbIuedkEFxgbnGw3azyBLYjugMB2bvaqYVVk3ZqSQbUppVmFQPqwD
         AfgATpRPKhvqFjN1sEPLCQ+IRh7DAEq9fSD4cdU54okKCCD/UfnuyEASuN515ODFBS
         hcpOmNRMjGe8jMumOOPzlMrVEEPMulw/1pY6AfZQnqq40PJAMx7YYV1Rm9n0khXhjl
         TushGZr5H1hKK7qNkNSH/e3cVDpMXDKgNOXRp+6/Y9fI4Uu89DsCCc2C1fZs/JMaPl
         rWD80gwt+/aDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        Po Liu <po.liu@nxp.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Message-ID: <20201207164853.3a9e6024@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201208002730.kftox7xvr7d475rp@skbuf>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-2-vinicius.gomes@intel.com>
        <20201205094325.790b187f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87eek11d23.fsf@intel.com>
        <20201207152126.6f3d1808@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87blf5ywkd.fsf@intel.com>
        <20201208002730.kftox7xvr7d475rp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 00:27:31 +0000 Vladimir Oltean wrote:
> On Mon, Dec 07, 2020 at 04:24:02PM -0800, Vinicius Costa Gomes wrote:
> > Jakub Kicinski <kuba@kernel.org> writes:
> >  
> > > On Mon, 07 Dec 2020 14:11:48 -0800 Vinicius Costa Gomes wrote:  
> > >> Jakub Kicinski <kuba@kernel.org> writes:  
> > >> >> + * @min_frag_size_mult: Minimum size for all non-final fragment size,
> > >> >> + * expressed in terms of X in '(1 + X)*64 + 4'  
> > >> >
> > >> > Is this way of expressing the min frag size from the standard?
> > >> >  
> > >>
> > >> The standard has this: "A 2-bit integer value indicating, in units of 64
> > >> octets, the minimum number of octets over 64 octets required in
> > >> non-final fragments by the receiver" from IEEE 802.3br-2016, Table
> > >> 79-7a.  
> > >
> > > Thanks! Let's drop the _mult suffix and add a mention of this
> > > controlling the addFragSize variable from the standard. Perhaps
> > > it should in fact be called add_frag_size (with an explanation
> > > that the "additional" means "above the 64B" which are required in
> > > Ethernet, and which are accounted for by the "1" in the 1 + X
> > > formula)?  
> >
> > Sounds good :-) Will add a comment with the standard reference and
> > change the name to 'add_frag_size'.  
> 
> I think you should be making references to the IEEE 802.3-2018, that
> will age better, and a lot more people have that handy.
> I believe the go-to definition for the additional fragment size can be
> found in clause 30.12.2.1.37 aLldpXdot3LocAddFragSize.

That's the LLDP incarnation of it. The variable is defined in:

99.4.7.3 Variables

Probably better mention 30.14.1.7 aMACMergeAddFragSize if we want a MIB
reference.
