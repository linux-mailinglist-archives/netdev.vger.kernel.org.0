Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EA052A8BB
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 18:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347593AbiEQQ7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 12:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242968AbiEQQ7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 12:59:22 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBFC4FC56
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 09:59:21 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2fee9fe48c2so72608837b3.3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 09:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOaQwwXyNwaLkeC5QHvHbPsdkuRfL/oZdvins0vjXGA=;
        b=rWJmv2NWXjEBjGbU+47s0qZl61+h3A88DsFAew4SKD3IwA1WaCXmPUhaeZalx/0Uvf
         UVsBT/qs6cRnYsVluWJlhPfxoSNs18pVcMEetydY0dPcTlLBH1yhvw99Gih5tRiL8Lip
         rlTp/zeJ7JaaAEacd8v9aby/GbpqfUZlGd9Mf9qKtcL7gi0DnWA77Fnhh41s7Bf+XMAm
         SA6vlihXX/4xB3X56weA+tZ9YCmJWKFdgOa4Wb6KWX3MHrkbp9k6p3EhLMgH6ZqHMGWx
         XQDBiVGdMiCdMUZq1cIcZ+Ir7mFDTD2nABqiyfMBwqsFW8222bikKysGy8MbXzZqNeV5
         CF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOaQwwXyNwaLkeC5QHvHbPsdkuRfL/oZdvins0vjXGA=;
        b=ETeqIYIMrkkk1lcmXdqi8/j8D9QBHgfS32dJHs/qutuWOKdZnX1oBP8p6Yl2F8ASUu
         wjSpDD7HkZBRkKZljwm/Bkn29ewTyYToi85MdfK099jv2htOsHkI8w9hHH+mpmZeJXCG
         KbwnytYdVXyxIXWca1Feaiquce6cnVES4Ytb1zRdpFdw7yCt9fF5+3c9tj29OxcmBJqp
         NcGmjexNEkvIjjrDWu3TXcBt/bjzarnc3UlH7NafJvgaBng/YWbBZIOqcB1MKW7I2LN1
         rzJJMArr4GdxQ6qPn8zTQ6jl8cJYf3XbmLscTHLasXAIvhwurwfEza7U41BaEZTjbG87
         ZQAA==
X-Gm-Message-State: AOAM532FA91mxsXRs7TdVJRvPDt0Ye+0I2w6B1x5OcxFzxy1rVuTTt1E
        MeQkrMKMjZeXntsUNQw+sZ0Brzxaz8K2Aew3ZHDVsw==
X-Google-Smtp-Source: ABdhPJz/Mc7L3yZ2QtY8PfQnudM9Fong20Bjzat5jn7UPATtSlOiUbMZ2RU4bO+ebGIvLKSVwSx+1AiBAfLpysf5QyY=
X-Received: by 2002:a81:6c4d:0:b0:2ff:2e65:5a97 with SMTP id
 h74-20020a816c4d000000b002ff2e655a97mr3168277ywc.467.1652806760042; Tue, 17
 May 2022 09:59:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220512205041.1208962-1-joannelkoong@gmail.com> <20220512205041.1208962-2-joannelkoong@gmail.com>
In-Reply-To: <20220512205041.1208962-2-joannelkoong@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 17 May 2022 09:59:08 -0700
Message-ID: <CANn89iKryk30MM=XuwDmdZ7T_rDJUe+zZrZMsaPXQG2mghe6tQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/2] net: Add a second bind table hashed by
 port and address
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
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

On Thu, May 12, 2022 at 1:51 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> We currently have one tcp bind table (bhash) which hashes by port
> number only. In the socket bind path, we check for bind conflicts by
> traversing the specified port's inet_bind2_bucket while holding the
> bucket's spinlock (see inet_csk_get_port() and inet_csk_bind_conflict()).
>
> In instances where there are tons of sockets hashed to the same port
> at different addresses, checking for a bind conflict is time-intensive
> and can cause softirq cpu lockups, as well as stops new tcp connections
> since __inet_inherit_port() also contests for the spinlock.
>
> This patch proposes adding a second bind table, bhash2, that hashes by
> port and ip address. Searching the bhash2 table leads to significantly
> faster conflict resolution and less time holding the spinlock.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Scary patch, but I could not find obvious issues with it.
Let's give it a try, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
