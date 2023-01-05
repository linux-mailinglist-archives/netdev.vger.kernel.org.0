Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821E765EFB3
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 16:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbjAEPJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 10:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233379AbjAEPJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 10:09:39 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3305D404;
        Thu,  5 Jan 2023 07:09:15 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 71D6761;
        Thu,  5 Jan 2023 16:09:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672931353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=680zHctk+9g3XOjt2E56oakXKseN7DiQQH3pba4FlnM=;
        b=qIW3DmL3Bk0BcZW84fBZ57BDpGHX34Wr0mrQVpFn+aRZnXAaqPW0ScLJZe8u6v9FR9uDsV
        RKwx+Pung3ErH808H5weO8grwfyn6yXCzkFf9u9Y9DFhP0UlgA1HOzUYzlolDtCceX+ylw
        dZjpmpiOEDLZMIGKpFqPxspK0o8eFw6C5EHRRUX312kFTAWTmPhZgjPZJ+6w5f6PnEW1o+
        Kd/XovQGI7sMyjQZw6AAkl8dR7GBp4/h5tEYOSEM/bwKN+pekiKPsw3KNTR/xdUpy9BVu+
        xqxeI9WeUmK+Go1f3B5WclIg58O6FvLWH8tMr1bc7oc6dsZG7R2lL2uSKDEaig==
MIME-Version: 1.0
Date:   Thu, 05 Jan 2023 16:09:13 +0100
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        daniel.machon@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, lars.povlsen@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, olteanv@gmail.com, pabeni@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
In-Reply-To: <20221209092904.asgka7zttvdtijub@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <dff03705f3c81962246731ad188d9d3d@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>> Also, if the answer to my question above is yes, and ptp should
>> have worked on eth0 before, this is a regression then.
> 
> OK, I can see your point.
> With the following diff, you should see the same behaviour as before:
> ---
> diff --git
> a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> index 904f5a3f636d3..538f4b76cf97a 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> @@ -91,8 +91,6 @@ lan966x_vcap_is2_get_port_keysets(struct net_device
> *dev, int lookup,
> 
>         /* Check if the port keyset selection is enabled */
>         val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
> -       if (!ANA_VCAP_S2_CFG_ENA_GET(val))
> -               return -ENOENT;
> 
>         /* Collect all keysets for the port in a list */
>         if (l3_proto == ETH_P_ALL)

Any news on this? Apart from the patches which would change the
need to use some tc magic, this should be a separate fixes patch,
right?

-michael
