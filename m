Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEE62D3362
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgLHUSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:18:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgLHURx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:17:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124D9C061257;
        Tue,  8 Dec 2020 12:16:54 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kmi5L-0001Ot-Lr; Tue, 08 Dec 2020 19:51:39 +0100
Date:   Tue, 8 Dec 2020 19:51:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
Message-ID: <20201208185139.GZ4647@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Eyal Birger <eyal.birger@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
References: <20201207134309.16762-1-phil@nwl.cc>
 <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eyal,

On Tue, Dec 08, 2020 at 04:47:02PM +0200, Eyal Birger wrote:
> On Mon, Dec 7, 2020 at 4:07 PM Phil Sutter <phil@nwl.cc> wrote:
> >
> > With an IPsec tunnel without dedicated interface, netfilter sees locally
> > generated packets twice as they exit the physical interface: Once as "the
> > inner packet" with IPsec context attached and once as the encrypted
> > (ESP) packet.
> >
> > With xfrm_interface, the inner packet did not traverse NF_INET_LOCAL_OUT
> > hook anymore, making it impossible to match on both inner header values
> > and associated IPsec data from that hook.
> >
> 
> Why wouldn't locally generated traffic not traverse the
> NF_INET_LOCAL_OUT hook via e.g. __ip_local_out() when xmitted on an xfrmi?
> I would expect it to appear in netfilter, but without the IPsec
> context, as it's not
> there yet.

Yes, that's right. Having an iptables rule with LOG target in OUTPUT
chain, a packet sent from the local host is logged multiple times:

| IN= OUT=xfrm SRC=192.168.111.1 DST=192.168.111.2 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=21840 DF
| PROTO=ICMP TYPE=8 CODE=0 ID=56857 SEQ=1
| IN= OUT=eth0 SRC=192.168.111.1 DST=192.168.111.2 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=21840 DF PROTO=ICMP TYPE=8 CODE=0 ID=56857 SEQ=1
| IN= OUT=eth0 SRC=192.168.1.1 DST=192.168.1.2 LEN=140 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=ESP SPI=0x1000

First when being sent to xfrm interface, then two times between xfrm and
eth0, the second time as ESP packet. This is with my patch applied.
Without it, the second log entry is missing. I'm arguing the above is
consistent to IPsec without xfrm interface:

| IN= OUT=eth1 SRC=192.168.112.1 DST=192.168.112.2 LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=49341 DF PROTO=ICMP TYPE=8 CODE=0 ID=44114 SEQ=1
| IN= OUT=eth1 SRC=192.168.2.1 DST=192.168.2.2 LEN=140 TOS=0x00 PREC=0x00 TTL=64 ID=37109 DF PROTO=ESP SPI=0x1000

The packet appears twice being sent to eth1, the second time as ESP
packet. I understand xfrm interface as a collector of to-be-xfrmed
packets, dropping those which do not match a policy.

> > Fix this by looping packets transmitted from xfrm_interface through
> > NF_INET_LOCAL_OUT before passing them on to dst_output(), which makes
> > behaviour consistent again from netfilter's point of view.
> 
> When an XFRM interface is used when forwarding, why would it be correct
> for NF_INET_LOCAL_OUT to observe the inner packet?

A valid question, indeed. One could interpret packets being forwarded by
those tunneling devices emit the packets one feeds them from the local
host. I just checked and ip_vti behaves identical to xfrm_interface
prior to my patch, so maybe my patch is crap and the inability to match
on ipsec context data when using any of those devices is just by design.

Thanks, Phil
