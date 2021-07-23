Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6ED3D4131
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 21:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhGWTQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 15:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhGWTQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 15:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 623B260F4C
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 19:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627070203;
        bh=QoInK3nMO0ccO67Z+FvuoU9WkD6+JKA4sf5w225QmRA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VxJJW2FDrQr+55ut3wwY0lc2P1plwg0HcqHibbIYMVOPMDT5zfPZqIHg2Iv6osdao
         QBGuo3ALzDTgwpSc2P5THssHOKaILRfz18xfzR+XzOPg0zfMkLeP8y5WncgiYR2aK1
         DtJMAmv0amLe8OmpKcjDW7tylipNcKD7DgIe/2hjNwAcdCrsCTpJciZ3Zoskc+KU6U
         DX2zbYKCPJBuGNnBS66rOc3FkL3qpU1/FyLuIujRd0aLX9G8771mazzBMj6A4etJDW
         er0V018aoJf+83BzUxe/3VBQUAxJAzeK6GX7kTbvJypyljyKYWNK8GIMTj8wgQ0JD0
         MRrqL3m+sAKMw==
Received: by mail-wr1-f42.google.com with SMTP id q3so3595360wrx.0
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 12:56:43 -0700 (PDT)
X-Gm-Message-State: AOAM531zsIp0ScE/WMfDqIvZTA/LhQejBvJXMNjWDviaTSTa3Jjt9Mrw
        SRSp2UAI+Q3g/ykp4dzXe/DhWC6BIaWGGRbK4pU=
X-Google-Smtp-Source: ABdhPJwT8+hxWoPH4Z87dILJ/GFln39ROgBXTHiCGKUqveGD2lUjsrPakMi8ZoCnfzTjPu6pCXdIFKPj+PeHbtdUj4E=
X-Received: by 2002:adf:b318:: with SMTP id j24mr7161727wrd.361.1627070201979;
 Fri, 23 Jul 2021 12:56:41 -0700 (PDT)
MIME-Version: 1.0
References: <1621477304-4495-1-git-send-email-tanhuazhong@huawei.com> <1621477304-4495-13-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1621477304-4495-13-git-send-email-tanhuazhong@huawei.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Fri, 23 Jul 2021 21:56:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3GygY5_AauiY51ahyCyaurjj1UAfPJnYFiok7x5TCjfg@mail.gmail.com>
Message-ID: <CAK8P3a3GygY5_AauiY51ahyCyaurjj1UAfPJnYFiok7x5TCjfg@mail.gmail.com>
Subject: Re: [PATCH net-next 12/15] net: hns3: refactor dump qs shaper of debugfs
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, Linuxarm <linuxarm@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 4:22 AM Huazhong Tan <tanhuazhong@huawei.com> wrote:
>  static int hclge_dbg_dump_tm_qset(struct hclge_dev *hdev, char *buf, int len)
>  {
> +       char data_str[ARRAY_SIZE(tm_qset_items)][HCLGE_DBG_DATA_STR_LEN];
> +       char *result[ARRAY_SIZE(tm_qset_items)], *sch_mode_str;
>         u8 priority, link_vld, sch_mode, weight;
> -       char *sch_mode_str;
> +       struct hclge_tm_shaper_para shaper_para;
> +       char content[HCLGE_DBG_TM_INFO_LEN];
> +       u16 qset_num, i;
>         int ret, pos;
> -       u16 qset_num;
> -       u16 i;
> +       u8 j;

These variables are too large to put on the stack of a function, as pointed out
by this compiler warning:

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c: In
function 'hclge_dbg_dump_tm_pg':
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:782:1:
error: the frame size of 1416 bytes is larger than 1400 bytes
[-Werror=frame-larger-than=]

I couldn't find an obvious way to fix it. Using kmalloc to dynamically
allocate them
would work, but it's probably better to use a seq_file here and change the loop
to multiple calls.

        Arnd
