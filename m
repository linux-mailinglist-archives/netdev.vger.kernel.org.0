Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5F02E25D6
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 11:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgLXKHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 05:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726839AbgLXKHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 05:07:36 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B48EC061794
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 02:06:56 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id c22so1282622pgg.13
        for <netdev@vger.kernel.org>; Thu, 24 Dec 2020 02:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=++j6uVb6tH6Ov/D97FhkzaMngr7jheHbTzXT19mkjr0=;
        b=fpvWKDM8xNbeKOKkIMXaqBkZ5kQQxvxdjk0J7KXhaOzC+Au8pY53bn/Vz5IuHU5TIS
         T+84/c/V958oQ4cxsBlsSmBkhUr3Je9JDcDLmPsSTZD6EVLCetR8gss3Q6syE9HDlUvk
         r582gnBsM3VIvH92/qMkyf4K/Y9COuwwfACHUz/sm7KNkAVMKwVf9YcsG9EBOhzayujw
         vLE9k37mvykS4X+MT/7wrqfuDFlqZQRsr90nHsC2JkwjQolVuPFPsbsDqkvsGxHzarqf
         E9i4g6TyOBR8X7bUYmqGhkQsshb1ofTAKtHgIClYuf507TpSa81dv1Rt0VPO2o05W7hA
         PCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=++j6uVb6tH6Ov/D97FhkzaMngr7jheHbTzXT19mkjr0=;
        b=YSS+Nnv6hmdImLXw7lPV61dUWuo+ly4hPkWHj7FcDGD9clV1AGuUtSCYzBpT0OAgbP
         FasipX1PEHtw7hzc5L3CYTEXUwVNmI2rwAcJpTPWXbCsVrH9Gj/ix44n1HtG5wuLfj7U
         kciRV9LPKXbzEXx0s0MeA1LJX5niGSIM2V9Oy7jc/lU+VQh8uzeV8fvOHTbA8xRR96tH
         eDLR8Nh6zhI/WHbuUIxfB4uO9aLM0v8al07QcleISPTVCKFoioknm9Exar1G9ZkOFGXq
         MGcobJ4hCoWyAh/+3/ZLW0UzI/2c0DYADcfeIeFtFiiIK2f8HKVu2C8jnmMURkMp2VxU
         AArA==
X-Gm-Message-State: AOAM530dJk0rZqf2APXjMuQeuaJkxjJ7vW5qWciMs2v3sm5YHl5eNQMm
        D98bOTIwL63jmCdX77RwiXnSTLIYHfBZw5jmisA=
X-Google-Smtp-Source: ABdhPJy/AA3OXu9FZUmaetDHsty21mDsaEkzIwySuHYxVeECnBSp5xZH8ikWCEGjEHH4+H4Qfoijl5OiUt35N2gXpTo=
X-Received: by 2002:a62:7693:0:b029:19d:92fb:4ec1 with SMTP id
 r141-20020a6276930000b029019d92fb4ec1mr4205126pfc.4.1608804415559; Thu, 24
 Dec 2020 02:06:55 -0800 (PST)
MIME-Version: 1.0
References: <20201121062817.3178900-1-eyal.birger@gmail.com>
In-Reply-To: <20201121062817.3178900-1-eyal.birger@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 24 Dec 2020 02:06:44 -0800
Message-ID: <CAJht_ENExFia=NPqYOmcF+kEFN8-YkAfUBuhzVEvPJwt0W4NZQ@mail.gmail.com>
Subject: Re: [net,v2] net/packet: fix packet receive on L3 devices without
 visible hard header
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jason@zx2c4.com,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 10:28 PM Eyal Birger <eyal.birger@gmail.com> wrote:
>
> Fix by changing af_packet RX ll visibility criteria to include the
> existence of a '.create()' header operation, which is used when creating
> a device hard header - via dev_hard_header() - by upper layers, and does
> not exist in these L3 devices.

This patch changed the RX LL visibility criteria (in the comment) to
"dev_has_header". We need to change the TX LL visibility criteria (in
the same comment), too.
