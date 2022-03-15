Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DF74D9F89
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343583AbiCOQDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349917AbiCOQC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:02:58 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DBA55BEC
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:01:47 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id v130so38161943ybe.13
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 09:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dyyhva8D1yhSqNS2XXe6het8agvljZk/e/fdhnQFdvY=;
        b=cDQrjJW5xmrinWAGlmzqO1lxhb0sKw8YGwhit8Y5whoTeB7ibip8vObGwyJM7u6rk0
         m5xpGJJd4i5sLcCdhDI9oVC+ERLduCCS9LhF1k+/MnDea6EkrgrT7nDuqMltfej/K9h6
         +2CWUsfcXSbO/2z1AvZkvmpX7iMG/3x60Cr+BJgWqfInF3WcZ8mIBlG47RM+ZhufzgEg
         +JM38YqOWpIaP3ubgVZTH879XizS7ddlgrbCJH1wFwGYyipahvvmvD7HxKwN1X2Vf2PG
         UZA1JQXsQ0D8Sht1JHMeHhoGmUj2vSJtRPccTFggSaPnYyRE+WZbZk+/vcDgnOd69CPz
         rOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dyyhva8D1yhSqNS2XXe6het8agvljZk/e/fdhnQFdvY=;
        b=j/vQr+eQV5jIr5LGzimV2ky+7nyoM0WI6Plb8oRnbuwsiNxR8ZlHDIHDr9fjtjZaGj
         KZgPbrIHKylXGR8cSXbyF1+meSLwHqhA6K3ZmSlqwTpAuD6jjVTEILzR1gEb88GVgbRe
         WVGS4vQ7uv3xeoZoOrOaRG63eoHbQ/tfq2rbAL7ycd07O7YjD7h3v64aVPrP587zd0i4
         Md8K5THEksJOAuzJhfNPDNOxdNSosCkBccfpFJ/p6OsdiReZ3eF0PaqsB1zluHCgGV5A
         a5NLB3yJAARzcL6QAsjd4P1wybzhMKrg16PlKcPqFvFVhMSoYTP7FOY1jAexx9uQq+MG
         HgVw==
X-Gm-Message-State: AOAM532P1b2uLmQWiK87kP76DAIOyKy6qLp6CToWXg3Wif09zbzPjFGk
        vQElEpROtNRebHKUs4kVg5kOJYWKOKDzKP7Qjs8eyg==
X-Google-Smtp-Source: ABdhPJyu+xxDOmpCm17LYVj7UXieaSjfRnKID1E6WWP3Fx5nR4jA6wHyS5eAAuIvhMpVwYiYxB53pXUKPSa5Vjdeebw=
X-Received: by 2002:a5b:7c6:0:b0:60b:a0ce:19b with SMTP id t6-20020a5b07c6000000b0060ba0ce019bmr23592744ybq.407.1647360105931;
 Tue, 15 Mar 2022 09:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
 <20220310054703.849899-7-eric.dumazet@gmail.com> <bd7742e5631aee2059aea2d55a7531cc88dfe49b.camel@gmail.com>
In-Reply-To: <bd7742e5631aee2059aea2d55a7531cc88dfe49b.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Mar 2022 09:01:34 -0700
Message-ID: <CANn89iJOw3ETTUxZOi+5MXZTuuBqRtDvOd4RwVK8mGOBPMNoBQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 06/14] ipv6/gro: insert temporary HBH/jumbo header
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>
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

On Fri, Mar 11, 2022 at 8:24 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, 2022-03-09 at 21:46 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
> > BIG TCP ipv6 packets (bigger than 64K).
> >
>
> This looks like it belongs in the next patch, not this one. This patch
> is adding the HBH header.

What do you mean by "it belongs" ?

Do you want me to squash the patches, or remove the first sentence ?

I am confused.

>
> > This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
> > so that resulting packet can go through IPv6/TCP stacks.
> >
