Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC2E565188F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbiLTBzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbiLTBzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:55:46 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575B4BFD
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 17:55:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id o1-20020a17090a678100b00219cf69e5f0so15006776pjj.2
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 17:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ag3KsmskPbk6tk2g6GqiHzhxAQ0uQQqhq13uPdkqemo=;
        b=KNwTVz5pnWhZy2X5Gw/sDPqmpXGMTA49B2a3HrcX2pjZ7GvFjofAc6Vf5xg2E3+KH+
         /uZsDalNar4SDrKLjT2y3siwBnd2TzxI893acbGdU9pwY2O6o+D8RavEAb+2posgUWuV
         EwMZ696DGGwBlMlSl0nyEu20d/sVRxgRWSBZZMbyJhVeNEaiDUAQ/AfMG+nz2tAjkJ8i
         GzJpDAc4glSQZaN12HtlqlnsiGeZdDjifExjcnGfeZiVgdrbOWa/NOhRgFZRASbR3mtx
         tCCeDAd5ZZXbRhDqOnojw7fp3IeQlsuV+J+iMXPdV0Np4WggXtHZyEnLtpxB+FZi+K1W
         TWxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ag3KsmskPbk6tk2g6GqiHzhxAQ0uQQqhq13uPdkqemo=;
        b=04sTTR3IYTSDg/a9gvFAOdMclaOYSh13JAb+0cN4T9kRXa1jy8RlOQLfZ4ul9GDb82
         9JE+MU/QT0hnVU0wEuf61FwqwMsXcAcRKayqRAfUHdOmAfIn2ppqctdfbsUXo22n434V
         zdM4P9ZYoqIKrz1dcsD0FiAxygzoXXC5NB28VDLXA5T6oRxkQ5dWYiQup4dzOzT3Bf0r
         1Eu5tGGJI/fHOhCyFyX3UAQjZPkB+p18r15CkXjs+CvdvgfSY47WxsgmtAKR1x1Rwrtz
         Hu70BvBD2harL5xJpN6UbPZkkOZt8zLOKC1Cy7O4qk6WlViF7GIIqaLbtvyiW7Psxa0a
         HikQ==
X-Gm-Message-State: ANoB5pnDTg/5Op18Iy3tdBCEpN3EGJxWp2YZMO9On78J+evw0gvD5VOW
        qTQ3wxomgE2a5aUkbokr1ezxh8KB66NhCzBCx5MkphLQj1ZQkNlx
X-Google-Smtp-Source: AA0mqf4Jviars003GQ7Ke3uwl3MdjcXrv90qMT9x9Tt3vgv0Laxs5ut++eE877kqYiGpsUf5aNAsyTq82QKEeq+7tHk=
X-Received: by 2002:a17:903:244c:b0:189:e426:463e with SMTP id
 l12-20020a170903244c00b00189e426463emr15983669pls.134.1671501343445; Mon, 19
 Dec 2022 17:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20221220004701.402165-1-kuba@kernel.org> <CAKH8qBvVTHXsgVLHuCmdFM1dnYEiDFovOFfXNq1=8igPCCO7jQ@mail.gmail.com>
 <20221219174505.67014ea5@kernel.org>
In-Reply-To: <20221219174505.67014ea5@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 19 Dec 2022 17:55:31 -0800
Message-ID: <CAKH8qBtW_iyP4a_jWbYERC2cZBKTbrW8QMO3S4Hv1xj+CTrv0A@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: pull before calling skb_postpull_rcsum()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Anand Parthasarathy <anpartha@meta.com>, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com
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

On Mon, Dec 19, 2022 at 5:45 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 19 Dec 2022 17:21:27 -0800 Stanislav Fomichev wrote:
> > > -       skb_postpull_rcsum(skb, skb->data + off, len);
> > > -       memmove(skb->data + len, skb->data, off);
> > > +       old_data = skb->data;
> > >         __skb_pull(skb, len);
> >
> > [..]
>
> Very counter-productively trimmed ;)
>
> > > +       skb_postpull_rcsum(skb, old_data + off, len);
> >
> > Are you sure about the 'old_data + off' part here (for
> > CHECKSUM_COMPLETE)? Shouldn't it be old_data?
>
> AFAIU before:
>
>       old_data (aka skb->data before)
>      /
>     / off  len
>    V-----><--->
> [ .=======xxxxx... buffer ...... ]
>           ^
>            \
>             the xxx part is what we delete
>
> after:
>           skb->data (after)
>          /
>         v
> [ .yyyyy=======... buffer ...... ]
>    <---><----->
>     len   off
>    ^
>     \
>      the yyy part is technically the old values of === but now "outside"
>      of the valid packet data
>
> > I'm assuming we need to negate the old parts that we've pulled?
>
> Yes.
>
> > Maybe safer/more correct to do the following?
> >
> > skb_pull_rcsum(skb, off);
>
> This just pulls from the front, we need to skip over various L2/L3
> headers thanks to off. Hopefully the diagrams help, LMK if they are
> wrong.

Ah, yeah, you're totally correct, thanks for the pics :-) Not sure how
I mixed up off/len in skb_pull_rcsum..

Acked-by: Stanislav Fomichev <sdf@google.com>

> > memmove(skb->data, skb->data-off, off);
