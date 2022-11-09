Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC9A62302F
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 17:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiKIQcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 11:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKIQcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 11:32:04 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F66519C0A
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 08:32:04 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id z192so21685492yba.0
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 08:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XnpKVb9e668NZTbjBsXA7O2HA7dphIqpflA9/xxa/3g=;
        b=oEw9a06zhUECBxiApVpuaBZlonPhSbVth7ecrEcu6+r9OZWkJQOetVTKRRikmclfNU
         yX8Yemkjr8OsB+Nq4txd5gFO9/QpVjSoGiFc8HgBBSiEixgfQMlPuFC3MsfoQjoFJVgD
         1OsbhfYL7s1RwtjDb3CgjiGbLAIgvObySADrPToshSTO1ZKpJbS+V/AUPnvVGZGYVj5s
         kOI4ajDK6WS4M4VrwgIr6OwwMid+gdfMRcLXS5Hu1q8+N0qxSho4DpxWuJVb/l92bSJ6
         lIAe28WBlvcCwnK4Ju6xMZwCV8oboEA2WlI9U0lnv3haqJsgqT0/uEhQgBm5s/CtdJaD
         ZV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XnpKVb9e668NZTbjBsXA7O2HA7dphIqpflA9/xxa/3g=;
        b=wLR9BexfrslSkZ5s6UW8ZH4xfiseIgL7kQWw7usUYR6NRVwn48nuuWr4aXeymuOMOZ
         eWSrJEfhvRqJ3pvxOKnlbZ5T70/YDmdcpebuWevX3anmbcoDRbQadgD5zAIBv8ngDmLG
         TcRXZ0Huf8D8bFj9EO9+NWl7+aDwTOqeNt1LdZjrKsOgo2VL4h1hOE2ieh3uFgzkOAru
         ZXGpHJumLGgTowpu+xESzGtOXDhwM+iuAiP5eRrs+Pp8VkPtYnzuRRJYt+fx9ZY8EJBa
         MN0a6R3LfNlbNx4inAyn4XleXLrU5avIjgdfYbYbMByE/7eko1EJgOKEAu0ZcAL4ZTM4
         GtGA==
X-Gm-Message-State: ACrzQf3CDNCL6mT75zJh2onUjLdfhlQ/8HFCF/C61f0jyOzqjPGbrnuy
        rpH3t/lTQNAPn3T4Z3Aepv+PFIEwYOLZ/205DVZryA==
X-Google-Smtp-Source: AMsMyM6rCha3CJ3Ce50gZQ4VPHtyryFDEeMJSlkcUy6Kkham49/VSENQysWkL/ZORDkl+wGQqCsPwt+iZUOkNWZLCt4=
X-Received: by 2002:a25:ab33:0:b0:6ca:857b:9aa0 with SMTP id
 u48-20020a25ab33000000b006ca857b9aa0mr1125656ybi.231.1668011523073; Wed, 09
 Nov 2022 08:32:03 -0800 (PST)
MIME-Version: 1.0
References: <20221109150116.2988194-1-weiyongjun@huaweicloud.com>
In-Reply-To: <20221109150116.2988194-1-weiyongjun@huaweicloud.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Nov 2022 08:31:51 -0800
Message-ID: <CANn89iJZWTVfNDDkpwPOqjj5_fVXzGRrkeEv1EedRipL-oBYbQ@mail.gmail.com>
Subject: Re: [PATCH net] eth: sp7021: drop free_netdev() from spl2sw_init_netdev()
To:     Wei Yongjun <weiyongjun@huaweicloud.com>
Cc:     Wells Lu <wellslutw@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Wei Yongjun <weiyongjun1@huawei.com>, netdev@vger.kernel.org
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

On Wed, Nov 9, 2022 at 7:01 AM Wei Yongjun <weiyongjun@huaweicloud.com> wrote:
>
> From: Wei Yongjun <weiyongjun1@huawei.com>
>
> It's not necessary to free netdev allocated with devm_alloc_etherdev()
> and using free_netdev() leads to double free.
>
> Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
>
> diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> index 9be585237277..c499a14314f1 100644
> --- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
> +++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
> @@ -287,7 +287,6 @@ static u32 spl2sw_init_netdev(struct platform_device *pdev, u8 *mac_addr,
>         if (ret) {
>                 dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
>                         ndev->name);

If the following leads to a double free, how the previous use of
ndev->name would actually work ?

Please test your patch with CONFIG_KASAN=y

> -               free_netdev(ndev);
>                 *r_ndev = NULL;
>                 return ret;
>         }
> --
> 2.34.1
>
