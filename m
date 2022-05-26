Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D47534DA9
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbiEZLBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiEZLBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:01:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7B31D0F3;
        Thu, 26 May 2022 04:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4821EB81F14;
        Thu, 26 May 2022 11:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE33C385A9;
        Thu, 26 May 2022 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653562868;
        bh=hfcaxSjEVLVQ76sX/0B4km9ev5zJp72a68slPepbwZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J9dNX/CYol3rStXoipC4u3m65JQ/CVaYQLLeFR/i3em/BmWPkr6liFYFLsTB73x+2
         AsmUaVFFeVz7ZNFGd1fXszmwZSbIzc9eBnFF5fLvfmUuJZGybocBoY+BaFL9uPpQAe
         ns25g2mHLQUqOlfyBZdCH7cHrwSN6s7nq7bUYiY00XpfTe5OmO3XJtHs0cFXqp6uPc
         r5iTZmfH515no5UYjI8tMSqvh8GPqn+Rffu8JwrjYtZvB+6eEbR+gl+TST/LgjdAyD
         /zyoM4tNT5p1h5DYZB/tt2QE43L7JUZZaXXKLXVcdTWOoaCcC4TE7SKVHlz5xygH6h
         fQZ4MpxI6Bd4w==
Date:   Thu, 26 May 2022 13:01:02 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Fix refcount leak in
 mv88e6xxx_mdios_register
Message-ID: <20220526130102.6c532648@dellmb>
In-Reply-To: <20220526083748.39816-1-linmq006@gmail.com>
References: <20220526083748.39816-1-linmq006@gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 May 2022 12:37:48 +0400
Miaoqian Lin <linmq006@gmail.com> wrote:

> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when done.
> This function missing of_node_put() in an error path.
> Add missing of_node_put() to avoid refcount leak.
> 
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 5d2c57a7c708..0726df6aeb1f 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -3960,8 +3960,10 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
>  	 */
>  	child = of_get_child_by_name(np, "mdio");
>  	err = mv88e6xxx_mdio_register(chip, child, false);
> -	if (err)
> +	if (err) {
> +		of_node_put(child);
>  		return err;
> +	}
>  
>  	/* Walk the device tree, and see if there are any other nodes
>  	 * which say they are compatible with the external mdio

Fix needs Fixes tag so that it can be backported. Please add correct
Fixes tag.
