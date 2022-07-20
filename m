Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC64C57B7F7
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbiGTNxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 09:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGTNxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 09:53:21 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2FC564CF;
        Wed, 20 Jul 2022 06:53:19 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id y4so23845226edc.4;
        Wed, 20 Jul 2022 06:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v7Ua7Pjztqwug82UBS8PZqoIQdh5WrByyVymA7qNXfY=;
        b=Nmbr0Ft+AJ1qLYlMHWEXMpaR4XELHNyQAwZbdBWe8fGQhHqGPd1gD6d1KCMogKEBpz
         Bm7n5gTDnNsGpTpIkaOZ/zXnhVIirBjmDIiHPfE54B8fs3L0ulH52s18KafGlgDihKqD
         PaL3yw6KG6rnj0ZvTD+0rKFVYgv6JFRs8QlaCeMNV8thMquMeGmS7cdhhzAbqDi04V1y
         bqXgezBmXgeiTzanu4P8w270e0fjtnEJ0Rdb5mMCD7nIRDUxtqJ86WODqq6wl3rOeexs
         MpaGTPLcOKjG1JGubt82XE2ZHtNLyqAR7dQDQ01s94CBo8rkf6vBBE6N47hf84cFcPIX
         X2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v7Ua7Pjztqwug82UBS8PZqoIQdh5WrByyVymA7qNXfY=;
        b=UEiZ1i4ln1A8kJ/SFQEA3pI04zCXCYWzD1TYPBPTe8TDFzjGW39zPjezhGnbtEQVD8
         GnPE1MvGHKwM3IpkUUQY/Dtlez2kOspL5S2OmGn9ELp15siVIhzSnXe+7x5kcV5IxOTI
         KGBRrP4EJ3Z2QhUUUIk/sQ054JKMccz4v4npp5d+ZwI1I7loZisrc4YYGdNLpAEwBzaN
         JoA5K1lOBnREMSvv9mirHgZOkVAA9GpGpqYFeQuaa6mDilVMYjudGeu5V1jZTTL0YRRT
         k5HGZYXqMdMUoqCTmbaBNCMc346IJ2KwX2HPz/LlnnjBvjpa4DckH3pKHWquerVcvea/
         Up2w==
X-Gm-Message-State: AJIora/Cua7UmNh6VI80AxTlG2ZmARZYgglyBc7NNTMaOeMftV5021Qh
        zLwwqEPhRve2P6dk1BeUMmyugeEv+YTNwA==
X-Google-Smtp-Source: AGRyM1tM9Guy5xL3TVWbHbE/7jg1cpe+wU1P3TJ2yS6onGuYZEUFHUh9quYHkm8PmlmdDbV86wGfEA==
X-Received: by 2002:aa7:d788:0:b0:43b:bcbe:64d3 with SMTP id s8-20020aa7d788000000b0043bbcbe64d3mr1108303edq.15.1658325198189;
        Wed, 20 Jul 2022 06:53:18 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id h10-20020a170906718a00b00718e4e64b7bsm7934599ejk.79.2022.07.20.06.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 06:53:17 -0700 (PDT)
Date:   Wed, 20 Jul 2022 16:53:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>, UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH net-next 0/9] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <20220720135314.5cjxiifrq5ig4vjb@skbuf>
References: <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
 <20220711160519.741990-1-sean.anderson@seco.com>
 <20220719152539.i43kdp7nolbp2vnp@skbuf>
 <bec4c9c3-e51b-5623-3cae-6df1a8ce898f@seco.com>
 <20220719153811.izue2q7qff7fjyru@skbuf>
 <2d028102-dd6a-c9f6-9e18-5abf84eb37a1@seco.com>
 <20220719181113.q5jf7mpr7ygeioqw@skbuf>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
 <c0a11900-5a31-ca90-220f-74e3380cef8c@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 03:34:45PM -0400, Sean Anderson wrote:
> We could do it, but it'd be a pretty big hack. Something like the
> following. Phylink would need to be modified to grab the lock before
> every op and check if the PCS is dead or not. This is of course still
> not optimal, since there's no way to re-attach a PCS once it goes away.

You assume it's just phylink who operates on a PCS structure, but if you
include your search pool to also cover include/linux/pcs/pcs-xpcs.h,
you'll see a bunch of exported functions which are called directly by
the client drivers (stmmac, sja1105). At this stage it gets pretty hard
to validate that drivers won't attempt from any code path to do
something stupid with a dead PCS. All in all it creates an environment
with insanely weak guarantees; that's pretty hard to get behind IMO.

> IMO a better solution is to use devlink and submit a patch to add
> notifications which the MAC driver can register for. That way it can
> find out when the PCS goes away and potentially do something about it
> (or just let itself get removed).

Not sure I understand what connection there is between devlink (device
links) and PCS {de}registration notifications. We could probably add those
notifications without any intervention from the device core: we would
just need to make this new PCS "core" to register an blocking_notifier_call_chain
to which interested drivers could add their notifier blocks. How a
certain phylink user is going to determine that "hey, this PCS is
definitely mine and I can use it" is an open question. In any case, my
expectation is that we have a notifier chain, we can at least continue
operating (avoid unbinding the struct device), but essentially move our
phylink_create/phylink_destroy calls to within those notifier blocks.

Again, retrofitting this model to existing drivers, phylink API (and
maybe even its internal structure) is something that's hard to hop on
board of; I think it's a solution waiting for a problem, and I don't
have an interest to develop or even review it.
