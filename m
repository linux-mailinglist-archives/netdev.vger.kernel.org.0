Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC89644C9D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiLFTlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:41:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLFTlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:41:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9747C303DA;
        Tue,  6 Dec 2022 11:41:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2733161851;
        Tue,  6 Dec 2022 19:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A7EC433D7;
        Tue,  6 Dec 2022 19:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670355694;
        bh=wIpp5xJ3aOk1YINDuDXnwzybQsgEaelfXPcy1Neahms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ou4A6q7x/+PsvK3XmFDZW7TmK0TTj1wZCPz0MtzBjyNx4vO+4OqWMHObEP7jxMQji
         l5sJnlYbq6kJdtNGkIND291wJiEmW14HC7cpzqBp40fqQgHahXV1QgeYpeg0KszFor
         McnyCRuN2Nw0oQ+unBXc2h5BP1vuBffMEyl+QlIw6WnWp3IAJM4cxmQ3aw2pAS+6Dq
         PaKPRJ39YHTEQXPcw29tZHE2DZUIr43X3jBDPP9JuF27t8cteQQ3vUHNxcScJl/CEo
         Wx1AfMNJLo/+lmvuf7EtMeqlLKcZljnS1bi9t3+60q5eKC/CdGok8anzWcgYwZYBjx
         4lK9vlmEmS61Q==
Date:   Tue, 6 Dec 2022 11:41:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64
 support for ksz8 series of switches
Message-ID: <20221206114133.291881a4@kernel.org>
In-Reply-To: <20221205052904.2834962-1-o.rempel@pengutronix.de>
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Dec 2022 06:29:04 +0100 Oleksij Rempel wrote:
> +	stats->rx_packets = raw->rx_bcast + raw->rx_mcast + raw->rx_ucast +
> +		raw->rx_pause;
> +	stats->tx_packets = raw->tx_bcast + raw->tx_mcast + raw->tx_ucast +
> +		raw->tx_pause;

FWIW for normal netdevs / NICs the rtnl_link_stat pkts do not include
pause frames, normally. Otherwise one can't maintain those stats in SW
(and per-ring stats, if any, don't add up to the full link stats).
But if you have a good reason to do this - I won't nack..
