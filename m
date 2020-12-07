Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBFB2D1E37
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 00:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgLGXRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 18:17:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:15606 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgLGXRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 18:17:14 -0500
IronPort-SDR: X+X2PW8/C/ic7bh+oeWwuXHwHhZP7iZkEAWLTneX6XB4ytZR6I92LxYGNNxu22L0ytn7FMGPw+
 ssbaWhDPIhzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9828"; a="153607887"
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="153607887"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2020 15:16:33 -0800
IronPort-SDR: AcBJtSDVnH4r/P+8UYpSbwg+1u4Ss6h1AzzkiF+du4nrwoimJI4b5gjHvg2NIW6bfd966B3Okb
 MF8cPF4Zz6nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,401,1599548400"; 
   d="scan'208";a="363360539"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 07 Dec 2020 15:16:29 -0800
Date:   Tue, 8 Dec 2020 00:07:55 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20201207230755.GB27205@ranger.igk.intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 07, 2020 at 12:52:22PM -0800, John Fastabend wrote:
> Jesper Dangaard Brouer wrote:
> > On Fri, 4 Dec 2020 16:21:08 +0100
> > Daniel Borkmann <daniel@iogearbox.net> wrote:
> > 
> > > On 12/4/20 1:46 PM, Maciej Fijalkowski wrote:
> > > > On Fri, Dec 04, 2020 at 01:18:31PM +0100, Toke Høiland-Jørgensen wrote:  
> > > >> alardam@gmail.com writes:  
> > > >>> From: Marek Majtyka <marekx.majtyka@intel.com>
> > > >>>
> > > >>> Implement support for checking what kind of xdp functionality a netdev
> > > >>> supports. Previously, there was no way to do this other than to try
> > > >>> to create an AF_XDP socket on the interface or load an XDP program and see
> > > >>> if it worked. This commit changes this by adding a new variable which
> > > >>> describes all xdp supported functions on pretty detailed level:  
> > > >>
> > > >> I like the direction this is going! :)
> > 
> > (Me too, don't get discouraged by our nitpicking, keep working on this! :-))
> > 
> > > >>  
> > > >>>   - aborted
> > > >>>   - drop
> > > >>>   - pass
> > > >>>   - tx  
> > > 
> > > I strongly think we should _not_ merge any native XDP driver patchset
> > > that does not support/implement the above return codes. 
> > 
> > I agree, with above statement.
> > 
> > > Could we instead group them together and call this something like
> > > XDP_BASE functionality to not give a wrong impression?
> > 
> > I disagree.  I can accept that XDP_BASE include aborted+drop+pass.
> > 
> > I think we need to keep XDP_TX action separate, because I think that
> > there are use-cases where the we want to disable XDP_TX due to end-user
> > policy or hardware limitations.
> 
> How about we discover this at load time though. Meaning if the program
> doesn't use XDP_TX then the hardware can skip resource allocations for
> it. I think we could have verifier or extra pass discover the use of
> XDP_TX and then pass a bit down to driver to enable/disable TX caps.

+1

> 
> > 
> > Use-case(1): Cloud-provider want to give customers (running VMs) ability
> > to load XDP program for DDoS protection (only), but don't want to allow
> > customer to use XDP_TX (that can implement LB or cheat their VM
> > isolation policy).
> 
> Not following. What interface do they want to allow loading on? If its
> the VM interface then I don't see how it matters. From outside the
> VM there should be no way to discover if its done in VM or in tc or
> some other stack.
> 
> If its doing some onloading/offloading I would assume they need to
> ensure the isolation, etc. is still maintained because you can't
> let one VMs program work on other VMs packets safely.
> 
> So what did I miss, above doesn't make sense to me.
> 
> > 
> > Use-case(2): Disable XDP_TX on a driver to save hardware TX-queue
> > resources, as the use-case is only DDoS.  Today we have this problem
> > with the ixgbe hardware, that cannot load XDP programs on systems with
> > more than 192 CPUs.
> 
> The ixgbe issues is just a bug or missing-feature in my opinion.

Not a bug, rather HW limitation?

> 
> I think we just document that XDP_TX consumes resources and if users
> care they shouldn't use XD_TX in programs and in that case hardware
> should via program discovery not allocate the resource. This seems
> cleaner in my opinion then more bits for features.

But what if I'm with some limited HW that actually has a support for XDP
and I would like to utilize XDP_TX?

Not all drivers that support XDP consume Tx resources. Recently igb got
support and it shares Tx queues between netstack and XDP.

I feel like we should have a sort-of best effort approach in case we
stumble upon the XDP_TX in prog being loaded and query the driver if it
would be able to provide the Tx resources on the current system, given
that normally we tend to have a queue per core.

In that case igb would say yes, ixgbe would say no and prog would be
rejected.

> 
> > 
> > 
> > > If this is properly documented that these are basic must-have
> > > _requirements_, then users and driver developers both know what the
> > > expectations are.
> > 
> > We can still document that XDP_TX is a must-have requirement, when a
> > driver implements XDP.
> 
> +1
> 
> > 
> > 
> > > >>>   - redirect  
> > > >>
> > 
> > 
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 
> 
> 
