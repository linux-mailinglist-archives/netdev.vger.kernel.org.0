Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAE7912F
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbfG2QjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:39:10 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41573 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbfG2QjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:39:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id x15so18186727pgg.8
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 09:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gIsL3P1o9qKhMBAvJdEIWDk2AVET8Aaaur2YuooL1Qs=;
        b=kHZXfnWXPRBSXQwfFlnLyr4mL2tIpg0byl+z2del5hIiEdVMNTH30dqcAO2sfRae+U
         APCeNAcOqjSnO5WK4swM8h/NL2IISqCBDB9j6aW9A3qrm5w5slJQCHaTgcbr3wqtFa0u
         C2IZ6pehlH6ONkxeUhdaNhGjEQy8+HZe9nvEQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gIsL3P1o9qKhMBAvJdEIWDk2AVET8Aaaur2YuooL1Qs=;
        b=iD2x0WQn/V1qC9nXumpo8eLUhy+i3tbz6ErGYl9ParJ7QmWWyJgF/CsiEfiAEfEoSE
         u7IpYVMmp2wroLhVc+e7TtO7e2mk9J8+CbqTlud/LQ3Th8byCEVZTmk8TQJue+xTwHIm
         AU8rPuhqXjE1ARawp5jsSFH2vKO9LfG2W1eW2eRCH0sMpjh2xrJ5y2KINRmEYxTqvmfz
         9KYhWTgHcApmGHmeljfhSW0f2iiDYwiwz0u+rBHqC8HgW4CMc6nq2WavxAfX6SVb/YAU
         XeAnjaCKqNMv/6nNYCvfNybPjuUAKs4CiOcQJTjRqN6zRyzHjEidJw35mQpPXzWD3tAy
         8IEw==
X-Gm-Message-State: APjAAAVcR092X1YViuZ5rcCwfGrq2X3eSJG8WPJpfVFJR9chAkuAs/m8
        mEF+s6yPBbJAwhtF23G7Z04fUg==
X-Google-Smtp-Source: APXvYqyBXqIpqVs0AKK9Spc8yO6L9TQO4zPdJZIh0268QH5XpLDfDnRlFx1iRpISBjHGplyemJ9ouA==
X-Received: by 2002:a65:5348:: with SMTP id w8mr104166567pgr.176.1564418343942;
        Mon, 29 Jul 2019 09:39:03 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v13sm72076160pfn.109.2019.07.29.09.39.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Jul 2019 09:39:03 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:39:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] net: spider_net: Mark expected switch fall-through
Message-ID: <201907290939.794DB730@keescook>
References: <20190729003251.GA25556@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729003251.GA25556@embeddedor>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 28, 2019 at 07:32:51PM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warning:
> 
> drivers/net/ethernet/toshiba/spider_net.c: In function 'spider_net_release_tx_chain':
> drivers/net/ethernet/toshiba/spider_net.c:783:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     if (!brutal) {
>        ^
> drivers/net/ethernet/toshiba/spider_net.c:792:3: note: here
>    case SPIDER_NET_DESCR_RESPONSE_ERROR:
>    ^~~~
> 
> Notice that, in this particular case, the code comment is
> modified in accordance with what GCC is expecting to find.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/net/ethernet/toshiba/spider_net.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
> index 5b196ebfed49..0f346761a2b2 100644
> --- a/drivers/net/ethernet/toshiba/spider_net.c
> +++ b/drivers/net/ethernet/toshiba/spider_net.c
> @@ -788,6 +788,7 @@ spider_net_release_tx_chain(struct spider_net_card *card, int brutal)
>  			/* fallthrough, if we release the descriptors
>  			 * brutally (then we don't care about
>  			 * SPIDER_NET_DESCR_CARDOWNED) */
> +			/* Fall through */
>  
>  		case SPIDER_NET_DESCR_RESPONSE_ERROR:
>  		case SPIDER_NET_DESCR_PROTECTION_ERROR:
> -- 
> 2.22.0
> 

-- 
Kees Cook
