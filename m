Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F6562FFDD
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKRWOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKRWOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:14:22 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A746B2C652
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:14:21 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id i2so6094526vsc.1
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 14:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mX32MQtHKDm6wEveVWCqAcHEnlzjCIcm9wWGTqAE0AE=;
        b=s7ajTFAgiciYZu0RBn8/xxmh/Cz8ELyi53DLnmTAmAu6HQSvQ360XtTHb/+adqiDOK
         0Dofie9sTwPA9NyAZjrgn9auKrrATOJMdraVOBklTDBXHcf66BFXYEuGydNSmM8P2ZOQ
         UDoDFJkdECKNi9F+GR80YgzjLX2sufMv4vriNQZ+A8KSfY69uRnR6MuLEPEUNKsBXHkZ
         y1JxsU0G9nzN1I0APSrfOlwy5XU2RmW4XoRk227Y9kEUEtyHnuAK8JcPbp6g6h02NgFe
         VT/APOOI9gRYa2pDXSV+JQvd9mMGN9NLowi5///G7LSHjH86dJJR3Q/WybVAL4cz7BMF
         kbBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mX32MQtHKDm6wEveVWCqAcHEnlzjCIcm9wWGTqAE0AE=;
        b=qZu2CUtq888slH1aPh3XRx9WIZuHngG3yCYFbfOQmEV91CbPZMGra4nIAOHvCB1bjS
         lj5de3pBblMCqCH5iWfJAfz5aEQ/XZIQEJs06svSci1kF9VqiMLl9RgkKbeTDWspKbNE
         Kiu/PcSp2dl6Fe7BPZ8IOhkQAG2pkS84Rn2ogaXq52afV5qKO0gFqYoyvuyXN2YKUGp7
         PHIOBQ3QMV1vSweWMf1oijYJlrxQS+2nxqU3sQ8JDJZu1/AbVCq9Rlk7eBODstS3wH9x
         BPtObG8oHASth+gsauAsSGeOEM7slxxAywKFRvlu8PahzFo1VkAEM3Fw404exSNVguPa
         kEPA==
X-Gm-Message-State: ANoB5pkbAnV/9ydPeVdpfSAW8GMK4ur0A2eOdq6a2FrWIUUR8tYn12mT
        Tm1xI2du6zWPgS/1APqnHW1r4cXJSr1fV1gx6IegxQ==
X-Google-Smtp-Source: AA0mqf6ZG9wnFEYX0sGQvr0QGPDLOuY+hvNYGVsHNAmDX6vtUvHIqpDzsh23QhTSdEkUJFJY7wfh4NhGELRuSZlS+Vw=
X-Received: by 2002:a05:6102:502:b0:3ad:94ed:2ab5 with SMTP id
 l2-20020a056102050200b003ad94ed2ab5mr5536440vsa.45.1668809660698; Fri, 18 Nov
 2022 14:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20221118220423.4038455-1-mfaltesek@google.com> <20221118220423.4038455-3-mfaltesek@google.com>
In-Reply-To: <20221118220423.4038455-3-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Fri, 18 Nov 2022 14:14:08 -0800
Message-ID: <CABXOdTc+wmpAyqb-+OBtBtTTQYP7Fm8bixY9OSCzNPRT2m9POg@mail.gmail.com>
Subject: Re: [PATCH net 2/3] nfc: st-nci: fix memory leaks in EVT_TRANSACTION
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        jordy@pwning.systems, krzk@kernel.org, sameo@linux.intel.com,
        theflamefire89@gmail.com, duoming@zju.edu.cn,
        Denis Efremov <denis.e.efremov@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 2:04 PM Martin Faltesek <mfaltesek@google.com> wrote:
>
> Error path does not free previously allocated memory. Add devm_kfree() to
> the failure path.
>
> Reported-by: Denis Efremov <denis.e.efremov@oracle.com>
> Fixes: 5d1ceb7f5e56 ("NFC: st21nfcb: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Reviewed-by: Guenter Roeck <groeck@google.com>

> ---
>  drivers/nfc/st-nci/se.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
> index 589e1dec78e7..fc59916ae5ae 100644
> --- a/drivers/nfc/st-nci/se.c
> +++ b/drivers/nfc/st-nci/se.c
> @@ -339,8 +339,10 @@ static int st_nci_hci_connectivity_event_received(struct nci_dev *ndev,
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
>                 memcpy(transaction->params, skb->data +
> --
> 2.38.1.584.g0f3c55d4c2-goog
>
