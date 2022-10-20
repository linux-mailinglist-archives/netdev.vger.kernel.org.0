Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A05C605662
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 06:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiJTEh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 00:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiJTEh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 00:37:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0CD163399
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 21:37:56 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1olNJW-00028k-5H; Thu, 20 Oct 2022 06:37:50 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1olNJS-0005wz-7H; Thu, 20 Oct 2022 06:37:46 +0200
Date:   Thu, 20 Oct 2022 06:37:46 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com,
        andrew@lunn.ch, linux@rempel-privat.de, bagasdotme@gmail.com,
        lkp@intel.com
Subject: Re: [PATCH net] ethtool: pse-pd: fix null-deref on genl_info in dump
Message-ID: <20221020043746.GB28729@pengutronix.de>
References: <20221019223551.1171204-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221019223551.1171204-1-kuba@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 03:35:51PM -0700, Jakub Kicinski wrote:
> ethnl_default_dump_one() passes NULL as info.
> 
> It's correct not to set extack during dump, as we should just
> silently skip interfaces which can't provide the information.
> 
> Reported-by: syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com
> Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: andrew@lunn.ch
> CC: linux@rempel-privat.de
> CC: bagasdotme@gmail.com
> CC: lkp@intel.com

Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>

Thank you!

> ---
>  net/ethtool/pse-pd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/pse-pd.c b/net/ethtool/pse-pd.c
> index 5a471e115b66..e8683e485dc9 100644
> --- a/net/ethtool/pse-pd.c
> +++ b/net/ethtool/pse-pd.c
> @@ -64,7 +64,7 @@ static int pse_prepare_data(const struct ethnl_req_info *req_base,
>  	if (ret < 0)
>  		return ret;
>  
> -	ret = pse_get_pse_attributes(dev, info->extack, data);
> +	ret = pse_get_pse_attributes(dev, info ? info->extack : NULL, data);
>  
>  	ethnl_ops_complete(dev);
>  
> -- 
> 2.37.3
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
