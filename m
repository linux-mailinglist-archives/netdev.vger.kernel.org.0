Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59192D1A2A
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbgLGUBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:01:24 -0500
Received: from smtp.uniroma2.it ([160.80.6.22]:46010 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgLGUBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:01:24 -0500
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 0B7JxWEZ000880;
        Mon, 7 Dec 2020 20:59:37 +0100
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 1476D120078;
        Mon,  7 Dec 2020 20:59:28 +0100 (CET)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1607371168; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8GUTq8erjAR+WpqdwgE8Twu+O0oWWwjcJRgvjKDUeB8=;
        b=ZIP+1mpspntF6b3PVPnTY+UZMZvPgNoKXKzEZjUvD6/e2B/skJnmSgRfVkARPrT2+68bDG
        VtvKjijzQ1rPVXBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1607371168; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8GUTq8erjAR+WpqdwgE8Twu+O0oWWwjcJRgvjKDUeB8=;
        b=aPr8pz1APniZ3QwO8zZTAtRMkVJDWtX/9jsqvwwukNviz248dowf3ZzrdaDeeBr5c+Ihm7
        iuwb4qWU13dc2Z5Q5PTxmBF3n8OvLLHkmhJZ+HV+myLjQX2tsfr889T5PGYU/SbqLs7E2m
        RBoouBgf8DG1rmyyBy+xazOBIZsK35MO0ZYzTW07bEgQF3SZyKf5+fpS0z9XiG8VluiuV9
        bP9Hf0DyVvUJ7ZT0K0UgHOJznj/7yM9CVyZiPAR5XKJZcYyQl18y1/sOotcA/fOmxRjRT0
        IPYoSHh7OebyIk96Vf3G2uqrgQGhfnaRoSPwJcPH97vbrMLfd9LCMGDMWfLycA==
Date:   Mon, 7 Dec 2020 20:59:26 +0100
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: Re: [PATCH][next] seg6: fix unintentional integer overflow on left
 shift
Message-Id: <20201207205926.6222eca38744c43632248a41@uniroma2.it>
In-Reply-To: <20201207144503.169679-1-colin.king@canonical.com>
References: <20201207144503.169679-1-colin.king@canonical.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Dec 2020 14:45:03 +0000
Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Shifting the integer value 1 is evaluated using 32-bit arithmetic
> and then used in an expression that expects a unsigned long value
> leads to a potential integer overflow. Fix this by using the BIT
> macro to perform the shift to avoid the overflow.
> 
> Addresses-Coverity: ("Uninitentional integer overflow")
> Fixes: 964adce526a4 ("seg6: improve management of behavior attributes")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  net/ipv6/seg6_local.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index b07f7c1c82a4..d68de8cd1207 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -1366,7 +1366,7 @@ static void __destroy_attrs(unsigned long parsed_attrs, int max_parsed,
>  	 * attribute; otherwise, we call the destroy() callback.
>  	 */
>  	for (i = 0; i < max_parsed; ++i) {
> -		if (!(parsed_attrs & (1 << i)))
> +		if (!(parsed_attrs & BIT(i)))
>  			continue;
>  
>  		param = &seg6_action_params[i];
> -- 
> 2.29.2
>

Hi Colin,
thanks for the fix. I've just given a look a the whole seg6_local.c code and I
found that such issues is present in other parts of the code.

If we agree, I can make a fix which explicitly eliminates the several (1 << i)
in favor of BIT(i).

Andrea
