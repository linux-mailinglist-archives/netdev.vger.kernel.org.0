Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5246D5776
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233027AbjDDEVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbjDDEVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:21:52 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AE419A6
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:21:50 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so31363440wra.9
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 21:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680582109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEuAppsNKlRqAfJkKpxvOEGy6rGv5xo3Ia++uTJBjds=;
        b=ERPo3XlybTgZ90DRfKOvHrTnM+lNGBtLvMB0dcTcTwPcFuiSSO60E8XtqXTPM53GPF
         vlgl/cafIpjNPRdfZCzMgVweoJ8e4/dud8Tu4qQuTO+BZpUJIR+eVS7ku1PNY3Vg6ek3
         NlB3XiWsLqP1hAO5WqPx3ndKUqolkZdqywjJTEqj0EFfm2UM8Yao8RP+U0v0r/D5X2c/
         kCRZFAORRO/VAc5UbR4hhHnQvud0arCurPCamWnLrXBOE1daICtoLMUvFwK3hdFrdokf
         yr4ffb4HfO38ihZUgeOl2bGbW3Ui9VlmfOfz/lnvLTavvlAqbqEuXBrcgRsWZJ7j1CNO
         jz4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680582109;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KEuAppsNKlRqAfJkKpxvOEGy6rGv5xo3Ia++uTJBjds=;
        b=lFsR1mHtxGex545hZcq+V2xlis6FGFM7NzUkaFTJdGTAh9F8mefXyN9zW5quKk6N7G
         x8D2gqcmrFIuaPG4B53xOBEkDgepWa/duQzj9XbiWmZ669ygwrZrhBSa21rTTxsfksU0
         ahrkwnEeYq7rTsSnoKyCk8fsOJJT6eiwetln7m79gu0mT8PRWyI+RY9mH4eXP/9rsuqc
         ZYpKKhvQSVj0//eHxtL0n/lriRCXVNGrZZjnrUNBUVZa2rWrnl5INFqljUy+FBz391g+
         S82AK3yt6C//8eRLpWoLFkesJlZc73VBZgN53ZCrxdsW3eP/u0DyeUhZIVQg+hAurgh2
         v7mA==
X-Gm-Message-State: AAQBX9ekT06jsAj2gbdAgKXHCsiTWYTZRAq1qvMxpvDmXfqcmXnsvsMn
        kZXLEvt1Q9UFJ/L6wekki8PpxbLVko4zliIgL+7Yu4V2XgmtChasyt2FwfTU
X-Google-Smtp-Source: AKy350b2m5NPYP7SNvXGEPvb9nEZxX77yRlpN39XpkGKnUAv2jdo8WzvVZcUo6LhsgcC6oh14paEQUy1u7QXQtVqx/w=
X-Received: by 2002:adf:e84c:0:b0:2c5:7eb5:97a6 with SMTP id
 d12-20020adfe84c000000b002c57eb597a6mr169963wrn.12.1680582109280; Mon, 03 Apr
 2023 21:21:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230331043906.3015706-1-kuba@kernel.org> <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
In-Reply-To: <1f9cf03e-94cf-9787-44ce-23f6a8dd0a7a@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 4 Apr 2023 06:21:37 +0200
Message-ID: <CANn89iKsNYizAvoFisrFBSb-vXnn6BjkR7fuR1S5vQLggcLCdA@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely localized NAPI
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 4, 2023 at 2:53=E2=80=AFAM Yunsheng Lin <linyunsheng@huawei.com=
> wrote:

> Interesting.
> I wonder if we can make this more generic by adding the skb to per napi
> list instead of sd->defer_list, so that we can always use NAPI kicking to
> flush skb as net_tx_action() done for sd->completion_queue instead of
> softirq kicking?

We do not have direct skb  -> napi association yet, but using an
expensive hash lookup.

I had the intent of adding per-cpu caches in this infrastructure,
to not acquire the remote-cpu defer_lock for one skb at a time.
(This is I think causing some regressions for small packets, with no frags)

>
> And it seems we know which napi binds to a specific socket through
> busypoll mechanism, we can reuse that to release a skb to the napi
> bound to that socket?

busypoll is not often used, and we usually burn (spinning) cycles there,
not sure we want to optimize it ?

>
> >
> > The main case we'll miss out on is when application runs on the same
> > CPU as NAPI. In that case we don't use the deferred skb free path.
> > We could disable softirq one that path, too... maybe?
> >
