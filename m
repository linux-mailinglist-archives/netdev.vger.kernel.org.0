Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1CB1BC5FC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgD1RDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbgD1RDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 13:03:22 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E931EC03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 10:03:21 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f7so10959054pfa.9
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 10:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cmDtaZEpK7I6xAIDW+hNfFg/9dwLVbaDO3EJJKFm7eY=;
        b=IqE9f1EMLlPszICDw7l7yGCA4i1GXd0ex0yCXoQFGNXSaXB0oHMg+j+d8Rcnzo9zJt
         BhLUmtp3syZeTKj7QWs0gQG8LyQEBG8cTog42siBowwbHWTJ8n0dnaCJrKzQ6oIUyyt8
         8i3r01SFyM3NJ7rrTnYgABE11j95+Y5RF3StcgsWAiggl0iW7MF82Sb3KD3peWq5z1nl
         S8I8oZTcj0P+cxFHQB0lB2yfqyi7uGLCfseJN602CftQK6xayn2AYg2p/Ty7CMBM165a
         85vb4t7Cq+jSfCuaSdURyXkKs+VQuB5yXaSGMjkOHNGtQ6lY8CyrcGIvCqXWvr2Vnbb7
         l/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cmDtaZEpK7I6xAIDW+hNfFg/9dwLVbaDO3EJJKFm7eY=;
        b=RN6IBuM43PyEJgzWO7IWjleSVoKL40V1nZGSTyBZ8QbIAVA+ivHhEXf0YDkPWDneLt
         Xza85UpKMf4JIufwmcWnZ+0ew4g9bBgZEmmc3VEcxepsXhHepvRq3evhUeOERKCiWQtC
         gkPCBuuVwy7osy3UPtF19u3hNuetLNFMdGlGWdNyna89v5dzGf1qwI+IxQM+DDOO6ShG
         1TjLZeeJ4NsvlnLvr+c3DWucCxSO414fMzrAV9beHREyfDFzxFjM15X50hJkmPFCTHYc
         /ZgjqAlBmg/4+YV4I2BzPu6yS47Fabsx9ZwWI5pAkwHTRiplzFxqQ2kt9z+qOOcOr0xp
         PXUA==
X-Gm-Message-State: AGi0PuYAgaPTeP10p2FCw2d9ULpnQkjd9Opq4o8EarilPWqb/t4yn134
        VzqdvoTWYvl/heEMvgOl3jg=
X-Google-Smtp-Source: APiQypLqNy4IBV4mtJ4uXuqOSlVv6ltNK6BCcmms5KBLXEp15B0Mqea3TjX/YTP4ecL6LgQ2H3tiQQ==
X-Received: by 2002:a62:3812:: with SMTP id f18mr29623832pfa.173.1588093400882;
        Tue, 28 Apr 2020 10:03:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9061])
        by smtp.gmail.com with ESMTPSA id d2sm16025380pfc.7.2020.04.28.10.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 10:03:19 -0700 (PDT)
Date:   Tue, 28 Apr 2020 10:03:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200428170317.pkcewewhgukvssd3@ast-mbp.dhcp.thefacebook.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com>
 <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <877dy0y6le.fsf@toke.dk>
 <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <87tv14vu2k.fsf@toke.dk>
 <20200428095113.330e83aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428095113.330e83aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 09:51:13AM -0700, Jakub Kicinski wrote:
> > > Kinda same story as XDP egress, folks may be asking for it but that
> > > doesn't mean it makes sense.  
> > 
> > Well I do also happen to think that XDP egress is a good idea ;)
> 
> I was planning not to get involved in that conversation any more,
> let's move on :P

getting involved like arguing till last men standing is not something
people appreciate, but expressing your opinion in xdp egress thread
is certainly valuable.

> > That I can agree with - generic XDP should follow the semantics of
> > native XDP, not the other way around. But that's what we're doing here
> > (with the pseudo-MAC header approach), isn't it? Whereas if we were
> > saying "just write your XDP programs to assume only L3 packets" we would
> > be creating a new semantic for generic XDP...
> 
> But you do see the problem this creates on redirect already, right?
> Do we want to support all that? Add an if in the redirect fast path?
> There will _never_ be native XDP for WireGuard, it just doesn't make
> sense. 
> 
> Generic XDP is not a hook in its own right, frame is already firmly
> inside the stack, XDP is on the perimeter.

I think the proper fix here is to disallow generic xdp on l3 devices.
imo the only use case for generic xdp is to provide fallback for
heterogeneous fleet of servers. On most of the machines XDP program
will be using native XDP, but some servers might have either old
kernel or old hw and in such cases generic XDP saves the day.
XDP programmer doens't need to special case their user and kernel side
for long tail of servers where performance doesn't matter.

cls_bpf addresses the use case for folks that want to process
ingress/egress traffic on l3 netdev. I don't think there is a need
for xdp based solution in addition to cls_bpf. It's going to be
much more limited comparing to cls_bpf.
