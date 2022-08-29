Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D865A4B18
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiH2MJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiH2MId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:08:33 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FCFE923EC;
        Mon, 29 Aug 2022 04:54:06 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id E2D7822CF;
        Mon, 29 Aug 2022 13:43:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661773419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HGfXO8M5+5YvwKhNeBpH83lxpoFv1FGhpqzUTAy+muk=;
        b=uY+mickqs0q3gOo6RsPw4cjvYLdsV+Xqw900xwmrhJAwo/T+cpIcPkiDjhePcPAVSnWFJ6
        m0Vnd84Tcf6BZ4+o1n5NBnyJBcmgJJLD+oWlP+xYzRi/BRo3joG1aD+4koc6dIrw/cZE3k
        E3BD1NcpHGbCW6gz4yEnupNMWo9RAvFYmdP3zM9uVLHcyMidjS9aN/0FHE3oiwEPPcJ+xT
        ulO7DsVHtDIly1V9D5rzccMPJVau1BcKQSktzSFQ7vk7x8r0XLOdUWAifp1YHwy8QOnHHQ
        JGOYPaa+uMvDHfkOQpMTX6Z0X/6S/cF0AWr1fzfU1zKaFOJCFxyUcuPGDusaRg==
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 13:43:38 +0200
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] reset: microchip-sparx5: fix the broken switch reset
In-Reply-To: <20220826115607.1148489-1-michael@walle.cc>
References: <20220826115607.1148489-1-michael@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1156fa93251e3d2d198ec27a671faad0@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-26 13:56, schrieb Michael Walle:
> The reset which is used by the switch to reset the switch core has many
> different side effects. It is not just a switch reset. Thus don't treat 
> it
> as one, but just issue the reset early during boot.
> 
> Michael Walle (3):
>   reset: microchip-sparx5: issue a reset on startup
>   dt-bindings: net: sparx5: don't require a reset line
>   net: lan966x: make reset optional
> 
>  .../bindings/net/microchip,sparx5-switch.yaml |  2 --
>  .../ethernet/microchip/lan966x/lan966x_main.c |  3 ++-
>  drivers/reset/reset-microchip-sparx5.c        | 22 ++++++++++++++-----
>  3 files changed, 19 insertions(+), 8 deletions(-)

Philipp, you could just patch #1, I guess. I'd then
resend patches #2 and #3 to the netdev ML targetting net-next.
As long as the device tree itself isn't changed, there should
be no dependency between these two.

-michael
