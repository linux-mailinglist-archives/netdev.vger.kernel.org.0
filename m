Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC202141F02
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 17:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgASQRy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Jan 2020 11:17:54 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32070 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgASQRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 11:17:53 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-gvmxi1jGNLWrJHBGlustNQ-1; Sun, 19 Jan 2020 11:17:50 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 656CE1005510;
        Sun, 19 Jan 2020 16:17:49 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48AB027089;
        Sun, 19 Jan 2020 16:17:48 +0000 (UTC)
Date:   Sun, 19 Jan 2020 17:17:46 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH iproute2-next v2] ip: xfrm: add espintcp encapsulation
Message-ID: <20200119161746.GA196479@bistromath.localdomain>
References: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
 <b7f74a02-ff87-1cd5-c3cb-7b620bd11fe2@gmail.com>
 <20200119154401.GA194807@bistromath.localdomain>
 <263b8a2b-6d46-546d-1195-7c76ec88534e@gmail.com>
MIME-Version: 1.0
In-Reply-To: <263b8a2b-6d46-546d-1195-7c76ec88534e@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: gvmxi1jGNLWrJHBGlustNQ-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-01-19, 09:05:45 -0700, David Ahern wrote:
> On 1/19/20 8:44 AM, Sabrina Dubroca wrote:
> > 2020-01-19, 08:31:32 -0700, David Ahern wrote:
> >> On 1/19/20 3:32 AM, Sabrina Dubroca wrote:
> >>> diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
> >>> new file mode 100644
> >>> index 000000000000..2d1f561b89d2
> >>> --- /dev/null
> >>> +++ b/include/uapi/linux/udp.h
> >>> @@ -0,0 +1,47 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> >>> +/*
> >>> + * INET		An implementation of the TCP/IP protocol suite for the LINUX
> >>> + *		operating system.  INET is implemented using the  BSD Socket
> >>> + *		interface as the means of communication with the user level.
> >>> + *
> >>> + *		Definitions for the UDP protocol.
> >>> + *
> >>> + * Version:	@(#)udp.h	1.0.2	04/28/93
> >>> + *
> >>> + * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
> >>> + *
> >>> + *		This program is free software; you can redistribute it and/or
> >>> + *		modify it under the terms of the GNU General Public License
> >>> + *		as published by the Free Software Foundation; either version
> >>> + *		2 of the License, or (at your option) any later version.
> >>> + */
> >>> +#ifndef _UDP_H
> >>> +#define _UDP_H
> >>> +
> >>> +#include <linux/types.h>
> >>> +
> >>> +struct udphdr {
> >>> +	__be16	source;
> >>> +	__be16	dest;
> >>> +	__be16	len;
> >>> +	__sum16	check;
> >>> +};
> >>> +
> >>> +/* UDP socket options */
> >>> +#define UDP_CORK	1	/* Never send partially complete segments */
> >>> +#define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
> >>> +#define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
> >>> +#define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
> >>> +#define UDP_SEGMENT	103	/* Set GSO segmentation size */
> >>> +#define UDP_GRO		104	/* This socket can receive UDP GRO packets */
> >>> +
> >>> +/* UDP encapsulation types */
> >>> +#define UDP_ENCAP_ESPINUDP_NON_IKE	1 /* draft-ietf-ipsec-nat-t-ike-00/01 */
> >>> +#define UDP_ENCAP_ESPINUDP	2 /* draft-ietf-ipsec-udp-encaps-06 */
> >>> +#define UDP_ENCAP_L2TPINUDP	3 /* rfc2661 */
> >>> +#define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
> >>> +#define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
> >>> +#define UDP_ENCAP_RXRPC		6
> >>> +#define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
> >>> +
> >>> +#endif /* _UDP_H */
> >>
> >> Hi Sabrina:
> >>
> >> I am confused about this header file. It is not from the kernel's uapi
> >> directory, so the kernel does not care about the values and where did
> >> you get the file?
> > 
> > Uh? It's right there:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next.git/tree/include/uapi/linux/udp.h
> > 
> 
> ah, but not in Dave's net-next which is what I use to sync iproute2 uapi
> headers.

Ah, yes, because I need TCP_ENCAP_ESPINTCP, as I wrote in the commit message:

> add the
> UAPI udp.h header (sync'd from ipsec-next to get the TCP_ENCAP_ESPINTCP
> definition).


> I will hold onto this patch until ipsec-next merges into net-next.

Makes sense, thanks.

-- 
Sabrina

