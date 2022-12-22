Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D9C6544BD
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 17:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiLVQB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 11:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbiLVQBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 11:01:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890D1102A;
        Thu, 22 Dec 2022 08:01:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27AA961C36;
        Thu, 22 Dec 2022 16:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDDCC433D2;
        Thu, 22 Dec 2022 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671724883;
        bh=K2JjOPdLe6p7TeCT7N6YrUkgLNDqAeGFUTw14h5uQK8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mqfEIXW6a7u+sj73dJ+oSBV1AUqaUIdHLjrV6jTf1hQECOWSbol3Grgp/SRqPm3Y/
         K42/eYnHCGQXG5KEolf8GVyZOUZSDEudP1AcF4FtVdN3+pDDtEFR51e/j65ANg5xZC
         j6713OtEF6kB8JlCnmr1chvXMV6EXNcBnurhfw2fmpcQxjm+tK0jfUJJ2XQQi+RQof
         IgGBGM6GnobAnpKq3xDccbB0gwMaDv/4HwOHioQe58c8eLNga9mMEmVvSEt6fFrDYN
         KwGFkfKy3bI7Ke2+UlhRg7PeUdnoft/EuiB6HtEzmVRERA9xNIMnpWs8zKzGUZdEvJ
         ivgIGmO7E5BDw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        alsi@bang-olufsen.dk, rmk+kernel@armlinux.org.uk,
        linus.walleij@linaro.org, marcan@marcan.st,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: brcmfmac: fix potential resource leak in brcmf_usb_probe_phase2()
References: <20221120103807.7588-1-niejianglei2021@163.com>
Date:   Thu, 22 Dec 2022 18:01:17 +0200
In-Reply-To: <20221120103807.7588-1-niejianglei2021@163.com> (Jianglei Nie's
        message of "Sun, 20 Nov 2022 18:38:07 +0800")
Message-ID: <874jtnjulu.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianglei Nie <niejianglei2021@163.com> writes:

> brcmf_usb_probe_phase2() allocates resource for dev with brcmf_alloc().
> The related resource should be released when the function gets some error.
> But when brcmf_attach() fails, relevant resource is not released, which
> will lead to resource leak.
>
> Fix it by calling brcmf_free() when brcmf_attach() fails.
>
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> index 85e18fb9c497..5d8c12b2c4d7 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
> @@ -1215,6 +1215,7 @@ static void brcmf_usb_probe_phase2(struct device *dev, int ret,
>  	return;
>  error:
>  	brcmf_dbg(TRACE, "failed: dev=%s, err=%d\n", dev_name(dev), ret);
> +	brcmf_free(devinfo->dev);
>  	complete(&devinfo->dev_init_done);
>  	device_release_driver(dev);
>  }

This doesn't look right. Now we would call brfmf_free() even before
brcmf_alloc() is called.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
