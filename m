Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1D6669D26
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbjAMQF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:05:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjAMQE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:04:58 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05D01007B
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Jb8tM5SZIx0ELJNoGn9ANaiCAyLfgc9Dacu5fX+OwQc=; b=PtCjlW/gcuyPIjhAKaRtLA3sPQ
        4RoEEA8pNdL7UKfrsQMg2MvM0p+9pE7P6JVQJzGMk6zPxajQS+acrOsYSZ6LiwWiELPaHLVfdB80U
        gjvo6ZeNUYqW+Byh2djxp+gkT8wT21WuUZ9YC37h8qu1ngCagOHu3UfpUHimXmpDi6/U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pGMOv-0020yi-TT; Fri, 13 Jan 2023 16:55:29 +0100
Date:   Fri, 13 Jan 2023 16:55:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
Message-ID: <Y8F+8TBxBsT4smVf@lunn.ch>
References: <20230113151258.196828-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113151258.196828-1-kurt@linutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 04:12:58PM +0100, Kurt Kanzenbach wrote:
> The switch receives management traffic such as STP and LLDP. However, PTP
> messages are not received, only transmitted.
> 
> Ideally, the switch would trap all PTP messages to the management CPU. This
> particular switch has a PTP block which identifies PTP messages and traps them
> to a dedicated port. There is a register to program this destination. This is
> not used at the moment.
> 
> Therefore, program it to the same port as the MGMT traffic is trapped to. This
> allows to receive PTP messages as soon as timestamping is enabled.
> 
> In addition, the datasheet mentions that this register is not valid e.g., for
> 6190 variants. So, add a new PTP operation which is added for the 6390 and 6290
> devices.
> 
> Tested simply like this on Marvell 88E6390, revision 1:
> 
> |/ # ptp4l -2 -i lan4 --tx_timestamp_timeout=40 -m
> |[...]
> |ptp4l[147.450]: master offset         56 s2 freq   +1262 path delay       413
> |ptp4l[148.450]: master offset         22 s2 freq   +1244 path delay       434
> |ptp4l[149.450]: master offset          5 s2 freq   +1234 path delay       446
> |ptp4l[150.451]: master offset          3 s2 freq   +1233 path delay       451
> |ptp4l[151.451]: master offset          1 s2 freq   +1232 path delay       451
> |ptp4l[152.451]: master offset         -3 s2 freq   +1229 path delay       451
> |ptp4l[153.451]: master offset          9 s2 freq   +1240 path delay       451
> 
> Link: https://lore.kernel.org/r/CAFSKS=PJBpvtRJxrR4sG1hyxpnUnQpiHg4SrUNzAhkWnyt9ivg@mail.gmail.com
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
