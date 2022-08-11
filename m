Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E026658FE90
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 16:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbiHKOvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 10:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiHKOvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 10:51:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637C1BC1B
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:51:45 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bv3so21609651wrb.5
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 07:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EB0G1pbzLa52qiVyCMsUbpkBl1VHpE7Rkuyo6w2vim4=;
        b=DC9vE8+OJwSmBS+mIN9sayw8qFVqcAehDME4rzb7pBkt4ZkbGxfba8ljjPlVq2AcCo
         yNQPBrJ0v9hUmKPg29aHifILBW112HYxkKCoDXamwh6Ikw+a6UKNs/MZLCtVwjPaaZNC
         Vxl1UrigG0H0DcI1MCPzIYkjcxB8MF5w3sTIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EB0G1pbzLa52qiVyCMsUbpkBl1VHpE7Rkuyo6w2vim4=;
        b=5mv6LtaIDPZFAql9Dtacbks2ZIGLcclEAKoRE2KwXzuN/FlidVEJ7NDUc9Rysyq7FP
         RRPXc1WVlRwIGiI4VdZRTKAaIRl3owrw3+Hzc8l6HChEXEcV9laCfUS1P6QtVYvC1Jr5
         fdG6Q5wXlPMb2UhNmtYzVKuq+qcDuCtpaFJto0hDFPxLoLyX1EwhBjACS5LMg3wbaJZD
         qiDbt/mZKllpHBum+NvkdypEMYaBuwrKeS7nJY2Mo67EWiiEj49LPA7RSQ2cWKbqM/mf
         jjX52NN0uhrVGAWHwwT7+wNnbqwJomQ6C1CKj8U/V/QhcL1qomZOgezsCj9urlQdUaNp
         S3LQ==
X-Gm-Message-State: ACgBeo0gyTysOn+g/ZhUmEnUq37Uwu0voapPZFFFqIl4Lc+4k26Bw/nY
        BCsP+W1W/ZBe0Ij7cXUoi7iDYzyhdUXmyqKxgn+8lQ==
X-Google-Smtp-Source: AA6agR7sPvYTwJB5RFx+N4uFLzEivCGWy8vpaTZ2orkldvu6m2tHz/BR+9dR5YnABPIonaZLbWg/QXj7NKC1KOFlG9U=
X-Received: by 2002:a05:6000:1689:b0:220:8a04:69f6 with SMTP id
 y9-20020a056000168900b002208a0469f6mr21543434wrd.357.1660229503934; Thu, 11
 Aug 2022 07:51:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220810160840.311628-1-alexander.mikhalitsyn@virtuozzo.com> <20220811074630.4784fe6e@kernel.org>
In-Reply-To: <20220811074630.4784fe6e@kernel.org>
From:   Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date:   Thu, 11 Aug 2022 17:51:32 +0300
Message-ID: <CAJqdLrq6D+w=H_9t8A7s0c96GyitHFTnY0a2QvUrVeuxaUdtAQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] neighbour: fix possible DoS due to net iface
 start/stop loop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, "Denis V . Lunev" <den@openvz.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        kernel@openvz.org, devel@openvz.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jakub

On Thu, Aug 11, 2022 at 5:46 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 10 Aug 2022 19:08:38 +0300 Alexander Mikhalitsyn wrote:
> >  include/net/neighbour.h |  1 +
> >  net/core/neighbour.c    | 46 +++++++++++++++++++++++++++++++++--------
> >  2 files changed, 38 insertions(+), 9 deletions(-)
>
> Which tree are these based on? They don't seem to apply cleanly

It's based on 5.19 tree, but I can easily resent it based on net-next.

Regards,
Alex
