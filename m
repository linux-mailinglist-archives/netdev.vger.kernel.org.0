Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5143546F53
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 23:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348444AbiFJVid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 17:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350912AbiFJVi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 17:38:28 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454771F2F1;
        Fri, 10 Jun 2022 14:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1654897096;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:Cc:Date:
    From:Subject:Sender;
    bh=a3Rk3yhxnJhCv6Qj624wu7M2nBXngXmeYHXcjNT33ok=;
    b=ZKTD1WNv00LFdu+Q4ppZ1lebC2ObidcVZY/5sy4/XwKKDAPvNWSYwoqkx+5iBDkf9h
    2gebngYyyJ+oKydxWMorT62lfCw8y4KBKGdji0lqlndNuqmteXz9PVgDpJM4aW2/+B05
    RUDJx+HjFBptPmM42NiSoxhUG7A9w3yzlp4OOJWtxN4cDznuMee4eLGKfoXFvyK42fYJ
    EcEsgNZxUEi+ZOppat5T+07WGt3X8jQ2PVeDWlOBRHY9Ahj2n8f6qnaIL9Y7LmORonT3
    RJUMC+50swxT+snFDNTst4p+P21P1CD+N9va0lYpdOCsNxl9SbPcUU8+xJWmxF8oYn4W
    MPzw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3DbdV+OforxeK+9Kg=="
X-RZG-CLASS-ID: mo00
Received: from [172.20.10.8]
    by smtp.strato.de (RZmta 47.45.0 DYNA|AUTH)
    with ESMTPSA id R0691fy5ALcFJJK
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 10 Jun 2022 23:38:15 +0200 (CEST)
Subject: Re: [PATCH v6 0/7] can: refactoring of can-dev module and of Kbuild
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <bba88460-4f81-aeb1-db35-9d37c48e120f@hartkopp.net>
Date:   Fri, 10 Jun 2022 23:38:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220610143009.323579-1-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.06.22 16:30, Vincent Mailhol wrote:
> Aside of calc_bittiming.o which can be configured with
> CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
> unconditionally to can-dev.o even if not needed by the user.
> 
> This series first goal it to split the can-dev modules so that the
> only the needed features get built in during compilation.
> Additionally, the CAN Device Drivers menu is moved from the
> "Networking support" category to the "Device Drivers" category (where
> all drivers are supposed to be).
> 
> 
> * menu before this series *
> 
> CAN bus subsystem support
>    symbol: CONFIG_CAN
>    |
>    +-> CAN Device Drivers
>        (no symbol)
>        |
>        +-> software/virtual CAN device drivers
>        |   (at time of writing: slcan, vcan, vxcan)
>        |
>        +-> Platform CAN drivers with Netlink support
>            symbol: CONFIG_CAN_DEV
>            |
>            +-> CAN bit-timing calculation  (optional for hardware drivers)
>            |   symbol: CONFIG_CAN_CALC_BITTIMING
>            |
>            +-> All other CAN devices drivers
> 
> * menu after this series *
> 
> Network device support
>    symbol: CONFIG_NETDEVICES
>    |
>    +-> CAN Device Drivers
>        symbol: CONFIG_CAN_DEV
>        |
>        +-> software/virtual CAN device drivers
>        |   (at time of writing: slcan, vcan, vxcan)
>        |
>        +-> CAN device drivers with Netlink support
>            symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
>            |
>            +-> CAN bit-timing calculation (optional for all drivers)
>            |   symbol: CONFIG_CAN_CALC_BITTIMING
>            |
>            +-> All other CAN devices drivers
>                (some may select CONFIG_CAN_RX_OFFLOAD)
>                |
>                +-> CAN rx offload (automatically selected by some drivers)
>                    (hidden symbol: CONFIG_CAN_RX_OFFLOAD)
> 
> Patches 1 to 5 of this series do above modification.
> 
> The last two patches add a check toward CAN_CTRLMODE_LISTENONLY in
> can_dropped_invalid_skb() to discard tx skb (such skb can potentially
> reach the driver if injected via the packet socket). In more details,
> patch 6 moves can_dropped_invalid_skb() from skb.h to skb.o and patch
> 7 is the actual change.
> 
> Those last two patches are actually connected to the first five ones:
> because slcan and v(x)can requires can_dropped_invalid_skb(), it was
> necessary to add those three devices to the scope of can-dev before
> moving the function to skb.o.
> 
> This design results from the lengthy discussion in [1].
> 
> [1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/
> 
> 
> ** Changelog **
> 
> v5 -> v6:
> 
>    * fix typo in patch #1's title: Kbuild -> Kconfig.
> 
>    * make CONFIG_RX_CAN an hidden config symbol and modify the diagram
>      in the cover letter accordingly.
> 
>      @Oliver, with CONFIG_CAN_RX_OFFLOAD now being an hidden config,
>      that option fully depends on the drivers. So contrary to your
>      suggestion, I put CONFIG_CAN_RX_OFFLOAD below the device drivers
>      in the diagram.

Yes, fine for me.

I did some Kconfig configuration tests and built the drivers to see 
vcan.ko depending on can-dev.ko at module loading the first time ;-)

Nice work.

So for these bits I can provide a

Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks,
Oliver

> 
>    * fix typo in cover letter: CONFIG_CAN_BITTIMING -> CONFIG_CAN_CALC_BITTIMING.
> 
> v4 -> v5:
> 
>    * m_can is also requires RX offload. Add the "select CAN_RX_OFFLOAD"
>      to its Makefile.
> 
>    * Reorder the lines of drivers/net/can/dev/Makefile.
> 
>    * Remove duplicated rx-offload.o target in drivers/net/can/dev/Makefile
> 
>    * Remove the Nota Bene in the cover letter.
> 
> 
> v3 -> v4:
> 
>    * Five additional patches added to split can-dev module and refactor
>      Kbuild. c.f. below (lengthy) thread:
>      https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/
> 
> 
> v2 -> v3:
> 
>    * Apply can_dropped_invalid_skb() to slcan.
> 
>    * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
>      modifying Kbuild.
> 
>    * fix small typos.
> 
> v1 -> v2:
> 
>    * move can_dropped_invalid_skb() to skb.c instead of dev.h
> 
>    * also move can_skb_headroom_valid() to skb.c
> 
> Vincent Mailhol (7):
>    can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
>    can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using
>      CAN_DEV
>    can: bittiming: move bittiming calculation functions to
>      calc_bittiming.c
>    can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
>    net: Kconfig: move the CAN device menu to the "Device Drivers" section
>    can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid()
>      to skb.c
>    can: skb: drop tx skb if in listen only mode
> 
>   drivers/net/Kconfig                   |   2 +
>   drivers/net/can/Kconfig               |  55 +++++--
>   drivers/net/can/dev/Makefile          |  17 ++-
>   drivers/net/can/dev/bittiming.c       | 197 -------------------------
>   drivers/net/can/dev/calc_bittiming.c  | 202 ++++++++++++++++++++++++++
>   drivers/net/can/dev/dev.c             |   9 +-
>   drivers/net/can/dev/skb.c             |  72 +++++++++
>   drivers/net/can/m_can/Kconfig         |   1 +
>   drivers/net/can/spi/mcp251xfd/Kconfig |   1 +
>   include/linux/can/skb.h               |  59 +-------
>   net/can/Kconfig                       |   5 +-
>   11 files changed, 338 insertions(+), 282 deletions(-)
>   create mode 100644 drivers/net/can/dev/calc_bittiming.c
> 
