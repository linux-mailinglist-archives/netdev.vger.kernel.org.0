Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC101F1E75
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 19:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730065AbgFHRqj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 13:46:39 -0400
Received: from mail-n.franken.de ([193.175.24.27]:56003 "EHLO drew.franken.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726097AbgFHRqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 13:46:39 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Jun 2020 13:46:38 EDT
Received: from [IPv6:2a02:8109:1140:c3d:e915:c325:ef07:5ec7] (unknown [IPv6:2a02:8109:1140:c3d:e915:c325:ef07:5ec7])
        (Authenticated sender: lurchi)
        by mail-n.franken.de (Postfix) with ESMTPSA id B38FF721E282E;
        Mon,  8 Jun 2020 19:37:26 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: packed structures used in socket options
From:   Michael Tuexen <Michael.Tuexen@lurchi.franken.de>
In-Reply-To: <cd3793726252407f8e80aa8d0025d44f@AcuMS.aculab.com>
Date:   Mon, 8 Jun 2020 19:37:25 +0200
Cc:     =?utf-8?Q?Ivan_Skytte_J=C3=B8rgensen?= <isj-sctp@i1.dk>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7BD347D7-562F-459D-B0CB-0BC798919876@lurchi.franken.de>
References: <CBFEFEF1-127A-4ADA-B438-B171B9E26282@lurchi.franken.de>
 <B69695A1-F45B-4375-B9BB-1E50D1550C6D@lurchi.franken.de>
 <23a14b44bd5749a6b1b51150c7f3c8ba@AcuMS.aculab.com>
 <2213135.ChUyxVVRYb@isjsys>
 <cd3793726252407f8e80aa8d0025d44f@AcuMS.aculab.com>
To:     David Laight <David.Laight@ACULAB.COM>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=disabled version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail-n.franken.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 8. Jun 2020, at 18:18, David Laight <David.Laight@ACULAB.COM> wrote:
> 
> From: Ivan Skytte Jørgensen
>> Sent: 07 June 2020 22:35
> ...
>>>>>>>> contains:
>>>>>>>> 
>>>>>>>> struct sctp_paddrparams {
>>>>>>>> 	sctp_assoc_t		spp_assoc_id;
>>>>>>>> 	struct sockaddr_storage	spp_address;
>>>>>>>> 	__u32			spp_hbinterval;
>>>>>>>> 	__u16			spp_pathmaxrxt;
>>>>>>>> 	__u32			spp_pathmtu;
>>>>>>>> 	__u32			spp_sackdelay;
>>>>>>>> 	__u32			spp_flags;
>>>>>>>> 	__u32			spp_ipv6_flowlabel;
>>>>>>>> 	__u8			spp_dscp;
>>>>>>>> } __attribute__((packed, aligned(4)));
>>>>>>>> 
>>>>>>>> This structure is only used in the IPPROTO_SCTP level socket option SCTP_PEER_ADDR_PARAMS.
>>>>>>>> Why is it packed?
> ...
>> I was involved. At that time (September 2005) the SCTP API was still evolving (first finalized in
>> 2011), and one of the major users of the API was 32-bit programs running on 64-bit kernel (on powerpc
>> as I recall). When we realized that the structures were different between 32bit and 64bit we had to
>> break the least number of programs, and the result were those ((packed)) structs so 32-bit programs
>> wouldn't be broken and we didn't need a xxx_compat translation layer in the kernel.
> 
> I was also looking at all the __u16 in that header - borked.
> 
> Ok, so the intention was to avoid padding caused by the alignment
> of sockaddr_storage rather than around the '__u16 spp_flags'.
> 
> I'd have to look up what (packed, aligned(4)) actually means.
> It could force the structure to be fully packed (no holes)
> but always have an overall alignment of 4.
> 
> It might have been clearer to put an 'aligned(4)' attribute
> on the spp_address field itself.
> Or even wonder whether sockaddr_storage should actually
> have 8 byte alignment.
> 
> If it has 16 byte alignment then you cannot cast an IPv4
> socket buffer address (which will be at most 4 byte aligned)
> to sockaddr_storage and expect the compiler not to generate
> code that will crash and burn on sparc64.
> 
> ISTR that the NetBSD view was that 'sockaddr_storage' should
> never actually be instantiated - it only existed as a typed
> pointer.
Not sure this is correct. I would say this applies to stuct sockaddr *.
I have seen instantiated sockaddr_storage variable in generic code,
where you need to provide enough space to hold an address, not yet
knowing the address family. However, I'm not familiar with the NetBSD
code base.

Best regards
Michael
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

