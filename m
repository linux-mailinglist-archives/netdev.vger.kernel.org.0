Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4665C55AEFA
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 06:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbiFZEpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 00:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233773AbiFZEpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 00:45:12 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F35113E36;
        Sat, 25 Jun 2022 21:45:12 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3178acf2a92so57913717b3.6;
        Sat, 25 Jun 2022 21:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfondrNowJy2MyDkZH1tseDvQbcDiYCbfVByxBjiMa8=;
        b=Clz/bnpubUuCNK5azdaWhznKmfR+aDJZJCingFwsA19xbp8jHaox0rqFxqXxvWozY5
         5FnmHwuxopztUt0Ezev/LszePHdlvV41NzFTcvSkKy48ER1Jw5qRcKAC/scPW/CW7/h5
         8WDCKE3vd6s6BbKLSQYuIcNV3LwKV16CrLGYTGIDHajGex3MVCt4XkN60RvZxQe+L63G
         Vj7uxs328NBMqhuWbBJwgcjMneBw3fJk4ABpYy3bkx7AzJUc2yo7ivmxc+rVF7gJjcg8
         X7YDz8+mr+/E6/RP1kG64TVFLC6E5FSPHY7mwC4LXmQGAMqws4+vsaSOU47+kp5vzxGO
         uxyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfondrNowJy2MyDkZH1tseDvQbcDiYCbfVByxBjiMa8=;
        b=NqcUFtfV0qQ05VlK2rkQFqmQczNNjgObSMbbz9rq1Q5dTlM879bDWMlxph7XNVNZA+
         00yazCfECGhH9+emrjFPgJnfCdm9CJRNhcx8DNjiKNymMaY9Zb+cYdVjFP3iv2oypwZg
         y3IaCXE7PlazrVrdOREac9B2HoP/DS91a2rDYv/QmYQB2LCmk1Atx1kVFk9KWsiVddKy
         DROqZIVfRh0/GKfDRun+/SaHVSEelKlNbakphHuiXTSKgah0rMIwLvt8oRZHhFSEprfH
         IE+vDuTmWeThZMuKF53FS+Q1CrOPwSZ5obH7FRE4Cgd2u2QD/2tqdtDR1X6GN4kXISnJ
         3vEA==
X-Gm-Message-State: AJIora9y5nlUZAoHDt7KV9Pg75nbuuwK4Cu9nFbmASF2epFHO4g/psZ/
        uVlotLc7nC7lPbaS3QM617QMCICeYgJVrOA1Pfs=
X-Google-Smtp-Source: AGRyM1tQKA39vvEyfFnxgVUxhLji4zj6DOAxlGntbkdgcS/NyCI5P0h8PG9pJg9IsmpRL53jPWTDf8Ws+9yUUU+Lf54=
X-Received: by 2002:a81:1315:0:b0:318:1841:8060 with SMTP id
 21-20020a811315000000b0031818418060mr7938630ywt.452.1656218711305; Sat, 25
 Jun 2022 21:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220623074005.259309-1-ztong0001@gmail.com> <YrQw1CVJfIS18CNo@electric-eye.fr.zoreil.com>
 <20220624114121.2c95c3aa@kernel.org>
In-Reply-To: <20220624114121.2c95c3aa@kernel.org>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Sat, 25 Jun 2022 21:45:00 -0700
Message-ID: <CAA5qM4Aq_2HSxCgaHUgZX9C3E0OCPT4tN-61-MZP1iLXCbF-=Q@mail.gmail.com>
Subject: Re: [PATCH] epic100: fix use after free on rmmod
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Yilun Wu <yiluwu@cs.stonybrook.edu>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 24, 2022 at 11:41 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 23 Jun 2022 11:22:28 +0200 Francois Romieu wrote:
> > Tong Zhang <ztong0001@gmail.com> :
> > > epic_close() calls epic_rx() and uses dma buffer, but in epic_remove_one()
> > > we already freed the dma buffer. To fix this issue, reorder function calls
> > > like in the .probe function.
> > >
> > > BUG: KASAN: use-after-free in epic_rx+0xa6/0x7e0 [epic100]
> > > Call Trace:
> > >  epic_rx+0xa6/0x7e0 [epic100]
> > >  epic_close+0xec/0x2f0 [epic100]
> > >  unregister_netdev+0x18/0x20
> > >  epic_remove_one+0xaa/0xf0 [epic100]
> > >
> > > Fixes: ae150435b59e ("smsc: Move the SMC (SMSC) drivers")
> > > Reported-by: Yilun Wu <yiluwu@cs.stonybrook.edu>
> > > Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> >
> > The "Fixes:" tag is a bit misleading: this code path predates the move
> > by several years. Ignoring pci_* vs dma_* API changes, this is pre-2005
> > material.
>
> Yeah, please find the correct Fixes tag.
>
> > Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>
>
> Keep Francois' tag when reposting.

Looks like drivers/net/ethernet/smsc/epic100.c is renamed from
drivers/net/epic100.c
and this bug has been around since the very initial commit. What would
you suggest ?
Remove the fix tag or use
Fix: 1da177e4c3f4 ("Linux-2.6.12-rc2")
