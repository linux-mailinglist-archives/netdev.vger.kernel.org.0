Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAB830979B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhA3Spd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 13:45:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:34708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhA3Spd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 13:45:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C227264DDE;
        Sat, 30 Jan 2021 18:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612032292;
        bh=0jgnQkC84KHs6u8jpWz9JTOXLddp2uoNoPY/ozcODMY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=du6n+gRodsJ8JUVePUBo3AGnoOwkht95TJelnKbEUjDc/BUO4ILII8/ActgohvCwT
         fTdwpolTa2foZg+UgPfAHPFFn6dxNRiacHAIbaTA/ejz+R59LYaZfk0cWFn/kaTzVS
         l8432as5C86q3v2PJUVLUMpYw+TrN6bgA09NRH+bYXKiilsbdBLHhwrObZ7AZsBq2D
         ZKFWqLZU8iW52j4qqPi+YWNxQ2I/g8DNPFnTjWg322R4MC8DJZVo3HNimnv8hzfLia
         Mwns/PWV3tKJ4NwVy9o2jFpVTG3NAgj462QcZsuXydG1LLCUeQ4e9qVDruCXSRivYw
         FFGsQHE3ZSbMA==
Date:   Sat, 30 Jan 2021 10:44:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Jonas Bonn <jonas@norrbonn.se>,
        Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
Message-ID: <20210130104450.00b7ab7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
        <20210123195916.2765481-16-jonas@norrbonn.se>
        <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se>
        <CAOrHB_DFv8_5CJ7GjUHT4qpyJUkgeWyX0KefYaZ-iZkz0UgaAQ@mail.gmail.com>
        <9b9476d2-186f-e749-f17d-d191c30347e4@norrbonn.se>
        <CAOrHB_Cyx9Xf6s63wVFo1mYF7-ULbQD7eZy-_dTCKAUkO0iViw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 22:59:06 -0800 Pravin Shelar wrote:
> On Fri, Jan 29, 2021 at 6:08 AM Jonas Bonn <jonas@norrbonn.se> wrote:
> > On 28/01/2021 22:29, Pravin Shelar wrote:  
> > > Receive path: LWT extracts tunnel metadata into tunnel-metadata
> > > struct. This object has 5-tuple info from outer header and tunnel key.
> > > When there is presence of extension header there is no way to store
> > > the info standard tunnel-metadata object. That is when the optional
> > > section of tunnel-metadata comes in the play.
> > > As you can see the packet data from GTP header onwards is still pushed
> > > to the device, so consumers of LWT can look at tunnel-metadata and
> > > make sense of the inner packet that is received on the device.
> > > OVS does exactly the same. When it receives a GTP packet with optional
> > > metadata, it looks at flags and parses the inner packet and extension
> > > header accordingly.  
> >
> > Ah, ok, I see.  So you are pulling _half_ of the GTP header off the
> > packet but leaving the optional GTP extension headers in place if they
> > exist.  So what OVS receives is a packet with metadata indicating
> > whether or not it begins with these extension headers or whether it
> > begins with an IP header.
> >
> > So OVS might need to begin by pulling parts of the packet in order to
> > get to the inner IP packet.  In that case, why don't you just leave the
> > _entire_ GTP header in place and let OVS work from that?  The header
> > contains exactly the data you've copied to the metadata struct PLUS it
> > has the incoming TEID value that you really should be validating inner
> > IP against.
> >  
> 
> Following are the reasons for extracting the header and populating metadata.
> 1. That is the design used by other tunneling protocols
> implementations for handling optional headers. We need to have a
> consistent model across all tunnel devices for upper layers.

Could you clarify with some examples? This does not match intuition, 
I must be missing something.

> 2. GTP module is parsing the UDP and GTP header. It would be wasteful
> to repeat the same process in upper layers.
> 3. TIED is part of tunnel metadata, it is already used to validating
> inner packets. But TIED is not alone to handle packets with extended
> header.
> 
> I am fine with processing the entire header in GTP but in case of 'end
> marker' there is no data left after pulling entire GTP header. Thats
> why I took this path.

