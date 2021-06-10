Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87CA03A37FE
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhFJXmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:42:19 -0400
Received: from mail-ej1-f44.google.com ([209.85.218.44]:38717 "EHLO
        mail-ej1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFJXmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:42:15 -0400
Received: by mail-ej1-f44.google.com with SMTP id og14so1695690ejc.5
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PbPy0sLFc6s1iVCDr+0Neuhg5szqPhBqV3IvM8xe9Rc=;
        b=MdASbkKBw1qZi8qXv8QILiOVDXfXorlejkwLkYa9mTv0mfWe3/65hu6qCgVdU+GaQG
         08XIP2PKL6Vbau47nQbrwBYpvOZu09GKmjDFd5ci9XLj+MleAhQ2g/WThXeEqQYaCUPY
         S+EqIQ+mSlG5UR5/3VnMhwsm+BVXq05gGJkev2hoA+n/NREA5yEjLOcDPSYksV5h9dpt
         OtQNFcaE/bV24bFxHy4liEWcWHi8ADsxK1Rnmz7iBVVV9aYniCWpLujCbFy9pTIPMdkj
         0AVtmZFR1A/B0GiBPUsl6ElPL1Hjhihiea1rOLNjpIWi4dSamfNWQjr28g/8dNs8dAhm
         ANOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PbPy0sLFc6s1iVCDr+0Neuhg5szqPhBqV3IvM8xe9Rc=;
        b=sSwoUpe+c7NPct8hIX3wT5PZUaPcSLMLVvHkAox4yRUk7QfeFaah66yM1BM3emCpNZ
         mcCLnBuEzN/jE3FUVfRNLfdaVnNo/vcjDlwo6XsX/FxWfR217jO73iV7LqRaMpsg++/Q
         orkelY3wCH0fm6S63DfZwkxHBuBCTe0V8zJ9Y6fK4dcLN53FPXABOB1h8VkaVIFX1aet
         7HFDUNccUisALNdnclZbd+G1PgtZxKgsl3JlmAtUeAqtNjW0xNfopUZUmPtMEIMwy735
         XJON6YgEKN/uiNaiSsPxk3XF3+DEfH97Cb8vzm/juD/B1nCqaieYQqMB4UfM1mhKAKo/
         JxrA==
X-Gm-Message-State: AOAM531dlLmJimjBo+OUEcsf+D86NFYZeE2ytUOMAS9f83UYdWLPg6EB
        a4jXKe4rJvrxxJ9IB9yUjfJmJPHRiBV2CD2+nRgp
X-Google-Smtp-Source: ABdhPJx3HkT0cnFJM6rU/xn9g9XPuNXhwJemA19TgZ/Z+YQGjVGxZ2pUb4AP1eoSda2Zuba1PC1W/lpXBbVk/1gaYhU=
X-Received: by 2002:a17:906:2c54:: with SMTP id f20mr812366ejh.91.1623368345578;
 Thu, 10 Jun 2021 16:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210610020108.1356361-1-liushixin2@huawei.com>
In-Reply-To: <20210610020108.1356361-1-liushixin2@huawei.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Jun 2021 19:38:54 -0400
Message-ID: <CAHC9VhQM4YP527Z9ijTBk2i++S=viZ1hKVo6GgCOUcNCVgB2vw@mail.gmail.com>
Subject: Re: [PATCH -next] netlabel: Fix memory leak in netlbl_mgmt_add_common
To:     Liu Shixin <liushixin2@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 9:29 PM Liu Shixin <liushixin2@huawei.com> wrote:
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
>  net/netlabel/netlabel_mgmt.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/net/netlabel/netlabel_mgmt.c b/net/netlabel/netlabel_mgmt.c
> index e664ab990941..e7f00c0f441e 100644
> --- a/net/netlabel/netlabel_mgmt.c
> +++ b/net/netlabel/netlabel_mgmt.c
> @@ -191,6 +191,12 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                 entry->family = AF_INET;
>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>                 entry->def.addrsel = addrmap;
> +
> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> +               if (ret_val != 0) {
> +                       kfree(map);
> +                       goto add_free_addrmap;
> +               }
>  #if IS_ENABLED(CONFIG_IPV6)
>         } else if (info->attrs[NLBL_MGMT_A_IPV6ADDR]) {
>                 struct in6_addr *addr;
> @@ -243,13 +249,19 @@ static int netlbl_mgmt_add_common(struct genl_info *info,
>                 entry->family = AF_INET6;
>                 entry->def.type = NETLBL_NLTYPE_ADDRSELECT;
>                 entry->def.addrsel = addrmap;
> +
> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> +               if (ret_val != 0) {
> +                       kfree(map);
> +                       goto add_free_addrmap;
> +               }
>  #endif /* IPv6 */
> +       } else {
> +               ret_val = netlbl_domhsh_add(entry, audit_info);
> +               if (ret_val != 0)
> +                       goto add_free_addrmap;
>         }
>
> -       ret_val = netlbl_domhsh_add(entry, audit_info);
> -       if (ret_val != 0)
> -               goto add_free_addrmap;
> -
>         return 0;

Thanks for the report and a fix, although I think there may be a
simpler fix that results in less code duplication; some quick pseudo
code below:

  int netlbl_mgmt_add_common(...)
  {
     void *map_p = NULL;

     if (NLBL_MGMT_A_IPV4ADDR) {
       struct netlbl_domaddr4_map *map;
       map_p = map;

     } else if (NLBL_MGMT_A_IPV6ADDR) {
       struct netlbl_domaddr4_map *map;
       map_p = map;
    }

  add_free_addrmap:
    kfree(map_p);
    kfree(addrmap);
  }

... this approach would even simplify the error handling after the
netlbl_af{4,6}list_add() calls a bit too (you could jump straight to
add_free_addrmap).

-- 
paul moore
www.paul-moore.com
