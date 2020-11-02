Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A252A25B4
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgKBH6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:58:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgKBH6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 02:58:00 -0500
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72DB521D91
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604303879;
        bh=ul6Yol9AQtOcP2zc4IwvOdoGNjakP1DfDt3OURCRsEY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LedD1T0pIXTHYsn8zazAsQIcO46Smc8P5S7z5rJKGOxIOKrbIaZIkhkxtSMz9Iayx
         cs2kRRDAVbGDHvtGZbokOh4tvpR2glPQclXYzFjuUFIvukDwim3tcQKWH0erhCesuD
         KHgikT2x/SCWdrr7uLVtcZ9Rn9h7Z4Uc0vEL865g=
Received: by mail-wm1-f54.google.com with SMTP id p19so677639wmg.0
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 23:57:59 -0800 (PST)
X-Gm-Message-State: AOAM531suC8+Dz49IFRxQfXtEAKxAKOBV1W0OvWDiXGKX7jpZSSFkJgy
        R9EavTkKLJYKoYVNV/PKjBXrBAJP3oRz9GlT5U0=
X-Google-Smtp-Source: ABdhPJxzXwsv+v4K3L6W0ZwPbgBnc4j4MtP6H5YLqIDkC1eYgx1ACzQpr/AnG9p/StfEbU+9jh6N4C6XfATGu5/cPIM=
X-Received: by 2002:a7b:c18d:: with SMTP id y13mr16104510wmi.120.1604303878066;
 Sun, 01 Nov 2020 23:57:58 -0800 (PST)
MIME-Version: 1.0
References: <20201102072456.20303-1-rdunlap@infradead.org>
In-Reply-To: <20201102072456.20303-1-rdunlap@infradead.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Nov 2020 08:57:41 +0100
X-Gmail-Original-Message-ID: <CAK8P3a39LYjQB=qJfBNsbiALohiHsrwdt6g9XUs5esF3KyV3Mw@mail.gmail.com>
Message-ID: <CAK8P3a39LYjQB=qJfBNsbiALohiHsrwdt6g9XUs5esF3KyV3Mw@mail.gmail.com>
Subject: Re: [PATCH] staging: wimax: depends on NET
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 2, 2020 at 8:25 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):
>
> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_alloc':
> op-msg.c:(.text+0xa9): undefined reference to `__alloc_skb'
> ld: op-msg.c:(.text+0xcc): undefined reference to `genlmsg_put'
> ld: op-msg.c:(.text+0xfc): undefined reference to `nla_put'
> ld: op-msg.c:(.text+0x168): undefined reference to `kfree_skb'
> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_data_len':
> op-msg.c:(.text+0x1ba): undefined reference to `nla_find'
> ld: drivers/staging/wimax/op-msg.o: in function `wimax_msg_send':
> op-msg.c:(.text+0x311): undefined reference to `init_net'
> ld: op-msg.c:(.text+0x326): undefined reference to `netlink_broadcast'
> ld: drivers/staging/wimax/stack.o: in function `__wimax_state_change':
> stack.c:(.text+0x433): undefined reference to `netif_carrier_off'
> ld: stack.c:(.text+0x46b): undefined reference to `netif_carrier_on'
> ld: stack.c:(.text+0x478): undefined reference to `netif_tx_wake_queue'
> ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_exit':
> stack.c:(.exit.text+0xe): undefined reference to `genl_unregister_family'
> ld: drivers/staging/wimax/stack.o: in function `wimax_subsys_init':
> stack.c:(.init.text+0x1a): undefined reference to `genl_register_family'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: netdev@vger.kernel.org

Good catch,

Acked-by: Arnd Bergmann <arnd@arndb.de>

I wonder if we also need a dependency on NETDEVICES then,
since that is what the drivers/net/wimax/ implicitly depended on
before.

       Arnd
