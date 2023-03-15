Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7056A6BA8B9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjCOHHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjCOHHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:07:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F2569CDF;
        Wed, 15 Mar 2023 00:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2ED361B40;
        Wed, 15 Mar 2023 07:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4E4C433D2;
        Wed, 15 Mar 2023 07:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678864019;
        bh=lDIyJ4oPK93F0w+KLjM947IqcTRna70bjQG2tKv16AE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kJWgnKYrbZLQ15lD5d6aPMeq7bqa3XU1QZ0jbOB66gyJ+aWspOJeg5to6AfmEcwLA
         2rIyhpS+dMw0S3BV0mOq07gpmHUc0oHrEFtmf23MCLLTaB/YoD7i78NxKtOD20vrkR
         GDXKocHfRDaafw10jrubPyG8IcZU8eOuc9sUE5JO/4W1U9DfDuX2F3ooNWVdDw15v8
         XgwPkkj01tkZDbjvl8CQYUqLTqXTOs5rCruIPkJMfIXmjGCNDQ26PXsAHtt6X8P5/1
         PosmB1FoPIhaNFJ3CY5WNzwU+71xO5q/vHwTZjmPHSrR36DhvNcm4jbALpv+vedeil
         7Yvoqap2WI9xA==
Date:   Wed, 15 Mar 2023 00:06:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: mmap: fix device tree support
Message-ID: <20230315000657.1ab9d9f4@kernel.org>
In-Reply-To: <20230310121059.4498-1-noltari@gmail.com>
References: <20230310121059.4498-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 13:10:59 +0100 =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mma=
p.c
> index e968322dfbf0..24ea2e19dfa6 100644
> --- a/drivers/net/dsa/b53/b53_mmap.c
> +++ b/drivers/net/dsa/b53/b53_mmap.c
> @@ -263,7 +263,7 @@ static int b53_mmap_probe_of(struct platform_device *=
pdev,
>  		if (of_property_read_u32(of_port, "reg", &reg))
>  			continue;
> =20
> -		if (reg < B53_CPU_PORT)
> +		if (reg <=3D B53_CPU_PORT)
>  			pdata->enabled_ports |=3D BIT(reg);

Should we switch to B53_N_PORTS instead?
That's the bound used by the local "for each port" macro:

#define b53_for_each_port(dev, i) \     =20
        for (i =3D 0; i < B53_N_PORTS; i++) \
                if (dev->enabled_ports & BIT(i))=20
