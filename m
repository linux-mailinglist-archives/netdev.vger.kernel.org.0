Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C839355E96B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239919AbiF1QP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbiF1QPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:15:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317B83915F;
        Tue, 28 Jun 2022 09:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8724CB81E03;
        Tue, 28 Jun 2022 16:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2BB6C3411D;
        Tue, 28 Jun 2022 16:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656432628;
        bh=WpVBva7j7VZPSNBXqtv9g6t3thfqx/hVtm/7Jj0xALM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W2lQSKlUM50c6BBCBf6d92/LNR7uq+577X3PTNJyz09slAuJZ9D0SUQ0M5sRbIdq6
         ZtCRiYhDXvCQ8txOi2B9cPTzUVx+PV57FZNsZ80XhJa+8EjKJ9Yh5FyUKNxHXu+rvf
         tn90FuKvrpufucD2L2KFhkBT31L55d0tadC+VUuaqOACRhml8qc74aBsG94gEC7acm
         5r6OOP9uFPSJo2POzRKv0cKEQDCyeh+9vMD1mAi1OO6L4y0SPbemeK9J9zFoyj0TG7
         Ils1xUPbqFrgc8M0JsFyOsrmrOLMQR+uz5l/yFfLTVVlDKxEASwSoQryqkJ6oA/44+
         XR6qLLnVd3UYg==
Date:   Tue, 28 Jun 2022 09:10:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Lukas Wunner <lukas@wunner.de>, kernel@pengutronix.de,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220628091027.3693f3f9@kernel.org>
In-Reply-To: <20220628084504.GA31626@pengutronix.de>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
        <20220624125902.4068436-2-o.rempel@pengutronix.de>
        <20220624220317.ckhx6z7cmzegvoqi@skbuf>
        <20220626171008.GA7581@pengutronix.de>
        <20220627091521.3b80a4e8@kernel.org>
        <20220627200238.en2b5zij4sakau2t@skbuf>
        <20220627200959.683de11b@kernel.org>
        <YrqsTY0uUy4AwKHN@lunn.ch>
        <20220628084504.GA31626@pengutronix.de>
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

On Tue, 28 Jun 2022 10:45:04 +0200 Oleksij Rempel wrote:
> After I started investigating this topic, I was really frustrated. It is
> has hard to find what is wrong: my patch is not working and flow
> controller is not triggered? Or every HW/driver implements counters in
> some own way. Same is about byte counts: for same packet with different
> NICs i have at least 3 different results: 50, 64 and 68.
> It makes testing and validation a nightmare. 

Yeah, I was gonna mention QA in my reply. The very practical reason I've
gone no-CRC, no-flow control in the driver stats in the past was that it
made it possible to test the counters are correct and the match far end.
I mean SW matches HW, and they both match between sender/receiver
(testing NIC-switch-NIC if either link does flow control the counters
on NICs won't match).
