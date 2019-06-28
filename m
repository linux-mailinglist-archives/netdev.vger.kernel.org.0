Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C84595FA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfF1IXS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 04:23:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726056AbfF1IXS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 04:23:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3196D3073AFE;
        Fri, 28 Jun 2019 08:23:17 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BEC560C6E;
        Fri, 28 Jun 2019 08:22:55 +0000 (UTC)
Date:   Fri, 28 Jun 2019 10:22:54 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     "Eelco Chaudron" <echaudro@redhat.com>
Cc:     "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>, davem@davemloft.net,
        netdev@vger.kernel.org, "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Daniel Borkmann" <borkmann@iogearbox.net>,
        "Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?=" 
        <toke@redhat.com>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Alexei Starovoitov" <alexei.starovoitov@gmail.com>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org, brouer@redhat.com,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Message-ID: <20190628102254.28191f12@carbon>
In-Reply-To: <CC99D6DE-5B6B-42F3-8D68-7F9AFF1712FF@redhat.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
        <20190623162133.6b7f24e1@carbon>
        <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
        <20190626103829.5360ef2d@carbon>
        <CC99D6DE-5B6B-42F3-8D68-7F9AFF1712FF@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 28 Jun 2019 08:23:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 09:14:39 +0200
"Eelco Chaudron" <echaudro@redhat.com> wrote:

> On 26 Jun 2019, at 10:38, Jesper Dangaard Brouer wrote:
> 
> > On Tue, 25 Jun 2019 03:19:22 +0000
> > "Machulsky, Zorik" <zorik@amazon.com> wrote:
> >  
> >> ﻿On 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" <brouer@redhat.com> 
> >> wrote:
> >>
> >>     On Sun, 23 Jun 2019 10:06:49 +0300 <sameehj@amazon.com> wrote:
> >>  
> >>     > This commit implements the basic functionality of drop/pass logic in the  
> >>     > ena driver.  
> >>
> >>     Usually we require a driver to implement all the XDP return codes,
> >>     before we accept it.  But as Daniel and I discussed with Zorik during
> >>     NetConf[1], we are going to make an exception and accept the driver
> >>     if you also implement XDP_TX.
> >>
> >>     As we trust that Zorik/Amazon will follow and implement XDP_REDIRECT
> >>     later, given he/you wants AF_XDP support which requires XDP_REDIRECT.
> >>
> >> Jesper, thanks for your comments and very helpful discussion during
> >> NetConf! That's the plan, as we agreed. From our side I would like to
> >> reiterate again the importance of multi-buffer support by xdp frame.
> >> We would really prefer not to see our MTU shrinking because of xdp
> >> support.  
> >
> > Okay we really need to make a serious attempt to find a way to support
> > multi-buffer packets with XDP. With the important criteria of not
> > hurting performance of the single-buffer per packet design.
> >
> > I've created a design document[2], that I will update based on our
> > discussions: [2] 
> > https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> >
> > The use-case that really convinced me was Eric's packet header-split.
> >
> >
> > Lets refresh: Why XDP don't have multi-buffer support:
> >
> > XDP is designed for maximum performance, which is why certain 
> > driver-level
> > use-cases were not supported, like multi-buffer packets (like 
> > jumbo-frames).
> > As it e.g. complicated the driver RX-loop and memory model handling.
> >
> > The single buffer per packet design, is also tied into eBPF 
> > Direct-Access
> > (DA) to packet data, which can only be allowed if the packet memory is 
> > in
> > contiguous memory.  This DA feature is essential for XDP performance.
> >
> >
> > One way forward is to define that XDP only get access to the first
> > packet buffer, and it cannot see subsequent buffers.  For XDP_TX and
> > XDP_REDIRECT to work then XDP still need to carry pointers (plus
> > len+offset) to the other buffers, which is 16 bytes per extra buffer.  
> 
> 
> I’ve seen various network processor HW designs, and they normally get 
> the first x bytes (128 - 512) which they can manipulate 
> (append/prepend/insert/modify/delete).

Good data point, thank you!  It confirms that XDP only getting access to
the first packet-buffer makes sense, for most use-cases.

We also have to remember that XDP it not meant to handle every
use-case.  XDP is a software fast-path, that can accelerate certain
use-case.  We have the existing network stack as a fall-back for
handling the corner-cases, that would otherwise slowdown our XDP
fast-path.


> There are designs where they can “page in” the additional fragments 
> but it’s expensive as it requires additional memory transfers. But
> the majority do not care (cannot change) the remaining fragments. Can
> also not think of a reason why you might want to remove something at
> the end of the frame (thinking about routing/forwarding needs here).

Use-cases that need to adjust tail of packet:

- ICMP replies directly from XDP[1] need to shorten packet tail, but
  this use-case doesn't use fragments.

- IPsec need to add/extend packet tail for IPset-trailer[2], again
  unlikely that this needs fragments(?). (This use-case convinced me
  that we need to add extend-tail support to bpf_xdp_adjust_tail)

- DNS or memcached replies directly from XDP, need to extend packet
  tail, to have room for reply. (It would be interesting to allow larger
  replies, but I'm not sure we should ever support that).


> If we do want XDP to access other fragments we could do this through
> a helper which swaps the packet context?

That might be a way forward.  If the XDP developer have to call a
helper, then they should realize and "buy into" an additional
overhead/cost.


[1] https://github.com/torvalds/linux/blob/master/samples/bpf/xdp_adjust_tail_kern.c
[2] http://vger.kernel.org/netconf2019_files/xfrm_xdp.pdf
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
