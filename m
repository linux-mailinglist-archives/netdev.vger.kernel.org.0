Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967BC3A4EEE
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 14:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhFLMvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 08:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLMvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 08:51:41 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84481C061574;
        Sat, 12 Jun 2021 05:49:41 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id b205so4790251wmb.3;
        Sat, 12 Jun 2021 05:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=soLSFJbZrxFS2wM14vi/4uzx1dl/kBu0tVSsmZ6Wonw=;
        b=DnM0ImUc9snQoG0t2N1Pa+Zu+cS+TfoIxjsjVB5/k3QmYqqod12eg58VfqdoyZJr00
         xXAhIR4CRaUdeEP3YWrvLZAUTM2bSgHU9jQXHsbXhBwk5kbqHLhtncJvKguxqboypqsA
         RWpxkInz8Krrx21DfEMKVT3fcU5c2l0YZFBeB6HBMtOvXk1/Nfn1w28k8Ru589LyjKRB
         ZE6xduyAGH1jBzjWdL6K7a9pd+pH9wIrblZSJjnR5J1WsV0Qz8WwO7SoSXi3ll7W9ENK
         xsDI858P5HrGhllNyE+GI8Pw7zK42U6evxsGk3T5jcmKF1ztrRrWIoqZ/uWtf2unNaZI
         y9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=soLSFJbZrxFS2wM14vi/4uzx1dl/kBu0tVSsmZ6Wonw=;
        b=QlWeoKbqwvuvGmCAulYqjn4WnpdhBFFiqoLtxQibVxccRvP8O4sYhOiK9hC5RzqVnl
         FQoxviAagXDAHEC7fkX9UucN1NVwzUGyNCV7F8xLqPpYaZbwIQybisK4OC3iEN+CD/dW
         YoW5e8Cd4yqMny2sDlOkrlwUNi9ETKbSyJewhxPH56l/jQZclQPMUuqWIXGQXWxtKV7f
         VbgjhPywtVvDBFEJWxUs96/jNYjyJTD5FiNvogR3T8Gd3sGadXaWksHNEGoVoiP0vavh
         7YQn79XiRQnTinbPJVAFU9I5I6dOyjpr1s/tvfXSkj3GP+UZD4E/O81XFeAjjYSV1bJR
         21+g==
X-Gm-Message-State: AOAM532iIW53mLv5Tf+az7U5JcSRA3hcJx4j4/q05cH/rTQq1FsMTDzt
        H8iM8R4yGnJzWtHjf2a60T/U8XH1qXMV06H3opE=
X-Google-Smtp-Source: ABdhPJxBVK2JqokeUcnyfOIslQB54QeJ696/LbQ5r6ljs6Lg2btGVl3NHWKKKrPd9e6IYdxd2BKAhiXY5+NfA0chFLQ=
X-Received: by 2002:a1c:6a09:: with SMTP id f9mr24341932wmc.91.1623502179896;
 Sat, 12 Jun 2021 05:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210611015812.1626999-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210611015812.1626999-1-mudongliangabcd@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sat, 12 Jun 2021 08:49:28 -0400
Message-ID: <CAB_54W4djgY19-z8Pr9A4FgECDTESwjprk-P-x4gQCLBxvt3xA@mail.gmail.com>
Subject: Re: [PATCH] ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 10 Jun 2021 at 21:58, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> In hwsim_subscribe_all_others, the error handling code performs
> incorrectly if the second hwsim_alloc_edge fails. When this issue occurs,
> it goes to sub_fail, without cleaning the edges allocated before.
>
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

sorry, it is a correct fix. Thanks.

- Alex
