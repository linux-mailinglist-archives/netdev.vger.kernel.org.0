Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7558321A7DB
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGITef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:34:35 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:14372 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbgGITef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:34:35 -0400
Received: (qmail 77774 invoked by uid 89); 9 Jul 2020 19:34:34 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 9 Jul 2020 19:34:34 -0000
Date:   Thu, 9 Jul 2020 12:34:31 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        A.Zema@falconvsystems.com
Subject: Re: [PATCH bpf] xsk: do not discard packet when QUEUE_STATE_FROZEN
Message-ID: <20200709193431.wruc3u6x5ddnkicv@bsd-mbp.dhcp.thefacebook.com>
References: <1594287951-27479-1-git-send-email-magnus.karlsson@intel.com>
 <20200709170356.pivsunwnk57jm4kr@bsd-mbp.dhcp.thefacebook.com>
 <CAJ8uoz2_m+-s4UXuChu9Edk99BS7NK=0cRFGFB4+z9KsHiDTMg@mail.gmail.com>
 <CAJ8uoz1WTvNC52GTB4rqNV3arDhufXr_xrDg9pJfxvMK6stkZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz1WTvNC52GTB4rqNV3arDhufXr_xrDg9pJfxvMK6stkZg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 09:30:42PM +0200, Magnus Karlsson wrote:
> On Thu, Jul 9, 2020 at 7:10 PM Magnus Karlsson
> <magnus.karlsson@gmail.com> wrote:
> >
> > On Thu, Jul 9, 2020 at 7:06 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> > >
> > > On Thu, Jul 09, 2020 at 11:45:51AM +0200, Magnus Karlsson wrote:
> > > > In the skb Tx path, transmission of a packet is performed with
> > > > dev_direct_xmit(). When QUEUE_STATE_FROZEN is set in the transmit
> > > > routines, it returns NETDEV_TX_BUSY signifying that it was not
> > > > possible to send the packet now, please try later. Unfortunately, the
> > > > xsk transmit code discarded the packet and returned EBUSY to the
> > > > application. Fix this unnecessary packet loss, by not discarding the
> > > > packet and return EAGAIN. As EAGAIN is returned to the application, it
> > > > can then retry the send operation and the packet will finally be sent
> > > > as we will likely not be in the QUEUE_STATE_FROZEN state anymore. So
> > > > EAGAIN tells the application that the packet was not discarded from
> > > > the Tx ring and that it needs to call send() again. EBUSY, on the
> > > > other hand, signifies that the packet was not sent and discarded from
> > > > the Tx ring. The application needs to put the packet on the Tx ring
> > > > again if it wants it to be sent.
> > >
> > > Doesn't the original code leak the skb if NETDEV_TX_BUSY is returned?
> > > I'm not seeing where it was released.  The new code looks correct.
> >
> > You are correct. Should also have mentioned that in the commit message.
> 
> Jonathan,
> 
> Some context here. The bug report from Arkadiusz started out with the
> unnecessary packet loss. While fixing it, I discovered that it was
> actually leaking memory too. If you want, I can send a v2 that has a
> commit message that mentions both problems? Let me know what you
> prefer.

I think it would be best to mention both problems for the benefit of
future readers.
-- 
Jonathan
