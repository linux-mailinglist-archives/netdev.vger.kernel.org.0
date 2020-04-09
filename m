Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4FD1A2D39
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 03:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgDIBNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 21:13:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgDIBNL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 21:13:11 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50CB620857;
        Thu,  9 Apr 2020 01:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586394791;
        bh=gnJSC+Ll55F8NHZqiO9BiUa6+NsFEi69Clrkki9joxs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uePBGxeiUOI2f9dBbu1gCSAP9K3iU/l7kNXxFDYcgmpU3qAU5kmOUR6ephSm+5kca
         lWfAiqPilBD2AnClEYq3x34FzcKztbx468I2/QicxdwWjzhwZGXljIHv9IH6k/Qhxr
         AjcleUITp5MwS6y8PkSpxiiWgJ/DVbRXQtIagTEc=
Date:   Wed, 8 Apr 2020 18:13:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "borkmann@iogearbox.net" <borkmann@iogearbox.net>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "toke@redhat.com" <toke@redhat.com>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        "gtzalik@amazon.com" <gtzalik@amazon.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sameehj@amazon.com" <sameehj@amazon.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "zorik@amazon.com" <zorik@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v2 01/33] xdp: add frame size to xdp_buff
Message-ID: <20200408181308.4e1cf9fc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <a101ea0284504b65edcd8f83bd7a05747c6f8014.camel@mellanox.com>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
        <158634663936.707275.3156718045905620430.stgit@firesoul>
        <20200408105339.7d8d4e59@kicinski-fedora-PC1C0HJN>
        <a101ea0284504b65edcd8f83bd7a05747c6f8014.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 00:48:30 +0000 Saeed Mahameed wrote:
> > > + * This macro reserves tailroom in the XDP buffer by limiting the
> > > + * XDP/BPF data access to data_hard_end.  Notice same area (and
> > > size)
> > > + * is used for XDP_PASS, when constructing the SKB via
> > > build_skb().
> > > + */
> > > +#define xdp_data_hard_end(xdp)				\
> > > +	((xdp)->data_hard_start + (xdp)->frame_sz -	\
> > > +	 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))  
> > 
> > I think it should be said somewhere that the drivers are expected to
> > DMA map memory up to xdp_data_hard_end(xdp).
> >   
> 
> but this works on a specific xdp buff, drivers work with mtu
> 
> and what if the driver want to have this as an option per packet .. 
> i.e.: if there is enough tail room, then build_skb, otherwise
> alloc new skb, copy headers, setup data frags.. etc
> 
> having such limitations on driver can be very strict, i think the
> decision must remain dynamic per frame..
> 
> of-course drivers should optimize to preserve enough tail room for all
> rx packets.. 

My concern is that driver may allocate a full page for each frame but
only DMA map the amount that can reasonably contain data given the MTU.
To save on DMA syncs.

Today that wouldn't be a problem, because XDP_REDIRECT will re-map the
page, and XDP_TX has the same MTU.

In this set xdp_data_hard_end is used both to find the end of memory
buffer, and end of DMA buffer. Implementation of bpf_xdp_adjust_tail()
assumes anything < SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) from
the end is fair game.

So I was trying to say that we should warn driver authors that the DMA
buffer can now grow / move beyond what the driver may expect in XDP_TX.
Drivers can either DMA map enough memory, or handle the corner case in
a special way.

IDK if that makes sense, we may be talking past each other :)
