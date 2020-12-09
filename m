Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7C22D37E2
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbgLIAg7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:36:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbgLIAg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:36:59 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40B0C0613CF;
        Tue,  8 Dec 2020 16:36:18 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id x16so483609ejj.7;
        Tue, 08 Dec 2020 16:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mkMFIqftA6fOka00URf8NhOMR4eJXlK1B5kNwAoNQh4=;
        b=EuOPJQJeFYNRtbLszFRpPb7sdtooqzYIpAVUXtaqw+jHTS2+NHM8R84f6d1gEB3y2e
         7/OVlPqVbbJnifASDQ6N/cfq5IGHfkK6PeZ3nGQ9/h+MC3w0P7sX3PsqywykDVk80bP0
         PA+JzIElgGXUpjAYvE5wA2rZoHTRwyZnABXL0WjcN+3N8paLtbE0bhubpLYriWwThMxg
         T4z6BziUr3UByTbWtFm7uiMqUFRfG+1iWNZcRlFs2z7Wtc+TSbohgSEKfPHCyKlIpAFs
         fWfwKMf0bFFkk4P++vhkwgnB0gR9IBFr0VAIJkmjL4lEJqYF+AxnBfrhC3BuA4eK5HrQ
         Wbig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mkMFIqftA6fOka00URf8NhOMR4eJXlK1B5kNwAoNQh4=;
        b=fG7fqTzXypiLCzKQlvJLvldLbGU0iXACuPpZX5mk2TO1qWGhRgGdykzSMKlqSLIqlA
         75tV1BQ8gkqVAjHXG37cSuObWOPh32ztQUaJISwFzSR3E4fp1QRQZRP1NbKRXUYv3dae
         UP73LKhM3UZ0OPRUZS4youKC9qJ8gP2EcUmAx1BjA60TkaP8l+pGgZnDX/MR8gfsTHj9
         K/e9ENulNGx6nCMPHvtZyPb/UMBfIIc2ch4OJNC72wHABMkDOkvXwPtGr2cbcXG1Nk+z
         YjH/bCp/2d9FAd5okjJCGVXxq0OwHs+nZPzMsFhhwgPkn6BzQ1Ah2yRLDdUfE7u3axku
         bZYg==
X-Gm-Message-State: AOAM530T5OXRUUerMubKOs7rc+qxNCljHCBtlJkLrNVvSpGYV+hJWA9B
        G9kq3gj3aePPby/manJG2k/GStdLvU1e7TAJTI0=
X-Google-Smtp-Source: ABdhPJxf5Ixnqs9paYGQBJNuLiyZHP+oImATrwLI0x1RD6F7YlOikrK9B5P/b4ND1Mim0+OfALId61aQlJ3k7JosiNo=
X-Received: by 2002:a17:906:298c:: with SMTP id x12mr268679eje.244.1607474177673;
 Tue, 08 Dec 2020 16:36:17 -0800 (PST)
MIME-Version: 1.0
References: <20201208124523.8169-1-ruc_zhangxiaohui@163.com>
In-Reply-To: <20201208124523.8169-1-ruc_zhangxiaohui@163.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Wed, 9 Dec 2020 11:36:05 +1100
Message-ID: <CAGRGNgWzTnmyYO97MkW+biQBrs-LarknCAsM9q+-UMqcSCN3bQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_config_scan
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaohui,

On Wed, Dec 9, 2020 at 12:07 AM Xiaohui Zhang <ruc_zhangxiaohui@163.com> wrote:
>
> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>
> mwifiex_config_scan() calls memcpy() without checking
> the destination size may trigger a buffer overflower,
> which a local user could use to cause denial of service
> or the execution of arbitrary code.
> Fix it by putting the length check before calling memcpy().
>
> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/scan.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index c2a685f63..b1d90678f 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -930,6 +930,8 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>                                     "DIRECT-", 7))
>                                 wildcard_ssid_tlv->max_ssid_length = 0xfe;
>
> +                       if (ssid_len > 1)
> +                               ssid_len = 1;
>                         memcpy(wildcard_ssid_tlv->ssid,
>                                user_scan_in->ssid_list[i].ssid, ssid_len);

Can ssid_len ever be 0 here?

If it can't, should we just set ssid_len to 1 unconditionally?

If it can, should we just skip the memcpy as it won't do anything?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
