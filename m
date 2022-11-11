Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06A176253FB
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiKKGnx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Nov 2022 01:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiKKGnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:43:50 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABCD5B590
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 22:43:48 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id 6so3701367pgm.6
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 22:43:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FH0c4rfmuxvYpFI19z+gns6kunPl+UaUJmTNoDhZsQo=;
        b=1eGoz0CXNj4pdmkH4/Dm357u0yLG6CB9zqBHN1IppigU8RcpkoPzYitwFWCFJpij66
         CtClJxYJolAr8lExPNnXCDWeQT8Ypc78kuu8vlxu83gsw8T1ASG7JQWlSn260oNiqIto
         D754oEZ1LZ5CkBvTbUixpP7hjOEi0OvmiozryaUSLhJy6h+HIKhjg7p2MHY9rOeP3CXS
         NLKzYKJFKakrCtJIgZbmODIEEkvMQZ20UTV0ofyc/dnEc3YMzC4P52opeC+A+Bd0WhjO
         1aohtUEhhXFj7HRbHXDsiZ81V6NuKxk30hPuPkFwHLzkONYd0TNyupOWtTF0OoAKPcXo
         2fQQ==
X-Gm-Message-State: ANoB5pn57cMKh2aTbwBET3b31LBnBJyNhMybsetlG5dAOeolw5Y9bNRV
        7wQxp0HP30a8hPfAuQXPGRaFv+9iXU8CUCESkwk=
X-Google-Smtp-Source: AA0mqf7uSGh0CT822kOSE9Xu5zohrTJP/gTTk0bwb4E2B8TvYTvGVX80nXq7szlUgw8ZzC5TsGM/4Eom+KuC1xmKctA=
X-Received: by 2002:a63:4d43:0:b0:41d:c892:2e9 with SMTP id
 n3-20020a634d43000000b0041dc89202e9mr454319pgl.457.1668149027733; Thu, 10 Nov
 2022 22:43:47 -0800 (PST)
MIME-Version: 1.0
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal> <20221109122641.781b30d9@kernel.org>
 <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
 <Y2zASloeKjMMCgyw@unreal> <20221110090127.0d729f05@kernel.org>
In-Reply-To: <20221110090127.0d729f05@kernel.org>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 11 Nov 2022 15:43:36 +0900
Message-ID: <CAMZ6RqKVrRufmUsJ3XuzGhc3Ea=dEjChu3rd7Xw8LZ-SBrsSUw@mail.gmail.com>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri. 11 Nov. 2022 à 02:01, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 10 Nov 2022 11:11:38 +0200 Leon Romanovsky wrote:
> > I will be happy to see such patch and will review it, but can't add sign-off
> > as I'm not netdev maintainer.
>
> Did we finish the version removal work? :S
>
> Personally I'd rather direct any effort towards writing a checkpatch /
> cocci / python check that catches new cases than cleaning up the pile
> of drivers we have. A lot of which are not actively used..

Agree, but I will not work on that (because of other personal
priorities). If someone else wants to do it, go ahead :)

What I can do is update the documentation:
https://lore.kernel.org/netdev/20221111064054.371965-1-mailhol.vincent@wanadoo.fr/


Yours sincerely,
Vincent Mailhol
