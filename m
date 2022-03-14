Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575EF4D8ABA
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 18:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243288AbiCNRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 13:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243148AbiCNRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 13:25:24 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD09A3EBB7
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:24:13 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2e2ca8d7812so110771737b3.13
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 10:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nIM2WgaeOe7Oad8pj23RRvmukruwEQzDbhHuVEzZZQg=;
        b=M/NEZL/7d/FHDcGogjwbbDHJ3nyrseJag6k+W6e5B0VW0Pnfh0e1AT7AkJZeJtVvJM
         Jd2eDvXOVeV5R4n8ggGQEggw+R2R5b+7knYQe3oCYPlDi2Hxcca7pMAMqJi+70p+4Hod
         OhO4mYothVIMU7uHTGFOelPSurS71ZWZu5Dw9PcuChttdcHuVxbAU01D/ZJ7o3udxBjd
         TohGwdQjjlNw147K3O72+EcFmSmulCenbymo+4JChN8+xHKf6uxzPLd3MWMvwmMsoMXw
         ExXb83dMCKPmN2YD1ocm9Ho/NMBnVD4OnE/VYytbFCoOinEBytibdRKvNYZhav23Iep6
         FFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nIM2WgaeOe7Oad8pj23RRvmukruwEQzDbhHuVEzZZQg=;
        b=y5XF10PmDkMrkcxCp7zEbGB/4X2l1qneYu1e/fUnXpb3ocDktWcQ/QAevIVbjFoD7q
         P+3iVyWCgTrfSZEoriUCSoXp0M4xy0NijfLVhBVUuJpjCXJfcfOO/5mfkJuno/llCWHy
         nh2XCajW9fEYIJDUIavmKAZzaBsrL+tBtLpggtNdQigi+fkAwVuU7yW0nSDvaI88irWg
         e3aqvNco6FbHGAjEMmJgMzjVrm+Nkk4ZZS9o+RU5xASs7e8j6kr2dY9Hzjnqh9eS//Ix
         Pn+R3ewfD41d8JvR9iQObGDBDGUM12SHXZ6Xprht7NEKvCmFta01hj+egLZuZ1GH36qw
         /AFA==
X-Gm-Message-State: AOAM532IADPcicvy2CG2OGN7rouaKMw8l1EzPjxzzRyEDdl6Dw5drP/b
        CTtNYGQd1sXggDPBFTz8CVAStdrK2aJzdS9EfjsOYA==
X-Google-Smtp-Source: ABdhPJwTdzcRy7i7JGDA0oXv/UANgr5uhFBQAmlzEStyV6GKKSkWMkCD8VQKJouQtsUeBcYpGo7a8Kz5xTypbNW6xZY=
X-Received: by 2002:a81:1043:0:b0:2dc:289f:9533 with SMTP id
 64-20020a811043000000b002dc289f9533mr19325113ywq.467.1647278652496; Mon, 14
 Mar 2022 10:24:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1647255926.git.william.xuanziyang@huawei.com> <751f88c0846df798a403643cefcaab53922ffe2f.1647255926.git.william.xuanziyang@huawei.com>
In-Reply-To: <751f88c0846df798a403643cefcaab53922ffe2f.1647255926.git.william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 14 Mar 2022 10:24:01 -0700
Message-ID: <CANn89iLK9theyFtU+++UQNHc-cn5cTz-Q_CP3BY44WBbfQfS8g@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: ipvlan: fix potential UAF problem for phy_dev
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, sakiwit@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
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

On Mon, Mar 14, 2022 at 3:54 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> Add the reference operation to phy_dev of ipvlan to avoid
> the potential UAF problem under the following known scenario:
>
> Someone module puts the NETDEV_UNREGISTER event handler to a
> work, and phy_dev is accessed in the work handler. But when
> the work is excuted, phy_dev has been destroyed because upper
> ipvlan did not get reference to phy_dev correctly.

Can you name the module deferring NETDEV_UNREGISTER to a work queue ?

This sounds like a bug to me.

>
> That likes as the scenario occurred by
> commit 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()").

Mentioning a commit that added a bug and many other commits trying to
fix it is a bit unfortunate.

Can you instead add a Fixes: tag ?

Do you have a repro to trigger the bug ?

>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/ipvlan/ipvlan_main.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
> index 696e245f6d00..dcdc01403f22 100644
> --- a/drivers/net/ipvlan/ipvlan_main.c
> +++ b/drivers/net/ipvlan/ipvlan_main.c
> @@ -158,6 +158,10 @@ static int ipvlan_init(struct net_device *dev)
>         }
>         port = ipvlan_port_get_rtnl(phy_dev);
>         port->count += 1;
> +
> +       /* Get ipvlan's reference to phy_dev */
> +       dev_hold(phy_dev);
> +
>         return 0;
>  }
>
> @@ -665,6 +669,14 @@ void ipvlan_link_delete(struct net_device *dev, struct list_head *head)
>  }
>  EXPORT_SYMBOL_GPL(ipvlan_link_delete);
>
> +static void ipvlan_dev_free(struct net_device *dev)
> +{
> +       struct ipvl_dev *ipvlan = netdev_priv(dev);
> +
> +       /* Get rid of the ipvlan's reference to phy_dev */
> +       dev_put(ipvlan->phy_dev);
> +}
> +
>  void ipvlan_link_setup(struct net_device *dev)
>  {
>         ether_setup(dev);
> @@ -674,6 +686,7 @@ void ipvlan_link_setup(struct net_device *dev)
>         dev->priv_flags |= IFF_UNICAST_FLT | IFF_NO_QUEUE;
>         dev->netdev_ops = &ipvlan_netdev_ops;
>         dev->needs_free_netdev = true;
> +       dev->priv_destructor = ipvlan_dev_free;
>         dev->header_ops = &ipvlan_header_ops;
>         dev->ethtool_ops = &ipvlan_ethtool_ops;
>  }
> --
> 2.25.1
>
