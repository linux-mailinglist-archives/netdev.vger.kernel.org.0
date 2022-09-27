Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C6C5EB6B4
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiI0BQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiI0BQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:16:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F4E816AC;
        Mon, 26 Sep 2022 18:16:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3AFB81647;
        Tue, 27 Sep 2022 01:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20401C433D6;
        Tue, 27 Sep 2022 01:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664241369;
        bh=nDFgevNMXOvXr7MUN9ukAYIWyF46we8P6PpsVRH3Xm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lW7RCDQuFnT+NbYWEkigsOyiKRoLMiVsmMz7ojrtfmXe0MpFSPe/liZYyGdRI7cAu
         TrHTsFkwGIM+aiorvVmLusbMov5lz8J2Am2x8JmVlHc45sB/YfhSdEZzo1EpZ9HYmv
         ws7AT7YI9jiXn60iADNaXHoFrZ+oSac9rXMESGgmR2R37a4y98MU9S0JVkiXZhfYBm
         8m6z9p9N/i1zdf+54/8+HlCLl5lvGGA2Oa5DiSxAn/MDYQs8UNA55T+5Y2YxG1JBpA
         LDTD7W5N8F2QDCP4Xij1oqpXPiLDQUtuDYs8pkZ6Hk+TSxj6hUO8GTsUEmSj+1OJ72
         YUP76gC3gWzBQ==
Date:   Mon, 26 Sep 2022 20:16:01 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] s390/qeth: Split memcpy() of struct
 qeth_ipacmd_addr_change flexible array
Message-ID: <YzJO0f7v7N4Z+9Dk@work>
References: <20220927003953.1942442-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927003953.1942442-1-keescook@chromium.org>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 05:39:53PM -0700, Kees Cook wrote:
> To work around a misbehavior of the compiler's ability to see into
> composite flexible array structs (as detailed in the coming memcpy()
> hardening series[1]), split the memcpy() of the header and the payload
> so no false positive run-time overflow warning will be generated.
> 
> [1] https://lore.kernel.org/linux-hardening/20220901065914.1417829-2-keescook@chromium.org/
> 
> Cc: Alexandra Winter <wintera@linux.ibm.com>
> Cc: Wenjia Zhang <wenjia@linux.ibm.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> Cc: Sven Schnelle <svens@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks!
--
Gustavo

> ---
>  drivers/s390/net/qeth_l2_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
> index 2d4436cbcb47..0ce635b7b472 100644
> --- a/drivers/s390/net/qeth_l2_main.c
> +++ b/drivers/s390/net/qeth_l2_main.c
> @@ -1530,8 +1530,8 @@ static void qeth_addr_change_event(struct qeth_card *card,
>  	else
>  		INIT_DELAYED_WORK(&data->dwork, qeth_l2_dev2br_worker);
>  	data->card = card;
> -	memcpy(&data->ac_event, hostevs,
> -			sizeof(struct qeth_ipacmd_addr_change) + extrasize);
> +	data->ac_event = *hostevs;
> +	memcpy(data->ac_event.entry, hostevs->entry, extrasize);
>  	queue_delayed_work(card->event_wq, &data->dwork, 0);
>  }
>  
> -- 
> 2.34.1
> 
