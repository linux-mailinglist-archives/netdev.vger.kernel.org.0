Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4323C4A784C
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346783AbiBBSzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:55:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:52439 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239119AbiBBSzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:55:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643828103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSng3PPjp54gN45DcNQq0rlFyiYuB5ZJceCegS5/YFw=;
        b=SZ32Ukb0RI/9r/E/eUsfGKDUe1CyPRPvJlfnZWi7FFF0pFrhenGd7XnT8Em57/4bbDUkUp
        Gp+Co8NzfYteUsmUJH4yVHTOehxxKw8zQtJiji6oJgL0daghVusqbFlnCRyRCnegIWLTQ8
        3ld8LQUK6rFjt3gsjkiURBSAQG1TGYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-3WkJk-VLMHGYoxXm2y91Wg-1; Wed, 02 Feb 2022 13:55:00 -0500
X-MC-Unique: 3WkJk-VLMHGYoxXm2y91Wg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3094718B9ED9;
        Wed,  2 Feb 2022 18:54:59 +0000 (UTC)
Received: from localhost.localdomain (ovpn-0-18.rdu2.redhat.com [10.22.0.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78F5377C9B;
        Wed,  2 Feb 2022 18:54:58 +0000 (UTC)
Message-ID: <7c6ddb66d278cbf7c946994605cbd3c57f3a2508.camel@redhat.com>
Subject: Re: Getting the IPv6 'prefix_len' for DHCP6 assigned addresses.
From:   Dan Williams <dcbw@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@kernel.org>
Date:   Wed, 02 Feb 2022 12:54:57 -0600
In-Reply-To: <58dfe4b57faa4ead8a90c3fe924850c2@AcuMS.aculab.com>
References: <58dfe4b57faa4ead8a90c3fe924850c2@AcuMS.aculab.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 16:58 +0000, David Laight wrote:
> I'm trying to work out how DHCP6 is supposed to work.
> 
> I've a test network with the ISC dhcp6 server and radvd running.
> If I enable 'autoconf' I get a nice address with the prefix from
> radvd and the last 8 bytes from my mac address, prefix_len 64.
> I get a nice address from dhcp6 (busybox udhcpc6) with the same prefix.
> 
> udhcpc6 runs my scripts and 'ip add $ipv6 dev $interface' adds the
> address.
> But the associated prefix_len is /128.
> 
> All the documentation for DHCP6 says the prefix_len (and probably the
> default route - but I've not got that far) should come from the network
> (I think from RA messages).
> 
> But I can't get it to work, and google searches just seem to show
> everyone else having the same problem.
> 
> The only code I've found that looks at the prefix_len from RA messages
> is that which adds to 'autoconf' addresses - and that refuses to do
> anything unless the prefix_len is 64.
> 
> I can't see anything that would change the prefix_len of an address
> that dhcp6 added.
> 
> Has something fallen down a big crack?

I'm far from an expert, but I don't think anything has fallen down a
crack. I'm sure David Ahern or somebody else will correct me, but here
goes:

Things are working as intended.

DHCPv6 is not a complete IPv6 addressing solution. It must be used in
combination with Router Advertisements to do generally useful things.

https://datatracker.ietf.org/doc/html/rfc8415#section-21.6

21.6.  IA Address Option

      IPv6-address         An IPv6 address.  A client MUST NOT form an
                           implicit prefix with a length other than 128
                           for this address.  A 16-octet field.

DHCPv6 intentionally doesn't tell you who your IPv6 router (gateway in
v4-land) is. That's what the Router Advertisement is for.

DHCPv6 intentionally doesn't tell you anything about what prefixes are
"on-link" like what the subnet mask implies for IPv4. That's what the
Router Advertisement is for.

If the router sends an RA with a Prefix Information Option (PIO) with
the "on-link" (L) bit set then the kernel should install on-link routes
for that prefix. If your DHCPv6-provided address falls within one of
those prefixes then kernel routing takes over and packets go where they
should regardless of the /128.

If you don't have RAs, or don't have those routes installed because the
router wasn't sending a PIO+L for the DHCP-provided prefixes, then yeah
things aren't going to work like you might expect.

I'm sure David will be along to correct me soon though...

Dan

> Kernel is 5.10.84 (LTS) - but I don't think anything relevant
> will have changed.
> 
>         David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes,
> MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 


