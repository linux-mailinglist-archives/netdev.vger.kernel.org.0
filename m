Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C8F30CF54
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbhBBWru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbhBBWrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 17:47:48 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D848C061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 14:47:08 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id y9so10931777ejp.10
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 14:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N5mpOeqQqew1wJ7DPLwydY45PLikXrvhq24BvEECL1g=;
        b=nXX70j+P5h+qaeQrj581Cke2lQeM6GyaHUbBSnBE0mXBHw0eCQfflFi/TLNB2u/5rd
         v8SJaK5M0qKCsg1UQv3ycam68Qyro67ZA/lejrreKxAp1SJ70Xr1HmBAQFvn/mFo1H8L
         MHFdVfBNBd8XHJH8zevOPeUenNkwM/+FWlnOQ6GLSEyxZYZ4GWuv1vEmAC6/WjlNnIuk
         KBeh8kT5F72YVBfAWABe1NMzduwPp+c/Rqp8mK998JfG4BDxF+bptkes5KXnTAaCfb0K
         aTnRr4mdobb1ljeBikP50X+NT4QfVQ6obCHiyB45oNJi48O2oJoHq3f0JPfWJNfODCjq
         hXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N5mpOeqQqew1wJ7DPLwydY45PLikXrvhq24BvEECL1g=;
        b=DMscbLDBcBMAjUIBGrm27N8b1Ehq9aZD9agbzc5h4Nb/KoGS7O9rpaVgo2+9Fkp9wL
         JlT/Yt9XB1FA3JQ0zE4/Y5ZrOI7K3Vwo7bTZRpGep0Y4G7AzIWeyn5F6hTVePnmB3Cgn
         n2/DUxqWJ8woEMB/K2ZKdDN1u3oIimMV/yFsGqLzpA18kMzevZTxWayoy6Vz+3PxifpJ
         m70OThNvzTLTIesNktk00fPKlx85wfpBzJMI4N6Dy5cmc8rygG/0U3WlxXYtBalwPe6T
         fjyroXLN7Q2EVlEjTkIz5N/sYwAufqS76Q9LcumArGdYhTA4XEUD6MSk7GE4DVWaOCNX
         GYiw==
X-Gm-Message-State: AOAM5330pFf59uXRXuU4SfrSvWIYICzrv3BOD9pvTbQWb8QHIaJDgMyn
        hsbKrTW22B4yhB1Ro1IxBWXLwulYUow2NZCRScq9gByz
X-Google-Smtp-Source: ABdhPJynF0O4OHjiPuEB3h7LJ9mzodFOGP6Kgj6LmgM7uAjpZYd1uqK01H96TPOkukzXYOUHjeW0KhOm/HpNEvPMBPU=
X-Received: by 2002:a17:906:fc5:: with SMTP id c5mr225115ejk.538.1612306026939;
 Tue, 02 Feb 2021 14:47:06 -0800 (PST)
MIME-Version: 1.0
References: <1612282568-14094-1-git-send-email-loic.poulain@linaro.org> <1612282568-14094-2-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1612282568-14094-2-git-send-email-loic.poulain@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 2 Feb 2021 17:46:29 -0500
Message-ID: <CAF=yD-KqK-5cMJ388aBUhCinZfnxmwdO3FWuZUrgZSAh9F7MGg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/2] net: qualcomm: rmnet: Fix rx_handler for
 non-linear skbs
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 2, 2021 at 11:08 AM Loic Poulain <loic.poulain@linaro.org> wrote:
>
> There is no guarantee that rmnet rx_handler is only fed with linear
> skbs, but current rmnet implementation does not check that, leading
> to crash in case of non linear skbs processed as linear ones.
>
> Fix that by ensuring skb linearization before processing.
>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

Acked-by: Willem de Bruijn <willemb@google.com>
