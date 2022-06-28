Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9829055D146
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiF1DKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 23:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiF1DKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 23:10:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A26825293;
        Mon, 27 Jun 2022 20:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D4276CE1DB0;
        Tue, 28 Jun 2022 03:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27D4C34115;
        Tue, 28 Jun 2022 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656385809;
        bh=/A5lHilGEudxQN1O5lOE9f2WrwiKW9Rpq6x20lJowk4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h166QgdZP9uwpn/JkxefGVFxMXKdD8DfVDJglCGI+/gO8rliUYhFA0zTxWl68rDVi
         xaOHqczWVTdbZOn6kvLHvHZf7uR2a6sDas4Xu5jha4ky7CLU9dRnTJWtUJLAPxYUeS
         6k3FutNoHPR+q2PKYpLYc4WnB/VH3/lBgyF4sZXwW1bfDsDfQeMEF/y3T7UuADShhT
         DYyoITkrMtHA1///J0ZfrVe0YiOcUyyHCKsK5T21aHELFDYYUQSHrVRvr7Xl9OJNHj
         FlHwrDUGB1cEQISrkqw1lIZ6ua4T98+JO1SK4N6ReEbXoPXgCXmm2fioOQUOUIIJkn
         cqn0bUER1tZBw==
Date:   Mon, 27 Jun 2022 20:09:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/3] net: dsa: ar9331: add support for pause
 stats
Message-ID: <20220627200959.683de11b@kernel.org>
In-Reply-To: <20220627200238.en2b5zij4sakau2t@skbuf>
References: <20220624125902.4068436-1-o.rempel@pengutronix.de>
        <20220624125902.4068436-2-o.rempel@pengutronix.de>
        <20220624220317.ckhx6z7cmzegvoqi@skbuf>
        <20220626171008.GA7581@pengutronix.de>
        <20220627091521.3b80a4e8@kernel.org>
        <20220627200238.en2b5zij4sakau2t@skbuf>
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

On Mon, 27 Jun 2022 23:02:38 +0300 Vladimir Oltean wrote:
> > > Yes, it will be interesting to know how to proceed with it.  
> > 
> > I'm curious as well, AFAIK most drivers do not count pause to ifc stats.  
> 
> How do you know? Just because they manually bump stats->tx_bytes and
> stats->tx_packets during ndo_start_xmit?
> 
> That would be a good assumption, but what if a network driver populates
> struct rtnl_link_stats64 entirely based on counters reported by hardware,
> including {rx,tx}_{packets,bytes}?

Yeah, a lot of drivers use SW stats. What matters is where the packets
get counted, even if device does the counting it may be in/before or
after the MAC. Modern NICs generally don't use MAC-level stats for the
interface because of virtualization.

> Personally I can't really find a reason why not count pause frames if
> you can. And in the same note, why go to the extra lengths of hiding
> them as Oleksij does. For example, the ocelot/felix switches do count
> PAUSE frames as packets/bytes, both on rx and tx.

Yeah, the corrections are always iffy. I understand the doubts, and we
can probably leave things "under-specified" until someone with a strong
preference comes along. But I hope that the virt example makes it clear
that neither of the choices is better (SR-IOV NICs would have to start
adding the pause if we declare rtnl stats as inclusive).

I can see advantages to both counting (they are packets) and not
counting those frames (Linux doesn't see them, they get "invented" 
by HW).

Stats are hard.
