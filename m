Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05496BD5A4
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjCPQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjCPQcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:32:05 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC95134323;
        Thu, 16 Mar 2023 09:32:02 -0700 (PDT)
Received: from [192.168.2.51] (p5dd0da05.dip0.t-ipconnect.de [93.208.218.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 2E736C0221;
        Thu, 16 Mar 2023 17:32:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678984320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cGWjnOpHWIVV1/IYEFbJX9ceWb2uuKW/Q/MSwoElVOA=;
        b=SZlvYtkKHarib2iwU34+kGLYqEJE46tTKRi/LVbTkO7bfW5ZysLdngXepNqS7L7PTDH1ik
        XDMWTndQCRQAdgBbHG7iOnCxl7u3RRFXwDPnGtylowV1bDOUE3lTX5Nalx9/6zIgVck75p
        aRmomzFRh7lA5Cx7CRO+Mx2d2m0fXdT3jwI5GSYRSuy0is+00M629Gs1/Fr3scglbZJudu
        5KEgkCN5iqAuH5BdI0+7J3QIydFa2nyeear8giTBhnlwcw/0jC6jhpuDMUh4/cL0EtEDAy
        Oicu2r0MUhqUsQUUGJXTeWeTZvkTM4GEdq6m3l1XB1I04gdTmmDf1diV/nHIqw==
Message-ID: <daee2ba3-effc-67d6-71f7-e99797f93aeb@datenfreihafen.org>
Date:   Thu, 16 Mar 2023 17:31:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH next] ca8210: Fix unsigned mac_len comparison with zero in
 ca8210_skb_tx()
Content-Language: en-US
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     error27@gmail.com, Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Harshit.

On 06.03.23 20:18, Harshit Mogalapalli wrote:
> mac_len is of type unsigned, which can never be less than zero.
> 
> 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
> 	if (mac_len < 0)
> 		return mac_len;
> 
> Change this to type int as ieee802154_hdr_peek_addrs() can return negative
> integers, this is found by static analysis with smatch.
> 
> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> ---
> Only compile tested.
> ---
>   drivers/net/ieee802154/ca8210.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> index 0b0c6c0764fe..d0b5129439ed 100644
> --- a/drivers/net/ieee802154/ca8210.c
> +++ b/drivers/net/ieee802154/ca8210.c
> @@ -1902,10 +1902,9 @@ static int ca8210_skb_tx(
>   	struct ca8210_priv  *priv
>   )
>   {
> -	int status;
>   	struct ieee802154_hdr header = { };
>   	struct secspec secspec;
> -	unsigned int mac_len;
> +	int mac_len, status;
>   
>   	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
>   

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

I took the liberty and changed the fixes tag to the change that 
introduced the resaon for the mismatch recently. As suggested by Simon.

regards
Stefan Schmidt
