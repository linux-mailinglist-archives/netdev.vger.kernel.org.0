Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2589C6D76AB
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 10:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbjDEITH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 04:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbjDEITD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 04:19:03 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ADD4C22
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 01:19:01 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bi9so45543589lfb.12
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 01:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680682740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kR2nFpKlk9WSXCvvRza5xwx32GkJOMTehJRh1OBGzy0=;
        b=bHSAsYUuA9yAUpeqRHJ7dt6CgSyYwxLjhcwwx8L+Y1fLrAP1wX35hqTWqdBvEDxUNs
         7R+pXSpDHrmUCaIwSnByPq9lXwQ6v2+jS9W8yz4OOlGHSTUYW4Dewld6ASlYSDospobC
         HhT2qD6A5ljNOTs+SybnEsQM+CpIzYOxe+sEonfZ5Ag9Ea08PjG+PufRYATCRex28J+w
         D3VBkpCIvnaCyLpGCrfpBA0lt4pCS9d1FUrEOPbSOPUmcaVDLbp90OdAWARDQ6vXckil
         Om2NO8VSF7cdHP/jE5n536RVkWCeXlM5Grkfszo1jYpnHaZAJwWkLJMcyibC20pwy867
         KjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680682740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kR2nFpKlk9WSXCvvRza5xwx32GkJOMTehJRh1OBGzy0=;
        b=Ptr7AK/gKHaqUG1vfeBp/fJHS1MsNtSFvwFf+cM2PGevUUGoBdlM8D61bh8Yq09iCi
         3h+ghLFOalVdHtWtoPdijfAtZoKX7ASKK9IkAfZSI058+LCkAZizVrOMRBinigCbVVXc
         rOq7gzVAqLIW6k3vRAXznMw/y5tGIeWCw7f3sq/Wq5dzZEAuiEgJK+12l0WHPdyeKRNy
         FeyjsUdVtlPheRM2j1c4h80trrv5mgtHpi3yN+2iN5V8x6u4E1eOaudgcPL2kArdaa8q
         UQewlVz+XqxJoGtD9QHvjBMhyhvEN496qKFX98wYQEwDw5ru7kvDdinqTgR8br/IjWM4
         lcUQ==
X-Gm-Message-State: AAQBX9fiTSL1p+1Uu4jQ2qsT5UoRGVSZUJsox0d9GtC962XSiTPanS4C
        fmY9UmCmctbVAlMoJEWFsx1aWX4TVFCNY+n84sE=
X-Google-Smtp-Source: AKy350YJ+J7i0yOufQEQyXc/AIZNnZvu47n+k1GzPJILm4f3Ir9Vw80jW7NN0/d2BPdxMF/eG7HuY0X+FUuw0rmSPmQ=
X-Received: by 2002:ac2:5519:0:b0:4e8:5371:c884 with SMTP id
 j25-20020ac25519000000b004e85371c884mr1651544lfk.5.1680682739926; Wed, 05 Apr
 2023 01:18:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com>
 <7331d6d3f9044e386e425e89b1fc32d60b046cf3.camel@gmail.com> <20230404182116.5795563c@kernel.org>
In-Reply-To: <20230404182116.5795563c@kernel.org>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Wed, 5 Apr 2023 16:18:47 +0800
Message-ID: <CAKhg4tLnSOxB7eeMqna1K3cmOn30cofxH=duOPLRs0h+59j01w@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 9:21=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 04 Apr 2023 08:51:18 -0700 Alexander H Duyck wrote:
> > I'm not quite sure I agree with the fix. Couldn't we just modify the
> > check further down that does:
> >
> >         if (!skb_cloned(from))
> >                 from_shinfo->nr_frags =3D 0;
> >
> > And instead just make that:
> >       if (!skb->cloned || (!skb_cloned(from) && !from->pp_recycle))
> >                 from_shinfo->nr_frags =3D 0;
> >
> > With that we would retain the existing behavior and in the case of
> > cloned from frames we would take the references and let the original
> > from skb freed to take care of pulling the pages from the page pool.
>
> Sounds like a better fix, indeed. But this sort of code will require
> another fat comment above to explain why. This:
>
>         if (to->pp_recycle =3D=3D from->pp_recycle && !skb_cloned(from))
>
> is much easier to understand, no?
>
> We should at least include that in the explanatory comment, I reckon...

Sure, the idea of dealing with the case where @from transitioned into non c=
loned
skb in the function retains the existing behavior, and gives more
opportunities to
coalesce skbs. And it seems (!skb_cloned(from) && !from->pp_recycle) is eno=
ugh
here.

I will take a closer look at the code path for the fragstolen case
before making v2
patch  -  If @from transitioned into non cloned skb before "if
(skb_head_is_locked(from))"

Thanks for the reviews.
