Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30F986EF1DC
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240293AbjDZKYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240083AbjDZKYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:24:31 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AB93C31
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:24:29 -0700 (PDT)
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 7EF7F20034;
        Wed, 26 Apr 2023 18:24:23 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1682504664;
        bh=7i/m5vPEyAJIjh73TnD53A+XVyXoIiDAr0En3yFs4AM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=W4hhLwpnlEL3R9MOHUDF4aoVsf8uuz0VdpeWE5KJzGHPuHQsixfk1hAiczV/MTax9
         ibCZb2H1rBmhAaSkLgAXffuuno8YSXpqT1A7X0Hbc6oPn4R6u2Lg2YAc9LRxIWefV/
         37ioIqijJIFsL572TRIpEF9pDI5vOAiR+h0cMhgFeEFxvTpNUMCCoOTYIwcjyd3LzZ
         l+Dl3l563UksUCcsfFn9r5pepW6212TUVvBiyVlcpDUk3UwyYnoUcZh90LnnUi1W1g
         kvC2Hr/hMKNPgbqu3k7YMLQ2GW26tlWjBaB0qyTDWsUg2h9jnULs198jV+9AgjvKAA
         vgc5ep4fPA4NA==
Message-ID: <aceee8aa24b33f99ebf22cf02d2063b9e3b17bb3.camel@codeconstruct.com.au>
Subject: Re: [RFC PATCH v1 0/1] net: mctp: MCTP VDM extension
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Krzysztof Richert <krzysztof.richert@intel.com>,
        matt@codeconstruct.com.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date:   Wed, 26 Apr 2023 18:24:23 +0800
In-Reply-To: <20230425090748.2380222-1-krzysztof.richert@intel.com>
References: <20230425090748.2380222-1-krzysztof.richert@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

> According to vendor needs it seems that supporting Vendor Define
> Messages based on=C2=A0 PCI vendor ID (0x7e) or based on IANA number (0x7=
f)
> which are described in DSP0236 will bring additional value to existing
> MCTP susbsystem. Currently MCTP subsystem allows to register one
> specific client for each MCTP message type.

Excellent, thanks for taking a look at this.

I have some comments on the general structure though. I'll discuss those
here, and we can cover the implementation details once that's sorted.

> Under MCTP type=3D0x7e we handle two different messages, one is handle
> by user-space application and the other is handle by kernel-space
> driver.

OK, but the kernel vs. user distinction has no influence on the
addressing, right?

> Because each vendor may define, own, internal message format=C2=A0
> that's why we considered to extend sockaddr_mctp and allow for
> registration on MCTP message types =3D 0x7e/0x7f with additional
> sub-type (up to 8 bytes), which can be defined and use by each vendor
> to distinguish MCTP VDM packages.

So there are really three components here:

 1) the existing type byte; in this case, either 0x7e/0x7f for
    indicating PCI/IANA vendor types

 2) the PCI (2-byte) or IANA (4-byte) vendor identifier

 3) an additional sub-type identifier

While (1) and (2) are well-defined by DSP0236, my concern is that (3) is
not specified anywhere, and seems to be an entirely Intel-specific
construct. Or is there something in the pipeline for the spec here?

Given you're proposing special handling for Intel vendor types, this
implies that we're going to be changing the addressing mechanism for
every new vendor-based type.

So - a couple of questions to shape the design:

 - do you *really* need the sub-type decoding in the kernel? (could it be
   possible for one bind() to handle all of a specific vendor type
   instead? or is this related to the kernel vs. user statement above?)

   if you do need it:

 - could we turn this into a non-vendor-specific (length, data) match
   instead? If the length is zero, this falls back to exactly as
   specified in DSP0236.

   or:

 - is there a better way of filtering the subtypes into each bound
   socket?

on the uapi:

> union mctp_vendor_id {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0__u32=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0resvd=C2=A0=C2=A0=C2=A0: 16,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0data=C2=A0=C2=A0=C2=A0=C2=A0: 16;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} pci_vendor_id;

no bitfields please - just two __u16 fields instead.

>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0__u32=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0data;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0} iana_number;
> };
>=20
>=20
> struct mctp_vdm_data {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0union mctp_vendor_id=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smctp_=
vendor;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__u64=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0__smctp_pad0;

This padding is a bit mysterious - what are you trying to pad here?

> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0__u64=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0smctp_sub_type;

As above: if we can turn this into separate length & value fields, we
can avoid having to code every vendor format into the kernel.

Also, do we really need 8 bytes of type for this? Is some vendor
planning to support more than 4.3 billion MCTP subtypes? :)

> };
>=20
> struct sockaddr_mctp_vendor_ext {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct sockaddr_mctp_ext=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0smctp_ext;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mctp_vdm_data smct=
p_vdm_data;
> };

You could avoid a bit of wrapping by including the ext fields directly
into the vendor-enabled sockaddr:

    struct sockaddr_mctp_vendor_ext {
    	struct sockaddr_mctp	smctp_base;
    	int			smctp_ifindex;
    	__u8			smctp_halen;
    	__u8			__smctp_pad0[3];
    	__u8			smctp_haddr[MAX_ADDR_LEN];
     =C2=A0=C2=A0=C2=A0struct mctp_vdm_data	smctp_vdm_data;
    };

- but we would need to ensure that we're exactly matching the layout of
sockaddr_mctp_ext; we could do that through a few build-time asserts
though.

We would probably simplify this a little too, by flattening into:

    struct sockaddr_mctp_vendor_ext {
    	struct sockaddr_mctp	smctp_base;
    	int			smctp_ifindex;
    	__u8			smctp_halen;
    	__u8			__smctp_pad0[3];
    	__u8			smctp_haddr[MAX_ADDR_LEN];
     =C2=A0=C2=A0=C2=A0__u32			smctp_vdm_vendor;
     =C2=A0=C2=A0=C2=A0__u32			smctp_vdm_type;
     =C2=A0=C2=A0=C2=A0__u32			smctp_vdm_len;
    };

but it's worthwhile working out the actual addressing semantics before
defining this.

We'll also have to be very explicit about the endianness here.

This is also under the assumption that we want to be able to support
both extended addressing *and* vendor addressing at the same time. I
don't think there's any reason not to, but any thoughts on that?

Cheers,


Jeremy
