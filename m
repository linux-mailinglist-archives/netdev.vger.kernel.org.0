Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068404F1A9D
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 23:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379083AbiDDVSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 17:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379525AbiDDRWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 13:22:55 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDDE1E3E9;
        Mon,  4 Apr 2022 10:20:58 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 8AE2C22246;
        Mon,  4 Apr 2022 19:20:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1649092856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fiuc10BmQ8FCYumv3/mTGwuX/cjcFoEPXhSP8kK6PCg=;
        b=WVy6B8bxp6qvBT9VjDxW2ZwquzLSrYjAOaw3xmKLS/jVoUOlRTtrgZFLao794Zl5r5UdDt
        CfbCFnR/Y5tmllb2MyALaL24UBOwDe+7ueZemyqdS/yD6uyd3a/g56rwQ0mZ5BNoMsDXZ1
        GyzpR8lu64sWFOFj+d/FMrx8z1WzLts=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 04 Apr 2022 19:20:56 +0200
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v3 0/4] net: lan966x: Add support for FDMA
In-Reply-To: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
References: <20220404130655.4004204-1-horatiu.vultur@microchip.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <57b1a196d25cf5d989611fea4f590333@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-04-04 15:06, schrieb Horatiu Vultur:
> Currently when injecting or extracting a frame from CPU, the frame
> is given to the HW each word at a time. There is another way to
> inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
> In this way the entire frame is given to the HW. This improves both
> RX and TX bitrate.
> 
> v2->v3:
> - move skb_tx_timestamp before the IFH is inserted, because in case of 
> PHY
>   timestamping, the PHY should not see the IFH.
> - use lower/upper_32_bits()
> - reimplement the RX path in case of memory pressure.
> - use devm_request_irq instead of devm_request_threaded_irq
> - add various checks for return values.
> 
> v1->v2:
> - fix typo in commit message in last patch
> - remove first patch as the changes are already there
> - make sure that there is space in skb to put the FCS
> - move skb_tx_timestamp closer to the handover of the frame to the HW
> 
> Horatiu Vultur (4):
>   net: lan966x: Add registers that are used for FDMA.
>   net: lan966x: Expose functions that are needed by FDMA
>   net: lan966x: Add FDMA functionality
>   net: lan966x: Update FDMA to change MTU.
> 
>  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 783 ++++++++++++++++++
>  .../ethernet/microchip/lan966x/lan966x_main.c |  49 +-
>  .../ethernet/microchip/lan966x/lan966x_main.h | 121 +++
>  .../ethernet/microchip/lan966x/lan966x_port.c |   3 +
>  .../ethernet/microchip/lan966x/lan966x_regs.h | 106 +++
>  6 files changed, 1052 insertions(+), 12 deletions(-)
>  create mode 100644 
> drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c

For this series:
Tested-by: Michael Walle <michael@walle.cc> # on kontron-kswitch-d10

-michael
