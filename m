Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC28457D2D5
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 19:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiGUR63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 13:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiGUR62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 13:58:28 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E108810F
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:58:28 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 6so4024400ybc.8
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 10:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hfAHnq6J3WpRzVusaMkitXLbpmQCK3LjlH7M+Xthd/k=;
        b=q0UqAbXtlOuBxz/V7cfOB+QVnbhh4wZ9ztVKEun32WaThJfKFQsFdrfhUW0dbXFNhP
         +bbZQhMzMhdNeLnfLgRJ0AuAb0Ul89iIqLBDQ1X1hey8PAMsba6I9IwNOUwxBOSNsL/k
         ZM0XKSCM7Bn7zhd71J8aiI0M6qCbFATexS07lbKR3UaRrogqkWgK6whzafFj+UtUP8HC
         kzY2U2rSygSy+AK3d/7KsqFj4qTh1UzeykbFM42OojHdMdw76PjUnp8IdvFtbrXMAMSt
         nQl+cOW03kgdIcFo76TGwxthHKQtLuWV7Zm2keYj97hdDGfx1T+eCLuRGD6wJcFMBZHq
         ORqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hfAHnq6J3WpRzVusaMkitXLbpmQCK3LjlH7M+Xthd/k=;
        b=j+nUHEHImj4nPnHDXOyluYWHspPh80TmKEmP29pGNAADcYsrM1/mkY6CDbsBWlN5Xu
         0FL1KP5bTVs2TgZJAb0wimPHSrsNCr9kuIm1NjSAT7DslCc3YvYkeXkXYNqqcR4BiSl9
         crnyuNOQwcyIcPbtbPsw/eCRp2llvmoadxx70pScwWnkJVCBfMBj67/vSuvbw9QPrOxf
         c02KNSGCl36qQ1m69Fwl0SwJ4+mDpmCbo6gf0PxdNJiRjJ26New9qtwlAFXzyIPCF9fT
         pfuy0jEL5ht8ZN01P9HxU/06nN3lvFi4sl+UuCApFGFweyykcmR2taXWkt06UFjDUswU
         CIUw==
X-Gm-Message-State: AJIora92lFOW/+pDfcF/HHfOPBGjsdnX4jVv0cMctMoMPIvUhHbjU/MD
        pVcXQvrXZ2vG3uCaX+nPQFYStmTCoFxTKaWBLQMiGg==
X-Google-Smtp-Source: AGRyM1tQX46WhI4a4TvytMjkeTHJqpEGoflecgqFrzKHc5nhY6abukPhshEJSm5Dhp/6lzEufplXPw/pdzNgx1jfjkQ=
X-Received: by 2002:a25:8142:0:b0:670:7a16:7b73 with SMTP id
 j2-20020a258142000000b006707a167b73mr14765805ybm.427.1658426307316; Thu, 21
 Jul 2022 10:58:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220720203701.2179034-1-kuba@kernel.org>
In-Reply-To: <20220720203701.2179034-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 21 Jul 2022 19:58:16 +0200
Message-ID: <CANn89iL7mkgn3NuEvdneJUc0=+NQUMG505tTCdcxwnBFY_a6ag@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] tls: rx: release the sock lock on locking timeout
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>, vfedorenko@novek.ru,
        syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 10:37 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Eric reports we should release the socket lock if the entire
> "grab reader lock" operation has failed. The callers assume
> they don't have to release it or otherwise unwind.
>
> Reported-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+16e72110feb2b653ef27@syzkaller.appspotmail.com
> Fixes: 4cbc325ed6b4 ("tls: rx: allow only one reader at a time")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/tls/tls_sw.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)

Reviewed-by: Eric Dumazet <edumazet@google.com>
