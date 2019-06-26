Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BCF56C61
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfFZOlS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 26 Jun 2019 10:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56326 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfFZOlS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 10:41:18 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7344D308425B;
        Wed, 26 Jun 2019 14:41:14 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 497BE60C43;
        Wed, 26 Jun 2019 14:41:00 +0000 (UTC)
Date:   Wed, 26 Jun 2019 16:40:59 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "Machulsky\, Zorik" <zorik@amazon.com>,
        "Jubran\, Samih" <sameehj@amazon.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse\, David" <dwmw@amazon.co.uk>,
        "Matushevsky\, Alexander" <matua@amazon.com>,
        "Bshara\, Saeed" <saeedb@amazon.com>,
        "Wilson\, Matt" <msw@amazon.com>,
        "Liguori\, Anthony" <aliguori@amazon.com>,
        "Bshara\, Nafea" <nafea@amazon.com>,
        "Tzalik\, Guy" <gtzalik@amazon.com>,
        "Belgazal\, Netanel" <netanel@amazon.com>,
        "Saidi\, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt\, Benjamin" <benh@amazon.com>,
        "Kiyanovski\, Arthur" <akiyano@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "xdp-newbies\@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Message-ID: <20190626164059.4a9511cf@carbon>
In-Reply-To: <87a7e4d0nj.fsf@toke.dk>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
        <20190623162133.6b7f24e1@carbon>
        <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
        <20190626103829.5360ef2d@carbon>
        <87a7e4d0nj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 26 Jun 2019 14:41:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 13:52:16 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> 
> > On Tue, 25 Jun 2019 03:19:22 +0000
> > "Machulsky, Zorik" <zorik@amazon.com> wrote:
> >  
> >> ﻿On 6/23/19, 7:21 AM, "Jesper Dangaard Brouer" <brouer@redhat.com> wrote:
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
> > discussions: [2] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
> >
> > The use-case that really convinced me was Eric's packet header-split.
> >
> >
> > Lets refresh: Why XDP don't have multi-buffer support:
> >
> > XDP is designed for maximum performance, which is why certain driver-level
> > use-cases were not supported, like multi-buffer packets (like jumbo-frames).
> > As it e.g. complicated the driver RX-loop and memory model handling.
> >
> > The single buffer per packet design, is also tied into eBPF Direct-Access
> > (DA) to packet data, which can only be allowed if the packet memory is in
> > contiguous memory.  This DA feature is essential for XDP performance.
> >
> >
> > One way forward is to define that XDP only get access to the first
> > packet buffer, and it cannot see subsequent buffers. For XDP_TX and
> > XDP_REDIRECT to work then XDP still need to carry pointers (plus
> > len+offset) to the other buffers, which is 16 bytes per extra buffer.  
> 
> Yeah, I think this would be reasonable. As long as we can have a
> metadata field with the full length + still give XDP programs the
> ability to truncate the packet (i.e., discard the subsequent pages)

You touch upon some interesting complications already:

1. It is valuable for XDP bpf_prog to know "full" length?
   (if so, then we need to extend xdp ctx with info)

 But if we need to know the full length, when the first-buffer is
 processed. Then realize that this affect the drivers RX-loop, because
 then we need to "collect" all the buffers before we can know the
 length (although some HW provide this in first descriptor).

 We likely have to change drivers RX-loop anyhow, as XDP_TX and
 XDP_REDIRECT will also need to "collect" all buffers before the packet
 can be forwarded. (Although this could potentially happen later in
 driver loop when it meet/find the End-Of-Packet descriptor bit).
 

2. Can we even allow helper bpf_xdp_adjust_tail() ?

 Wouldn't it be easier to disallow a BPF-prog with this helper, when
 driver have configured multi-buffer?  Or will it be too restrictive,
 if jumbo-frame is very uncommon and only enabled because switch infra
 could not be changed (like Amazon case).

 Perhaps it is better to let bpf_xdp_adjust_tail() fail runtime?


> I  think many (most?) use cases will work fine without having access
> to the full packet data...

I agree.  Other people should voice their concerns if they don't
agree...

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
