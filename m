Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89160647C4A
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLICcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:32:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiLICcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:32:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD8C248D1;
        Thu,  8 Dec 2022 18:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02246B8270D;
        Fri,  9 Dec 2022 02:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431A2C433EF;
        Fri,  9 Dec 2022 02:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670553165;
        bh=66YHqkbUz9ICPV7H8paDpaZ9/YWiJiIvaPjUkb0Y3DI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pu+JQvBBOujIrrhp5ay1lDV61pqlOjPPst+T9VGJR2+H3VJJPCFlMLBLadlQx7vrt
         nBqwm93Zr46Pg5YhPliBdUqJvQ75WPsCu0sR3bjjiBop5D0yTL4Vxi4BwiKJljpbWt
         IhPKa09uWZe+GG7PXxaCJgdktAPUWTQCOBCxR3/u5vcogVCsss9xuLexkMXtbnLFpn
         dYtg1mZuAPXjjEhRPLqOLqarbZY07podNBm7m0U6UrfxDHGndNPm9VZBl0UikB74M5
         bTkMIb5OnzvBNwCnpG9JaUAAgyIoemNAY4wgcHiUmYd9NmRiBvFxpJ7AhjDdux4MJY
         ZgUDaQ+ZWDRZw==
Date:   Thu, 8 Dec 2022 18:32:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <ehakim@nvidia.com>
Cc:     <linux-kernel@vger.kernel.org>, <raeds@nvidia.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <sd@queasysnail.net>,
        <atenart@kernel.org>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next v4 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <20221208183244.0365f63b@kernel.org>
In-Reply-To: <20221208115517.14951-1-ehakim@nvidia.com>
References: <20221208115517.14951-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Dec 2022 13:55:16 +0200 ehakim@nvidia.com wrote:
> +	dev = get_dev_from_nl(genl_info_net(info), attrs);

What prevents this dev from disappearing before...

> +	if (IS_ERR(dev))
> +		return PTR_ERR(dev);
> +	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
> +		return -EINVAL;
> +
> +	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
> +
> +	rtnl_lock();

... we finally take the lock?

I think you're just moving this code, but still.

> +	ret = macsec_update_offload(dev, offload);
>  
>  	rtnl_unlock();
