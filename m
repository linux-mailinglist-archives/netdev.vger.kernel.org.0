Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7461149AF
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 00:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbfLEXIo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 18:08:44 -0500
Received: from valentin-vidic.from.hr ([94.229.67.141]:39831 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbfLEXIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 18:08:44 -0500
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 369ED2A9; Fri,  6 Dec 2019 00:08:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1575587315;
        bh=gOfv2vg4JtHkkPl08ul7DDaNE8L+hWoX0Am0lJG/V0A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uh8XTKypfL1JWzKMadXYcUfM2Ho6PZCRoU7LKfZYM3PvgnfUsct1693HZ1juX7Kvr
         v2q6VZsnHk5f5WdXQumZ8txy7FXewbhbMR8ysVmolnn9GOOEUtJGDLdDOGmKIoDM6U
         nvquzrQkgitkdsgWY49hkmGnLt6dcb7AhOcc9gke1GyAqbm6Jwck9F/rb4TrKb/Djd
         HMz3P8pbGrr2G8E1tRdWPiB/gA64OhgY5Z8rPxAQQanwyQgqgmwavWdYwj7Gts0bWE
         YdZrXY5uBZqwIxPCq6gVEWbQoev+y/SnZfVrPugptGiuZgwJPuBEaOlIvQHz+z3+/K
         nrevkXXK/CE/g==
Date:   Fri, 6 Dec 2019 00:08:35 +0100
From:   Valentin =?utf-8?B?VmlkacSH?= <vvidic@valentin-vidic.from.hr>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net/tls: Fix return values to avoid ENOTSUPP
Message-ID: <20191205230835.GB20116@valentin-vidic.from.hr>
References: <20191204.165528.1483577978366613524.davem@davemloft.net>
 <20191205064118.8299-1-vvidic@valentin-vidic.from.hr>
 <20191205113411.5e672807@cakuba.netronome.com>
 <CA+FuTSe=GSP41GG+QYKEmQ0eDUEoFeQ+oGAsgGJEZTe=hJq4Tw@mail.gmail.com>
 <20191205204343.GA20116@valentin-vidic.from.hr>
 <CA+FuTSeu-ouuT37d9r40o62=_PcGBUmE_HaOAr9EsNPzpTw=ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSeu-ouuT37d9r40o62=_PcGBUmE_HaOAr9EsNPzpTw=ag@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 04:26:14PM -0500, Willem de Bruijn wrote:
> > I based these on the description from the sendmsg manpage, but you decide:
> >
> > EOPNOTSUPP
> >     Some bit in the flags argument is inappropriate for the socket type.
> 
> Interesting. That is a narrower interpretation than asm-generic/errno.h
> 
>   #define EOPNOTSUPP      95      /* Operation not supported on
> transport endpoint */
> 
> which is also the string that strerror() generates.

Found one interesting example where EINVAL seems to mean "this value will never work"
and EOPNOTSUPP means "this value will not work in the current state/type of socket":

        case TCP_FASTOPEN_CONNECT:
                if (val > 1 || val < 0) {
                        err = -EINVAL;
                } else if (net->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) {
                        if (sk->sk_state == TCP_CLOSE)
                                tp->fastopen_connect = val;
                        else
                                err = -EINVAL;
                } else {
                        err = -EOPNOTSUPP;
                }
                break;

> I think there is a fundamental difference between, say, passing an
> argument of incorrect length (optlen < sizeof(..)) and asking for a
> possibly unsupported cipher mode. But consistency trumps that.
> 
> I don't mean to drag this out by bike-shedding.
> 
> Happy to defer to maintainers on whether the errno on published code
> can and should be changed, which is the more fundamental issue than
> the exact errno.
> 
> FWIW, I also did not see existing openssl and gnutls callers test the
> specific errno. The calls just fail on any setsockopt return value -1.

Right, I'm also fine with whatever the maintainer decides to take :)

-- 
Valentin
