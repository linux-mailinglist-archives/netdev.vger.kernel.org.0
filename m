Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1E36B7288
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 10:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCMJ2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 05:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjCMJ23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 05:28:29 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E06E59F5;
        Mon, 13 Mar 2023 02:28:26 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 38905D5A;
        Mon, 13 Mar 2023 10:28:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1678699702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=skyNVaDreGk4up3teBKgNO9R6cLkCNyVzzbEod9/6Rg=;
        b=DVcf4ZYa6wHEiz4Cd/JqkKPK/bVkzbgR3vXVxQqyCz4xPnSTc5hFMWAWK1G2kM2Da2tOh8
        1mqgEdMcSlshmtEWuUN//iZmO+qU7y7ww+jT+VU0aA4kn0bmh+3tuMo8CClkhCv37vNcQJ
        2cyomQpVH3QWY8r5C67IBT3S4jSHwUCgODwpX7OQOfcFCe3SkM5yDTc6b5UkmJnXoFsz9G
        +GtrMbMWOSiSJ/7lWGUHuGApEZlqEVj2WNwUhIahXmmKzWlzUmzS24azUvR4HGMSB/j5n8
        reQW0KXi3WnoOadzpI3qw7SUtMmAKyJCWEfx0uO9Y3y14/l0u1C08rFx0hL58g==
From:   Michael Walle <michael@walle.cc>
To:     andrew@lunn.ch, Linus Walleij <linus.walleij@linaro.org>
Cc:     Arun.Ramadoss@microchip.com, alexander.stein@ew.tq-group.com,
        ansuelsmth@gmail.com, bagasdotme@gmail.com, corbet@lwn.net,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, f.fainelli@gmail.com, hdegoede@redhat.com,
        hkallweit1@gmail.com, jacek.anaszewski@gmail.com, john@phrozen.org,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org, lee@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com,
        pavel@ucw.cz, rasmus.villemoes@prevas.dk,
        rmk+kernel@armlinux.org.uk, robh+dt@kernel.org,
        tharvey@gateworks.com, Michael Walle <michael@walle.cc>
Subject: Re: [PATCH v8 00/13] Adds support for PHY LEDs with offload triggers
Date:   Mon, 13 Mar 2023 10:28:15 +0100
Message-Id: <20230313092815.496442-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <576d57cb-481c-46ba-9e3b-d3b7e3a4ec69@lunn.ch>
References: <576d57cb-481c-46ba-9e3b-d3b7e3a4ec69@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I think there will be a day when a switch without LED controller appears,
> > but the system has a few LEDs for the ports connected to an
> > arbitrary GPIO controller, and then we will need this. But we have
> > not seen that yet :)
> 
> The microchip sparx5 might be going in that direction. It has what
> looks like a reasonably generic sgpio controller:
> drivers/pinctrl/pinctrl-microchip-sgpio.c

That gpio controller supports both, some kind of hardware controlled
and pure software controlled mode. AFAIK the driver only supports
software controlled mode (yet?). In any case, our board
(arch/arm/boot/dts/lan966x-kontron-kswitch-d10-mmt.dtsi) is broken in
a way that we are forced to use the software controlled mode anyway.
Therefore, there is already such a board ;)

-michael
