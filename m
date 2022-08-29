Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5E5A45F8
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 11:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiH2JWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 05:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiH2JWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 05:22:34 -0400
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD115A806;
        Mon, 29 Aug 2022 02:22:33 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 30DEF38F;
        Mon, 29 Aug 2022 11:22:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661764951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OUc1LWdpbz87/rNtBwzA999uipsSxmoZtcNrouUeHHE=;
        b=VXlqjc+QqsODaMUjfx6UczpKtVyzDsKuFWOsE/xhziHxDKsN9y0pb6hWS1PuiFLeWiUhNB
        GCrNztMmGP/YkZ6aaoW4Pki5uDc1mlc4DGRWi1hUeCgZzlBI3zXLBfVVtKxDMzfaBnkmda
        /z8wJPQEkrwMwAkVjTD6UAHUIzGKWojx+MbkHwKmk7eO4EttsvqywM8gz2GjTaRcuuLXZQ
        +wSYq5YX2UbZaYKCofGSYeYVWC93PpSiIeUscJFMHuH/XiwzLHdnejxyxvF+8R454nrQM9
        Bs8GxzeJPIg8JSOfFM4g+Ya+YxBgQf+PLqNm08o7VE0MevpZxrKuyAZDxISPnQ==
MIME-Version: 1.0
Date:   Mon, 29 Aug 2022 11:22:30 +0200
From:   Michael Walle <michael@walle.cc>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] reset: microchip-sparx5: issue a reset on startup
In-Reply-To: <578bdccee9a92dd74bb6a1b87fb5011bf7279e57.camel@microchip.com>
References: <20220826115607.1148489-1-michael@walle.cc>
 <20220826115607.1148489-2-michael@walle.cc>
 <578bdccee9a92dd74bb6a1b87fb5011bf7279e57.camel@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <392c923d59b581fdc9c8f8a13a2ae258@walle.cc>
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

Hi Steen,

Am 2022-08-29 11:14, schrieb Steen Hegelund:
> On Fri, 2022-08-26 at 13:56 +0200, Michael Walle wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know 
>> the content is safe
>> 
>> Originally this was used in by the switch core driver to issue a 
>> reset.
>> But it turns out, this isn't just a switch core reset but instead it
>> will reset almost the complete SoC.
>> 
>> Instead of adding almost all devices of the SoC a shared reset line,
>> issue the reset once early on startup. Keep the reset controller for
>> backwards compatibility, but make the actual reset a noop.
>> 
>> Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
>> Signed-off-by: Michael Walle <michael@walle.cc>
..

> Tested-by: Steen Hegelund <Steen.Hegelund@microchip.com> on Sparx5

Thanks for testing!

-michael
