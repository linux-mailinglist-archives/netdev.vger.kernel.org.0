Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C09833811F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 00:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhCKXNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 18:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbhCKXNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 18:13:13 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0DFC061574;
        Thu, 11 Mar 2021 15:13:12 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so10126349pjv.1;
        Thu, 11 Mar 2021 15:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bU9j8QS9UEqtU91hrNDexuTDXigIeltrQEJrDXB39JU=;
        b=f/kuHReiRdBMXdOa966VBks+JO5X0AAmZaiPPeBGrQwvKqvQ+CoD8qjV0uQPREWRWw
         kadZC5M5uY7DFdui29GRMfDwEtxCy3Wbx118+IUwqSe+lPsb54h4N0OYNNB9yyxg00oa
         L0KycMqH4/jDv7S43dH6PV3jHzLfhkS7HX0mScTYZ2tZUpAL0oiSv9xzVWPDelvLGrBE
         Perdg5mKo4+BR34Hk3I/luPCkFHgGSD7Qpn4cChs+DVRKr9k2sAXmNndgBhMMKHk7MS6
         MQkYlftREEuPfE9Zt8D2QQbjv0u8QpWSfRODvd0owNP62OcuPwIrGZDIC5QOlYlnEO6m
         wDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bU9j8QS9UEqtU91hrNDexuTDXigIeltrQEJrDXB39JU=;
        b=DMYkSsNfWYXyvhCkVCIAlEwG4EkQrGDcMNaa0sDR8zcZK9KV7OSD3x7g3CmJu4tw2U
         6Kb4R6irrPHJNWp2qv0pfuQJtNN/jd51U6tM7XXqLkYiNH3Ke2Fz0klvkSOV0JgnF+/a
         jmRVke46c/DsESNJUisf4kFGnstZdqgAEfxFMAdzoUUHchAHziPYptHUpqO8D7DhHJqL
         aVOBMvcUhRYVKXtOjcnvo7zdcHbF5SPRUIwcsl/dsnPT2SvI2w7FP7T6WSJpC0NnUgtb
         8a1kTG4Hw/ZDZYACwwy2JCxIRL8AxMG6Nsb2TOw/oqE6naUJY5G6eH6aahPinr45e0fN
         pS7g==
X-Gm-Message-State: AOAM531pYXUwBLdbYPRUCNzWAXiUDixXcZQq4VP20ew+xN74jqOmW/Yx
        cxnnB0SjPcZawKRlmdHLmWy7KEoXSxEeVPnvPSTbj6n5vTI=
X-Google-Smtp-Source: ABdhPJxCQlZY7oDGdfCTApTySwUAzoKFFF1LkwbBouxB3bZObIYRGghCCCfAIky1XLTOTgoYXqyOfWvpPJVug9y+5Xs=
X-Received: by 2002:a17:90a:ea91:: with SMTP id h17mr11119542pjz.66.1615504392023;
 Thu, 11 Mar 2021 15:13:12 -0800 (PST)
MIME-Version: 1.0
References: <20210311072311.2969-1-xie.he.0141@gmail.com> <20210311124309.5ee0ef02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EMToKj2OeeE1fMfwAVYvhbgZpENkv0C7ac+XHnWcTe2Tg@mail.gmail.com> <20210311145230.5f368151@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311145230.5f368151@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 11 Mar 2021 15:13:01 -0800
Message-ID: <CAJht_EMR6kqsetwNUbJJziLW97T0pXBSqSNZ5ma-q175cxoKyQ@mail.gmail.com>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking whether
 the netif is running
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 2:52 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Normally driver's ndo_stop() calls netif_tx_disable() which takes TX
> locks, so unless your driver is lockless (LLTX) there should be no xmit
> calls after that point.

Do you mean I should call "netif_tx_disable" inside my "ndo_stop"
function as a fix for the racing between "ndo_stop" and
"ndo_start_xmit"?

I can't call "netif_tx_disable" inside my "ndo_stop" function because
"netif_tx_disable" will call "netif_tx_stop_queue", which causes
another racing problem. Please see my recent commit f7d9d4854519
("net: lapbether: Remove netif_start_queue / netif_stop_queue")
