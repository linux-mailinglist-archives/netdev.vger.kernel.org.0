Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E89C31D18A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBPUZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:25:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:58058 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229628AbhBPUZo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 15:25:44 -0500
IronPort-SDR: DXh/rpf3x6qwrjlpVTbfbtXipZaQx4cG0BUCmPDjxZ2BU1XtusZEp2VkL60ItYnS/RoGC/g7Sh
 +wkeBGknMo+Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="202206614"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="202206614"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 12:24:58 -0800
IronPort-SDR: /iDFsFb+LdNDukmCb3z9n6bzzAs4iDHPRPn067Y7xeoWu1QjIIInAsfWrdjO5lX26gSBk1BwX8
 paMFYuKYSz4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="512643753"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 16 Feb 2021 12:24:55 -0800
Date:   Tue, 16 Feb 2021 21:15:02 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Message-ID: <20210216201502.GB17126@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <875z2tcef2.fsf@toke.dk>
 <20210216020128.GA9572@ranger.igk.intel.com>
 <87sg5wb93o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sg5wb93o.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 11:27:55AM +0100, Toke Høiland-Jørgensen wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> >
> > Am I reading this right or you're trying to reject the fix of the long
> > standing issue due to a PR that is not ready yet on a standalone
> > project/library? :P
> 
> Haha, no, that is not what I'm saying. As I said up-thread I agree that
> this is something we should fix, obviously. I'm just suggesting we fix
> it in a way that will also be compatible with libxdp and multiprog so we
> won't have to introduce yet-another-flag that users will have to decide
> on.
> 
> However, now that I'm looking at your patch again I think my fears may
> have been overblown. I got hung up on the bit in the commit message
> where you said "refcounting of BPF resources will be done automatically
> by bpf_link itself", and wrongly assumed that you were exposing the
> bpf_link fd to the application. But I see now that it's kept in the
> private xsk_ctx structure, and applications still just call
> xsk_socket__delete(). So in libxdp we can just implement the same API
> with a different synchronisation mechanism; that's fine. Apologies for
> jumping to conclusions :/

No worries, this shows how important a thorough commit message is, seems
that I failed on that part.

> 
> > Once libxdp is the standard way of playing with AF-XDP and there are
> > actual users of that, then I'm happy to work/help on that issue.
> 
> That is good to know, thanks! I opened an issue in the xdp-tools
> repository to track this for the libxdp side (Magnus and I agreed that
> we'll merge the existing code first, then fix this on top):
> https://github.com/xdp-project/xdp-tools/issues/93

Thanks! And good to hear that there's some sort of agreement.

> 
> As noted above, the mechanism may have to change, but I think it's
> possible to achieve the same thing in a libxdp context :)
> 
> -Toke
> 
