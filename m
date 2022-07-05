Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7765567593
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbiGER0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 13:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiGER0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 13:26:22 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8275920181;
        Tue,  5 Jul 2022 10:26:21 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id z21so21657518lfb.12;
        Tue, 05 Jul 2022 10:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0pQ6iR1EUoNTK7xjFYRM45QP5J5vl1BP+iXYidiRQmM=;
        b=SZoANr5ucaa007kirol6HgWRLWmSNZtzohchEqusEZPS5tWh7f2pnJALJ1QbcNz+nC
         ChfyPglkvPmoJ60XGHMo2yEmVHG3lgVFygPWFpmmgV16JwlFZB9hvN07O8oD6v8K9IXC
         SpzmazvCWv/n2cmmPXuSedj94gOglgsSgflmhWTckAw6+45KsCLswkNvVMWcaZzILPcc
         yQxTRSL+yH0WxL3cFBj5OFrTC/SXuUbhlb0GA5/URMu3N4k49BEt2SEswovawa7JwgD3
         D4lQeueQBkc2iMQRmwL/p+MlKS2Hmsmq9+c++giFQ0h0zo7VngJ4Wl6gSPBtHBIyqUll
         g4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0pQ6iR1EUoNTK7xjFYRM45QP5J5vl1BP+iXYidiRQmM=;
        b=zfCwByr9AG6MWZfYCweB+JQp+OihX/Cbf3d22AsNSbp0Q59u6HYznPisGmVaiGTprh
         /SliYuAalRGO/ec1C2U1m+iQoPXlt9k7CskkonM+EuBR1u44MC0Nacb2cb7ekjRHS1zr
         PvRiUfkj6tqXFYF97en2hCoHxuxv1asSrB7vEJafsyCp8d5gxkBO7fgKQlngL6em6Prz
         b0dGOgEH8oC+kvcq1TeySqxCUj7bL4i9Yi1MQAoE4J0jNjQw7TlRyZ/qw1jvJosjqVKS
         B8abM58QCVcVLv80lkKAhXcVJIJN2d83cLeLjvUQxLfEq36rV8Jf782b6OPfTpKihiI5
         07nQ==
X-Gm-Message-State: AJIora/QbyaSMRQBpMSSz5iQLZFBLHFwfytwwDM/gSvbGBD6v3H79rko
        sq8Z+bhAl0tZeYruPqPuYBAH6PmRTvD+Xsmc4eY=
X-Google-Smtp-Source: AGRyM1tWng4bLriXfSk1WSsMNfdidVcDNLbP6dXIv1cqB7TlocrcpUtRMfF3kWR3xpVQZCPeuLFHdw9cxRVzUrFdews=
X-Received: by 2002:a05:6512:108d:b0:481:6f3:e641 with SMTP id
 j13-20020a056512108d00b0048106f3e641mr22196430lfg.251.1657041979515; Tue, 05
 Jul 2022 10:26:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220614181706.26513-1-max.oss.09@gmail.com> <20220705125931.3601-1-vasyl.vavrychuk@opensynergy.com>
 <20220705151446.GA28605@francesco-nb.int.toradex.com>
In-Reply-To: <20220705151446.GA28605@francesco-nb.int.toradex.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 5 Jul 2022 10:26:08 -0700
Message-ID: <CABBYNZJDkmU_Fgfszrau9CK6DSQM2xGaGwfVyVkjNo7MVtBd8w@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: core: Fix deadlock due to `cancel_work_sync(&hdev->power_on)`
 from hci_power_on_sync.
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Max Krummenacher <max.oss.09@gmail.com>,
        =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        max.krummenacher@toradex.com,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jul 5, 2022 at 8:14 AM Francesco Dolcini
<francesco.dolcini@toradex.com> wrote:
>
> Hello Vasyl,
>
> On Tue, Jul 05, 2022 at 03:59:31PM +0300, Vasyl Vavrychuk wrote:
> > Fixes: commit dd06ed7ad057 ("Bluetooth: core: Fix missing power_on work cancel on HCI close")
>
> This fixes tag is broken, dd06ed7ad057 does not exist on
> torvalds/master, and the `commit` word should be removed.
>
> Should be:
>
> Fixes: ff7f2926114d ("Bluetooth: core: Fix missing power_on work cancel on HCI close")

Ive rebased the patch on top of bluetooth-next and fixed the hash,
lets see if passes CI I might just go ahead and push it.

-- 
Luiz Augusto von Dentz
