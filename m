Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D1E433D6C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 19:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231226AbhJSR1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 13:27:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbhJSR1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 13:27:34 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4E2C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:25:20 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s4so7681113ybs.8
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 10:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jIGfRjSC+R/JXRKo6ClL56xe7HbxJ8iXJz7XLWL4MUM=;
        b=GaUrvUoPFURFn1a1YcR1lJciG0EzTW4p7Cb5ApXO7jkQOQbYwkt1BoMNvRPZJLRpMe
         mlsGhPiVSCY5c4lxxppD3YQmml6JcBxViwdNHX2MoPM1z9uy56fYeblDOKDSLC1uIiRT
         yRh19K8eT1uh+jQ0DZ9UTksDQr+KF17/WDe/XHc4wqgJaJ6tgnl3aAiOr8DIwbZWGeTy
         rO1mDeTG5V2dAKPSafoI5EulhDq1YXOcgDANmm08Mmxpjhg5m4WQKN3+nHVlyBUZTYDe
         hVdyiiTSKrCpLiflNe+WmvePcE5KWSlEvi8PD0zjA+phiCLFCYech3dZ3rMPQCAHHzsZ
         JYbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jIGfRjSC+R/JXRKo6ClL56xe7HbxJ8iXJz7XLWL4MUM=;
        b=ico/mftfxSmmrxXPb7ifx3epkC2rftrp/jdd4pPdYC3AHtoVc0LnNBH1cREERAZqKZ
         2NFm4o1DaPNGWfc9D8KK6+vjLWeBrMDR5cmVct+3MIkd6LzO70ZO7CD2qPJEBt83f8M9
         HODal19zwsoVtFTRBqQW1U2vAnLU6fN3VCCAB6AEiEh23T0yqwiJXqt5NqIb3wNM2GEs
         z1Mx32SAa4IfTL35xLo3Mzr9iDl8VKCGH7LLBgFsF0Wmgk+0sYvhBSV9pzNVDgD+Ekce
         Kg6YNGZURyt0uQeMdh5kLpfL2c+ZQ2Ph7G6KDU08gAO3KKaQRiNcXcYG9dz+xI7qftEC
         FdFQ==
X-Gm-Message-State: AOAM532IuLACf5ni/ty84BfuUiewNrLXKzbupKUWFa79p95uz0L9hLa8
        2DSxvU/f+saEs0gYy5H5Uun/E79jkikXM3yJ+BH9UA==
X-Google-Smtp-Source: ABdhPJyqczJYG8hRK0zJCIvTawHJJI1Jhe0bq2e8ryvlNQRq4S9Yc9JIxWjzM9ek4u9dMaUuhanuC1qF6O1iyA2UH10=
X-Received: by 2002:a5b:783:: with SMTP id b3mr37721825ybq.328.1634664319653;
 Tue, 19 Oct 2021 10:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20211019171534.66628-1-toke@redhat.com>
In-Reply-To: <20211019171534.66628-1-toke@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 19 Oct 2021 10:25:08 -0700
Message-ID: <CANn89iKmR3XTjcHkpk=woDdED7YPi=8jNAOpKvvcjr9pY3bo0Q@mail.gmail.com>
Subject: Re: [PATCH net-next] fq_codel: generalise ce_threshold marking for
 subset of traffic
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 10:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
> so it can be applied to a subset of the traffic, using the ECT(1) bit of
> the ECN field as the classifier. However, hard-coding ECT(1) as the only
> classifier for this feature seems limiting, so let's expand it to be more
> general.
>
> To this end, change the parameter from a ce_threshold_ect1 boolean, to a
> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is appli=
ed
> to the whole diffserv/ECN field in the IP header. This makes it possible =
to
> classify packets by any value in either the ECN field or the diffserv
> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
> INET_ECN_MASK corresponds to the functionality before this patch, and a
> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
> match against a diffserv code point.

Please include what command line should be used once we get iproute2 suppor=
t.

Thanks !

>
> Regardless of the selector chosen, the normal rules for ECN-marking of
> packets still apply, i.e., the flow must still declare itself ECN-capable
> by setting one of the bits in the ECN field to get marked at all.
>
> Fixes: e72aeb9ee0e3 ("fq_codel: implement L4S style ce_threshold_ect1 mar=
king")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
