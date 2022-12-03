Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51BB64151E
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 10:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiLCJAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 04:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLCJAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 04:00:50 -0500
Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637F517A81;
        Sat,  3 Dec 2022 01:00:48 -0800 (PST)
Received: from amadeus-VLT-WX0.lan (unknown [218.85.118.194])
        by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 61A7280008A;
        Sat,  3 Dec 2022 17:00:42 +0800 (CST)
From:   Chukun Pan <amadeus@jmu.edu.cn>
To:     heiko@sntech.de
Cc:     alexandre.torgue@foss.st.com, amadeus@jmu.edu.cn,
        davem@davemloft.net, david.wu@rock-chips.com,
        devicetree@vger.kernel.org, edumazet@google.com,
        joabreu@synopsys.com, krzysztof.kozlowski+dt@linaro.org,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, peppe.cavallaro@st.com,
        robh+dt@kernel.org
Subject: Re: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs compatible
Date:   Sat,  3 Dec 2022 17:00:15 +0800
Message-Id: <20221203090015.16132-1-amadeus@jmu.edu.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <3689593.Mh6RI2rZIc@diego>
References: <3689593.Mh6RI2rZIc@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
        tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCH0pJVksaHk5DGUlNS0hOT1UTARMWGhIXJBQOD1
        lXWRgSC1lBWUlKQ1VDTlVKSkNVSkJPWVdZFhoPEhUdFFlBWU9LSFVKSktPS0NVSktLVUtZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mxw6ARw*IT0uMApMFiwDAzgV
        TywwCypVSlVKTUxLS05DS09IT0hDVTMWGhIXVRoWGh8eDgg7ERYOVR4fDlUYFUVZV1kSC1lBWUlK
        Q1VDTlVKSkNVSkJPWVdZCAFZQUlCSEM3Bg++
X-HM-Tid: 0a84d73765e6b03akuuu61a7280008a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Actually looking deeper in the TRM, having these registers "just" written
> to from the dwmac-glue-layer feels quite a bit like a hack.

> The "pcs" thingy referenced in patch2 actually looks more like a real device
> with its own section in the TRM and own iomem area. This pcs device then
> itself has some more settings stored in said pipe-grf.

> So this looks more like it wants to be an actual phy-driver.

> @Chukun Pan: plase take a look at something like
> https://elixir.bootlin.com/linux/latest/source/drivers/phy/mscc/phy-ocelot-serdes.c#L398
> on how phy-drivers for ethernets could look like.

> Aquiring such a phy from the dwmac-glue and calling phy_set_mode after
> moving the xpcs_setup to a phy-driver shouldn't be too hard I think.

Thanks for pointing that out.
The patch2 is come from the sdk kernel of rockchip.
The sgmii-phy of RK3568 is designed on nanning combo phy.
In the sdk kernel, if we want to use sgmii mode, we need
to modify the device tree in the gmac section like this:

```
&gmac0 {
	power-domains = <&power RK3568_PD_PIPE>;
	phys = <&combphy1_usq PHY_TYPE_SGMII>;
	phy-handle = <&sgmii_phy>;
	phy-mode = "sgmii";
	rockchip,pipegrf = <&pipegrf>;
	rockchip,xpcs = <&xpcs>;
	status = "okay";
};
```

I'm not sure how to write this on the mainline kernel.
Any hint will be appreciated.

--
Thanks,
Chukun

-- 
2.25.1

