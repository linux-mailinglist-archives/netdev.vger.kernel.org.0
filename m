Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE914589B5
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 08:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbhKVHUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 02:20:04 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:54974 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhKVHUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 02:20:04 -0500
Received: from [172.16.68.9] (unknown [49.255.141.98])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 74EAB20164;
        Mon, 22 Nov 2021 15:16:56 +0800 (AWST)
Message-ID: <123a5491b8485f42c9279d397cdeb6358c610f6c.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next] mctp: Add MCTP-over-serial transport binding
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>
Date:   Mon, 22 Nov 2021 15:16:55 +0800
In-Reply-To: <YZs1p+lkKO+194zN@kroah.com>
References: <20211122042817.2988517-1-jk@codeconstruct.com.au>
         <YZs1p+lkKO+194zN@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

Thanks for the review, I'll get a v2 done. Some replies inline.

> > This change adds a MCTP Serial transport binding, as per DMTF
> > DSP0253.
> 
> What is "DMTF DSP0253"?  Can you provide a link to this or more
> information that explains why this has to be a serial thing?

Sure, can do!

[it doesn't *have* to be a serial thing - MCTP supports multiple
physical layers as "transports" - current specs define transports for
serial, i2c and PCIe. The choice of transport will be dictated by
however you've connected your remote MCTP device(s). In this case
though, it's also handy for emulation, where we can transport MCTP
packets between virtual machines by connecting VMs' pty channels]

> > The 'mctp' utility provides the ldisc magic to set up the serial
> > link:
> > 
> >   # mctp link serial /dev/ttyS0 &
> >   # mctp link
> >   dev lo index 1 address 0x00:00:00:00:00:00 net 1 mtu 65536 up
> >   dev mctpserial0 index 5 address 0x(no-addr) net 1 mtu 68 down
> 
> Where is this magic mctp application?  I can't find it in my distro
> packages anywhere.

The MCTP support is pretty new, and possibly a bit eclectic for general
distro inclusion at this stage. I'll include a ref to the tools.

> > +         Say y here if you need to connect to MCTP devices over serial.
> 
> Module name?

Ack.

> > +#define MCTP_SERIAL_VERSION    0x1
> 
> Where does this number come from?

Defined by the current spec; I'll add a comment.

> > +static DEFINE_IDA(mctp_serial_ida);
> 
> I think you forgot to clean this up when the module is removed.

Would it be possible to have the module exit called while we still have
ida bitmaps still allocated? It looks like a ldisc being open will
require a reference on the module; so a module remove will mean we have
no ldiscs in use, and therefore an empty ida, so the ida_destroy() will
always be a no-op.

Is there a path I'm missing here? Or is this more of a completeness
thing?

Cheers,


Jeremy

