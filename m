Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5C4597B81
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 04:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240728AbiHRC33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 22:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239403AbiHRC32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 22:29:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37974DB04
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 19:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3Q3HE+D5YQ4YxJbHPiJRwAI28kmD0AtZkeVh5fzzryg=; b=gHPrvRBavCgtxv+1Q28ubdgds7
        O229kVw8iRoS8yCpQ+Zv68nAXknenmpMUDpkPElBVdcZjoLxUFPifF0lsezAixUGpdTKTnMrD7E/M
        N/JIySc5RDy8bEUlLikJh2FZHI60SU2Cn4RTP8MIQHUDVbS3hMdrc2cY1r3jl6BDYZzQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oOVHc-00DhDw-OV; Thu, 18 Aug 2022 04:29:20 +0200
Date:   Thu, 18 Aug 2022 04:29:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Yang Wei <yang.wei9@zte.com.cn>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] net: moxa: MAC address reading, generating, validity
 checking
Message-ID: <Yv2kAO5l4uFcqh7D@lunn.ch>
References: <20220817171043.459267-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817171043.459267-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -539,6 +533,11 @@ static int moxart_mac_probe(struct platform_device *pdev)
>  
>  	SET_NETDEV_DEV(ndev, &pdev->dev);
>  
> +	ret = platform_get_ethdev_address(p_dev, ndev);
> +	if (ret)
> +		eth_hw_addr_random(ndev);

You should look at the return value. It could be EPROBE_DEFFER,
because the EEPROM has not probed yet. You need to return this value,
so that the device core will probe other devices, including the
EEPROM, and then later reprobe this driver.

	Andrew
