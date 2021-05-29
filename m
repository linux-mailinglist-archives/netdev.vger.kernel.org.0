Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDB2394A75
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 06:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhE2E6c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 00:58:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhE2E6b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 00:58:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76152611C9;
        Sat, 29 May 2021 04:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622264216;
        bh=/7PiqVLDOulKmJBaXyeqfLBDC/PlPwQBWBL+bvkTkc0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hrtfvv1+5dKYicMfUBqNqxh5sEsWpzi3e5PEJPeidq38L781MOtju5+YY1q8g3ThX
         OgXq6t0sHHLKykImvmHhemtI4rSmxdudOjIxJVwdxSkhU9decHQcqesD9otWutgTgb
         OpHcik3hZVMIg7Qy8//x8KF88Lu2vHw5ADJdGHDsWKuH6MAeLtiN3N/41134+QFcd+
         HyAyGQrWOgjH0vKE4MzvbgUlQdreJ78RmYRgSnFk+r7VNxL6P0j/V4oKuF3/YysHrn
         Pksld3O9zcGd7XIEmCHTtDf+gIXf1b1VtPbE2zUKf9u++je1cZa94d2mFAoBUVcsSU
         MKMfJUYmtzUBA==
Date:   Fri, 28 May 2021 21:56:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        David Ahern <dsahern@gmail.com>, magnus.karlsson@intel.com,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Jesper Dangaard Brouer <brouer@redhat.com>,
        bjorn@kernel.org,
        "Maciej =?UTF-8?B?RmlqYcWC?= =?UTF-8?B?a293c2tp?= (Intel)" 
        <maciej.fijalkowski@intel.com>,
        john fastabend <john.fastabend@gmail.com>
Subject: Re: [RFC bpf-next 1/4] net: xdp: introduce flags field in xdp_buff
 and xdp_frame
Message-ID: <20210528215654.31619c97@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
References: <cover.1622222367.git.lorenzo@kernel.org>
        <b5b2f560006cf5f56d67d61d5837569a0949d0aa.1622222367.git.lorenzo@kernel.org>
        <CALx6S34cmsFX6QwUq0sRpHok1j6ecBBJ7WC2BwjEmxok+CHjqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 May 2021 14:18:33 -0700 Tom Herbert wrote:
> On Fri, May 28, 2021 at 10:44 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > Introduce flag field in xdp_buff and xdp_frame data structure in order
> > to report xdp_buffer metadata. For the moment just hw checksum hints
> > are defined but flags field will be reused for xdp multi-buffer
> > For the moment just CHECKSUM_UNNECESSARY is supported.
> > CHECKSUM_COMPLETE will need to set csum value in metada space.
> >  
> Lorenzo,
> 
> This isn't sufficient for the checksum-unnecessary interface, we'd
> also need ability to set csum_level for cases the device validated
> more than one checksum.
> 
> IMO, we shouldn't support CHECKSUM_UNNECESSARY for new uses like this.
> For years now, the Linux community has been pleading with vendors to
> provide CHECKSUM_COMPLETE which is far more useful and robust than
> CHECSUM_UNNECESSARY, and yet some still haven't got with the program
> even though we see more and more instances where CHECKSUM_UNNECESSARY
> doesn't even work at all (e.g. cases with SRv6, new encaps device
> doesn't understand). I believe it's time to take a stand! :-)

I must agree. Not supporting CHECKSUM_COMPLETE seems like a step back.
