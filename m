Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538895B5727
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 11:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiILJ0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 05:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiILJ0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 05:26:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27931033;
        Mon, 12 Sep 2022 02:26:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6ED7C6112C;
        Mon, 12 Sep 2022 09:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A2EC433D6;
        Mon, 12 Sep 2022 09:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662974776;
        bh=Oq0ZzVeBX8F/RKS4c4Vh4FGTIXqsPapMIyRWRtNrqkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GU69TbWSZ4eAoMzeJfsgt0vzabJ5NQPvio0rifqGc1qyyqcoM1R5c4RCnTghwH9CU
         IB21B+wU7wC7LHpPaE+vefWzWR7WqSO4wJqx1wObZGPpKki6lLlkGUk45FV9L7dH2H
         0flvhvNaQ1bLe5FJQnci4Bn1O5556vJO43oOyhhazWtX2FRb2p9KXMdNSPSjmmUMva
         B5CGzELM9/2mkVFYHYs0K/K8zCB/TVhPIma9iB2j2rtdNtS0RIsMy8nOooaExLZ6Cq
         aPaSKwmIXZBpGeOJz93ujl/9BnY6Xx3qq8Fi4nv1ViSMQmTEykzF5bE6/5RA9006Tr
         bQVusZjVXMCrw==
Date:   Mon, 12 Sep 2022 17:26:11 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
Message-ID: <20220912092611.GW1728671@dragon>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 12:24:58AM +0300, Vladimir Oltean wrote:
> Commit "arm64: dts: ls1028a: enable swp5 and eno3 for all boards" which
> Shawn declared as applied, but for which I can't find a sha1sum, has
> enabled a new Ethernet port on the LS1028A-RDB (&enetc_port3), but
> U-Boot, which passes a MAC address to Linux' device tree through the
> /aliases node, fails to do this for this newly enabled port.
> 
> Fix that by adding more ethernet aliases in the only
> backwards-compatible way possible: at the end of the current list.
> 
> And since it is possible to very easily convert either swp4 or swp5 to
> DSA user ports now (which have a MAC address of their own), using these
> U-Boot commands:
> 
> => fdt addr $fdt_addr_r
> => fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet
> 
> it would be good if those DSA user ports (swp4, swp5) gained a valid MAC
> address from U-Boot as well. In order for that to work properly,
> provision two more ethernet aliases for &mscc_felix_port{4,5} as well.
> 
> The resulting ordering is slightly unusual, but to me looks more natural
> than eno0, eno2, swp0, swp1, swp2, swp3, eno3, swp4, swp5.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks!
