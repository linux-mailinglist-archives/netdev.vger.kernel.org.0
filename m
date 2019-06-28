Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D6D59660
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfF1IsL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 Jun 2019 04:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfF1IsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 04:48:11 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9DADC3082135;
        Fri, 28 Jun 2019 08:48:05 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFF9A5D962;
        Fri, 28 Jun 2019 08:47:52 +0000 (UTC)
Date:   Fri, 28 Jun 2019 10:46:23 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
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
        Daniel Borkmann <borkmann@iogearbox.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        brouer@redhat.com
Subject: Re: XDP multi-buffer incl. jumbo-frames (Was: [RFC V1 net-next 1/1]
 net: ena: implement XDP drop support)
Message-ID: <20190628104557.1ffef3e5@carbon>
In-Reply-To: <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
References: <20190623070649.18447-1-sameehj@amazon.com>
        <20190623070649.18447-2-sameehj@amazon.com>
        <20190623162133.6b7f24e1@carbon>
        <A658E65E-93D2-4F10-823D-CC25B081C1B7@amazon.com>
        <20190626103829.5360ef2d@carbon>
        <87a7e4d0nj.fsf@toke.dk>
        <20190626164059.4a9511cf@carbon>
        <87h88cbdbe.fsf@toke.dk>
        <CA+FuTSfKnhv9rr=cDa_4m7Dd9qkEm_oabDfyvH0T0sM+fQTU=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 28 Jun 2019 08:48:11 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 26 Jun 2019 11:20:45 -0400 Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> On Wed, Jun 26, 2019 at 11:01 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > > On Wed, 26 Jun 2019 13:52:16 +0200
> > > Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> > >  
> > >> Jesper Dangaard Brouer <brouer@redhat.com> writes:
> > >>  
[...]
> > >
> > > You touch upon some interesting complications already:
> > >
> > > 1. It is valuable for XDP bpf_prog to know "full" length?
> > >    (if so, then we need to extend xdp ctx with info)  
> >
> > Valuable, quite likely. A hard requirement, probably not (for all use
> > cases).  
> 
> Agreed.
> 
> One common validation use would be to drop any packets whose header
> length disagrees with the actual packet length.

That is a good point.

Added a section "XDP access to full packet length?" to capture this:
- https://github.com/xdp-project/xdp-project/commit/da5b84264b85b0d
- https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org#xdp-access-to-full-packet-length


> > >  But if we need to know the full length, when the first-buffer is
> > >  processed. Then realize that this affect the drivers RX-loop, because
> > >  then we need to "collect" all the buffers before we can know the
> > >  length (although some HW provide this in first descriptor).
> > >
> > >  We likely have to change drivers RX-loop anyhow, as XDP_TX and
> > >  XDP_REDIRECT will also need to "collect" all buffers before the packet
> > >  can be forwarded. (Although this could potentially happen later in
> > >  driver loop when it meet/find the End-Of-Packet descriptor bit).  
> 
> Yes, this might be quite a bit of refactoring of device driver code.
> 
> Should we move forward with some initial constraints, e.g., no
> XDP_REDIRECT, no "full" length and no bpf_xdp_adjust_tail?

I generally like this...

If not adding "full" length. Maybe we could add an indication to
XDP-developer, that his is a multi-buffer/multi-segment packet, such
that header length validation code against packet length (data_end-data)
is not possible.  This is user visible, so we would have to keep it
forever... I'm leaning towards adding "full" length from beginning.

> That already allows many useful programs.
>
> As long as we don't arrive at a design that cannot be extended with
> those features later.

That is the important part...

 
> > > 2. Can we even allow helper bpf_xdp_adjust_tail() ?
[...]
> >  
> > >  Perhaps it is better to let bpf_xdp_adjust_tail() fail runtime?  
> >
> > If we do disallow it, I think I'd lean towards failing the call at
> > runtime...  
> 
> Disagree. I'd rather have a program fail at load if it depends on
> multi-frag support while the (driver) implementation does not yet
> support it.

I usually agree that we should fail the program, early at load time.
For XDP we are unfortunately missing some knobs to do this, see[1].

Specifically for bpf_xdp_adjust_tail(), it might be better to fail
runtime.  Because, the driver might have enabled TSO for TCP packets,
while your XDP use-case is for adjusting UDP-packets (and do XDP level
replies), which will never see multi-buffer packets.  If we fail use of
bpf_xdp_adjust_tail(), then you would have to disable TSO to allow
loading your XDP-prog, hurting the other TSO-TCP use-case.


[1] http://vger.kernel.org/netconf2019_files/xdp-feature-detection.pdf
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
