Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF00535A952
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 01:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235210AbhDIXq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 19:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235163AbhDIXq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 19:46:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4E6D610CC;
        Fri,  9 Apr 2021 23:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618012003;
        bh=XCIJfysJJf3a2VP7wbLTB+veGqZtLou6gE/nlIYkC04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xxvi0KuuMeQfzbT6Bwj+eTZGgc4fvm9FMOyUlj1NEdZsj70bUOdmO9rx8cKvuFttD
         y6Y5plGkPZd/F0cqEfUNiOm/R3E0/wMdtrmlZ4ew0oVccgn8Gh1qj1tgTT2YiWO9lJ
         wVjDIRJg/4wMpluN+CzE7ktNoDwEDiK9Mpo6ULD51cM6MdEdlByuuOPcdiz+cDph02
         ZTtN/Dmvd7Cwnku85nMaWGvEHFtsr6XtbubW4qZWlZlsTTgBepCRZIXmRoAxICGL4d
         sLmCA/nArtdmTVZmZP3dRM+hkMQ5WDpJPVg9jL/GQDMwUen4JmPmRHqrQ0rZ+WoqYv
         +yLvpi+wEYCPA==
Date:   Fri, 9 Apr 2021 16:46:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     samirweng1979 <samirweng1979@163.com>
Cc:     gustavoars@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] nfc: pn533: remove redundant assignment
Message-ID: <20210409164641.3334d216@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409115010.33436-1-samirweng1979@163.com>
References: <20210409115010.33436-1-samirweng1979@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Apr 2021 19:50:09 +0800 samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In many places,first assign a value to a variable and then return
> the variable. which is redundant, we should directly return the value.
> in pn533_rf_field funciton,return statement in the if statement is
> redundant, we just delete it.
> 
> Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>

Thank you for the changes, please see comments below.

> diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
> index f1469ac..61ab4c0 100644
> --- a/drivers/nfc/pn533/pn533.c
> +++ b/drivers/nfc/pn533/pn533.c
> @@ -489,12 +489,8 @@ static int pn533_send_data_async(struct pn533 *dev, u8 cmd_code,
>  				 pn533_send_async_complete_t complete_cb,
>  				 void *complete_cb_context)
>  {
> -	int rc;
> -
> -	rc = __pn533_send_async(dev, cmd_code, req, complete_cb,
> +	return __pn533_send_async(dev, cmd_code, req, complete_cb,
>  				complete_cb_context);

Please realign the continuation line so it starts after the opening
bracket.

> -
> -	return rc;
>  }
>  
>  static int pn533_send_cmd_async(struct pn533 *dev, u8 cmd_code,
> @@ -502,12 +498,8 @@ static int pn533_send_cmd_async(struct pn533 *dev, u8 cmd_code,
>  				pn533_send_async_complete_t complete_cb,
>  				void *complete_cb_context)
>  {
> -	int rc;
> -
> -	rc = __pn533_send_async(dev, cmd_code, req, complete_cb,
> +	return __pn533_send_async(dev, cmd_code, req, complete_cb,
>  				complete_cb_context);

Same here.

> -	return rc;
>  }
>  
>  /*
> @@ -2614,7 +2606,6 @@ static int pn533_rf_field(struct nfc_dev *nfc_dev, u8 rf)
>  				     (u8 *)&rf_field, 1);
>  	if (rc) {
>  		nfc_err(dev->dev, "Error on setting RF field\n");
> -		return rc;
>  	}
>  
>  	return rc;

In case some code is added between the check and the return statement
it'd be better to fix this by replacing the second return rc with
return 0:

	if (rc) {
		nfc_err(...);
		return rc;
	}

	return 0;

> diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
> index a0665d8..6465348 100644
> --- a/drivers/nfc/pn533/uart.c
> +++ b/drivers/nfc/pn533/uart.c
> @@ -239,9 +239,8 @@ static int pn532_uart_probe(struct serdev_device *serdev)
>  {
>  	struct pn532_uart_phy *pn532;
>  	struct pn533 *priv;
> -	int err;
> +	int err = -ENOMEM;
>  
> -	err = -ENOMEM;
>  	pn532 = kzalloc(sizeof(*pn532), GFP_KERNEL);

IMO having the assignment before the call is more readable, please
leave as is.

>  	if (!pn532)
>  		goto err_exit;
