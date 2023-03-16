Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809B56BC533
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 05:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCPEYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 00:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCPEYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 00:24:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7092885F;
        Wed, 15 Mar 2023 21:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48F69B81FAC;
        Thu, 16 Mar 2023 04:24:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837AAC433D2;
        Thu, 16 Mar 2023 04:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678940666;
        bh=SWftvtwBMsqpnfifYayDxLhuAFeXbIUC+wC8JVy38CY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qs+lc8s1KTjOTNMQTCSq/sy8Con6uLlgGhbA40D9ik0Cw/h8eXu7VnL/4C85FrmYk
         peLXqsZmQwGzqFov6Ujj+MZtiO5vNlam6Y2SOJKSWKpG+rJ+3DKZTZfV9uU1n7u0FV
         IkX3SBO6vHpmRmJFoxGiHS1pdsaYJI9gW+5G89apgsDGkiT66HNtPOtuSHAZoWbyhf
         diYGG+AXkhT7buSRJaFnriIQZbbf84zKl3CAWdZP7v09OReze50d0O6Uw0UMSlU/Za
         9Ko4A+EU/JmcVuU2QUP4g46RQnYBOKycoQhHaWKANtsbiC4DjvrvsWrMVHumKSmzNA
         hJZOR+xVIVHOA==
Date:   Wed, 15 Mar 2023 21:24:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: usb: smsc95xx: Limit packet length to skb->len
Message-ID: <20230315212425.12cb48ca@kernel.org>
In-Reply-To: <20230313220124.52437-1-szymon.heidrich@gmail.com>
References: <20230313220124.52437-1-szymon.heidrich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Mar 2023 23:01:24 +0100 Szymon Heidrich wrote:
> Packet length retrieved from skb data may be larger than

nit: s/skb data/descriptor/ may be better in terms of terminology

> the actual socket buffer length (up to 1526 bytes). In such

nit: the "up to 1526 bytes" is a bit confusing, I'd remove it.

> case the cloned skb passed up the network stack will leak
> kernel memory contents.



> Fixes: 2f7ca802bdae ("net: Add SMSC LAN9500 USB2.0 10/100 ethernet adapter driver")
> Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
> ---
>  drivers/net/usb/smsc95xx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 32d2c60d3..ba766bdb2 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1851,7 +1851,8 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
>  			}
>  		} else {
>  			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
> -			if (unlikely(size > (ETH_FRAME_LEN + 12))) {
> +			if (unlikely(size > (ETH_FRAME_LEN + 12) ||
> +				     size > skb->len)) {

We need this check on both sides of the big if {} statement.

In case the error bit is set and we drop the packet we still
end up in skb_pull() which if size > skb->len will panic the
kernel.

So let's do this check right after size and align are calculated?
The patch for smsc75xx has sadly already been applied so you'll
need to prepare a fix to the fix :(

>  				netif_dbg(dev, rx_err, dev->net,
>  					  "size err header=0x%08x\n", header);
>  				return 0;

