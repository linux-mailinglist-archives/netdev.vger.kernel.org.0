Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7E0252FECC
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 20:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238798AbiEUS04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 14:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiEUS0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 14:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AEF4B1F6
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 11:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E730260A71
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 18:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCEBC385A5;
        Sat, 21 May 2022 18:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653157608;
        bh=lEgXnZmux6SCA2eMoF/98MW49CT/I0Q/mMDMkeyqLoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ir9IwIJADSE6odJTVqh0TV+CRlnIdcSyCmJYcGqBnU6aEKPefTMC84eE/VlmioyQ3
         NYZv258LjbMQH50r4Qo9RtjcYdDvE9obX4MMTsjVBMaubkizkRcwCeo77QJuO7nrS/
         BaWqJuBTioAgZy03tJ8LkzquGmHfLVbNHosv0Ezmeq3WPND/HbecYrsYK8I8ojl9sI
         AgEdViNUs4il3MT/Xa8vOjSZX6L0qo/dnPcJfsnHofOaWFibXi3+UtrfrWbGPHgnVA
         wS0dei9JXX9QcZEdoZPsjhKp/ciHKdAeuUE+wCHKYejok3v4QhOI3zxCsRXmOrmNGP
         GHTe3TOsS5l0Q==
Date:   Sat, 21 May 2022 11:26:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, olteanv@gmail.com,
        hkallweit1@gmail.com, f.fainelli@gmail.com, saeedm@nvidia.com,
        michael.chan@broadcom.com
Subject: Re: [RFC net-next] net: track locally triggered link loss
Message-ID: <20220521112646.0d3c0a8a@kernel.org>
In-Reply-To: <Yoj11Kv55HX3k/Ou@lunn.ch>
References: <20220520004500.2250674-1-kuba@kernel.org>
        <YoeIj2Ew5MPvPcvA@lunn.ch>
        <20220520111407.2bce7cb3@kernel.org>
        <YofidJtb+kVtFr6L@lunn.ch>
        <20220520150256.5d9aed65@kernel.org>
        <Yoj11Kv55HX3k/Ou@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 May 2022 16:23:16 +0200 Andrew Lunn wrote:
> > For a system which wants to monitor link quality on the local end =>
> > i.e. whether physical hardware has to be replaced - differentiating
> > between (1) and (2) doesn't really matter, they are both non-events.  
> 
> Maybe data centres should learn something from the automotive world.
> It seems like most T1 PHYs have a signal quality value, which is
> exposed via netlink in the link info message. And it is none invasive.

There were attempts at this (also on the PCIe side of the NIC)
but AFAIU there is no general standard of the measurement or the
quality metric so it's hard to generalize.

> Many PHYs also have counters of receive errors, framing errors
> etc. These can be reported via ethtool --phy-stats.

Ack, they are, I've added the APIs already and we use those.
Symbol errors during carrier and FEC corrected/uncorrected blocks.
Basic FCS errors, too.

IDK what the relative false-positive rate of different sources of
information are to be honest. The monitoring team asked me about
the link flaps and the situation in Linux is indeed less than ideal.

> SFPs expose SNR ratios in their module data, transmit and receive
> powers etc, via ethtool -m and hwmon.
> 
> There is also ethtool --cable-test. It is invasive, in that it
> requires the link to go down, but it should tell you about broken
> pairs. However, you probably know that already, a monitoring system
> which has not noticed the link dropping to 100Mbps so it only uses two
> pairs is not worth the money you paired for it.

Last hop in DC is all copper DACs. Not sure there's a standard
--cable-test for DACs :S

> Now, it seems like very few, if any, firmware driven Ethernet card
> actually make use of these features. You need cards which Linux is
> actually driving the hardware. But these APIs are available for
> anybody to use. Don't data centre users have enough purchasing power
> they can influence firmware/driver writers to actually use these APIs?
> And i think the results would be better than trying to count link
> up/down.

Let's separate new and old devices.

For new products customer can stipulate requirements and they usually
get implemented. I'd love to add more requirements for signal quality 
and error reporting. It'd need to be based on standards because each
vendor cooking their own units does not scale. Please send pointers 
my way!

Old products are a different ball game, and that's where we care about
basic info like link flaps. Vendors EOL a product and you're lucky to
get bug fixes. Servers live longer and longer and obviously age
correlates with failure rates so we need to monitor those devices.
