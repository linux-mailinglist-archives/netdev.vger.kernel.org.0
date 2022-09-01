Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA3F5A9C8F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 18:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbiIAQHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 12:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbiIAQHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 12:07:12 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5940F72B74
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 09:07:11 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-32a09b909f6so342496957b3.0
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 09:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aOX3b5WRndoOqWfMYuBPMSz6xrM2daGYXLX/7kwuwZ0=;
        b=GwWs2TE101XCnPEP8wKR+dSw6GxCCnubsLKNO61paDv/b4aqGIMAG18YmmPLgM7tL/
         9rxLGJP7ak9XNNnjdQbCzL5iB225ng61KZfyh3olNNwiXcwXq+h7ffsMnPZ6pAlJCtYZ
         bLH1QVrBdzA4VVUk2XpxtrkSITAV/Ux4pJMcF2oCM9VlSnufDfkhwlUbtk195Gwro7U5
         g7RY3vz6GYmUmLlUKiLSvS3ZL5u8vzZe1L4nTOO/3oih+NGg56PcP0RM+dkrg4Oj4lO2
         Ba4ny5o4vVi/kMzPE7kpTqTkZZ2uDTniFuM40424qKlkBW1erqkUlj7BbmP4i5zxlw0+
         FvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aOX3b5WRndoOqWfMYuBPMSz6xrM2daGYXLX/7kwuwZ0=;
        b=HccntUsYLXQiD1huRK/AcZFn6BRwW/fjURHVehMQ+Cj26uoBEGlFJiihLRKjNCj0FO
         6MXO1gaSbn4uOYLV3EP7IG7VbC4VXq+nyd1L/YhJMBiRgvI2aSAH44SnNha2HSDWL4TX
         XBDtdhxhMuv246YyDaApYVNJ4liGiYpFu5rmlVz0wSBeRqhGIYjck84SVy6PVVmbcmMz
         +9hSYg41GVe0lt1TeEFH3BccQ4aHiWE6vQAl46Z7eDbYI5Ys8sEsEthTWkr7nrCO+xTK
         JxGzGqFtrfQRgXzev0Pkz52jP/29JF6rWt4tJ7FSubyHDpBOsoegf86+/L2N8VyrN/S4
         k5Yg==
X-Gm-Message-State: ACgBeo2D8vT+FkRafi38fWg1ijHjgK4nEorb816RX5EZx5m/umPGLVN8
        7oeSCpr0Pxg0W0SjKx+fKJ28+Uuib0WTx8yiOu09TA==
X-Google-Smtp-Source: AA6agR4WWi3CPBRYCWEFVbnu2G8pTDzczJE8ASPxBsFd2QD0z+KnsqkUEdVwHr9uF0KxpAAczMEG+KuB9OxJUCT+Ths=
X-Received: by 2002:a81:1c4b:0:b0:340:972f:abb0 with SMTP id
 c72-20020a811c4b000000b00340972fabb0mr23600297ywc.489.1662048430253; Thu, 01
 Sep 2022 09:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220829114648.GA2409@debian> <CANn89iLkfMUK8n5w00naST9J+KrLaAqqg2r0X9Sd-L0XzpLzSQ@mail.gmail.com>
 <20220901150115.GB31767@debian>
In-Reply-To: <20220901150115.GB31767@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Sep 2022 09:06:59 -0700
Message-ID: <CANn89iKMe7WZS-Q4rzqEUUD+ANL6Fmb6BnFo8TvX7y_EVi=HOw@mail.gmail.com>
Subject: Re: [PATCH 3/4] net-next: frags: add inetpeer frag_mem tracking
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Martin KaFai Lau <kafai@fb.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-wpan@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
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

On Thu, Sep 1, 2022 at 8:03 AM Richard Gobert <richardbgobert@gmail.com> wrote:
>
> On Mon, Aug 29, 2022 at 03:15:47PM -0700, Eric Dumazet wrote:
> > We tried to get rid of any dependence over inetpeer, which is not
> > resistant against DDOS attacks.
> >
> > So I would not add a new dependency.
>
> I see your point. What do you suggest doing differently?
>
> The inetpeer mechanism is used for IPv4 frags. If it isn't resistant
> against DDoS attacks, can it perhaps be improved?

It can be disabled if needed, by changing ipfrag_max_dist sysctl.

Quite frankly IPv4 reassembly unit is a toy, I am always surprised
some applications are still relying on IP fragments.
