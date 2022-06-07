Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89DA54021E
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 17:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343862AbiFGPHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 11:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245029AbiFGPHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 11:07:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE20222A5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 08:07:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id c2so23387685edf.5
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 08:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cpUdsTyIPCcMmtdjwCdXyawVI7nFPjuJb4HUJd00R90=;
        b=l5yXTtzZLXSTRMMhr4YColzIJmloWxVOQoMJor/ILy6VLlRjjmwZH/5SFZRyphcRwy
         tgUumm/DNu8RNsHyRfr/bv5oHhFH91CiJc75S658XbzU5oM8YVEOv0pOX5Nenvy5UMbV
         MBQqTPcioCiIfoJF1q1byDIi1OcxsYPsiHxA4WUidvFUcGSmYmB6XKi+A1/4/Wvo06TV
         RQLQ6HJxnVXa7KuflJ7yFBd4wsjjd2gyKTRMOt77/Yj/Ql/OfJGPeOBvvP1pOJ/ZJMyv
         LQsiUGwuFKuv8Px8fqCMnWQc2RlK4rzEJPnCmP19g8G+0np8fTVAIeug8MJXcEDXgDyu
         JFsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cpUdsTyIPCcMmtdjwCdXyawVI7nFPjuJb4HUJd00R90=;
        b=GazcBmPofeg1XY5K45YDDh8s2WrexnwhizrSoWb4CFHAgYYfCwyVVsQEyUAIAp1UaI
         jiC4bAFVcpQJZVQ6cp0a6LDdlm5SBLAMNYfQH/bmqAsvghPsvkw8b6SEKd+kWfu0vZMK
         iaXHtOHOH0NsjKoxaImGbSpWWjVufyhgWaDrK+P6jKXvJMfcpAPw+VFIpHhOSGljx6pM
         Z3tOLasnRJOIHDodeIxKBK5NW0rRuPNYhXtzbY/mCFHl/y445IYa29DQzGqqV989CZrs
         lX3RBTepcK6OGBr/Wdy7uhE7JwBnik4HJdmJEQQCqgOv4EshLDNOADD05NKPjo7OjvU7
         SXZA==
X-Gm-Message-State: AOAM530m40EoeuERAIZIOxD67j7adqcPcXuMlN8GVSE6YXyni6tSH5Mh
        HtF4/BPEfidHCZ/WZ0PpfPoEiNREIlW+6bfuA0+82g==
X-Google-Smtp-Source: ABdhPJxK4e5qri1Qu3qcOGoU0voiFb9Gq/rj0DQWa41EFSbqP7LWC8CXK+LKurUHjlnZ0g7HeZirr6b6EYtmkD0xUls=
X-Received: by 2002:a05:6402:2405:b0:431:6ef1:e2a with SMTP id
 t5-20020a056402240500b004316ef10e2amr9999796eda.26.1654614468216; Tue, 07 Jun
 2022 08:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com> <20220607025729.1673212-3-mfaltesek@google.com>
In-Reply-To: <20220607025729.1673212-3-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 7 Jun 2022 08:07:36 -0700
Message-ID: <CABXOdTc7jM005yyFZJcXWXj5pg+i4AsW+Hs54ZDurqMzAdpdYQ@mail.gmail.com>
Subject: Re: [PATCH net v3 2/3] nfc: st21nfca: fix memory leaks in
 EVT_TRANSACTION handling
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, krzysztof.kozlowski@linaro.org,
        christophe.ricard@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jordy@pwning.systems, Krzysztof Kozlowski <krzk@kernel.org>,
        martin.faltesek@gmail.com, netdev <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org, sameo@linux.intel.com,
        William K Lin <wklin@google.com>, theflamefire89@gmail.com,
        "# v4 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 7:57 PM Martin Faltesek <mfaltesek@google.com> wrote:
>
> Error paths do not free previously allocated memory. Add devm_kfree() to
> those failure paths.
>
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>  drivers/nfc/st21nfca/se.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> index 9645777f2544..8e1113ce139b 100644
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -326,22 +326,29 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>                 transaction->aid_len = skb->data[1];
>
>                 /* Checking if the length of the AID is valid */
> -               if (transaction->aid_len > sizeof(transaction->aid))
> +               if (transaction->aid_len > sizeof(transaction->aid)) {
> +                       devm_kfree(dev, transaction);
>                         return -EINVAL;
> +               }
>
>                 memcpy(transaction->aid, &skb->data[2],
>                        transaction->aid_len);
>
>                 /* Check next byte is PARAMETERS tag (82) */
>                 if (skb->data[transaction->aid_len + 2] !=
> -                   NFC_EVT_TRANSACTION_PARAMS_TAG)
> +                   NFC_EVT_TRANSACTION_PARAMS_TAG) {
> +                       devm_kfree(dev, transaction);
>                         return -EPROTO;
> +               }
>
>                 transaction->params_len = skb->data[transaction->aid_len + 3];
>
>                 /* Total size is allocated (skb->len - 2) minus fixed array members */
> -               if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
> +               if (transaction->params_len > ((skb->len - 2) -
> +                   sizeof(struct nfc_evt_transaction))) {
> +                       devm_kfree(dev, transaction);
>                         return -EINVAL;
> +               }
>
>                 memcpy(transaction->params, skb->data +
>                        transaction->aid_len + 4, transaction->params_len);
> --
> 2.36.1.255.ge46751e96f-goog
>
