Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262A14BDC60
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379426AbiBUPod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 10:44:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379460AbiBUPoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 10:44:08 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E02122B32
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:43:30 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id u12so21219703ybd.7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 07:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8CiXW+ordTPvlB+u9HbUK6sbw1rc2hC0tPgjcuKVOVM=;
        b=qUcvoofk8rUJAf0+4Hif+JUd1A284UxMQ/JJk7kRQn93WTS/uI4J9O3QoDFcKalbXt
         rTfHx5TC1V040BXgKQJLZwfR+hK7Hh9QNfrYcSE2Y2EA7fCI3K3l4EDpoP3+lfmQR2xn
         t0zle6EricYu1Gpra8GkZspUtBsUrTKMmQ/GF2DCxqa/MGEVn4+JMIOvMxPgSf1huyxZ
         wc06SF+cnafh3OUrDhy2v7Wtl8iAiRdGjErskv8WTACS2psKUbm3QbNtYySpy8DnI+s8
         B6/+4Gmsqk9qoaW05SOAnNf6fbG5+jKd+AEDVZE7g1XWKDtO4b53JP52RrJ9U8SqHZqs
         oouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8CiXW+ordTPvlB+u9HbUK6sbw1rc2hC0tPgjcuKVOVM=;
        b=65oWPdRMqB5vH9lBhJIJ9iXgzRT2ipdzDwaAfEelX/0K4ith8mdGz+v+K7DzqL7tsx
         30zBrySPxYmV8b0Lu73Vn6bjhI+s+IBnOk9YtdOy7uAjU9U/GnHpxTHUipP88p3xQ1+G
         GMXqy4Dy56dc7veXuqX1FYWOjIakIW5X94JzC7NEcieHlLdc0WphG9JuKtfiXV6AaeOq
         cNjSIlTqpY4Ty44meRjyAIBeJTVGPJhJ3NIyINC3IlKExq5M0KWB1ZEVQkEdjVVCSmg6
         XzhlCby2M5Z0W/F+0dpuFpsUX16mN1+eqZYVBHTAd94ByqK3X42pfZO1tkOBKq3kFVSW
         tSgA==
X-Gm-Message-State: AOAM530x6Y6l4FxvB+KT5vDtJw7ilQ6DxXSn4SLMkivpJQddQuzpmCLi
        9DFXtEsV9RHTFn/Iziy0C2AkBnQXLTHiXDehNwMBbQ==
X-Google-Smtp-Source: ABdhPJxdkqqwtNvDKWif6dKTTnGdo3MNqTsPxysw3CgEmS0eSJlkISpcJQj8TmNxzR0EW0Fp9m3MpKLCfKQKB6Ec6z8=
X-Received: by 2002:a25:d614:0:b0:61d:bb22:8759 with SMTP id
 n20-20020a25d614000000b0061dbb228759mr19289175ybg.231.1645458209249; Mon, 21
 Feb 2022 07:43:29 -0800 (PST)
MIME-Version: 1.0
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Feb 2022 07:43:18 -0800
Message-ID: <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
To:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC Herbert Xu, author of blamed commit.

On Mon, Feb 21, 2022 at 4:28 AM Ziyang Xuan
<william.xuanziyang@huawei.com> wrote:
>
> vlan device MTU can only follow real device change from bigger to smaller
> but from smaller to bigger under the premise of vlan device MTU not exceed
> the real device MTU.
>
> This issue can be seen using the following commands:
>
> ip link add link eth1 dev eth1.100 type vlan id 100
> ip link set eth1 mtu 256
> ip link set eth1 mtu 1500
> ip link show
>
> Modify to allow vlan device follow real device MTU change from smaller
> to bigger when user has not configured vlan device MTU which is not
> equal to real device MTU. That also ensure user configuration has higher
> priority.
>
> Fixes: 2e477c9bd2bb ("vlan: Propagate physical MTU changes")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/8021q/vlan.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index 788076b002b3..7de4f462525a 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -361,6 +361,7 @@ static int __vlan_device_event(struct net_device *dev, unsigned long event)
>  static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>                              void *ptr)
>  {
> +       unsigned int orig_mtu = ((struct netdev_notifier_info_ext *)ptr)->ext.mtu;
>         struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
>         struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>         struct vlan_group *grp;
> @@ -419,7 +420,7 @@ static int vlan_device_event(struct notifier_block *unused, unsigned long event,
>
>         case NETDEV_CHANGEMTU:
>                 vlan_group_for_each_dev(grp, i, vlandev) {
> -                       if (vlandev->mtu <= dev->mtu)
> +                       if (vlandev->mtu <= dev->mtu && vlandev->mtu != orig_mtu)
>                                 continue;
>
>                         dev_set_mtu(vlandev, dev->mtu);
> --
> 2.25.1
>

Herbert, do you recall why only a decrease was taken into consideration ?

Thanks.
