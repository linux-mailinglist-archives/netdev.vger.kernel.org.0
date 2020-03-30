Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6567A1980AD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbgC3QNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:13:42 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55468 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgC3QNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:13:42 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jIx2e-000544-RQ; Mon, 30 Mar 2020 18:13:36 +0200
Date:   Mon, 30 Mar 2020 18:13:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] udp: fix a skb extensions leak
Message-ID: <20200330161336.GD23604@breakpoint.cc>
References: <e17fe23a0a5f652866ec623ef0cde1e6ef5dbcf5.1585213585.git.lucien.xin@gmail.com>
 <20200330082929.GG13121@gauss3.secunet.de>
 <CADvbK_egz4aYOHa2+FPL6V+vXcfRGst6zEiUxqskpHc3fOk-oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_egz4aYOHa2+FPL6V+vXcfRGst6zEiUxqskpHc3fOk-oA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xin Long <lucien.xin@gmail.com> wrote:
> On Mon, Mar 30, 2020 at 4:29 PM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Thu, Mar 26, 2020 at 05:06:25PM +0800, Xin Long wrote:
> > > On udp rx path udp_rcv_segment() may do segment where the frag skbs
> > > will get the header copied from the head skb in skb_segment_list()
> > > by calling __copy_skb_header(), which could overwrite the frag skbs'
> > > extensions by __skb_ext_copy() and cause a leak.
> > >
> > > This issue was found after loading esp_offload where a sec path ext
> > > is set in the skb.
> > >
> > > On udp tx gso path, it works well as the frag skbs' extensions are
> > > not set. So this issue should be fixed on udp's rx path only and
> > > release the frag skbs' extensions before going to do segment.
> >
> > Are you sure that this affects only the RX path? What if such
> > a packet is forwarded? Also, I think TCP has the same problem.
> You're right, just confirm it exists on the forwarded path.
> __copy_skb_header() is also called by skb_segment(), but
> I don't have tests to reproduce it on other protocols like TCP.

skb_segment() is fine, either nskb is a new allocation or a clone
with head state already discarded.

> > If a skb in the fraglist has a secpath, it is still valid.
> > So maybe instead of dropping it here and assign the one
> > from the head skb, we could just keep the secpath. But
> > I don't know about other extensions. I've CCed Florian,
> > he might know a bit more about other extensions. Also,
> > it might be good to check if the extensions of the GRO
> > packets are all the same before merging.
> >
> Not sure if we can improve __copy_skb_header() or add
> a new function to copy these members ONLY when nskb's
> are not set.

I don't see how.
