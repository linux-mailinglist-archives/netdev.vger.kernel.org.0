Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2816DEC8D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 09:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjDLH1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 03:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDLH1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 03:27:30 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AA40FA
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:27:29 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id z8so15316468lfb.12
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 00:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681284447; x=1683876447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=teLE11VKLwJ34mPOP5jIvAn/hsTwOb/R8bAYuIy2y6c=;
        b=ngrKYIVQXlMYTrhq48Difd4ZrF3vHuQB2I7+milmahF/gONYI8h5Z+gm+Y5kHoi51o
         CWMd9KYAc2PueLXQIh5uLdJFXr421HpfyttsPk+KpJGMOAhNw02MhKARJjU4RGaQFBQ7
         Ss5+ejDnDpCl87zofDwdLra/nCKdxeJl7xQFQAeBIY7FcfCBmME8euAh8ooJhEM7a+zp
         0hU3ZjSaM9t/Tv7yuiy4C7qY4GdqKCMTLdN8gSyiLvC4IvB+bvj8dvvhQZiGEJGnCG24
         Rf5lFgxajJbTsHuhSU2dm6begQzFo89855pX1XdSgvjZX5K5KWtSwKAIwQL1mfTCusb7
         ZD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681284447; x=1683876447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=teLE11VKLwJ34mPOP5jIvAn/hsTwOb/R8bAYuIy2y6c=;
        b=xYjvOW5D/w8ZDbfpTbPV3IYkTr3WtYZlYlgx91dynaNdcUINRrrJi8p6ra1JEi9tGc
         B8268DpZBencjVKsdZAGABoQsH+rOoqrmIZ4HiBQcPqOFqfWQn+hRrhyNGQBYYyaFSNq
         27sfXJ7fDZEFvKrOy0GOmmKv1BBn0XH6xSDHscryR1pPwMwVEKNaDkzTNgwFjlu0J5to
         I9n5ag3/fjUYQnp62iaiQ4/7wK8TBraqS8orGNTI616BBbXfySuxnbKF1khbVTMVzhtW
         XoATOEAf5JFwmTcXRuxwFaY14nojwjnaotubV1bcLlNtvc7JDZ6Mm4nBHc2q93HDPp2S
         VZsA==
X-Gm-Message-State: AAQBX9euWdLNuuxkQyDKYNrDgTu7NE2O4AaPQpWhH94o76A8InlQc4CU
        IeIy3ZazRRXTBRn6UktwQxmi6OUzNV+Kt8qDu8o=
X-Google-Smtp-Source: AKy350ZdoUW5GfxdM5fBYiPAKS17cZoOw9OR4wz1cv9xPVw4/WtVj4E/SgajzJJSogj9TOCVNunJS9zRZ9jnd+/1JY0=
X-Received: by 2002:ac2:5681:0:b0:4eb:3f84:8082 with SMTP id
 1-20020ac25681000000b004eb3f848082mr3845550lfr.5.1681284447312; Wed, 12 Apr
 2023 00:27:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230404074733.22869-1-liangchen.linux@gmail.com> <20230410172626.443a00ca@kernel.org>
In-Reply-To: <20230410172626.443a00ca@kernel.org>
From:   Liang Chen <liangchen.linux@gmail.com>
Date:   Wed, 12 Apr 2023 15:27:13 +0800
Message-ID: <CAKhg4tK74HRuZ8MgAG1t6oQ+CV4o6y3QLvuYOkWUPCZMHjUyxw@mail.gmail.com>
Subject: Re: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sure. I have addressed it and submitted the updated patch for your
review as v3. Thank you for pointing it out.

Thanks,
Liang

On Tue, Apr 11, 2023 at 8:26=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue,  4 Apr 2023 15:47:33 +0800 Liang Chen wrote:
> > -     if (to->pp_recycle !=3D (from->pp_recycle && !skb_cloned(from)))
> > +     if ((to->pp_recycle !=3D from->pp_recycle)
> > +             || (from->pp_recycle && skb_cloned(from)))
> >               return false;
>
> It should be formatted like this:
>
>         if (to->pp_recycle !=3D from->pp_recycle ||
>             (from->pp_recycle && skb_cloned(from)))
