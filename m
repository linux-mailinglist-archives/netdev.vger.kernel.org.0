Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B59A528DD4
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 21:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbiEPTVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 15:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345352AbiEPTUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 15:20:55 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7178D10E4;
        Mon, 16 May 2022 12:20:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9943ECE177A;
        Mon, 16 May 2022 19:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF39C385AA;
        Mon, 16 May 2022 19:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652728849;
        bh=7dUSBEaVamNeH7xckM86EZ0E5ZnTZzdD58oA2l0UR3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VJ7OGTc52LlV1ISiugEC2mc7JmkPYUHU9OJljdPL20C9+c4WADQlABss11pQKlmo1
         kpnKMpqghOyA0WK8OdDpzqKwonl8XTsQTDbUOzLF3liCLKarJ+Qp5ZpgPdWfhuYu29
         LV86wvCPO+CqHu4Eumw8WtfxvhO0Z5V19nhm3Tz77ZAxi/wA+r8j4QfZwWHZ+xU1yd
         EmyEMbazGyMjF/5jMsLqchJD+KZTUAxIa3wqAQw9bMMJPzMGZIXtej6dO62ejWs+up
         MuEvpp/O8Ty24E+KKTQc7ARAlK42mOyti6GUMCtzItWqSikGZodQknV0Ixscyill6f
         s+n/vF1Pyk9pw==
Date:   Mon, 16 May 2022 12:20:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Message-ID: <20220516122048.70e238a2@kernel.org>
In-Reply-To: <20220514150656.122108-3-maxime.chevallier@bootlin.com>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
        <20220514150656.122108-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 May 2022 17:06:53 +0200 Maxime Chevallier wrote:
> This tagging protocol is designed for the situation where the link
> between the MAC and the Switch is designed such that the Destination
> Port, which is usually embedded in some part of the Ethernet Header, is
> sent out-of-band, and isn't present at all in the Ethernet frame.
> 
> This can happen when the MAC and Switch are tightly integrated on an
> SoC, as is the case with the Qualcomm IPQ4019 for example, where the DSA
> tag is inserted directly into the DMA descriptors. In that case,
> the MAC driver is responsible for sending the tag to the switch using
> the out-of-band medium. To do so, the MAC driver needs to have the
> information of the destination port for that skb.
> 
> This out-of-band tagging protocol is using the very beggining of the skb
> headroom to store the tag. The drawback of this approch is that the
> headroom isn't initialized upon allocating it, therefore we have a
> chance that the garbage data that lies there at allocation time actually
> ressembles a valid oob tag. This is only problematic if we are
> sending/receiving traffic on the master port, which isn't a valid DSA
> use-case from the beggining. When dealing from traffic to/from a slave
> port, then the oob tag will be initialized properly by the tagger or the
> mac driver through the use of the dsa_oob_tag_push() call.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

This must had been asked on v1 but there's no trace of it in the
current submission afaict...

If the tag is passed in the descriptor how is this not a pure switchdev
driver? The explanation must be preserved somehow.
