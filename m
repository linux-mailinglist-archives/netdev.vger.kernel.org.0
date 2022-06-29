Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2BF5604D4
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiF2PjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232242AbiF2PjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:39:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAEA2C667;
        Wed, 29 Jun 2022 08:39:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BF6BB82553;
        Wed, 29 Jun 2022 15:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFF4C34114;
        Wed, 29 Jun 2022 15:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656517148;
        bh=sKpa3nSekXMC1dtLq0tyU6Qud/zL0leMfbAOmxPeT7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tkAOtw9sMCZ52YMxzIiR2IZ33V6d9HSV2I2OW2zOO9DTKpuK4gFejS4+jrTB2x8lF
         6iSG9TdNItbYLUSr0XhIEg9fOpz3zBr/s1SkDobyi0O+hE5rk3kVrfCrFufSzXdpjG
         P8gE4e5fVo3tv+s4b/maQskXrnUmQZEl9WwNBrplDanyELnxDcY2DI2GKwrbLgD0j9
         zq4mr/qZBTRL2wzjDhKLJfzE2QDLmJV/bwirfT9ygB0USRYgodD+r6SQE6WxCXmrbk
         0VWw2C2fNuFRzN/hQQqYaLD4UGA9Pwd5iaLWIZysh9DVvlC0OKAg3CxRVD0YP3mPLp
         7Jdu/DclpuQYA==
Date:   Wed, 29 Jun 2022 08:39:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>
Subject: Re: [PATCH net-next] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Message-ID: <20220629083906.45e7a023@kernel.org>
In-Reply-To: <MN0PR12MB5953872B976C38C430166DECB7BB9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1656439734-632-1-git-send-email-radhey.shyam.pandey@amd.com>
        <20220628220846.25025a22@kernel.org>
        <MN0PR12MB5953872B976C38C430166DECB7BB9@MN0PR12MB5953.namprd12.prod.outlook.com>
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

On Wed, 29 Jun 2022 15:24:55 +0000 Pandey, Radhey Shyam wrote:
> Oh, I could also see this error when making it a module compilation.
> I will fix it in v2. As an alternative to device_is_bound() i think we 
> can check the presence of drvdata. Similar approach i see it in ongoing
> onboard_usb_hub driver series[1]. Does it look ok?/any other suggestions?
> 
> -       if (mdio_pdev && !device_is_bound(&mdio_pdev->dev)) 
> +       if (mdio_pdev && !dev_get_drvdata(&mdio_pdev->dev)) 
> 
> [1]: https://lore.kernel.org/all/20220622144857.v23.2.I7c9a1f1d6ced41dd8310e8a03da666a32364e790@changeid/
> Listed in v21 changes.

Yeah, no real opinion here. The entire patch looks odd but I lost track
of the devlink discussions. Could you CC Saravana, Greg, Rafael, etc
on the next version? And the Ethernet PHY maintainers.
