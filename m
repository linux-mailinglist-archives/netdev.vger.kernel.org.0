Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D202B2431
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgKMTBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:01:19 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:41095 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgKMTBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:01:18 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CXnqr5nT4z3qxt0;
        Fri, 13 Nov 2020 20:01:12 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CXnqX0kJLz2TTHp;
        Fri, 13 Nov 2020 20:00:56 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.24) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 13 Nov
 2020 19:58:09 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "Richard Cochran" <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        "Codrin Ciubotariu" <codrin.ciubotariu@microchip.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2 08/11] net: ptp: add helper for one-step P2P clocks
Date:   Fri, 13 Nov 2020 19:57:18 +0100
Message-ID: <2009343.a9G9AutfCf@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201113005124.n3stqpzafx65tz2u@skbuf>
References: <20201112153537.22383-1-ceggers@arri.de> <20201112153537.22383-9-ceggers@arri.de> <20201113005124.n3stqpzafx65tz2u@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.24]
X-RMX-ID: 20201113-200102-4CXnqX0kJLz2TTHp-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, 13 November 2020, 01:51:24 CET, Vladimir Oltean wrote:
> On Thu, Nov 12, 2020 at 04:35:34PM +0100, Christian Eggers wrote:
> > This function subtracts the ingress hardware time stamp from the
> > correction field of a PTP header and updates the UDP checksum (if UDP is
> > used as transport. It is needed for hardware capable of one-step P2P
> 
> Please close the parenthesis.
> 
> > that does not already modify the correction field of Pdelay_Req event
> > messages on ingress.
> > 
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
> 
> Please add more verbiage here, giving the reader as much context as
> possible. You are establishing a de-facto approach for one-step peer
> delay timestamping for hardware like yours, you need to explain why it
> is done this way, for people to understand just by looking at git blame.
> 
> > ---
> > 
> >  include/linux/ptp_classify.h | 97 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 97 insertions(+)
> > 
> > diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> > index 56b2d7d66177..f27b512e1abd 100644
> > --- a/include/linux/ptp_classify.h
> > +++ b/include/linux/ptp_classify.h
> > @@ -10,8 +10,12 @@
> > 
> >  #ifndef _PTP_CLASSIFY_H_
> >  #define _PTP_CLASSIFY_H_
> > 
> > +#include <asm/unaligned.h>
> > 
> >  #include <linux/ip.h>
> > 
> > +#include <linux/ktime.h>
> > 
> >  #include <linux/skbuff.h>
> > 
> > +#include <linux/udp.h>
> > +#include <net/checksum.h>
> > 
> >  #define PTP_CLASS_NONE  0x00 /* not a PTP event message */
> >  #define PTP_CLASS_V1    0x01 /* protocol version 1 */
> > 
> > @@ -118,6 +122,91 @@ static inline u8 ptp_get_msgtype(const struct
> > ptp_header *hdr,> 
> >  	return msgtype;
> >  
> >  }
> > 
> > +/**
> > + * ptp_check_diff8 - Computes new checksum (when altering a 64-bit field)
> > + * @old: old field value
> > + * @new: new field value
> > + * @oldsum: previous checksum
> > + *
> > + * This function can be used to calculate a new checksum when only a
> > single + * field is changed. Similar as ip_vs_check_diff*() in ip_vs.h.
> > + *
> > + * Return: Updated checksum
> > + */
> > +static inline __wsum ptp_check_diff8(__be64 old, __be64 new, __wsum
> > oldsum) +{
> > +	__be64 diff[2] = { ~old, new };
> > +
> > +	return csum_partial(diff, sizeof(diff), oldsum);
> > +}
> > +
> > +/**
> > + * ptp_onestep_p2p_move_t2_to_correction - Update PTP header's correction
> > field + * @skb: packet buffer
> > + * @type: type of the packet (see ptp_classify_raw())
> > + * @hdr: ptp header
> > + * @t2: ingress hardware time stamp
> > + *
> > + * This function subtracts the ingress hardware time stamp from the
> > correction + * field of a PTP header and updates the UDP checksum (if UDP
> > is used as + * transport). It is needed for hardware capable of one-step
> > P2P that does not + * already modify the correction field of Pdelay_Req
> > event messages on ingress. + */
> > +static inline
> > +void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff *skb,
> > +					   unsigned int type,
> > +					   struct ptp_header *hdr,
> > +					   ktime_t t2)
> 
> The way this function is coded up right now, there's no reason to call it:
> - onestep
> - p2p
> - move_t2_to_correction
> As it is, it would be better named ptp_header_update_correction.

Do you want to provide the verbatim value of the correction field instead of t2?
I already considered this prototype as long as I wanted to move the "negative
correction back to the tail tag".

Providing the verbatim correction value would make this function more flexible
for other user but would move reading the old correction value to the caller.

> 
> > +{
> > +	u8 *ptr = skb_mac_header(skb);
> > +	struct udphdr *uhdr = NULL;
> > +	s64 ns = ktime_to_ns(t2);
> > +	__be64 correction_old;
> > +	s64 correction;
> > +
> > +	/* previous correction value is required for checksum update. */
> > +	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
> > +	correction = (s64)be64_to_cpu(correction_old);
> > +
> > +	/* PTP correction field consists of 32 bit nanoseconds and 16 bit
> 
> 48 bit nanoseconds
> 
> > +	 * fractional nanoseconds.  Avoid shifting negative numbers.
> > +	 */
> > +	if (ns >= 0)
> > +		correction -= ns << 16;
> > +	else
> > +		correction += -ns << 16;
> 
> Again? Why? There's nothing wrong with left-shifting negative numbers,
> two's complement works the same (note that right-shifting is a different
> story, but that's not the case here).
I had the same in mind, but googling for this gave another result:
https://stackoverflow.com/questions/3784996/why-does-left-shift-operation-invoke-undefined-behaviour-when-the-left-side-oper

Did I understand something wrong?

But without "moving negative correction values to the tail tag", there should
be no negative values for t2.

> 
> > +
> > +	/* write new correction value */
> > +	put_unaligned_be64((u64)correction, &hdr->correction);
> > +
> > +	/* locate udp header */
> > +	if (type & PTP_CLASS_VLAN)
> > +		ptr += VLAN_HLEN;
> 
> Can't you just go back from the struct ptp_header pointer and avoid this
> check?
This should also remove the distinction between IPV4 and IPV6. Knowing
that it's any of these should be enough.

> 
> > +	ptr += ETH_HLEN;
> > +
> > +	switch (type & PTP_CLASS_PMASK) {
> > +	case PTP_CLASS_IPV4:
> > +		ptr += ((struct iphdr *)ptr)->ihl << 2;
> > +		uhdr = (struct udphdr *)ptr;
> > +		break;
> > +	case PTP_CLASS_IPV6:
> > +		ptr += IP6_HLEN;
> > +		uhdr = (struct udphdr *)ptr;
> > +		break;
> > +	}
> > +
> > +	if (!uhdr)
> > +		return;
> > +
> > +	/* update checksum */
> > +	uhdr->check = csum_fold(ptp_check_diff8(correction_old,
> > +						hdr->correction,
> > +						~csum_unfold(uhdr->check)));
> > +	if (!uhdr->check)
> > +		uhdr->check = CSUM_MANGLED_0;
> > +}
> > +




