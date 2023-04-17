Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB76E4F25
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDQRWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjDQRWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:22:38 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863534EE9;
        Mon, 17 Apr 2023 10:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=e4u/r1Ao73tMp+87CjTm7CAwGZ4eC7s0hnGVdo/J5F4=; b=CCPuC+u1Cjfrv/G1W1KQmUNBW2
        LztD4+HDJQuyEtDusWM65DkXMopB95lw1eaY3Ym4c05/NfWhaI4/t2LO563wRXd+1+wr8amunE6GP
        K1PlQvzMHY1w4hun/2QyG9ibgf8dwpk+GGq+KDt4ckXHvitlo4iM2zz+G8jTi9OBLaKI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1poSYc-00AWh4-FU; Mon, 17 Apr 2023 19:22:26 +0200
Date:   Mon, 17 Apr 2023 19:22:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Herve Codina <herve.codina@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <9e7fe32a-8125-41d5-9f8e-d3e5c6c64584@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
 <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
 <20230414165504.7da4116f@bootlin.com>
 <c99a99c5-139d-41c5-89a4-0722e0627aea@lunn.ch>
 <20230417121629.63e97b80@bootlin.com>
 <a2615755-f009-4a21-b464-88ec5e58f32a@lunn.ch>
 <20230417173941.0206f696@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417173941.0206f696@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> My application (probably a subset of what we can do with E1 lines) does
> not use signaling.
> 
> I don't expose any channel to the user space but just:
> - One hdlc interface using one timeslot.
> - One or more dai links (audio channels) that can be used using ALSA library.

Well, that obviously does what you need for you application, but it
does not sound very generic. I don't think you could build a PBX on
top of that. I'd think you can build an E1 trunk to VoIP gateway.  So
i also have to wounder how generic vs one specific use case your
building blocks are.

Looking at the binding, i assume you could in fact instantiate 32 hdlc
instances? And that 'transparent' actually means DAI? So you can
instantiate as many DAI as you want. If you wanted to implement
signalling, a third type could be added?

> I thought I was providing a "standardised" API between the HDLC device
> and the framer. Maybe it was not as complete as you could expect but I had
> the feeling that it was standardised.

You are abusing the Generic PHY interface, for something which is not
a PHY. Your PHY driver does nothing a PHY driver normally does,
because you keep arguing the MFD does it all. So to me this is the
wrong abstraction.

You need an abstraction of a framer. You do however want a similar API
to generic PHY. devm_of_framer_optional_get() for the consumer of a
framer, which looks in DT for a phandle to a device.
devm_framer_create() which registers a framer provider, your MFD, with
the framer core. The hdlc driver can then get an instance of the
framer, and either put a notifier call block on its chain, or register
a function to be called when there is change in status.

What i also don't like is you have a very static configuration. You
are putting configuration into DT, which i'm surprised Rob Herring and
Krzysztof Kozlowski accepted. How you use E1 slots is not a hardware
property, it is purely software configuration, so should not be in DT.
So there should be a mechanism to configure how slots are used. You
can then dynamically instantiate HDLC interfaces and DAI links. This
is something which should be in the framer core. But since you have
managed to get this binding accepted, you can skip this. But
implementing the basic framer abstraction will give a place holder for
somebody to implement a much more generic solution in the future.

	 Andrew
