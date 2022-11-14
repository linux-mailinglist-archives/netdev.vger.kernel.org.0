Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0780B627577
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 06:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbiKNFOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 00:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiKNFOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 00:14:51 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C2415FEB;
        Sun, 13 Nov 2022 21:14:48 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id z26so10026868pff.1;
        Sun, 13 Nov 2022 21:14:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0v0laWrBsQpIC77havxoVIJOK4/6x29MDLsM2aZBDvw=;
        b=0SmGWlpTZVWNl5K3j32dJusKyOvo+4SPDrkT6/WvrAPkJ1pr0wRs5bZ1kYxie6l/0h
         wJAq7OD4VVy7rHejkd46umvSAGzat3z4Jdp2MnZ4CTmYjzcrjhb4C98nst1RIc2xfqkP
         QShh8WgoVOxcpdz2wplQi/wpkEorpS5ouBAe/TKpEu0bF9kGZ2OVK4PXWLBAgPHS/CpG
         Wgg1nX0WiXukxf5ANgGiUH3B13vKgIRXZTsntavafTRLHBzkEopW8wnL5j3hRWdXs/be
         UIDQcmmZDqVYKzpJLLs/RXOQ44MgpTypItwWyR7emNyA5xKHv2hbYHu6waG3J5gDeSZF
         yMqg==
X-Gm-Message-State: ANoB5pmZ+XB+46DXD1YyUWc36WzRW0Tc+aEurZ72Lwgv/0MVTMBjXVtl
        QyqNcH7vlDPIYS9adWrPC4BJlIvjd0snreIsiig=
X-Google-Smtp-Source: AA0mqf7FQ2jPez4Z+q5QCZHlD15+hW94EsQ5njMmML7hpjCTDfQ8q8HFUvYZFAm85LQqYgXWRmFQwUyaW1uTUS2rIdI=
X-Received: by 2002:a63:4e53:0:b0:473:f7fb:d2c7 with SMTP id
 o19-20020a634e53000000b00473f7fbd2c7mr10516376pgl.535.1668402888118; Sun, 13
 Nov 2022 21:14:48 -0800 (PST)
MIME-Version: 1.0
References: <1668396306-47940-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1668396306-47940-1-git-send-email-zhangchangzhong@huawei.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 14 Nov 2022 14:14:36 +0900
Message-ID: <CAMZ6RqJNXr9S83o_YgofXsTh7pqtP9iGy_kTrgL69F=_BNqu2A@mail.gmail.com>
Subject: Re: [PATCH] can: etas_es58x: free netdev when register_candev()
 failed in es58x_init_netdev()
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhang,

Thank you for the patch.

On Mon. 14 nov. 2022 at 12:13, Zhang Changzhong
<zhangchangzhong@huawei.com> wrote:
> In case of register_candev() fails, clear es58x_dev->netdev[channel_idx]
> and add free_candev(). Otherwise es58x_free_netdevs() will unregister
> the netdev that has never been registered.
>
> Fixes: 1dfb6005a60b ("can: etas_es58x: add support for ETAS ES581.4 CAN USB interface")

Nitpick, the correct fix tag is:
Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X
CAN USB interfaces")

Aside of that,
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
> index 25f863b..ddb7c57 100644
> --- a/drivers/net/can/usb/etas_es58x/es58x_core.c
> +++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
> @@ -2091,8 +2091,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
>         netdev->dev_port = channel_idx;
>
>         ret = register_candev(netdev);
> -       if (ret)
> +       if (ret) {
> +               es58x_dev->netdev[channel_idx] = NULL;
> +               free_candev(netdev);
>                 return ret;
> +       }
>
>         netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
>                                        es58x_dev->param->dql_min_limit);
> --
> 2.9.5
>
