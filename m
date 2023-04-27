Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01AAC6F00AC
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242959AbjD0GIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbjD0GIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:08:24 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2FD35A5
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:08:23 -0700 (PDT)
Received: from [172.16.75.132] (unknown [49.255.141.98])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id ECBCA20009;
        Thu, 27 Apr 2023 14:08:15 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1682575696;
        bh=773AkmtjNnA1q/tsGZHVZBAggTfN/EF5Dp0dnpyCasI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=EyPoylmftGavkUCxlkEWCL6eTEcR0IG+qNribfbABP4gRIlOkQa0feIe26S9DmjID
         O3DACwSy7XipZwtGMtTBNHTTjWyr3BKfrKZue4+tTNKzNAxnu5RlVrvuaVKiFMgrEv
         81jBjLQKr2BbYu1bK7IEuh8dYG8OskwSeDnwHwUsL3ghTu2qECuFUendJ+Arz3eJM/
         AQsDrhgmtVdkasnvU3OqjcTuxmdcHMuM9UscCmQaVA6nF3H2FPc/URVfuAsPazTRDI
         Qi6ksU0uy7G2U89We1FODw/DxPvvFTxsfFzS94VQkqzCdG1SOcuB5ZtwkzJDnfDNE7
         O7zAXa4K6vshg==
Message-ID: <61b1f1f0c9aab58551e98ba396deba56e77f1f89.camel@codeconstruct.com.au>
Subject: Re: [RFC PATCH v1 0/1] net: mctp: MCTP VDM extension
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     "Richert, Krzysztof" <krzysztof.richert@intel.com>,
        matt@codeconstruct.com.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date:   Thu, 27 Apr 2023 14:08:08 +0800
In-Reply-To: <67d9617d-4f77-5a1c-3bae-d14350ccaed5@intel.com>
References: <20230425090748.2380222-1-krzysztof.richert@intel.com>
         <aceee8aa24b33f99ebf22cf02d2063b9e3b17bb3.camel@codeconstruct.com.au>
         <67d9617d-4f77-5a1c-3bae-d14350ccaed5@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof,

> > =C2=A0- could we turn this into a non-vendor-specific (length, data) ma=
tch
> > =C2=A0=C2=A0=C2=A0instead? If the length is zero, this falls back to ex=
actly as
> > =C2=A0=C2=A0=C2=A0specified in DSP0236.
> No problem, for me sounds good. I will prepare solution based on the=20
> non-vendor data as offset/length/data instead of sub-code.

OK, neat.

We may need to work out when the subtype length gets set - either if:

 (a) it is part of the sockaddr,

 or

 (b) it is defined when vendor-specific addressing is enabled via the
 MCTP_OPT_VENDOR_EXT sockopt (ie, we would make the length part of the
 setsockopt argument).

The (a) approach may have issues when we're processing incoming packets:
we'll need to have advance knowledge of the length before we can extract
the sockaddr.

This is fine for a "responder" model, where there's a bind() call to
provide the sockopt (and hence subtype length) in the receiving socket.

However, this may be tricky for recvfrom(), where there is no prior
length value available. We could extract this from the earlier
(outgoing) message, but that's getting a bit hacky at that point.

> I think offset is also required to know from which byte to start
> parsing data.

Are there cases where the subtype does not immediately follow the
PCIe/IANA type? If not, we could just require that...

> > Also, do we really need 8 bytes of type for this? Is some vendor
> > planning to support more than 4.3 billion MCTP subtypes? :)
> Intel uses only one byte and those are static values. Behind 8 bytes=20
> was idea that maybe someone uses dynamic generated values (e.g SHA).
> For me it's hard to guess what maximum size it should be to not
> kill performance and make it useful.
> If you have advise I would appreciate.

I don't think there'll be much impact on performance here, but we do
need to ensure we don't hit the maximum size of a sockaddr. It would
also be nice to keep things down to a reasonable size in general - I
don't think there will be much need for more than 16 bits of subtype, or
32 if we're being super conservative.

(and we can probably reduce the length down to just a u8 too).

> > This is also under the assumption that we want to be able to support
> > both extended addressing *and* vendor addressing at the same time. I
> > don't think there's any reason not to, but any thoughts on that?
> Actually it's our main use case when extending addressing and vendor
> addressing are use in the same time.

OK, good to know.

I assume this is for PECI - have you considered just standardising that
as a top-level MCTP type value? :D

Cheers,


Jeremy
