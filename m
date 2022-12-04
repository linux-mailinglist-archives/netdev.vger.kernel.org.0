Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20CC641CC2
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 12:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiLDLsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 06:48:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLDLsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 06:48:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE51DE91;
        Sun,  4 Dec 2022 03:48:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C00B80921;
        Sun,  4 Dec 2022 11:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98782C433C1;
        Sun,  4 Dec 2022 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670154497;
        bh=xXdpfa9NBAzhsXeP373CriSbG2R7fBgHZOhdJePlMak=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n2nJwwblzUoZSrfMPK6nxZNFkQrJsygezztuTSAUMonwzsnk8WyPaW8dUOcY5Hwxx
         Hmwk6C4v14U1RrFGX+rNOdxcY8Zsu8pWbdGZIWxHVVLr9Wq6bNhLrF4trMboRIcjWY
         fnZXqFKPy1aGQY1aERZOKTjz4/QP/17OPIWwSgyTJNfefZauzKfKB6Q4OmVn9Nd7LW
         qrOUk9a6ai5XGA5Mby3ugZ3hpyMbaNRY9HIgn0IwldYib+rdnDKqhNDb2i6XCQaYXc
         T44lEHZgIyk4+FZCFKmsjhDtNXD+fUt+AjHERhmGk2MorbR3Snq7Q8FsJ65qRPwWJh
         1cBzvmZp+b0Xg==
Date:   Sun, 4 Dec 2022 13:48:07 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: Re: [PATCH 2/2] net: asix: Avoid looping when the device is
 diconnected
Message-ID: <Y4yI95L+LYhp5ESL@unreal>
References: <20221201175525.2733125-1-l.stach@pengutronix.de>
 <20221201175525.2733125-2-l.stach@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201175525.2733125-2-l.stach@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 06:55:25PM +0100, Lucas Stach wrote:
> We've seen device access fail with -EPROTO when the device has been
> recently disconnected and before the USB core had a chance to handle
> the disconnect hub event. It doesn't make sense to continue on trying
> to enable host access when the adapter is gone.
> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---
>  drivers/net/usb/asix_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index be1e103b7a95..28b31e4da020 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -96,7 +96,7 @@ static int asix_check_host_enable(struct usbnet *dev, int in_pm)
>  
>  	for (i = 0; i < AX_HOST_EN_RETRIES; ++i) {
>  		ret = asix_set_sw_mii(dev, in_pm);
> -		if (ret == -ENODEV || ret == -ETIMEDOUT)
> +		if (ret == -ENODEV || ret == -ETIMEDOUT || ret == -EPROTO)

It looks like you can put if (ret < 0) here,

>  			break;
>  		usleep_range(1000, 1100);
>  		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
> -- 
> 2.30.2
> 
