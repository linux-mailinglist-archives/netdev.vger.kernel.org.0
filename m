Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5547A2A87D9
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731922AbgKEUTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:19:25 -0500
Received: from mailout12.rmx.de ([94.199.88.78]:35910 "EHLO mailout12.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730973AbgKEUTY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 15:19:24 -0500
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout12.rmx.de (Postfix) with ESMTPS id 4CRvxg4GVwzRpXp;
        Thu,  5 Nov 2020 21:19:19 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CRvxQ6K0Kz2xDW;
        Thu,  5 Nov 2020 21:19:06 +0100 (CET)
Received: from n95hx1g2.localnet (192.168.54.22) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 5 Nov
 2020 21:18:05 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add hardware time stamping support
Date:   Thu, 5 Nov 2020 21:18:04 +0100
Message-ID: <5844018.3araiXeC39@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201022113243.4shddtywgvpcqq6c@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de> <2541271.Km786uMvHt@n95hx1g2> <20201022113243.4shddtywgvpcqq6c@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.22]
X-RMX-ID: 20201105-211906-4CRvxQ6K0Kz2xDW-0@kdin01
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Thursday, 22 October 2020, 13:32:43 CET, Vladimir Oltean wrote:
> On Thu, Oct 22, 2020 at 01:11:40PM +0200, Christian Eggers wrote:
> > On Thursday, 22 October 2020, 12:50:14 CEST, Vladimir Oltean wrote:
> > after applying the RX timestamp correctly to the correction field
> > (shifting
> > the nanoseconds by 16),
> 
> That modification should have been done anyway, since the unit of
> measurement for correctionField is scaled ppb (48 bits nanoseconds, 16
> bits scaled nanoseconds), and not nanoseconds.
> 
> > it seems that "moving" the timestamp back to the tail tag on TX is not
> > required anymore. Keeping the RX timestamp simply in the correction
> > field (negative value), works fine now. So this halves the effort in
> > the tag_ksz driver.

unfortunately I made a mistake when testing. Actually the timestamp *must* be
moved from the correction field (negative) to the egress tail tag.

> Ok, this makes sense.
> Depending on what Richard responds, it now looks like the cleanest
> approach would be to move your implementation that is currently in
> ksz9477_update_ptp_correction_field() into a generic function called
> 
> static inline void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff
> *skb, unsigned int ptp_type,
>  struct ptp_header *ptp_header,
> ktime_t t2)
I have implemented this in ptp_classify.h. Passing t2 instead of the correction
field itself is fine for rx, but as this function is now still required for
transmit, it looks a little bit misused there (see below).

Shall I keep it as below, or revert it to passing value of the correction field
itself?

regards
Christian


static void ksz9477_xmit_timestamp(struct sk_buff *skb)
{
	struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
	struct ptp_header *ptp_hdr;
	u32 tstamp_raw = 0;
	u64 correction;

	if (!clone)
		goto out_put_tag;

	/* Use cached PTP header and type from ksz9477_ptp_should_tstamp(). Note
	 * that KSZ9477_SKB_CB(clone)->ptp_header != NULL implies that this is a
	 * Pdelay_resp message.
	 */
	ptp_hdr = KSZ9477_SKB_CB(clone)->ptp_header;
	if (!ptp_hdr)
		goto out_put_tag;

	correction = get_unaligned_be64(&ptp_hdr->correction);

	/* For PDelay_Resp messages we will likely have a negative value in the
	 * correction field (see ksz9477_rcv()). The switch hardware cannot
	 * correctly update such values, so it must be moved to the time stamp
	 * field in the tail tag.
	 */
	if ((s64)correction < 0) {
		unsigned int ptp_type = KSZ9477_SKB_CB(clone)->ptp_type;
		struct timespec64 ts;
		u64 ns;

		/* Move ingress time stamp from PTP header's correction field to
		 * tail tag. Format of the correction filed is 48 bit ns + 16
		 * bit fractional ns.  Avoid shifting negative numbers.
		 */
		ns = -((s64)correction) >> 16;
		ts = ns_to_timespec64(ns);
		tstamp_raw = ((ts.tv_sec & 3) << 30) | ts.tv_nsec;

>>>		/* Set correction field to 0 (by subtracting the negative value)
>>>		 * and update UDP checksum.
>>>		 */
>>>		ptp_onestep_p2p_move_t2_to_correction(skb, ptp_type, ptp_hdr, ns_to_ktime(-ns));
	}

out_put_tag:
	put_unaligned_be32(tstamp_raw, skb_put(skb, KSZ9477_PTP_TAG_LEN));
}


Addtionally ptp_onestep_p2p_move_t2_to_correction() must be able to handle negative values:

static inline
void ptp_onestep_p2p_move_t2_to_correction(struct sk_buff *skb,
					   unsigned int type,
					   struct ptp_header *hdr,
					   ktime_t t2)
{
	u8 *ptr = skb_mac_header(skb);
	struct udphdr *uhdr = NULL;
	s64 ns = ktime_to_ns(t2);
	__be64 correction_old;
	s64 correction;

	/* previous correction value is required for checksum update. */
	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
	correction = (s64)be64_to_cpu(correction_old);

	/* PTP correction field consists of 32 bit nanoseconds and 16 bit
	 * fractional nanoseconds.  Avoid shifting negative numbers.
	 */
>>>	if (ns >= 0)
>>>		correction -= ns << 16;
>>>	else
>>>		correction += -ns << 16;

	/* write new correction value */
	put_unaligned_be64((u64)correction, &hdr->correction);
...
}


