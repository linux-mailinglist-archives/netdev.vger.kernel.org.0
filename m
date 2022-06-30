Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41C75617EF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234707AbiF3K1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234961AbiF3K1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:27:16 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B3862ED
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:27:15 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id r133so18679224iod.3
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ksJlGSU+Oe8kweIYn41JlqAp4CweuSkZPzJhuH9GTs=;
        b=nkPUubwmzF+XVw6j5W9Yv0mk2foSwfFUQbbYwCubn43HxaVDQzcbonfJ3cLqA1mMIb
         I27wk8BS+eG0j1pr8ckHuE7Cgu4gFgEO2DpNAYJv5SICOqi+xP68uhImFl8v8T2vFkhd
         lr76jGCPX/HUZrdr2Wbd45Nu+riPWr0Gz/gED8TDFci0RsBXiJDdXyD/rBaKAmshjGYg
         dgnkJ+JGL7kwGqne550Ejhf/ir00/hhnx0MNTh8bTPGpKNf7JLuQ7VSWoRXVoqjzqT3S
         j4ADpFzeapIZ+WZ996a7cUUUVTIK+jt+xc5l4ruMisbHlZxuKv3zyzvGAHkatcgFJ2MS
         xSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ksJlGSU+Oe8kweIYn41JlqAp4CweuSkZPzJhuH9GTs=;
        b=1mpsT/Xga+SSRs7RBsojlaYlM3GSynfcb0fQrSdIDaEgOAYqFj1zFFrMHYDwk/Hz+e
         f9Tva9/qAuyIaGDsDre27DwUE088lEseY9IWwejSh+ry2byqMTEpBIliopUqvJHg+2OW
         qLokukpLfQXJgpjkaQVDxzdwpoDGQptxhI+f16wPK1KJKMG/Tx4NeSsnZVj6d+VZSRf4
         Wc+CyMitWLRI+flLo7+U/IRry4CTjTKofrRoKAPHTiN/ExtBo6zqnXwYt1G9hsPwBN5V
         diS8dvtW5VptgAuIRtFooXv6wsN7qmGAThP4BBuVGM4aD0thGiE2lTtMVWGhf+W6g9Xu
         PXLw==
X-Gm-Message-State: AJIora8Lh5PS178kSwpKmHwBUqTNLHLCBR4wT06YC7G2zWhncsClIthq
        zU1NkMc9TeCj4nRQbgcdi77gJYhasIgIoYRuAg0/3g==
X-Google-Smtp-Source: AGRyM1tzD2OBYBKtXrqVoPDnvIIeh++5FfK2VLBFXwBqfk+v91OGpMYM18olH+BVZVtxA90kyqifcwIlewfrHY0MY68=
X-Received: by 2002:a6b:fd13:0:b0:675:3114:23a0 with SMTP id
 c19-20020a6bfd13000000b00675311423a0mr4287684ioi.54.1656584834366; Thu, 30
 Jun 2022 03:27:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220629181911.372047-1-kuba@kernel.org>
In-Reply-To: <20220629181911.372047-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Jun 2022 12:27:02 +0200
Message-ID: <CANn89iJLPPeOsoGCaYxnDMHTfcJbTOXeJEJNxLj40D=310CvsQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] net: tun: avoid disabling NAPI twice
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        Petar Penkov <ppenkov@aviatrix.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 8:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Eric reports that syzbot made short work out of my speculative
> fix. Indeed when queue gets detached its tfile->tun remains,
> so we would try to stop NAPI twice with a detach(), close()
> sequence.
>
> Alternative fix would be to move tun_napi_disable() to
> tun_detach_all() and let the NAPI run after the queue
> has been detached.
>
> Fixes: a8fc8cb5692a ("net: tun: stop NAPI when detaching queues")

Reviewed-by: Eric Dumazet <edumazet@google.com>

> Reported-by: syzbot <syzkaller@googlegroups.com>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Cc: Petar Penkov <ppenkov@aviatrix.com>
> ---
> CC: ppenkov@aviatrix.com
> ---
>  drivers/net/tun.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index e2eb35887394..259b2b84b2b3 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -640,7 +640,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>         tun = rtnl_dereference(tfile->tun);
>
>         if (tun && clean) {
> -               tun_napi_disable(tfile);
> +               if (!tfile->detached)
> +                       tun_napi_disable(tfile);
>                 tun_napi_del(tfile);
>         }
>
> --
> 2.36.1
>
