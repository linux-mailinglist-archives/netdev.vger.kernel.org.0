Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60CA35C528
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfGAVqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:46:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38816 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAVqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:46:55 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hi48P-0000Jk-DW; Mon, 01 Jul 2019 21:46:49 +0000
Date:   Mon, 1 Jul 2019 22:46:49 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: fix ntohs/htons sparse warnings
Message-ID: <20190701214649.GE17978@ZenIV.linux.org.uk>
References: <1d1f9dba-1ade-7782-6cc0-3151a7086a4b@gmail.com>
 <20190701195621.GC17978@ZenIV.linux.org.uk>
 <81c45b3c-bbaa-c619-981c-8b8f4b73d5c5@gmail.com>
 <20190701211356.GD17978@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701211356.GD17978@ZenIV.linux.org.uk>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:13:56PM +0100, Al Viro wrote:
> On Mon, Jul 01, 2019 at 10:36:26PM +0200, Heiner Kallweit wrote:
> 
> > > The code dealing with the value passed to __vlan_hwaccel_put_tag() as the
> > > third argument treats it as a host-endian integer.  So... Has anyone
> > > tested that code on b-e host?  Should that ntohs() actually be swab16(),
> > > yielding (on any host) the same value we currently get for l-e hosts only?
> > > 
> > I haven't seen any b-e host with a Realtek network chip yet.
> 
> Ever tried to google for realtek 8169 pcie card?  The first hit is this:
> https://www.amazon.com/Realtek-Chipset-Ethernet-Interface-Software/dp/B007MWYCG2
> and certainly does look like it should fit into at least some G5 Macs.
> What's more, googling for realtek 8169 PCI card brings quite a bit (top
> hit happens to be on ebay for ~$8).  That certainly shall fit into
> any number of big-endian motherboards...
> 
> Sure, there's a plenty of embedded r8169 on motherboards (mostly x86 ones),
> but these beasts do exist on discrete cards.  I'm fairly certain that I've
> got one or two somewhere in the detritus pile and they are fairly cheap
> these days.
> 
> So it wouldn't cost too much to put together a mixed network, with
> r8169 both on l-e and b-e hosts and play with VLAN setups there...

FWIW, looking at r8169 docs, they say that Rx descriptor has, at offset
4, a 32bit value (l-e) with
	bits 17..31 reserved
	bit 16: TAVA (Tag Available)
	bits 8..15: VIDL (lower 8 bits of VLAN ID)
	bits 5..7: PRIO (priority)
	bit 4: CFI (Canonical Format Indicator)
	bits 0..3: VIDH (upper 4 bits of VLAN ID)

AFAICS, in kernel-side representation we want VIDL in bits 0..7, VIDH - 8..11,
CFI - 12 and PRIO - 13..15, so that VLAN ID is simply value & 0xfff.

IOW, we do want 256 * octet4 + octet5, i.e.
	swab16(le32_to_cpu(desc->opts2) & 0xffff).
Regardless of the host endianness.  Some cards might be possible to set up to
byteswap the 32bit values on the way to/from host, but even in that case we
would have wanted
	swab16(desc->opts2 & 0xffff),
not
	be16_to_cpu(le32_to_cpu(desc->opts2 & 0xffff)
and if it *is* set that way, the current code will break anyway.

Again, all of that is from RTFS alone - I have _not_ tested that, but
it does look like your original patch has missed that while these
16 bits are stored in network order _in_ _card_ _memory_, we'd
already done cpu_to_le32 to the containing 32bit word.  So the
value is host-endian, and the lower 16 bits are consistently in
the wrong order, be it b-e or l-e host.  IOW, swab16 is the right
thing to do and sparse warning has been correct.
