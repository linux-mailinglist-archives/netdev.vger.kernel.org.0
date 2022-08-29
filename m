Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4DA5A458C
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiH2Izj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiH2Izi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:55:38 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280C02A42B;
        Mon, 29 Aug 2022 01:55:34 -0700 (PDT)
Received: from [IPV6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98] (p200300e9d7011d41444abdf5adf89c98.dip0.t-ipconnect.de [IPv6:2003:e9:d701:1d41:444a:bdf5:adf8:9c98])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 04503C04DF;
        Mon, 29 Aug 2022 10:55:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661763332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IR5r053jYKiiUav7LjqLc9Puhvx5djJKdCrkqggGylI=;
        b=RtH45SbWKB8TanE9NUt36SCO0wdLhcmjbcKeLGOdUrDWxlDzTHDJpUXUEVcJoCyrLHAmzZ
        ovqCFArVxuNp8JRU7AGDWitF+psagUlzlOh5v1WOA/w6gVIAaeRA7bK4B0P6Nosfr2y2kH
        1oCuJs9B8au6wSC3w2zXBFAC+UQEsnTqFqIlqv9kRSGV1oQAeywUsyUD0Q4TJczAT2bUUu
        Xo+txNn2ivE1eaB4htd6KrvEIuloMtO3IxbozSj1dzxFIE1naJaUlECI4sJIk9zVAox4tz
        sZw5MoplQ4ObeFpFn/AvV7m8EuCUGsSk0T6HcqW5pS/R7s5d5Cqus0nypfBwXA==
Message-ID: <8752aa54-28a3-9ae3-45ca-947551f31773@datenfreihafen.org>
Date:   Mon, 29 Aug 2022 10:55:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] ieee802154: cc2520: add rc code in cc2520_tx()
Content-Language: en-US
To:     Li Qiong <liqiong@nfschina.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
References: <20220829071259.18330-1-liqiong@nfschina.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220829071259.18330-1-liqiong@nfschina.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello Qiong.

On 29.08.22 09:12, Li Qiong wrote:
> The rc code is 0 at the error path "status & CC2520_STATUS_TX_UNDERFLOW".
> Assign rc code with '-EINVAL' at this error path to fix it.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>   drivers/net/ieee802154/cc2520.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ieee802154/cc2520.c b/drivers/net/ieee802154/cc2520.c
> index 1e1f40f628a0..c69b87d3837d 100644
> --- a/drivers/net/ieee802154/cc2520.c
> +++ b/drivers/net/ieee802154/cc2520.c
> @@ -504,6 +504,7 @@ cc2520_tx(struct ieee802154_hw *hw, struct sk_buff *skb)
>   		goto err_tx;
>   
>   	if (status & CC2520_STATUS_TX_UNDERFLOW) {
> +		rc = -EINVAL;
>   		dev_err(&priv->spi->dev, "cc2520 tx underflow exception\n");
>   		goto err_tx;
>   	}

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
