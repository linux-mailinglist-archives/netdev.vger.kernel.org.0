Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596ED141A0F
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 23:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgARWen convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Jan 2020 17:34:43 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40999 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726960AbgARWen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 17:34:43 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-jIDkwQWgNTC2GZn2PaZ7GA-1; Sat, 18 Jan 2020 17:34:38 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D9DC8017CC;
        Sat, 18 Jan 2020 22:34:37 +0000 (UTC)
Received: from bistromath.localdomain (ovpn-117-110.ams2.redhat.com [10.36.117.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAAA084BBB;
        Sat, 18 Jan 2020 22:34:35 +0000 (UTC)
Date:   Sat, 18 Jan 2020 23:34:33 +0100
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH iproute2-next] ip: xfrm: add espintcp encapsulation
Message-ID: <20200118223433.GA159952@bistromath.localdomain>
References: <0b5baa21f8d0048b5e97f927e801ac2f843bb5e1.1579104430.git.sd@queasysnail.net>
 <2df9df78-0383-c914-596e-1855c69fb170@gmail.com>
MIME-Version: 1.0
In-Reply-To: <2df9df78-0383-c914-596e-1855c69fb170@gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: jIDkwQWgNTC2GZn2PaZ7GA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-01-18, 14:24:45 -0700, David Ahern wrote:
> On 1/16/20 3:39 AM, Sabrina Dubroca wrote:
> > diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
> > index 32f560933a47..e310860b9f1f 100644
> > --- a/ip/ipxfrm.c
> > +++ b/ip/ipxfrm.c
> > @@ -759,6 +759,9 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
> >  		case 2:
> >  			fprintf(fp, "espinudp ");
> >  			break;
> > +		case 7:
> > +			fprintf(fp, "espintcp ");
> > +			break;
> >  		default:
> >  			fprintf(fp, "%u ", e->encap_type);
> >  			break;
> > @@ -1211,6 +1214,8 @@ int xfrm_encap_type_parse(__u16 *type, int *argcp, char ***argvp)
> >  		*type = 1;
> >  	else if (strcmp(*argv, "espinudp") == 0)
> >  		*type = 2;
> > +	else if (strcmp(*argv, "espintcp") == 0)
> > +		*type = 7;
> >  	else
> >  		invarg("ENCAP-TYPE value is invalid", *argv);
> >  
> 
> are there enums / macros for the magic numbers?

Yes, in include/uapi/linux/udp.h:

/* UDP encapsulation types */
#define UDP_ENCAP_ESPINUDP_NON_IKE	1 /* draft-ietf-ipsec-nat-t-ike-00/01 */
#define UDP_ENCAP_ESPINUDP	2 /* draft-ietf-ipsec-udp-encaps-06 */
#define UDP_ENCAP_L2TPINUDP	3 /* rfc2661 */
#define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
#define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
#define UDP_ENCAP_RXRPC		6
#define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */


Since the existing code wasn't using them (no idea why), I did the
same. I can change that if you prefer (and add udp.h to iproute's
include/uapi, since it's currently missing).

-- 
Sabrina

