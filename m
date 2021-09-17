Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEAAA40FFA3
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhIQTCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:02:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229475AbhIQTCR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 15:02:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78EB76124B;
        Fri, 17 Sep 2021 19:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631905255;
        bh=kKf4ItxdG+UjjBE1sBXkIgFyl6ZGWXdYFTvHNTsK2NI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Why6fEV2bbQ99exKBeMq9gUJgiVLjSQDClBa6/qDE8yM9ZZifuPN1zyJ+hAAAp3/V
         Nr0OiRxaUUj1CygUbyBW7atJ3Ut3Weg9iXDkUk7QNHKk4nVThFJ+Gq5PltO3xoIoQn
         PMMl3jsmemdaGIdwp3/DJUJUWEz2dwERsarZDJwaQZAlNo2Jzc20bniNTTKy+sXhD/
         ayhKfFG/cVAKDWMpIsNo97UQ70wPyPuXcemeeVpoaWEYMrx3Q7+KA0Bv9qu0XBHGAO
         GJv9CDsYJ1+NIMkY9XOUSA2tdR/xZn8r3UxMclO7hjrJjrZO/aOMk+DefCzStXGM9h
         KV1HXob0RHMzA==
Date:   Fri, 17 Sep 2021 12:00:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YUSrWiWh57Ys7UdB@lore-desk>
        <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 11:43:07 -0700 Alexei Starovoitov wrote:
> > If bpf_xdp_load_bytes() / bpf_xdp_store_bytes() works for most we
> > can start with that. In all honesty I don't know what the exact
> > use cases for looking at data are, either. I'm primarily worried
> > about exposing the kernel internals too early.  
> 
> I don't mind the xdp equivalent of skb_load_bytes,
> but skb_header_pointer() idea is superior.
> When we did xdp with data/data_end there was no refine_retval_range
> concept in the verifier (iirc or we just missed that opportunity).
> We'd need something more advanced: a pointer with valid range
> refined by input argument 'len' or NULL.
> The verifier doesn't have such thing yet, but it fits as a combination of
> value_or_null plus refine_retval_range.
> The bpf_xdp_header_pointer() and bpf_skb_header_pointer()
> would probably simplify bpf programs as well.
> There would be no need to deal with data/data_end.

What are your thoughts on inlining? Can we inline the common case 
of the header being in the "head"? Otherwise data/end comparisons 
would be faster.
