Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB87B3A47FD
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 19:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhFKRji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 13:39:38 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:37829 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhFKRjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 13:39:37 -0400
Received: by mail-ed1-f51.google.com with SMTP id b11so38029798edy.4
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 10:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kicSdfyPUPG0oZw0Yyms2mDBTb2EqDMsn04Ocyed7OA=;
        b=xB5cCJAthgJGLgDcW5FU+YuJlwc9WkRntsmvFSTnAC8U6tvjQ5SDTlmFxMTNrH1pSp
         X+L07kyYXu8Tz+dl1ZA6u6m0+mb9UDaM4ofl5hLaFgJlZoiA3ue6VvFqv96WlefCBOse
         HqKqcBp+bsDnAtZbcDTAaOIGvRUZ4dxXVQEc0G6D1wXMqiUZwLI2P3qiwDFMrH214BeJ
         DHtTrO/kvGwCqketn8SYpwictc/Hf/z+NyBnso7vry4ONhbf4uTTK4/R4wRCA5cg9NWs
         9xGNVVcP6ZP0T1l0ldjLugscRSXyvQ59DibfLXUvflBIyDwSn1MXCy+anjNcIxMjNzUz
         X7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kicSdfyPUPG0oZw0Yyms2mDBTb2EqDMsn04Ocyed7OA=;
        b=tv+zdXTGcrpGQ37EGm1iFRR3uS4v0Li5hp+p9A1Z6stjfYSG4GX8kBkn1Nb0jf8Eq1
         s+BPZLGJ//kq/7TnY6h+muRK3ubbDlBZJ2KGdESqiWII4q/Shr/+oHfSt5jHgtSeaTpX
         ZJvX+PXdyj5UxeHqcU70PGIe1aXdQ3Krq6g/aWZBbYI6os3QSMXEy/0D6pGLFCxSrvT8
         E4z2jc4+XvBirrEoHrDA+C0HPEADivDAA4bsxDPlCE0sXz2ZReNOwSerCjIO0/o8NbXa
         7YBUjQGvl8fcpbEu9vWHn3l09HV/qBhoOK1R0Xhq5WC7Rbl7Mtld0ay89lyg6fJHbHNB
         nFfw==
X-Gm-Message-State: AOAM531PCH0PHpvfwWqhm9lzjFStGuqjIrWSDDsJ02ujfxe9cQdeGgCm
        5QPhc9LgQdaXXqn6KxTNhpatOmw+jijeL1Ju55vJ
X-Google-Smtp-Source: ABdhPJwxcUeB13OSebDiZwZ8pswKPJkD8oPnqPRTubV8D4BitINoO9F6PgQpRJGMuHWIf1jckj+ZuaRPqDN+Jb03uc4=
X-Received: by 2002:aa7:c0d3:: with SMTP id j19mr5029543edp.196.1623432998161;
 Fri, 11 Jun 2021 10:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210611082119.2117194-1-liushixin2@huawei.com>
In-Reply-To: <20210611082119.2117194-1-liushixin2@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 11 Jun 2021 13:36:27 -0400
Message-ID: <CAHC9VhTEYjQjFH9D4ozFbYcg=6ebMeVgN2dmYvb0ifdvadc2fA@mail.gmail.com>
Subject: Re: [PATCH -next v2] netlabel: Fix memory leak in netlbl_mgmt_add_common
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 3:50 AM Liu Shixin <liushixin2@huawei.com> wrote:
>
> Hulk Robot reported memory leak in netlbl_mgmt_add_common.
> The problem is non-freed map in case of netlbl_domhsh_add() failed.
>
> BUG: memory leak
> unreferenced object 0xffff888100ab7080 (size 96):
>   comm "syz-executor537", pid 360, jiffies 4294862456 (age 22.678s)
>   hex dump (first 32 bytes):
>     05 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     fe 00 00 00 00 00 00 00 00 00 00 00 00 00 00 01  ................
>   backtrace:
>     [<0000000008b40026>] netlbl_mgmt_add_common.isra.0+0xb2a/0x1b40
>     [<000000003be10950>] netlbl_mgmt_add+0x271/0x3c0
>     [<00000000c70487ed>] genl_family_rcv_msg_doit.isra.0+0x20e/0x320
>     [<000000001f2ff614>] genl_rcv_msg+0x2bf/0x4f0
>     [<0000000089045792>] netlink_rcv_skb+0x134/0x3d0
>     [<0000000020e96fdd>] genl_rcv+0x24/0x40
>     [<0000000042810c66>] netlink_unicast+0x4a0/0x6a0
>     [<000000002e1659f0>] netlink_sendmsg+0x789/0xc70
>     [<000000006e43415f>] sock_sendmsg+0x139/0x170
>     [<00000000680a73d7>] ____sys_sendmsg+0x658/0x7d0
>     [<0000000065cbb8af>] ___sys_sendmsg+0xf8/0x170
>     [<0000000019932b6c>] __sys_sendmsg+0xd3/0x190
>     [<00000000643ac172>] do_syscall_64+0x37/0x90
>     [<000000009b79d6dc>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
> v1->v2: According to Dongliang's and Paul's advices, simplify the code.
>
>  net/netlabel/netlabel_mgmt.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
>
> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> index e664ab990941..fa9e68e5f826 100644
> --- a/net/netlabel/netlabel_mgmt.c
> +++ b/net/netlabel/netlabel_mgmt.c
> @@ -76,6 +76,7 @@ static const struct nla_policy netlbl_mgmt_genl_policy[NLBL_MGMT_A_MAX + 1] = {
>  static int netlbl_mgmt_add_common(struct genl_info *info,
>                                   struct netlbl_audit *audit_info)
>  {
> +       void * pmap = NULL;

You should use the 'void *pmap = NULL;' style that is used in the rest
of this function, and most everywhere in the kernel.

>         int ret_val = -EINVAL;
>         struct netlbl_domaddr_map *addrmap = NULL;
>         struct cipso_v4_doi *cipsov4 = NULL;
> @@ -175,6 +176,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                         ret_val = -ENOMEM;
>                         goto add_free_addrmap;
>                 }
> +
> +               pmap = map;

There is no need for the extra vertical whitespace here.

>                 map->list.addr = addr->s_addr & mask->s_addr;
>                 map->list.mask = mask->s_addr;
>                 map->list.valid = 1;
> @@ -183,14 +186,13 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                         map->def.cipso = cipsov4;
>
>                 ret_val = netlbl_af4list_add(&map->list, &addrmap->list4);
> -               if (ret_val != 0) {
> -                       kfree(map);
> -                       goto add_free_addrmap;
> -               }
> +               if (ret_val != 0)
> +                       goto add_free_map;
>
>                 entry->family = AF_INET;
>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>                 entry->def.addrsel = addrmap;
> +

Please don't add extra vertical whitespace here.

>  #if IS_ENABLED(CONFIG_IPV6)
>         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
>                 struct in6_addr *addr;
> @@ -223,6 +225,8 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                         ret_val = -ENOMEM;
>                         goto add_free_addrmap;
>                 }
> +
> +               pmap = map;

Same thing, no extra vertical whitespace please.

-- 
paul moore
www.paul-moore.com
