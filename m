Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AC03D7C37
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhG0Re4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhG0Rez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 13:34:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C78F560F91;
        Tue, 27 Jul 2021 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627407295;
        bh=34oomPwLOz6ismCivb7ARRh2IKeTTmQhVQ99PJXlZyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=omLK9UCk0r6WhAmknYqMqjGVpeqAe/COeYl86h3qXpNGO/zb2qn3a0kHYnaikFgLJ
         JMXpPRYpN8NLOr5nx2MWRiN0jsgGvngSM+uYBX5BvCtTbw6W1mr3d2mCdWhqG1Tmid
         NNGwKIZuJ8+vwI5lEffvc9fFQkBl1euyyFtglRJPkDVkflD6hrpkzq7yFacPoPLoly
         HANnUAlTzlIFesxIyG2KVg9LI4MfJYdWAFZqVqeEThEvcvYTf/+y6svwzkUBDbZPl8
         ipJGY8ja2r1wc/5HJaWtzJjDd3xwEITqm/mzV2M6IeznY/wdHoV2Zx444DaIdatpRS
         Zc2hI7asNZatQ==
Date:   Tue, 27 Jul 2021 10:34:52 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     k.opasiak@samsung.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: Re: [PATCH] nfc: s3fwrn5: fix undefined parameter values in dev_err()
Message-ID: <YQBDvOG51Tl0ts+g@Ryzen-9-3900X.localdomain>
References: <20210727122506.6900-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727122506.6900-1-tangbin@cmss.chinamobile.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 08:25:06PM +0800, Tang Bin wrote:
> In the function s3fwrn5_fw_download(), the 'ret' is not assigned,
> so the correct value should be given in dev_err function.
> 
> Fixes: a0302ff5906a ("nfc: s3fwrn5: remove unnecessary label")
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>

This clears up a clang warning that I see:

drivers/nfc/s3fwrn5/firmware.c:425:41: error: variable 'ret' is uninitialized when used here [-Werror,-Wuninitialized]
                        "Cannot allocate shash (code=%d)\n", ret);
                                                             ^~~
./include/linux/dev_printk.h:144:65: note: expanded from macro 'dev_err'
        dev_printk_index_wrap(_dev_err, KERN_ERR, dev, dev_fmt(fmt), ##__VA_ARGS__)
                                                                       ^~~~~~~~~~~
./include/linux/dev_printk.h:110:23: note: expanded from macro 'dev_printk_index_wrap'
                _p_func(dev, fmt, ##__VA_ARGS__);                       \
                                    ^~~~~~~~~~~
drivers/nfc/s3fwrn5/firmware.c:416:9: note: initialize the variable 'ret' to silence this warning
        int ret;
               ^
                = 0
1 error generated.

One comment below but regardless:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/nfc/s3fwrn5/firmware.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/s3fwrn5/firmware.c b/drivers/nfc/s3fwrn5/firmware.c
> index 1421ffd46d9a..52c6f76adfb2 100644
> --- a/drivers/nfc/s3fwrn5/firmware.c
> +++ b/drivers/nfc/s3fwrn5/firmware.c
> @@ -422,7 +422,7 @@ int s3fwrn5_fw_download(struct s3fwrn5_fw_info *fw_info)
>  	tfm = crypto_alloc_shash("sha1", 0, 0);
>  	if (IS_ERR(tfm)) {
>  		dev_err(&fw_info->ndev->nfc_dev->dev,
> -			"Cannot allocate shash (code=%d)\n", ret);
> +			"Cannot allocate shash (code=%d)\n", PTR_ERR(tfm));

We know this is going to be an error pointer so this could be changed to

"Cannot allocate shash (code=%pe)\n", tfm);

to make it a little cleaner to understand. See commit 57f5677e535b
("printf: add support for printing symbolic error names").

>  		return PTR_ERR(tfm);
>  	}
>  
> -- 
> 2.18.2

Cheers,
Nathan
