Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6889F427113
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 20:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbhJHS7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbhJHS7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 14:59:39 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A71C061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 11:57:42 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id r1so10445410qta.12
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 11:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2qL3aJlwX8dY3EMOyIG3DqLy94CGJ+XhgRpCzxZefjc=;
        b=PPTh64qnE0JXbijKzOW0x4rBWhMASZZmcHq8ttkhv6L2qoW2R35R0xWck3VkaBKsO1
         JeIrMm1rAQLNe6Mu5REEflK8UbyhfsSdDmiJYC5xcgZSrWZjRY4UvUTrpogL+hTr1VKf
         kz+60fKz/rMUfXPrWzSQuDQdmVEnhJ38AL/RM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2qL3aJlwX8dY3EMOyIG3DqLy94CGJ+XhgRpCzxZefjc=;
        b=vrEY6LbJKyL4at/3QAfA1Hp+D0jmi+l0xK1GxGol/m5Vn3JivXEHLn0D9b+SEjO0mt
         WambmLqFiw1gMcvILw93APq0v5KrvxlmM3kst3tVNcU9ZoVroaSHdJGeOcKdcslxUpWw
         ieMXnffwlBO1WldqYFKsGBST1gcWs7sWO/0dTEgxmLClvtfyly5DWoXbllxGOT6/lU9t
         gbkfoVAO0TH4WohWMGGvZodVT0tC0xJQt5OGFoHxSpZmM0Owhz1cz0fzG9fPfCwUEnYZ
         5Hy4w3Ao+AA7Dm/iNBymQsRpbEN20rTWTsPML99sxIkwGA4A/QDUssh2m1T6sb5yPmgZ
         Qmzg==
X-Gm-Message-State: AOAM532fkgfRtbXywpFfI4HmkXcg913n3uCQx6QKeS/Ffwnl9zRH+zru
        xlY4DPVgZK1ahKSyRUffnCVyYpdWVM1fFpVPiP5BmQ==
X-Google-Smtp-Source: ABdhPJwJkl1ktm+0RRD+4A3ffkUyHF40twpcaLf6sAOrP1lQJkHSVuVEl/RNIJ3prXtUSynKIIHCOSYvpxH6t1w7HjQ=
X-Received: by 2002:ac8:73c7:: with SMTP id v7mr59364qtp.84.1633719461286;
 Fri, 08 Oct 2021 11:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <20211008175913.3754184-1-kuba@kernel.org> <20211008175913.3754184-3-kuba@kernel.org>
In-Reply-To: <20211008175913.3754184-3-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 8 Oct 2021 11:57:30 -0700
Message-ID: <CACKFLi=X=yTKVD1Re5yyxLzHCgwsZu8Q60vLA94O4j1NywzW_A@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] ethernet: tg3: remove direct
 netdev->dev_addr writes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 8, 2021 at 10:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> tg3 does various forms of direct writes to netdev->dev_addr.
> Use a local buffer. Make sure local buffer is aligned since
> eth_platform_get_mac_address() may call ether_addr_copy().
>
> tg3_get_device_address() returns whenever it finds a method
> that found a valid address. Instead of modifying all the exit
> points pass the buffer from the outside and commit the address
> in the caller.
>
> Constify the argument of the set addr helper.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Thanks.
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
