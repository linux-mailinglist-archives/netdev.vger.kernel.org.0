Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979616F146E
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 11:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjD1Jpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 05:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjD1Jpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 05:45:52 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610E444A2
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 02:45:50 -0700 (PDT)
Received: from sparky.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id DA21820009;
        Fri, 28 Apr 2023 17:45:46 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1682675148;
        bh=P2m6+vpk1/fkc31fJC+JmKnHAtHzz+DYWJVhTusy2vU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References;
        b=dZRwmUxaCAHtn0e7dZPemiZle5nxvlrFz2xVQ5GFF0OoU6fx9f7v3mt3GIGyfnd6Z
         efneROJCibCNruPJIqZdLtJbQbLbf1Nls/CzWM4BtNr3ppL10HNMy+BigUdq+RQxxO
         XVL9ggI7nVKrlMjVz9TsA/nIbud3kjtfCtbzE5jt3qYzI+Ey6FA8J81KSbYVrzdApi
         1u4DsC+xy2fW6zH9FDjkgRlEEo+Mb07zYSMhB2yiEZStui1Qcr+ZnHEdPvWwev5/rF
         pB30KIV2/AQFP1jIzNzdCLAhigI2IyXYGxwBM1AycwzcyQZQY3qBjDU9tWw06VbgL+
         Myxyv3W1id4cw==
Message-ID: <ce269480332ed97c153d61452ee93829d4df5c73.camel@codeconstruct.com.au>
Subject: Re: [RFC PATCH v1 0/1] net: mctp: MCTP VDM extension
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     "Richert, Krzysztof" <krzysztof.richert@intel.com>,
        matt@codeconstruct.com.au
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Date:   Fri, 28 Apr 2023 17:45:45 +0800
In-Reply-To: <4ab1d6c1-d03b-d541-39a0-263e73197521@intel.com>
References: <20230425090748.2380222-1-krzysztof.richert@intel.com>
         <aceee8aa24b33f99ebf22cf02d2063b9e3b17bb3.camel@codeconstruct.com.au>
         <67d9617d-4f77-5a1c-3bae-d14350ccaed5@intel.com>
         <61b1f1f0c9aab58551e98ba396deba56e77f1f89.camel@codeconstruct.com.au>
         <4ab1d6c1-d03b-d541-39a0-263e73197521@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
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

> > However, this may be tricky for recvfrom(), where there is no prior
> > length value available. We could extract this from the earlier
> > (outgoing) message, but that's getting a bit hacky at that point.
> Actually, I've thought to use the same approach as for sockaddr_mctp_ext.
> So subtype data would be part of sockaddr(a), but enabled by MCTP_OPT_VEN=
DOR_EXT.

Yes - you'll always need the setsockopt to enable the different
sockaddr format, but we may need it to also provide the format (length,
whatever) of the subtype addressing. However, there are some
more factors there, I'll cover those below.

> In scenario when bind() function is not called, it would result in receiv=
ing
> message from any subtype, right ?=20

Yes - if we don't have a sockaddr_mctp_vendor_ext at the time the packet
comes in, then we have no idea how to extract the packet subtype.

> > Are there cases where the subtype does not immediately follow the
> > PCIe/IANA type? If not, we could just require that...
> Yes. Just after PCIe/IANA, in the Intel format, is 'control byte' and
> next subtype. For some vendors it may be, as you assumed, immediately
> follow the PCIe/IANA, or on completely different offset.

OK, the "completely different offset" is a fairly major issue here.

To implement that, we essentially need a sort of arbitrary packet
inspection to allow the addressing mechanism to parse a subtype from any
data in the packet. I can see a few potential issues with that, mainly:

 1) there's no way to prevent a packet matching multiple binds(); there
    may be incoming packets that match more than one subtype if they're
    at different offsets

 2) similarly: there's no way to reject a bind() if it conflicts with
    an existing bound socket

 3) this sounds like something that may be prone to bugs

One alternative I can see is that:

 A) we keep the DSP0236 specified behaviour in the kernel; allowing a
    bind on a PCI/IANA vendor type, but not the subtype

 B) we add a "vendor mark" field to the sockaddr_mctp_vendor_ext; an
    arbitrary u32. Sockets can specify a vendor mark value during bind()
    so that they receive packets with a specific mark. This allows us
    to reject duplicate bind()s on the same mark value.

 C) packets can get a vendor mark applied by a some user-specified BPF
    (or similar?) logic, that can do the arbitrary packet parsing, and
    apply a suitable mark value to the skb.

 D) when looking up the socket for an incoming packet, we also require
    a match on the vendor mark, if one is applied during bind().

With that, we wold just need the appropriate plumbing to allow marking
through BPF. It would be up to userspace to provide the actual parse ->
mark logic, and to match the bind() mark value to whatever the BPF sets.

Would that work?

Cheers,


Jeremy
