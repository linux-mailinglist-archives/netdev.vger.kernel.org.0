Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54E4068D029
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbjBGHKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjBGHKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:10:13 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E225227BD;
        Mon,  6 Feb 2023 23:10:11 -0800 (PST)
Received: by soltyk.jannau.net (Postfix, from userid 1000)
        id 5DDC326F72B; Tue,  7 Feb 2023 08:10:09 +0100 (CET)
Date:   Tue, 7 Feb 2023 08:10:09 +0100
From:   Janne Grunau <j@jannau.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] dt-bindings: net: Add network-class.yaml schema
Message-ID: <20230207071009.GB9004@jannau.net>
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
 <CAL_JsqKD7gD86_B93M19rBCWn+rmSw24vOGEhqi9Nvne1Xixwg@mail.gmail.com>
 <20230206163154.GA9004@jannau.net>
 <Y+GqsTLXRKyg0BdV@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+GqsTLXRKyg0BdV@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-07 02:34:41 +0100, Andrew Lunn wrote:
> > > > I've ignored "max-frame-size" since the description in
> > > > ethernet-controller.yaml claims there is a contradiction in the
> > > > Devicetree specification. I suppose it is describing the property
> > > > "max-frame-size" with "Specifies maximum packet length ...".
> > > 
> > > Please include it and we'll fix the spec. It is clearly wrong. 2 nios
> > > boards use 1518 and the consumer for them says it is MTU. Everything
> > > else clearly uses mtu with 1500 or 9000.
> > 
> > Ok, the example in the pdf is 'max-frame-size = <1518>;'. I'll include 
> > it with the description of ethernet-controller.yaml which specifies it 
> > as MTU.
> 
> You need to be careful here. Frame and MTU are different things.

yes, we are aware. The description in of the property in
Documentation/devicetree/bindings/net/ethernet-controller.yaml is:

| Maximum transfer unit (IEEE defined MTU), rather than the
| maximum frame size (there\'s contradiction in the Devicetree
| Specification).

The description for the property in the Devicetree is:

| Specifies maximum packet length in bytes that the physical interface
| can send and receive.

While the "packet length" in the description is a little confusing this 
seems to refer to the ethernet frame size.

> The IEEE 802.3 standard says nothing about MTU. I believe MTU is an IP
> concept. It is the size of the SDU an Ethernet PDU can carry. This is
> typically 1500.
> 
> Historically, the max Ethernet frame size was 1518. But with 802.1Q
> which added the VLAN header, all modern hardware actual uses 1522 to
> accommodate the extra 4 bytes VLAN header. So i would not actually put
> max-frame-size = <1518> anywhere, because it will get copy/pasted and
> break VLAN setups.
> 
> It looks like the ibm,emac.txt makes this error, max-frame-size =
> <5dc>; 0x5dc is 1500. And there are a few powerpc .dtc using
> 1500/0x5dc, which are probably broken.

I would not say it is an error. The specification/name and use of 
"max-frame-size" has clearly diverged. All 4 in-tree users of this 
property interpret it as MTU. With the exception of the 2 nios2 boards 
Rob found all device trees use either 1500, 3800 or 9000 as 
'max-frame-size'.

I think Rob's plan to deal with this conflict between specification and 
actual use is to accept the use and update the description in the 
specification. This results in a "max-frame-size" property which 
describes the maximal payload / MTU. The upside of this is that we can 
leave all devicetrees and drivers unchanged and avoid breaking 
out-of-tree users.

I'll fix the 2 nios2 boards since those currently end up with a MTU of 
1518 in altera_tse_main.c.

Janne
