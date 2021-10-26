Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F4943B14A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 13:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235490AbhJZLgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 07:36:52 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:42250 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhJZLgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 07:36:45 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 3433B20222;
        Tue, 26 Oct 2021 19:34:17 +0800 (AWST)
Message-ID: <cbf0fd9611c76e557b759ecbecf6bcf712b44f55.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v6] mctp: Implement extended addressing
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Eugene Syromiatnikov <esyr@redhat.com>
Date:   Tue, 26 Oct 2021 19:34:16 +0800
In-Reply-To: <f5b11b52cf0644088a919fb2a1a07c18@AcuMS.aculab.com>
References: <20211026015728.3006286-1-jk@codeconstruct.com.au>
         <f5b11b52cf0644088a919fb2a1a07c18@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> > +struct sockaddr_mctp_ext {
> > +       struct sockaddr_mctp    smctp_base;
> > +       int                     smctp_ifindex;
> > +       __u8                    smctp_halen;
> > +       __u8                    __smctp_pad0[3];
> > +       __u8                    smctp_haddr[MAX_ADDR_LEN];
> > +};
> 
> You'd be better off 8-byte aligning smctp_haddr.
> I also suspect that always copying the 32 bytes will be faster
> and generate less code than the memset() + memcpy().

The padding here is more to avoid layout variations between ABIs
rather than performance.

The largest current hardware address size that we need (for the i2c
transport) is... 1 byte. If we were to implement the PCIe VDM binding
for MCTP that'd then be the largest, now at 2 bytes. If anyone's crazy
enough to do MCTP over ethernet, we're still only at 6.

So, we'll be a long way off needing to optimise for 8-byte aligned
accesses here; I don't think the extra padding would be worth it.

Cheers,


Jeremy

