Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45A1068CBF7
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 02:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjBGBez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 20:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjBGBew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 20:34:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD9C2F7AC;
        Mon,  6 Feb 2023 17:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tZWkCJrGrg0CgOQ/KDtg58bqJacvpTUQpLyNlTnrySs=; b=duOAIAbGYd5mxT4ixKQCZRLbCb
        lrCA8ogNU46SpMPvMKMnuwUEopuVnJRdNEBeZV7nE3qTWsp0fkNpRqwolaN8Rl5FCc+Zo9t0QFUz8
        f2vDD42t06VYQ7XoBg17UtNGokleyafXrAkg6OoEiTGIP+sJPg39KOTKxhet7pd52fOM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pPCsb-004FpP-6f; Tue, 07 Feb 2023 02:34:41 +0100
Date:   Tue, 7 Feb 2023 02:34:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Janne Grunau <j@jannau.net>
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
Message-ID: <Y+GqsTLXRKyg0BdV@lunn.ch>
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
 <CAL_JsqKD7gD86_B93M19rBCWn+rmSw24vOGEhqi9Nvne1Xixwg@mail.gmail.com>
 <20230206163154.GA9004@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206163154.GA9004@jannau.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > I've ignored "max-frame-size" since the description in
> > > ethernet-controller.yaml claims there is a contradiction in the
> > > Devicetree specification. I suppose it is describing the property
> > > "max-frame-size" with "Specifies maximum packet length ...".
> > 
> > Please include it and we'll fix the spec. It is clearly wrong. 2 nios
> > boards use 1518 and the consumer for them says it is MTU. Everything
> > else clearly uses mtu with 1500 or 9000.
> 
> Ok, the example in the pdf is 'max-frame-size = <1518>;'. I'll include 
> it with the description of ethernet-controller.yaml which specifies it 
> as MTU.

You need to be careful here. Frame and MTU are different things.

The IEEE 802.3 standard says nothing about MTU. I believe MTU is an IP
concept. It is the size of the SDU an Ethernet PDU can carry. This is
typically 1500.

Historically, the max Ethernet frame size was 1518. But with 802.1Q
which added the VLAN header, all modern hardware actual uses 1522 to
accommodate the extra 4 bytes VLAN header. So i would not actually put
max-frame-size = <1518> anywhere, because it will get copy/pasted and
break VLAN setups.

It looks like the ibm,emac.txt makes this error, max-frame-size =
<5dc>; 0x5dc is 1500. And there are a few powerpc .dtc using
1500/0x5dc, which are probably broken.

      Andrew
