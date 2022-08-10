Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F053958E460
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 03:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiHJBM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 21:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiHJBMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 21:12:02 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AED254647;
        Tue,  9 Aug 2022 18:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=wsVLLgzkz3GDUeRDpLJYtX2KkZ5PxL+g/u552PnAlyA=; b=JHOqdE8gC/7zLKeEQ4sjg6NCXE
        ChNgrLOSptC0Uw9mnyQsvFYKm8QY8c8l6I/PfjO2uiClGXzHENEAjdQdF5ECXmXA2JWvHVaQEl4bW
        wCxmsgne9yzK/TDgXovNHicpQndkdSkp/AitKCgop69mYx8nwylRA3aJuf2nTREWw4bA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oLaGC-00CtN6-8q; Wed, 10 Aug 2022 03:11:48 +0200
Date:   Wed, 10 Aug 2022 03:11:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
Message-ID: <YvMF1JW3RzRbOhlx@lunn.ch>
References: <20220808210945.GP17705@kitsune.suse.cz>
 <20220808143835.41b38971@hermes.local>
 <20220808214522.GQ17705@kitsune.suse.cz>
 <53f91ad4-a0d1-e223-a173-d2f59524e286@seco.com>
 <20220809213146.m6a3kfex673pjtgq@pali>
 <b1b33912-8898-f42d-5f30-0ca050fccf9a@seco.com>
 <20220809214207.bd4o7yzloi4npzf7@pali>
 <2083d6d6-eecf-d651-6f4f-87769cd3d60d@seco.com>
 <20220809224535.ymzzt6a4v756liwj@pali>
 <CAJ+vNU2xBthJHoD_-tPysycXZMchnXoMUBndLg4XCPrHOvgsDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU2xBthJHoD_-tPysycXZMchnXoMUBndLg4XCPrHOvgsDA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Is something like the following really that crazy of an idea?
> diff --git a/net/core/dev.c b/net/core/dev.c
> index e0878a500aa9..a679c74a63c6 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1151,6 +1151,15 @@ static int dev_alloc_name_ns(struct net *net,
>         int ret;
> 
>         BUG_ON(!net);
> +#ifdef CONFIG_OF
> +       if (dev->dev.parent && dev->dev.parent->of_node) {
> +               const char *name =
> of_get_property(dev->dev.parent->of_node, "label", NULL);
> +               if (name) {
> +                       strlcpy(dev->name, name, IFNAMSIZ);
> +                       return 0;
> +               }
> +       }
> +#endif
>         ret = __dev_alloc_name(net, name, buf);
>         if (ret >= 0)
>                 strlcpy(dev->name, buf, IFNAMSIZ);
> 
> I still like using the index from aliases/ethernet* instead as there
> is a precedence for that in other Linux drivers as well as U-Boot

I guess you are new to the netdev list :-)

This is one of those FAQ sort of things, discussed every
year. Anything like this is always NACKed. I don't see why this time
should be any different.

DSA is somewhat special because it is very old. It comes from before
the times of DT. Its DT binding was proposed relatively earl in DT
times, and would be rejected in modern days. But the rules of ABI mean
the label property will be valid forever. But i very much doubt it
will spread to interfaces in general.

     Andrew
